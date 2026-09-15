import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/ket_theme.dart';
import '../../core/services/editor_service.dart';
import '../../core/services/settings_service.dart';
import '../templates/templates_service.dart';
import 'tutorial_model.dart';

class TutorialWidget extends StatefulWidget {
  const TutorialWidget({super.key});

  @override
  State<TutorialWidget> createState() => _TutorialWidgetState();
}

class _TutorialWidgetState extends State<TutorialWidget> {
  Tutorial? _selectedTutorial;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: SettingsService(),
      builder: (context, _) {
        final language = SettingsService().language;
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.05, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: _selectedTutorial != null
              ? _TutorialDetailView(
                  key: ValueKey('${_selectedTutorial!.id}-${language.name}'),
                  tutorial: _selectedTutorial!,
                  language: language,
                  onBack: () => setState(() => _selectedTutorial = null),
                )
              : _buildGridView(language),
        );
      },
    );
  }

  Widget _buildGridView(AppLanguage language) {
    final strings = AppStrings.forLanguage(language);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.get('learningLab'),
                style: KetTheme.headerStyle.copyWith(
                  color: KetTheme.accent,
                  letterSpacing: 1.5,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                strings.get('masterQuantum'),
                style: KetTheme.headerStyle.copyWith(
                  fontSize: 22,
                  color: KetTheme.textMain,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                strings.get('learningSubtitle'),
                style: KetTheme.descriptionStyle,
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 320,
              mainAxisExtent: 180,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemCount: quantumTutorials.length,
            itemBuilder: (context, index) {
              final tutorial = quantumTutorials[index];
              return _TutorialCard(
                tutorial: tutorial,
                language: language,
                onTap: () => setState(() => _selectedTutorial = tutorial),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _TutorialCard extends StatelessWidget {
  final Tutorial tutorial;
  final AppLanguage language;
  final VoidCallback onTap;

  const _TutorialCard({
    required this.tutorial,
    required this.language,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final diffColor = _getDifficultyColor(tutorial.difficulty);
    final strings = AppStrings.forLanguage(language);

    return HoverButton(
      onPressed: onTap,
      builder: (context, states) {
        final isHovered = states.isHovered;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: isHovered
              ? (Matrix4.identity()..scaleByDouble(1.02, 1.02, 1.0, 1.0))
              : Matrix4.identity(),
          decoration: BoxDecoration(
            color: isHovered ? KetTheme.bgHover : KetTheme.bgSidebar,
            borderRadius: KetTheme.radiusLg,
            border: Border.all(
              color: isHovered
                  ? KetTheme.accent.withValues(alpha: 0.5)
                  : KetTheme.border,
              width: isHovered ? 1.5 : 1,
            ),
            boxShadow: isHovered ? KetTheme.softShadow : null,
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(tutorial.icon, color: KetTheme.accent, size: 28),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: diffColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      strings
                          .difficulty(tutorial.difficulty.name)
                          .toUpperCase(),
                      style: TextStyle(
                        color: diffColor,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                tutorial.title.resolve(language),
                style: KetTheme.bodyStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(FluentIcons.clock, size: 12, color: KetTheme.textMuted),
                  const SizedBox(width: 4),
                  Text(
                    strings.duration(tutorial.duration),
                    style: KetTheme.descriptionStyle.copyWith(fontSize: 11),
                  ),
                  const Spacer(),
                  Icon(
                    FluentIcons.chevron_right_med,
                    size: 12,
                    color: KetTheme.textMuted,
                  ),
                  if (tutorial.hasRunnableExperiment) ...[
                    const SizedBox(width: 6),
                    Icon(FluentIcons.play, size: 11, color: KetTheme.success),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getDifficultyColor(Difficulty diff) {
    switch (diff) {
      case Difficulty.beginner:
        return KetTheme.success;
      case Difficulty.intermediate:
        return KetTheme.warning;
      case Difficulty.advanced:
        return KetTheme.danger;
    }
  }
}

class _TutorialDetailView extends StatelessWidget {
  final Tutorial tutorial;
  final AppLanguage language;
  final VoidCallback onBack;

  const _TutorialDetailView({
    super.key,
    required this.tutorial,
    required this.language,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.forLanguage(language);
    return Column(
      children: [
        // Premium App Bar
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: KetTheme.bgHeader,
            border: Border(
              bottom: BorderSide(color: KetTheme.border, width: 0.5),
            ),
          ),
          child: Row(
            children: [
              Tooltip(
                message: strings.get('back'),
                child: IconButton(
                  icon: const Icon(FluentIcons.back),
                  onPressed: onBack,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tutorial.title.resolve(language),
                    style: KetTheme.bodyStyle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${strings.difficulty(tutorial.difficulty.name).toUpperCase()} • ${strings.duration(tutorial.duration)}",
                    style: KetTheme.descriptionStyle.copyWith(
                      fontSize: 10,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Content
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            itemCount: tutorial.sections.length,
            itemBuilder: (context, index) {
              final section = tutorial.sections[index];
              return TweenAnimationBuilder<double>(
                duration: Duration(milliseconds: 500 + (index * 150)),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: child,
                    ),
                  );
                },
                child: _SectionWidget(section: section, language: language),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SectionWidget extends StatelessWidget {
  final TutorialSection section;
  final AppLanguage language;

  const _SectionWidget({required this.section, required this.language});

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.forLanguage(language);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          section.title.resolve(language),
          style: KetTheme.headerStyle.copyWith(
            color: KetTheme.accent,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          section.subtitle.resolve(language),
          style: KetTheme.bodyStyle.copyWith(
            color: KetTheme.textSecondary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 16),
        _buildRichContent(section.content.resolve(language)),
        if (section.codeSnippet != null) ...[
          const SizedBox(height: 20),
          _CodeBlock(
            code: section.codeSnippet!,
            language: language,
            templateId: section.templateId,
            filename:
                "lab_${section.title.resolve(language).toLowerCase().replaceAll(' ', '_')}.py",
          ),
        ],
        if (section.templateId != null &&
            TemplateService.findById(section.templateId!) == null)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              strings.get('templateUnavailable'),
              style: KetTheme.descriptionStyle,
            ),
          ),
        const SizedBox(height: 40),
        const Divider(),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildRichContent(String content) {
    final parts = content.split('\$');
    List<Widget> inlineParts = [];

    for (int i = 0; i < parts.length; i++) {
      if (i % 2 == 0) {
        if (parts[i].isNotEmpty) {
          inlineParts.add(
            Text(
              parts[i],
              style: KetTheme.bodyStyle.copyWith(
                height: 1.6,
                color: KetTheme.textMain.withValues(alpha: 0.9),
              ),
            ),
          );
        }
      } else {
        if (parts[i].isNotEmpty) {
          inlineParts.add(
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: Math.tex(
                parts[i],
                mathStyle: MathStyle.text,
                textStyle: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF00E5FF),
                ),
              ),
            ),
          );
        }
      }
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: inlineParts,
    );
  }
}

class _CodeBlock extends StatelessWidget {
  final String code;
  final String filename;
  final AppLanguage language;
  final String? templateId;

  const _CodeBlock({
    required this.code,
    required this.filename,
    required this.language,
    this.templateId,
  });

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.forLanguage(language);
    final template = templateId == null
        ? null
        : TemplateService.findById(templateId!);

    void openCode() => EditorService().openFile(filename, code);

    return Container(
      decoration: BoxDecoration(
        color: KetTheme.bgActivityBar,
        borderRadius: KetTheme.radiusLg,
        border: Border.all(color: KetTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: KetTheme.bgHeader,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
              border: Border(bottom: BorderSide(color: KetTheme.border)),
            ),
            child: Row(
              children: [
                Icon(FluentIcons.code, size: 12, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  filename,
                  style: KetTheme.descriptionStyle.copyWith(fontSize: 11),
                ),
                const Spacer(),
                Tooltip(
                  message: strings.get('openInEditor'),
                  child: IconButton(
                    icon: const Icon(FluentIcons.open_file, size: 14),
                    onPressed: openCode,
                  ),
                ),
                if (template != null)
                  Tooltip(
                    message: strings.get('runTemplate'),
                    child: IconButton(
                      icon: const Icon(FluentIcons.play, size: 14),
                      onPressed: () => TemplateService.runTemplate(template),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              code,
              style: const TextStyle(
                fontFamily: 'Cascadia Mono',
                fontSize: 11,
                color: Color(0xFFDCDCAA),
                height: 1.5,
              ),
            ),
          ),
          if (template != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Row(
                children: [
                  Button(
                    onPressed: openCode,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(FluentIcons.open_file, size: 13),
                        const SizedBox(width: 6),
                        Text(strings.get('tryTemplate')),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () => TemplateService.runTemplate(template),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(FluentIcons.play, size: 13),
                        const SizedBox(width: 6),
                        Text(strings.get('runTemplate')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
