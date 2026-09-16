# Changelog

All notable changes to KET Studio are documented here.

## Unreleased

No changes yet.

## 1.3.1 - 2026-09-16

- Bundled the required Microsoft Visual C++ x64 runtime DLLs app-local in
  Windows release packages for clean-machine startup.
- Added a reproducible `signtool` workflow for signing app binaries, the EXE
  installer and the MSIX package with a trusted release certificate.
- Expanded the practical installation and release documentation around
  SmartScreen, dependencies and trusted distribution.

## 1.3.0 - 2026-09-15

- Added a transparent KET Studio PNG brand mark and regenerated the Windows
  application icon from it.
- Added reproducible MSIX packaging metadata and documented certificate trust,
  signing, fallback EXE distribution and clean-machine verification.
- Clarified that Windows 10/11 x64 is the only shipped desktop target; Linux
  and macOS remain explicitly marked as roadmap platforms.
- Tightened release documentation around hashes, native terminal packaging,
  upgrade testing and supply-chain evidence.

## 1.2.0 - 2026-09-15

- Added English/O‘zbekcha localization for the tutorial surface, Settings,
  primary execution status labels and desktop actions.
- Added localized tutorial content and a runnable VQE lesson with Run template
  actions connected to real Python execution and visualization output.
- Added tutorial authoring documentation with template ids, research-quality
  disclaimers and reproducibility rules.
- Refined Settings into a tighter desktop configuration surface with a
  persisted language selector and localized environment controls.
- Refined the desktop shell with a denser spacing rhythm, compact bars and
  panel headers, tighter editor tabs, and a more focused welcome surface.
- Added draggable left and right panel splitters with bounded desktop widths.
- Improved status, metrics, history, explorer, terminal and visualization
  panel density for resizable Windows windows.
- Added research-readiness documentation covering reproducibility, provenance,
  experiment bundles, backend boundaries, validation and research deliverables.

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
