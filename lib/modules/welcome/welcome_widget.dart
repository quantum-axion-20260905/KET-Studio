import 'package:fluent_ui/fluent_ui.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../config/demo_content.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/services/command_service.dart';
import '../../core/services/editor_service.dart';
import '../../core/services/settings_service.dart';
import '../../core/theme/ket_theme.dart';
import '../templates/templates_service.dart';

class WelcomeWidget extends StatelessWidget {
  const WelcomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: SettingsService(),
      builder: (context, _) {
        final strings = AppStrings.forLanguage(SettingsService().language);
        return Container(
          color: KetTheme.bgCanvas,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOverview(strings),
                    const SizedBox(height: 12),
                    _buildQuickActions(strings),
                    const SizedBox(height: 12),
                    _buildTemplates(strings),
                    const SizedBox(height: 12),
                    _buildFooter(strings),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOverview(AppStrings strings) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: KetTheme.panelSurface(elevated: true),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            strings.get('controlCenter'),
            style: KetTheme.headerStyle.copyWith(color: KetTheme.accent),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/quantum.jpg',
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.get('workspaceTitle'),
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: KetTheme.textMain,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      strings.get('workspaceSubtitle'),
                      style: KetTheme.bodyStyle.copyWith(
                        color: KetTheme.textSecondary,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _OverviewChip(
                title: strings.get('scripts'),
                value: strings.get('scriptsHint'),
              ),
              _OverviewChip(
                title: strings.get('panels'),
                value: strings.get('panelsHint'),
              ),
              _OverviewChip(
                title: strings.get('execution'),
                value: strings.get('executionHint'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(AppStrings strings) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: KetTheme.panelSurface(elevated: true),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(strings.get('actions'), style: KetTheme.headerStyle),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _ActionCard(
                      icon: FluentIcons.page_add,
                      title: strings.get('newFile'),
                      subtitle: strings.get('newFileHint'),
                      emphasis: true,
                      onTap: () => EditorService().openFile("untitled.py", ""),
                    ),
                    _ActionCard(
                      icon: FluentIcons.fabric_open_folder_horizontal,
                      title: strings.get('openFolder'),
                      subtitle: strings.get('openFolderHint'),
                      onTap: () => CommandService().execute("file.openFolder"),
                    ),
                    _ActionCard(
                      icon: FluentIcons.test_beaker,
                      title: strings.get('tryDemo'),
                      subtitle: strings.get('tryDemoHint'),
                      onTap: () => EditorService().openFile(
                        "demo_visualizer.py",
                        DemoContent.demoScript,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: KetTheme.panelSurface(elevated: true),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(strings.get('workspace'), style: KetTheme.headerStyle),
                const SizedBox(height: 10),
                _InfoRow(
                  icon: FluentIcons.bulleted_list,
                  title: strings.get('projectState'),
                  description: strings.get('projectStateHint'),
                ),
                const SizedBox(height: 10),
                _InfoRow(
                  icon: FluentIcons.processing,
                  title: strings.get('visualization'),
                  description: strings.get('visualizationHint'),
                ),
                const SizedBox(height: 10),
                _InfoRow(
                  icon: FluentIcons.settings,
                  title: strings.get('environment'),
                  description: strings.get('environmentHintWelcome'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTemplates(AppStrings strings) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: KetTheme.panelSurface(elevated: true),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(strings.get('quantumTemplates'), style: KetTheme.headerStyle),
          const SizedBox(height: 6),
          Text(
            strings.get('quantumTemplatesHint'),
            style: KetTheme.descriptionStyle,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: TemplateService.templates.map((tpl) {
              return _TemplateCard(tpl: tpl, language: strings.language);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(AppStrings strings) {
    return Row(
      children: [
        Text(
          strings.get('learningResources'),
          style: KetTheme.descriptionStyle,
        ),
        const SizedBox(width: 22),
        Text(strings.get('quantumHardware'), style: KetTheme.descriptionStyle),
        const Spacer(),
        Text("v1.2.0", style: KetTheme.descriptionStyle.copyWith(fontSize: 11)),
      ],
    );
  }
}

class _OverviewChip extends StatelessWidget {
  final String title;
  final String value;

  const _OverviewChip({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: KetTheme.bgHeader,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: KetTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title.toUpperCase(),
            style: KetTheme.headerStyle.copyWith(color: KetTheme.accent),
          ),
          const SizedBox(height: 4),
          Text(value, style: KetTheme.descriptionStyle),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool emphasis;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.emphasis = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: HoverButton(
        onPressed: onTap,
        builder: (context, states) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: emphasis
                  ? KetTheme.accentSoft
                  : (states.isHovered ? KetTheme.bgHover : KetTheme.bgHeader),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: emphasis
                    ? KetTheme.accent.withValues(alpha: 0.28)
                    : KetTheme.border,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: emphasis ? KetTheme.accent : KetTheme.bgCanvas,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    size: 16,
                    color: emphasis ? Colors.white : KetTheme.accent,
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  title,
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: KetTheme.textMain,
                  ),
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: KetTheme.descriptionStyle),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: KetTheme.bgHeader,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 15, color: KetTheme.accent),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: KetTheme.textMain,
                ),
              ),
              const SizedBox(height: 4),
              Text(description, style: KetTheme.descriptionStyle),
            ],
          ),
        ),
      ],
    );
  }
}

class _TemplateCard extends StatelessWidget {
  final QuantumTemplate tpl;
  final AppLanguage language;

  const _TemplateCard({required this.tpl, required this.language});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      child: HoverButton(
        onPressed: () => TemplateService.useTemplate(tpl),
        builder: (context, states) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: states.isHovered ? KetTheme.bgHover : KetTheme.bgHeader,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: states.isHovered
                    ? KetTheme.accent.withValues(alpha: 0.28)
                    : KetTheme.border,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: KetTheme.accentSoft,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(tpl.icon, size: 18, color: KetTheme.accent),
                ),
                const SizedBox(height: 9),
                Text(
                  tpl.titleFor(language),
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: KetTheme.textMain,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tpl.descriptionFor(language),
                  style: KetTheme.descriptionStyle,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
