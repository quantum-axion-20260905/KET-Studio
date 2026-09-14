# Changelog

All notable changes to KET Studio are documented here.

## Unreleased

- Refined the desktop shell with a denser spacing rhythm, compact bars and
  panel headers, tighter editor tabs, and a more focused welcome surface.
- Added draggable left and right panel splitters with bounded desktop widths.
- Improved status, metrics, history, explorer, terminal and visualization
  panel density for resizable Windows windows.

## 1.1.0 - 2026-09-14

- Added a real interactive terminal: xterm3 UI, Windows ConPTY, POSIX PTY,
  ANSI/VT output, resize, Ctrl+C, exit lifecycle and cleanup.
- Added a documented visualization guide and versioned event schema for
  histogram, heatmap, chart, table, statevector, Bloch, inspector, metrics,
  estimator, image and circuit results.
- Added renderer safeguards and user-facing warnings for oversized or invalid
  events, matrices, tables, charts, histograms and statevectors.
- Fixed the injected Python `ket_viz.table` and `ket_viz.chart` APIs so the
  documented call signatures work as written.
- Fixed web startup crashes caused by desktop-only platform and filesystem
  APIs and added an explicit browser-mode experience.
- Added automated service, protocol and CI checks plus MIT, contribution,
  conduct and security policies.

## 1.0.0

- Initial public KET Studio release with Python execution, event-driven
  visualizations, templates, explorer, tutorials, metrics, and history.
