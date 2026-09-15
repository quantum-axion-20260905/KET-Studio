import 'package:flutter_test/flutter_test.dart';

import 'package:ket_studio/core/localization/app_localizations.dart';
import 'package:ket_studio/modules/templates/templates_service.dart';
import 'package:ket_studio/modules/tutorial/tutorial_model.dart';

void main() {
  test('Uzbek localization exposes translated product labels', () {
    final strings = AppStrings.forLanguage(AppLanguage.uzbek);

    expect(strings.get('settings'), 'Sozlamalar');
    expect(strings.get('runTemplate'), contains('ishga'));
    expect(strings.duration('15 min'), '15 daq');
  });

  test('tutorial catalog contains runnable VQE experiment', () {
    final tutorial = quantumTutorials.firstWhere(
      (item) => item.id == 'vqe_optimization',
    );
    final section = tutorial.sections.firstWhere(
      (item) => item.templateId != null,
    );

    expect(tutorial.title.resolve(AppLanguage.uzbek), contains('VQE'));
    expect(section.templateId, 'vqe_realtime');
    expect(TemplateService.findById(section.templateId!), isNotNull);
  });
}
