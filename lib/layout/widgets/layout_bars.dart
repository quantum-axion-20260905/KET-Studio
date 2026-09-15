import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:window_manager/window_manager.dart';

import '../../core/plugin/plugin_system.dart';
import '../../core/services/command_service.dart';
import '../../core/services/editor_service.dart';
import '../../core/services/execution_service.dart';
import '../../core/services/layout_service.dart';
import '../../core/services/menu_service.dart';
import '../../core/services/python_setup_service.dart';
import '../../core/services/settings_service.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/ket_theme.dart';

class TopBar extends StatelessWidget {
  final LayoutService layout;

  const TopBar({super.key, required this.layout});

  void _handleRun() async {
    final activeFile = EditorService().activeFile;
    if (activeFile == null) return;
    await EditorService().saveActiveFile();
    await ExecutionService().runPython(
      activeFile.path,
      content: activeFile.controller.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.forLanguage(SettingsService().language);
    return Container(
      height: KetTheme.topBarHeight,
      decoration: BoxDecoration(
        color: KetTheme.bgSidebar,
        border: Border(bottom: BorderSide(color: KetTheme.border)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            const _BrandChip(),
            const SizedBox(width: 12),
            Expanded(
              child: ListenableBuilder(
                listenable: Listenable.merge([
                  MenuService(),
                  CommandService(),
                  EditorService(),
                  ExecutionService().isRunning,
                  SettingsService(),
                ]),
                builder: (context, _) {
                  return Wrap(
                    spacing: 2,
                    children: MenuService().menus.map((group) {
                      return DropDownButton(
                        title: Text(group.title, style: KetTheme.menuStyle),
                        trailing: const SizedBox.shrink(),
                        style: ButtonStyle(
                          padding: WidgetStateProperty.all(
                            const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 6,
                            ),
                          ),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          backgroundColor: WidgetStateProperty.resolveWith((
                            states,
                          ) {
                            if (states.isHovered) return KetTheme.bgHover;
                            return Colors.transparent;
                          }),
                        ),
                        items: group.items.map((item) {
                          if (item.isSeparator) {
                            return const MenuFlyoutSeparator();
                          }

                          final cmd = item.command;
                          if (cmd == null) {
                            return const MenuFlyoutSeparator();
                          }

                          return MenuFlyoutItem(
                            leading: cmd.icon != null
                                ? Icon(
                                    cmd.icon,
                                    size: 14,
                                    color: KetTheme.textSecondary,
                                  )
                                : null,
                            text: Text(
                              item.label,
                              style: KetTheme.menuStyle.copyWith(
                                color: KetTheme.textMain,
                              ),
                            ),
                            onPressed:
                                (cmd.isEnabled == null || cmd.isEnabled!())
                                ? cmd.action
                                : null,
                            trailing: cmd.shortcut != null
                                ? Text(
                                    cmd.shortcut!,
                                    style: KetTheme.menuStyle.copyWith(
                                      color: KetTheme.textMuted,
                                      fontSize: 10,
                                    ),
                                  )
                                : null,
                          );
                        }).toList(),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: MoveWindow(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 190),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        layout.activeWorkspacePreset.description,
                        style: KetTheme.descriptionStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
            ValueListenableBuilder<bool>(
              valueListenable: ExecutionService().isRunning,
              builder: (context, running, _) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (running)
                      _ActionPill(
                        icon: FluentIcons.stop,
                        label: strings.get('stop'),
                        fill: KetTheme.danger.withValues(alpha: 0.14),
                        iconColor: KetTheme.danger,
                        onPressed: () => ExecutionService().stop(),
                      ),
                    if (running) const SizedBox(width: 4),
                    _ActionPill(
                      icon: running
                          ? FluentIcons.progress_ring_dots
                          : FluentIcons.play,
                      label: running
                          ? strings.get('running')
                          : strings.get('run'),
                      fill: running ? KetTheme.accentSoft : KetTheme.accent,
                      iconColor: Colors.white,
                      textColor: Colors.white,
                      onPressed: running ? null : _handleRun,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(width: 6),
            _CircleIconButton(
              icon: FluentIcons.settings,
              tooltip:
                  "${AppStrings.forLanguage(SettingsService().language).get('settings')} (Ctrl+,)",
              onPressed: () => CommandService().execute("settings.open"),
            ),
            const SizedBox(width: 6),
            if (!kIsWeb) const WindowButtons(),
          ],
        ),
      ),
    );
  }
}

// Removed WorkspaceTabs as requested

class _BrandChip extends StatelessWidget {
  const _BrandChip();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.asset('assets/quantum.jpg', width: 18, height: 18),
        ),
        const SizedBox(width: 8),
        Text(
          "KET Studio",
          style: KetTheme.bodyStyle.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 12.5,
          ),
        ),
      ],
    );
  }
}

class _ActionPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color fill;
  final Color? iconColor;
  final Color? textColor;
  final VoidCallback? onPressed;

  const _ActionPill({
    required this.icon,
    required this.label,
    required this.fill,
    this.iconColor,
    this.textColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Button(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        ),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.isDisabled) return fill.withValues(alpha: 0.45);
          if (states.isHovered) return fill.withValues(alpha: 0.88);
          return fill;
        }),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: iconColor ?? KetTheme.textMain),
          const SizedBox(width: 6),
          Text(
            label.toUpperCase(),
            style: KetTheme.statusStyle.copyWith(
              fontSize: 10,
              color: textColor ?? KetTheme.textMain,
            ),
          ),
        ],
      ),
    );
  }
}

