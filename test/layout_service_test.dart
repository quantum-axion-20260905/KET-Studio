import 'package:flutter_test/flutter_test.dart';
import 'package:ket_studio/core/services/layout_service.dart';

void main() {
  test('workspace presets expose valid default panels', () {
    final service = LayoutService();

    for (final preset in service.workspaces) {
      if (preset.defaultLeftPanelId != null) {
        expect(
          preset.leftPanelIds,
          contains(preset.defaultLeftPanelId),
          reason: '${preset.mode} has an invalid left default',
        );
      }
      if (preset.defaultRightPanelId != null) {
        expect(
          preset.rightPanelIds,
          contains(preset.defaultRightPanelId),
          reason: '${preset.mode} has an invalid right default',
        );
      }
    }
  });

  test('unsupported panel toggles do not mutate the active workspace', () {
    final service = LayoutService();
    service.setWorkspace(WorkspaceMode.circuit);
    final before = service.activeRightPanelId;

    service.toggleLeftPanel('explorer');

    expect(service.activeRightPanelId, before);
    expect(service.activeLeftPanelId, isNull);
    service.setWorkspace(WorkspaceMode.code);
  });
}
