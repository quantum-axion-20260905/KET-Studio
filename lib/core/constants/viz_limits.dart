/// Safety and usability limits for visualization payloads.
///
/// These limits keep malformed or very large scientific payloads from
/// blocking Flutter's UI thread. They are intentionally public so the event
/// schema and user documentation can describe the same contract as the
/// renderer.
abstract final class VizLimits {
  static const int maxEventBytes = 8 * 1024 * 1024;
  static const int maxPendingEvents = 100;
  static const int maxEventsPerSession = 50;
  static const int maxSessions = 50;

  static const int maxMatrixRows = 128;
  static const int maxMatrixColumns = 128;
  static const int maxMatrixCells = maxMatrixRows * maxMatrixColumns;

  static const int maxTableRows = 100;
  static const int maxTableColumns = 32;
  static const int maxHistogramBuckets = 64;
  static const int maxChartPoints = 2000;
  static const int maxStatevectorAmplitudes = 64;
  static const int maxBlochStates = 100;
  static const int maxInspectorFrames = 100;
}
