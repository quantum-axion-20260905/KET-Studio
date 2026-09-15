import 'package:fluent_ui/fluent_ui.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/plugin/plugin_system.dart';
import '../../core/services/settings_service.dart';
import 'tutorial_widget.dart';

class TutorialPlugin implements ISidePanel {
  @override
  String get id => 'tutorial';

  @override
  IconData get icon => FluentIcons.reading_mode;

  @override
  String get title => AppStrings.forLanguage(
    SettingsService().language,
  ).get('tutorialPanelTitle');

  @override
  String get tooltip => AppStrings.forLanguage(
    SettingsService().language,
  ).get('tutorialPanelTooltip');

  @override
  PanelPosition get position => PanelPosition.left;

  @override
  Widget buildContent(BuildContext context) {
    return const TutorialWidget();
  }
}