class MoveWindow extends StatelessWidget {
  final Widget child;

  const MoveWindow({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return DragToMoveArea(child: child);
  }
}

class WindowButtons extends StatelessWidget {
  const WindowButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _CircleIconButton(
          icon: FluentIcons.chrome_minimize,
          tooltip: "Minimize",
          onPressed: () => windowManager.minimize(),
        ),
        const SizedBox(width: 4),
        _CircleIconButton(
          icon: FluentIcons.chrome_full_screen,
          tooltip: "Maximize",
          onPressed: () async {
            if (await windowManager.isMaximized()) {
              await windowManager.unmaximize();
            } else {
              await windowManager.maximize();
            }
          },
        ),
        const SizedBox(width: 6),
        _CircleIconButton(
          icon: FluentIcons.chrome_close,
          tooltip: "Close",
          hoverColor: KetTheme.danger,
          onPressed: () => windowManager.close(),
        ),
      ],
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final Color? hoverColor;

  const _CircleIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.hoverColor,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: HoverButton(
        onPressed: onPressed,
        builder: (context, states) {
          final fill = states.isHovered
              ? (hoverColor ?? KetTheme.bgHover)
              : KetTheme.bgHeader;
          return Container(
            width: 28,
            height: 26,
            decoration: BoxDecoration(
              color: fill,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: states.isHovered && hoverColor != null
                    ? hoverColor!.withValues(alpha: 0.4)
                    : KetTheme.border,
              ),
            ),
            child: Icon(
              icon,
              size: 10,
              color: hoverColor != null && states.isHovered
                  ? Colors.white
                  : KetTheme.textSecondary,
            ),
          );
        },
      ),
    );
  }
}

class ActivityBar extends StatelessWidget {
  final bool isLeft;
  final LayoutService layout;

