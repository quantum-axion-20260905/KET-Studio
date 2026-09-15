import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/services/python_setup_service.dart';
import '../../core/services/settings_service.dart';
import '../../core/theme/ket_theme.dart';

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({super.key});

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  final _pythonController = TextEditingController(
    text: SettingsService().pythonPath,
  );

  String _section = 'appearance';

  AppStrings get _strings => AppStrings.forLanguage(SettingsService().language);

  @override
  void dispose() {
    _pythonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([SettingsService(), PythonSetupService()]),
      builder: (context, _) {
        final settings = SettingsService();
        final setup = PythonSetupService();
        if (_pythonController.text != settings.pythonPath) {
          _pythonController.text = settings.pythonPath;
        }

        return ContentDialog(
          title: Row(
            children: [
              Icon(FluentIcons.settings, color: KetTheme.accent, size: 18),
              const SizedBox(width: 10),
              Text(_strings.get('settings')),
            ],
          ),
          constraints: const BoxConstraints(maxWidth: 1040, maxHeight: 720),
          content: SizedBox(
            width: 960,
            height: 570,
            child: Row(
              children: [
                _buildSidebar(),
                const SizedBox(width: 18),
                Expanded(
                  child: DecoratedBox(
                    decoration: KetTheme.panelSurface(),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: SingleChildScrollView(
                        child: _buildSection(settings, setup),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Button(
              onPressed: _copySettingsJson,
              child: Text(_strings.get('copyJson')),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: Text(_strings.get('close')),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSidebar() {
    return SizedBox(
      width: 196,
      child: DecoratedBox(
        decoration: KetTheme.panelSurface(elevated: true),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_strings.get('configuration'), style: KetTheme.headerStyle),
              const SizedBox(height: 10),
              _SectionButton(
                label: _strings.get('appearance'),
                icon: FluentIcons.color,
                selected: _section == 'appearance',
                onPressed: () => setState(() => _section = 'appearance'),
              ),
              _SectionButton(
                label: _strings.get('editor'),
                icon: FluentIcons.edit,
                selected: _section == 'editor',
                onPressed: () => setState(() => _section = 'editor'),
              ),
              _SectionButton(
                label: _strings.get('terminal'),
                icon: FluentIcons.command_prompt,
                selected: _section == 'terminal',
                onPressed: () => setState(() => _section = 'terminal'),
              ),
              _SectionButton(
                label: _strings.get('environment'),
                icon: FluentIcons.processing,
                selected: _section == 'environment',
                onPressed: () => setState(() => _section = 'environment'),
              ),
              _SectionButton(
                label: _strings.get('advanced'),
                icon: FluentIcons.developer_tools,
                selected: _section == 'advanced',
                onPressed: () => setState(() => _section = 'advanced'),
              ),
              const Spacer(),
              Text(
                _strings.get('configurationHint'),
                style: KetTheme.descriptionStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(SettingsService settings, PythonSetupService setup) {
    switch (_section) {
      case 'appearance':
        return _buildAppearance(settings);
      case 'editor':
        return _buildEditor(settings);
      case 'terminal':
        return _buildTerminal(settings);
      case 'environment':
        return _buildEnvironment(settings, setup);
      case 'advanced':
        return _buildAdvanced(settings, setup);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildAppearance(SettingsService settings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: _strings.get('appearance'),
          subtitle: _strings.get('appearanceHint'),
        ),
        const SizedBox(height: 18),
        _SettingCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _LabeledRow(
                title: _strings.get('language'),
                subtitle: _strings.get('languageHint'),
                trailing: SizedBox(
                  width: 180,
                  child: ComboBox<AppLanguage>(
                    value: settings.language,
                    items: [
                      ComboBoxItem(
                        value: AppLanguage.english,
                        child: Text(_strings.get('english')),
                      ),
                      ComboBoxItem(
                        value: AppLanguage.uzbek,
                        child: Text(_strings.get('uzbek')),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) settings.setLanguage(value);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _LabeledRow(
                title: _strings.get('themeMode'),
                subtitle: _strings.get('themeModeHint'),
                trailing: SizedBox(
                  width: 180,
                  child: ComboBox<ThemeMode>(
                    value: settings.themeMode,
                    items: [
                      ComboBoxItem(
                        value: ThemeMode.dark,
                        child: Text(_strings.get('dark')),
                      ),
                      ComboBoxItem(
                        value: ThemeMode.light,
                        child: Text(_strings.get('light')),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) settings.setThemeMode(value);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(_strings.get('accentColor'), style: KetTheme.bodyStyle),
              const SizedBox(height: 6),
              Text(
                _strings.get('accentColorHint'),
                style: KetTheme.descriptionStyle,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: settings.availableAccents.map((color) {
                  final selected =
                      settings.accentColor.toARGB32() == color.toARGB32();
                  return GestureDetector(
                    onTap: () => settings.setAccentColor(color),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: selected ? Colors.white : Colors.transparent,
                          width: 2,
                        ),
                        boxShadow: selected
                            ? [
                                BoxShadow(
                                  color: color.withValues(alpha: 0.35),
                                  blurRadius: 10,
                                ),
                              ]
                            : null,
                      ),
                      child: selected
                          ? const Icon(
                              FluentIcons.check_mark,
                              color: Colors.white,
                              size: 12,
                            )
                          : null,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _ToggleCard(
          title: _strings.get('compactDensity'),
          subtitle: _strings.get('compactDensityHint'),
          value: settings.compactMode,
          onChanged: settings.setCompactMode,
        ),
        const SizedBox(height: 14),
        _ToggleCard(
          title: _strings.get('startMaximized'),
          subtitle: _strings.get('startMaximizedHint'),
          value: settings.startMaximized,
          onChanged: settings.setStartMaximized,
        ),
      ],
    );
  }

  Widget _buildEditor(SettingsService settings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: _strings.get('editor'),
          subtitle: _strings.get('editorHint'),
        ),
        const SizedBox(height: 18),
        _SliderCard(
          title: _strings.get('editorFontSize'),
          subtitle: _strings.get('editorFontSizeHint'),
          valueLabel: '${settings.fontSize.toStringAsFixed(1)} px',
          value: settings.fontSize,
          min: 10,
          max: 24,
          onChanged: settings.setFontSize,
        ),
        const SizedBox(height: 14),
        _SliderCard(
          title: _strings.get('editorLineHeight'),
          subtitle: _strings.get('editorLineHeightHint'),
          valueLabel: settings.editorLineHeight.toStringAsFixed(2),
          value: settings.editorLineHeight,
          min: 1.1,
          max: 2.0,
          onChanged: settings.setEditorLineHeight,
        ),
        const SizedBox(height: 14),
        _ToggleCard(
          title: _strings.get('wordWrap'),
          subtitle: _strings.get('wordWrapHint'),
          value: settings.editorWordWrap,
          onChanged: settings.setEditorWordWrap,
        ),
        const SizedBox(height: 14),
        _ToggleCard(
          title: _strings.get('autoSave'),
          subtitle: _strings.get('autoSaveHint'),
          value: settings.autoSave,
          onChanged: settings.setAutoSave,
        ),
      ],
    );
  }

  Widget _buildTerminal(SettingsService settings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: _strings.get('terminal'),
          subtitle: _strings.get('terminalHint'),
        ),
        const SizedBox(height: 18),
        _SliderCard(
          title: _strings.get('terminalFontSize'),
          subtitle: _strings.get('terminalFontSizeHint'),
          valueLabel: '${settings.terminalFontSize.toStringAsFixed(1)} px',
          value: settings.terminalFontSize,
          min: 10,
          max: 22,
          onChanged: settings.setTerminalFontSize,
        ),
        const SizedBox(height: 14),
        _SettingCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_strings.get('terminalMaxLines'), style: KetTheme.bodyStyle),
              const SizedBox(height: 6),
              Text(
                _strings.get('terminalMaxLinesHint'),
                style: KetTheme.descriptionStyle,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: settings.terminalMaxLines.toDouble(),
                      min: 200,
                      max: 5000,
                      divisions: 24,
                      onChanged: (value) {
                        settings.setTerminalMaxLines(value.round());
                      },
                    ),
                  ),
                  SizedBox(
                    width: 72,
                    child: Text(
                      '${settings.terminalMaxLines}',
                      textAlign: TextAlign.end,
                      style: KetTheme.statusStyle,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _ToggleCard(
          title: _strings.get('autoScroll'),
          subtitle: _strings.get('autoScrollHint'),
          value: settings.terminalAutoScroll,
          onChanged: settings.setTerminalAutoScroll,
        ),
        const SizedBox(height: 14),
        _ToggleCard(
          title: _strings.get('clearTerminal'),
          subtitle: _strings.get('clearTerminalHint'),
          value: settings.clearTerminalOnRun,
          onChanged: settings.setClearTerminalOnRun,
        ),
        const SizedBox(height: 14),
        _ToggleCard(
          title: _strings.get('executionDetails'),
          subtitle: _strings.get('executionDetailsHint'),
          value: settings.showExecutionDetails,
          onChanged: settings.setShowExecutionDetails,
        ),
      ],
    );
  }

  Widget _buildEnvironment(SettingsService settings, PythonSetupService setup) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: _strings.get('environment'),
          subtitle: _strings.get('environmentHint'),
        ),
        const SizedBox(height: 18),
        _SettingCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _strings.get('pythonInterpreter'),
                style: KetTheme.bodyStyle,
              ),
              const SizedBox(height: 6),
              Text(
                _strings.get('pythonInterpreterHint'),
                style: KetTheme.descriptionStyle,
              ),
              const SizedBox(height: 12),
              TextBox(
                controller: _pythonController,
                placeholder: 'python yoki python.exe to‘liq manzili',
                onChanged: settings.setPythonPath,
                suffix: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Button(
                      onPressed: () => _selectPythonExecutable(settings),
                      child: Text(_strings.get('browse')),
                    ),
                    const SizedBox(width: 6),
                    Button(
                      onPressed: () {
                        _pythonController.text = 'python';
                        settings.setPythonPath('python');
                      },
                      child: Text(_strings.get('reset')),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _SettingCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _strings.get('environmentStatus'),
                style: KetTheme.bodyStyle,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _StatusPill(
                    label: setup.isSetupComplete
                        ? _strings.get('ready')
                        : _strings.get('notReady'),
                    accent: setup.isSetupComplete
                        ? KetTheme.success
                        : KetTheme.warning,
                  ),
                  _StatusPill(
                    label: setup.isBusy
                        ? _strings.get('provisioning')
                        : _strings.get('idle'),
                    accent: setup.isBusy ? KetTheme.accent : KetTheme.textMuted,
                  ),
                  _StatusPill(
                    label: 'Qiskit ${setup.qiskitVersion}',
                    accent: KetTheme.accent,
                  ),
                ],
              ),
              if (setup.currentTask.value != null) ...[
                const SizedBox(height: 14),
                Text(
                  setup.currentTask.value!,
                  style: KetTheme.descriptionStyle,
                ),
                const SizedBox(height: 8),
                ProgressBar(value: setup.progress.value * 100),
              ],
              const SizedBox(height: 14),
              Row(
                children: [
                  FilledButton(
                    onPressed: setup.isBusy
                        ? null
                        : () => setup.checkAndInstallDependencies(force: true),
                    child: Text(_strings.get('rebuildEnvironment')),
                  ),
                  const SizedBox(width: 8),
                  Button(
                    onPressed: _copySettingsJson,
                    child: Text(_strings.get('copyConfig')),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAdvanced(SettingsService settings, PythonSetupService setup) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: _strings.get('advanced'),
          subtitle: _strings.get('advancedHint'),
        ),
        const SizedBox(height: 18),
        _SettingCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _strings.get('configurationPreview'),
                style: KetTheme.bodyStyle,
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: KetTheme.bgCanvas.withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: KetTheme.border),
                ),
                child: SelectableText(
                  settings.exportJson(),
                  style: const TextStyle(
                    fontFamily: 'Consolas',
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _SettingCard(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _strings.get('resetSettings'),
                      style: KetTheme.bodyStyle,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _strings.get('resetSettingsHint'),
                      style: KetTheme.descriptionStyle,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              FilledButton(
                onPressed: () async {
                  await settings.resetToDefaults();
                  _pythonController.text = settings.pythonPath;
                  if (mounted) setState(() {});
                },
                child: Text(_strings.get('resetDefaults')),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _SettingCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_strings.get('runtimeSnapshot'), style: KetTheme.bodyStyle),
              const SizedBox(height: 8),
              Text(
                '${_strings.get('platform')}: ${kIsWeb ? 'web' : Platform.operatingSystem}\n${_strings.get('interpreter')}: ${settings.pythonPath}\n${_strings.get('environmentReady')}: ${setup.isSetupComplete}',
                style: KetTheme.descriptionStyle,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _selectPythonExecutable(SettingsService settings) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: !kIsWeb && Platform.isWindows ? ['exe'] : [],
    );
    if (result?.files.single.path == null) return;

    final path = result!.files.single.path!;
    _pythonController.text = path;
    settings.setPythonPath(path);
  }

  Future<void> _copySettingsJson() async {
    await Clipboard.setData(
      ClipboardData(text: SettingsService().exportJson()),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: KetTheme.bodyStyle.copyWith(fontSize: 20)),
        const SizedBox(height: 4),
        Text(subtitle, style: KetTheme.descriptionStyle),
      ],
    );
  }
}

class _SectionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onPressed;

  const _SectionButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: HoverButton(
        onPressed: onPressed,
        builder: (context, states) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: selected
                  ? KetTheme.accentSoft
                  : (states.isHovered ? KetTheme.bgHover : Colors.transparent),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: selected
                    ? KetTheme.accent.withValues(alpha: 0.28)
                    : Colors.transparent,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 14,
                  color: selected ? KetTheme.accent : KetTheme.textMuted,
                ),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: KetTheme.bodyStyle.copyWith(
                    color: selected
                        ? KetTheme.textMain
                        : KetTheme.textSecondary,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SettingCard extends StatelessWidget {
  final Widget child;

  const _SettingCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: KetTheme.panelSurface(elevated: true),
      child: Padding(padding: const EdgeInsets.all(12), child: child),
    );
  }
}

class _ToggleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleCard({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _SettingCard(
      child: _LabeledRow(
        title: title,
        subtitle: subtitle,
        trailing: ToggleSwitch(checked: value, onChanged: onChanged),
      ),
    );
  }
}

class _SliderCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String valueLabel;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  const _SliderCard({
    required this.title,
    required this.subtitle,
    required this.valueLabel,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _SettingCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(title, style: KetTheme.bodyStyle)),
              Text(valueLabel, style: KetTheme.statusStyle),
            ],
          ),
          const SizedBox(height: 6),
          Text(subtitle, style: KetTheme.descriptionStyle),
          const SizedBox(height: 12),
          Slider(value: value, min: min, max: max, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _LabeledRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget trailing;

  const _LabeledRow({
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: KetTheme.bodyStyle),
              const SizedBox(height: 6),
              Text(subtitle, style: KetTheme.descriptionStyle),
            ],
          ),
        ),
        const SizedBox(width: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 180),
          child: trailing,
        ),
      ],
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String label;
  final Color accent;

  const _StatusPill({required this.label, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: accent.withValues(alpha: 0.2)),
      ),
      child: Text(label, style: KetTheme.statusStyle.copyWith(color: accent)),
    );
  }
}
