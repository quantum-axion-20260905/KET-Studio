import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'settings_service.dart';

class TerminalService extends ChangeNotifier {
  static final TerminalService _instance = TerminalService._internal();
  factory TerminalService() => _instance;
  TerminalService._internal();

  // Terminaldagi qatorlar
  final List<String> _logs = [];
  void Function(String line)? _outputListener;

  // Getter
  List<String> get logs => _logs;

  /// Connects legacy execution logs to the interactive terminal when it is
  /// mounted. The listener remains optional for tests and startup.
  void attachOutputListener(void Function(String line) listener) {
    _outputListener = listener;
  }

  void detachOutputListener(void Function(String line) listener) {
    if (identical(_outputListener, listener)) _outputListener = null;
  }

  // Yozuv qo'shish (Masalan: "Process started...")
  void write(String text) {
    _logs.add(text);
    _outputListener?.call(text);
    _limitLogs();
    _throttledNotify();
  }

  void writeLines(List<String> lines) {
    if (lines.isEmpty) return;
    _logs.addAll(lines);
    for (final line in lines) {
      _outputListener?.call(line);
    }
    _limitLogs();
    _throttledNotify();
  }

  bool _isNotifyThrottled = false;
  void _throttledNotify() {
    if (!_isNotifyThrottled) {
      _isNotifyThrottled = true;
      notifyListeners();
      Future.delayed(const Duration(milliseconds: 100), () {
        _isNotifyThrottled = false;
        notifyListeners();
      });
    }
  }

  void _limitLogs() {
    final maxLines = SettingsService().terminalMaxLines;
    if (_logs.length > maxLines) {
      _logs.removeRange(0, _logs.length - maxLines);
    }
  }

  bool _notifyScheduled = false;

  @override
  void notifyListeners() {
    if (_notifyScheduled) return;

    final phase = WidgetsBinding.instance.schedulerPhase;
    if (phase != SchedulerPhase.idle) {
      _notifyScheduled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _notifyScheduled = false;
        super.notifyListeners();
      });
    } else {
      super.notifyListeners();
    }
  }

  // Tozalash (clear)
  void clear() {
    _logs.clear();
    notifyListeners();
  }
}
