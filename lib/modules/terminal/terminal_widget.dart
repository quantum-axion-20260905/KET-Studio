import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:xterm3/xterm.dart';

import '../../core/services/execution_service.dart';
import '../../core/services/layout_service.dart';
import '../../core/services/settings_service.dart';
import '../../core/services/terminal_service.dart';
import '../../core/theme/ket_theme.dart';
import '../../v03/application/runtime/runtime_supervisor.dart';
import '../../v03/core/terminal/terminal_host.dart';

/// Interactive terminal surface backed by a native PTY.
///
/// The old panel only displayed lines collected from a redirected Python
/// process. This widget owns an xterm-compatible terminal session instead:
/// input, ANSI output, resize events, interrupts and process exit all travel
/// through the native host. Legacy execution logs are mirrored into the same
/// terminal so the Run button and manual shell commands share one surface.
class TerminalWidget extends StatefulWidget {
  final LayoutService layout;

  const TerminalWidget({super.key, required this.layout});

  @override
  State<TerminalWidget> createState() => _TerminalWidgetState();
}

class _TerminalWidgetState extends State<TerminalWidget> {
  late final Terminal _terminal;
  late final RuntimeSupervisor _runtime;
  TerminalSession? _session;
  StreamSubscription<String>? _outputSubscription;
  bool _connecting = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _runtime = RuntimeSupervisor();
    _terminal = Terminal(maxLines: SettingsService().terminalMaxLines);
    _terminal.onOutput = _sendInput;
    _terminal.onResize = (width, height, _, _) {
      final session = _session;
      if (session == null || width <= 0 || height <= 0) return;
      unawaited(session.resize(TerminalSize(columns: width, rows: height)));
    };
    TerminalService().attachOutputListener(_mirrorExecutionLine);
    unawaited(_connect());
  }

  void _mirrorExecutionLine(String line) {
    _terminal.write('$line\r\n');
  }

  void _clearTerminal() {
    _terminal.clear();
    if (!mounted || _error == null) return;
    setState(() => _error = null);
  }

  Future<void> _connect() async {
    if (kIsWeb) {
      _onTerminalError(
        'Interactive terminal is available in the desktop application.',
      );
      return;
    }

    if (mounted) {
      setState(() {
        _connecting = true;
        _error = null;
      });
    }

    try {
      final oldSession = _session;
      _session = null;
      await _outputSubscription?.cancel();
      _outputSubscription = null;
      if (oldSession != null) {
        try {
          await oldSession.terminate(force: true);
        } catch (_) {}
        await oldSession.dispose();
      }

      await _runtime.initialize();
      final session = await _runtime.openTerminal(
        workingDirectory: Directory.current.path,
        initialSize: TerminalSize(
          columns: _terminal.viewWidth <= 0 ? 120 : _terminal.viewWidth,
          rows: _terminal.viewHeight <= 0 ? 32 : _terminal.viewHeight,
        ),
      );
      _session = session;
      _outputSubscription = session.output
          .cast<List<int>>()
          .transform(utf8.decoder)
          .listen(_terminal.write, onError: _onTerminalError);
      unawaited(_watchExit(session));
      _terminal.write(
        '\r\n\x1b[38;5;39mKET Studio interactive terminal connected.\x1b[0m\r\n',
      );
      if (mounted) setState(() => _connecting = false);
    } catch (error) {
      _onTerminalError(error);
    }
  }

  Future<void> _watchExit(TerminalSession session) async {
    try {
      final code = await session.exitCode;
      if (!identical(_session, session)) return;
      _session = null;
      final subscription = _outputSubscription;
      _outputSubscription = null;
      await subscription?.cancel();
      await session.dispose();
      _terminal.write(
        '\r\n\x1b[38;5;244m[terminal process exited: $code]\x1b[0m\r\n',
      );
      if (mounted) setState(() => _connecting = false);
    } catch (error) {
      if (identical(_session, session)) _onTerminalError(error);
    }
  }

  void _sendInput(String value) {
    // The Run button still uses the structured execution service for KET_VIZ
    // events. While it is active, route terminal keystrokes to that process;
    // otherwise input belongs to the interactive shell PTY.
    if (ExecutionService().isRunning.value) {
      ExecutionService().writeToStdin(value);
      return;
    }

    final session = _session;
    if (session == null) return;
    unawaited(session.write(utf8.encode(value)));
  }

  void _onTerminalError(Object error, [StackTrace? stackTrace]) {
    _terminal.write('\r\n\x1b[31mKET terminal error: $error\x1b[0m\r\n');
    if (!mounted) return;
    setState(() {
      _connecting = false;
      _error = '$error';
    });
  }

  Future<void> _interrupt() async {
    final session = _session;
    if (session == null) return;
    try {
      await session.interrupt();
    } catch (error) {
      _onTerminalError(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFF080C11),
      child: Column(
        children: [
          SizedBox(
            height: 34,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Icon(
                    FluentIcons.command_prompt,
                    size: 13,
                    color: KetTheme.accent,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _connecting ? 'Starting terminal…' : 'TERMINAL',
                    style: KetTheme.bodyStyle.copyWith(fontSize: 12),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'PTY shell',
                    style: KetTheme.descriptionStyle.copyWith(fontSize: 11),
                  ),
                  const Spacer(),
                  if (_error != null)
                    Tooltip(
                      message: _error!,
                      child: Icon(
                        FluentIcons.warning,
                        size: 13,
                        color: KetTheme.warning,
                      ),
                    ),
                  IconButton(
                    icon: Icon(
                      FluentIcons.clear,
                      size: 14,
                      color: KetTheme.textMuted,
                    ),
                    onPressed: _clearTerminal,
                  ),
                  IconButton(
                    icon: Icon(
                      FluentIcons.stop,
                      size: 14,
                      color: KetTheme.textMuted,
                    ),
                    onPressed: _session == null ? null : _interrupt,
                  ),
                  IconButton(
                    icon: Icon(
                      FluentIcons.refresh,
                      size: 14,
                      color: KetTheme.textMuted,
                    ),
                    onPressed: _connecting ? null : _connect,
                  ),
                  IconButton(
                    icon: Icon(
                      FluentIcons.chrome_close,
                      size: 13,
                      color: KetTheme.textMuted,
                    ),
                    onPressed: () => widget.layout.toggleBottomPanel(),
                  ),
                ],
              ),
            ),
          ),
          Divider(size: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
              child: TerminalView(
                _terminal,
                autofocus: !kIsWeb,
                backgroundOpacity: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    TerminalService().detachOutputListener(_mirrorExecutionLine);
    final session = _session;
    _session = null;
    unawaited(_outputSubscription?.cancel() ?? Future<void>.value());
    if (session != null) {
      unawaited(() async {
        try {
          await session.terminate(force: true);
        } catch (_) {}
        await session.dispose();
      }());
    }
    unawaited(_runtime.dispose());
    super.dispose();
  }
}