  const ActivityBar({super.key, required this.isLeft, required this.layout});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: layout,
      builder: (context, _) {
        final allowedPanelIds = isLeft
            ? layout.allowedLeftPanelIds
            : layout.allowedRightPanelIds;
        final panels =
            (isLeft
                    ? PluginRegistry().leftPanels
                    : PluginRegistry().rightPanels)
                .where((panel) => allowedPanelIds.contains(panel.id))
                .toList();
        if (panels.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: EdgeInsets.fromLTRB(isLeft ? 4 : 0, 4, isLeft ? 0 : 4, 4),
          child: Container(
            width: KetTheme.activityRailWidth,
            decoration: KetTheme.panelSurface(radius: KetTheme.radiusMd),
            child: Column(
              children: [
                const SizedBox(height: 4),
                ...panels.map((panel) {
                  final isActive = isLeft
                      ? layout.activeLeftPanelId == panel.id
                      : layout.activeRightPanelId == panel.id;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    child: HoverButton(
                      onPressed: () {
                        if (isLeft) {
                          layout.toggleLeftPanel(panel.id);
                        } else {
                          layout.toggleRightPanel(panel.id);
                        }
                      },
                      builder: (context, states) {
                        return Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: isActive
                                ? KetTheme.accentSoft
                                : (states.isHovered
                                      ? KetTheme.bgHover
                                      : Colors.transparent),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: isActive
                                  ? KetTheme.accent.withValues(alpha: 0.35)
                                  : Colors.transparent,
                            ),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              if (isActive)
                                Positioned(
                                  left: isLeft ? 0 : null,
                                  right: isLeft ? null : 0,
                                  child: Container(
                                    width: 2,
                                    height: 12,
                                    color: KetTheme.accent,
                                  ),
                                ),
                              Icon(
                                panel.icon,
                                size: 15,
                                color: isActive
                                    ? KetTheme.accent
                                    : KetTheme.textMuted,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }),
                const Spacer(),
                Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  width: 20,
                  height: 1,
                  color: KetTheme.borderStrong,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class StatusBar extends StatelessWidget {
  final LayoutService layout;

  const StatusBar({super.key, required this.layout});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        EditorService(),
        ExecutionService().isRunning,
        PythonSetupService(),
        SettingsService(),
        layout,
      ]),
      builder: (context, _) {
        final editor = EditorService();
        final exec = ExecutionService();
        final setup = PythonSetupService();
        final strings = AppStrings.forLanguage(SettingsService().language);
        final activeFile = editor.activeFile;

        return Container(
          height: KetTheme.statusBarHeight,
          decoration: BoxDecoration(
            color: KetTheme.bgSidebar,
            border: Border(top: BorderSide(color: KetTheme.border)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                _StatusInfo(
                  icon: layout.activeWorkspacePreset.icon,
                  label: layout.activeWorkspacePreset.label,
                ),
                if (layout.supportsBottomPanel) const SizedBox(width: 8),
                if (layout.supportsBottomPanel)
                  _StatusChip(
                    icon: FluentIcons.command_prompt,
                    label: strings.get('terminal'),
                    onTap: () => layout.toggleBottomPanel(),
                  ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    activeFile == null
                        ? strings.get('workspaceReady')
                        : (activeFile.path.startsWith('/fake')
                              ? activeFile.name
                              : activeFile.path),
                    style: KetTheme.descriptionStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _StatusInfo(
                  icon: setup.isSetupComplete
                      ? FluentIcons.completed
                      : FluentIcons.sync_status,
                  label: setup.isSetupComplete
                      ? strings.get('envReady')
                      : strings.get('envLoading'),
                ),
                const SizedBox(width: 8),
                if (setup.isSetupComplete)
                  _StatusInfo(
                    icon: FluentIcons.product_variant,
                    label: "Qiskit ${setup.qiskitVersion}",
                  ),
                if (activeFile != null) const SizedBox(width: 8),
                if (activeFile != null)
                  _StatusInfo(
                    icon: FluentIcons.edit,
                    label:
                        "Ln ${editor.cursorLine}, Col ${editor.cursorColumn}",
                  ),
                const SizedBox(width: 8),
                ValueListenableBuilder<bool>(
                  valueListenable: exec.isRunning,
                  builder: (context, running, _) {
                    return _StatusInfo(
                      icon: running
                          ? FluentIcons.progress_ring_dots
                          : FluentIcons.play_resume,
                      label: running
                          ? strings.get('pythonRunning')
                          : strings.get('engineIdle'),
                      highlight: running,
                    );
                  },
                ),
                const SizedBox(width: 8),
                Text(
                  "v1.2.0",
                  style: KetTheme.descriptionStyle.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatusChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _StatusChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return HoverButton(
      onPressed: onTap,
      builder: (context, states) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: states.isHovered ? KetTheme.bgHover : KetTheme.accentSoft,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: KetTheme.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 12, color: KetTheme.accent),
              const SizedBox(width: 6),
              Text(
                label.toUpperCase(),
                style: KetTheme.headerStyle.copyWith(color: KetTheme.textMain),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatusInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool highlight;

  const _StatusInfo({
    required this.icon,
    required this.label,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: highlight ? KetTheme.accentSoft : KetTheme.bgHeader,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: highlight
              ? KetTheme.accent.withValues(alpha: 0.3)
              : KetTheme.border,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 11,
            color: highlight ? KetTheme.accent : KetTheme.textSecondary,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: KetTheme.statusStyle.copyWith(
              color: highlight ? KetTheme.textMain : KetTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class PanelHeader extends StatelessWidget {
  final ISidePanel panel;
  final Widget child;

  const PanelHeader({super.key, required this.panel, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: KetTheme.panelSurface(
          elevated: true,
          radius: KetTheme.radiusMd,
        ),
        child: ClipRRect(
          borderRadius: KetTheme.radiusMd,
          child: Column(
            children: [
              Container(
                height: KetTheme.panelHeaderHeight,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: KetTheme.bgHeader,
                  border: Border(bottom: BorderSide(color: KetTheme.border)),
                ),
                child: Row(
                  children: [
                    Icon(panel.icon, size: 14, color: KetTheme.accent),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        panel.title,
                        style: KetTheme.bodyStyle.copyWith(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      panel.id,
                      style: KetTheme.statusStyle.copyWith(
                        color: KetTheme.textMuted,
                        fontSize: 9.5,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: KeyedSubtree(key: ValueKey(panel.id), child: child),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
