import 'package:flutter_test/flutter_test.dart';
import 'package:ket_studio/core/constants/viz_limits.dart';
import 'package:ket_studio/core/services/viz_service.dart';

void main() {
  testWidgets('stores bounded visualization events in a session', (
    tester,
  ) async {
    final service = VizService();
    service.clearSessions();
    await tester.pump();

    service.startSession('test-session');
    service.updateData(VizType.histogram, {
      'histogram': {'0': 1, '1': 2},
    });
    await tester.pump(const Duration(milliseconds: 40));

    expect(service.currentSession, isNotNull);
    expect(service.currentSession!.events, hasLength(1));
    expect(service.currentSession!.events.single.type, VizType.histogram);
    expect(service.status, VizStatus.hasOutput);

    service.endSession();
    await tester.pump();
    expect(service.status, VizStatus.hasOutput);
    expect(service.currentSession!.status, VizStatus.stopped);
  });

  testWidgets('keeps visualization sessions bounded and surfaces warnings', (
    tester,
  ) async {
    final service = VizService();
    service.clearSessions();
    await tester.pump();

    service.startSession('bounded-session');
    for (var index = 0; index < VizLimits.maxEventsPerSession + 5; index++) {
      service.updateData(VizType.text, {'content': 'event-$index'});
    }
    service.addWarning('oversized payload');
    await tester.pump(const Duration(milliseconds: 40));

    expect(
      service.currentSession!.events,
      hasLength(VizLimits.maxEventsPerSession),
    );
    expect(service.currentSession!.events.first.payload['content'], 'event-5');
    expect(service.currentSession!.warnings, contains('oversized payload'));
  });
}
