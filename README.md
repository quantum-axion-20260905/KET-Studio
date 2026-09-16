# KET Studio

<p align="center">
  <img src="assets/ket_studio_logo.png" width="160" alt="KET Studio logo" />
</p>

<p align="center">
  <strong>An open-source Windows desktop workspace for visible and reproducible quantum experiments.</strong>
</p>

<p align="center">
  <a href="https://github.com/quantum-axion-20260905/KET-Studio/releases"><img src="https://img.shields.io/badge/release-v1.3.1-7257ff?style=for-the-badge" alt="Release v1.3.1" /></a>
  <a href="https://github.com/quantum-axion-20260905/KET-Studio/actions"><img src="https://img.shields.io/github/actions/workflow/status/quantum-axion-20260905/KET-Studio/flutter.yml?branch=main&style=for-the-badge&label=CI" alt="CI status" /></a>
  <a href="https://github.com/quantum-axion-20260905/KET-Studio/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-MIT-18c7db?style=for-the-badge" alt="MIT license" /></a>
  <a href="https://github.com/quantum-axion-20260905/KET-Studio"><img src="https://img.shields.io/github/stars/quantum-axion-20260905/KET-Studio?style=for-the-badge" alt="GitHub stars" /></a>
</p>

KET Studio brings Python execution, a real Windows terminal, structured
visualization and research context into one desktop workflow. It is designed
for students, researchers and open-source contributors who need to see what a
quantum experiment produced and keep enough context to run it again.

> Current scope: Windows 10/11 x64 desktop release. Linux and macOS are on the
> roadmap and are not presented as supported installers yet.

## Why KET Studio?

Quantum SDKs are powerful, but the path from a script to an inspectable result
is often fragmented across an editor, shell, plotting window and notebook.
KET Studio provides a focused local workspace where a run can expose:

- Python stdout/stderr and process status in a real ConPTY terminal;
- structured histograms, heatmaps, charts, tables and quantum-state views;
- rendered circuit/image artifacts in the project output directory;
- metrics, estimates, warnings and bounded session history;
- the metadata needed to make a result easier to reproduce and review.

KET Studio is an experiment runner and visualization workspace. It does not
replace Qiskit, Cirq, a simulator, a remote backend or a hardware provider.

## What works today

| Capability | Status | Notes |
|---|---|---|
| Python experiment execution | Available | Runs the selected script in a separate process |
| Real desktop terminal | Available | Windows ConPTY, ANSI/VT output, input, resize and Ctrl+C |
| Visualization protocol | Available | `KET_VIZ` JSON-lines transport with bounded renderers |
| Qiskit/Aer workflow | Available | Core packages are provisioned in the desktop environment |
| Circuit visualization | Available | Render a PNG/SVG first, then send its path |
| Research archive | Manual today | Save source, raw results, logs and `.ket/out` artifacts yourself |
| Linux/macOS | Roadmap | Build, native PTY and release QA are not complete |
| Web preview | Demo only | Browser sandbox has no local Python, file system or PTY |

## Quick start for users

1. Download the Windows package from the [KET Studio website](http://169.58.123.200:3010/downloads).
2. For the development/self-signed MSIX, install the accompanying certificate
   into `Trusted People`; use the EXE fallback when certificate trust is not
   available.
3. Open KET Studio and go to **Settings → Environment**.
4. Select or verify a Python 3.10+ interpreter and press **Rebuild environment**.
   The desktop app creates an isolated `ket_venv`, attempts to install
   `qiskit[visualization]`, `qiskit-aer` and `numpy`, and runs a verification
   circuit.
5. Open a project folder, create `experiment.py`, paste a tutorial and press
   **Run** or **F5**.

The `ket_viz` helper is injected by the KET Studio launcher during Run/F5; it
is not a package that should be installed with `pip`. Optional packages such as
`pandas`, `scipy` and IBM runtime can be added from **Settings → Environment**.

## First working experiment

This example uses only KET Studio’s visualization bridge and is deterministic:

```python
import ket_viz

ket_viz.metrics({
    "status": "completed",
    "backend": "AerSimulator",
    "qubits": 2,
    "shots": 1024,
    "seed": 7,
})

ket_viz.histogram(
    {"00": 512, "11": 512},
    title="Bell-state measurement",
)

ket_viz.table("Run summary", [
    ["Qubits", 2],
    ["Shots", 1024],
    ["Seed", 7],
])
```

Run it through KET Studio and expect metrics, a histogram and a table in the
visualization workspace. The [tutorials page](http://169.58.123.200:3010/tutorials)
contains more runnable templates, including a complete Qiskit Bell circuit and
a Matplotlib artifact example.

## Visualization API

The launcher exposes these Python helpers through the temporary `ket_viz`
module:

| Helper | Use it for |
|---|---|
| `histogram(counts, title=...)` | Measurement counts, probabilities or buckets |
| `heatmap(matrix, title=...)` | Rectangular numeric matrices and landscapes |
| `chart(values, title=...)` | Energy, loss, fidelity or convergence series |
| `table(rows)` / `table(title, rows)` | Compact parameter and result reports |
| `statevector(amplitudes, title=...)` | State labels, magnitudes and phases |
| `bloch(state)` | Bloch-sphere coordinates |
| `inspector(title, frames)` | Important algorithm steps and gate context |
| `metrics(values)` | Status, seed, backend and provenance metadata |
| `estimator(values)` | Pre-run qubit, depth and gate-count estimates |
| `text(message)` | Human-readable progress or status notes |
| `image(path, title=...)` | A saved PNG/SVG or other image artifact |
| `circuit(path, title=...)` | A rendered circuit image |

All payloads must be JSON-safe. For images and circuits, create the file first
and send its project-relative path afterwards. For another process or language,
write one UTF-8 line with the `KET_VIZ ` prefix followed by JSON:

```text
KET_VIZ {"kind":"histogram","payload":{"histogram":{"0":490,"1":534}}}
```

See the [Visualization Guide](docs/visualization-guide.md) for code examples
and the [Event Schema](docs/event_schema.md) for the formal protocol.

## Practical limits

The limits protect the desktop UI; they do not limit the underlying scientific
calculation. Save large raw data to disk and send an aggregated preview:

| Data | Safe UI limit | If exceeded |
|---|---:|---|
| Single event | 8 MiB | Ignored with a warning |
| Pending queue | 100 events | Oldest events are dropped |
| Session/history | 50 events / 50 sessions | Bounded memory |
| Matrix | 128 × 128 | Limit notice |
| Histogram | 64 buckets | Extra values are grouped into `other` |
| Chart | 2,000 points | First points are shown |
| Table | 100 × 32 | Limit notice |
| Statevector | 64 amplitudes | First amplitudes are shown |
| Inspector/Bloch | 100 items | Extra items are bounded |

There is no fixed native circuit-size limit because KET Studio displays a
rendered image rather than parsing a circuit object. For readability, roughly
20 qubits and depth 100 is a useful target; split larger circuits or show key
steps.

## Reproducible research workflow

KET Studio helps make a run visible, but it does not independently validate a
scientific claim or create an immutable archive yet. For an important result,
keep the following together:

```text
research-run/
├── experiment.py
├── requirements-lock.txt
├── metadata.json          # backend, shots, seed, versions
├── raw/                   # counts, arrays, CSV/JSON
├── logs/                  # stdout and stderr
└── .ket/out/              # images and rendered circuits
```

Record the KET Studio version, Git commit, script SHA-256, OS, Python and
library versions, backend configuration, qubits, depth, gate counts, shots,
optimizer parameters, seeds, raw results and rerun outcome. The complete
[Research Readiness](docs/research-readiness.md) document separates what works
now from the grant roadmap.

## Development

### Requirements

- Flutter 3.47+ and Dart;
- Python 3.10+ for the desktop environment;
- Windows Developer Mode for Windows plugin builds;
- Visual Studio with the Desktop development with C++ workload for Windows
  native builds.

### Run locally

```powershell
flutter pub get
flutter run -d windows
```

The browser build is a UI preview only:

```powershell
flutter run -d edge
```

### Verify changes

```powershell
flutter analyze
flutter test
flutter build windows --release
```

To build the native terminal host separately:

```powershell
pwsh -File .\scripts\build_native_host.ps1 -Configuration Release
```

The repository CI runs analysis, tests, a web build and a Windows build. Read
the [Development Guide](docs/development.md) before changing the event schema,
native host or release workflow.

## Project documentation

- [Getting Started](docs/getting-started.md) — installation and first run;
- [Visualization Guide](docs/visualization-guide.md) — KET Studio-specific code;
- [Event Schema](docs/event_schema.md) — formal JSON-lines protocol;
- [Research Readiness](docs/research-readiness.md) — current gaps and grant roadmap;
- [Architecture](docs/architecture.md) — system boundaries and data flow;
- [Windows Distribution](docs/windows-installer.md) — MSIX, EXE, checksums and signing;
- [Development Guide](docs/development.md) — contribution and release checks;
- [Contributing](CONTRIBUTING.md), [Code of Conduct](CODE_OF_CONDUCT.md) and
  [Security Policy](SECURITY.md).

## Roadmap

The most valuable next steps for a research-grade release are:

1. Exportable run bundles with manifest, JSONL events, raw results, logs and
   visual artifacts.
2. Pinned Python dependencies and environment snapshot/verification.
3. Run comparison, checkpoints and provenance-aware session navigation.
4. Deterministic expected-output tests and clean-machine installer smoke tests.
5. Trusted public code signing and a secure HTTPS distribution endpoint.
6. Optional backend adapter contracts for simulator and hardware workflows.
7. Linux/macOS builds only after native terminal and release QA are complete.

## Contributing

Issues, documentation improvements, tests and renderer ideas are welcome. Please
open an issue before a large architectural change, keep examples deterministic
where possible and include a minimal reproducer when reporting a bug.

## License

KET Studio is released under the [MIT License](LICENSE). Third-party packages
retain their own licenses; distribution work should preserve their notices.

## O‘zbekcha qisqa ma’lumot

KET Studio — Python tajribalarini yozish, haqiqiy Windows terminalida ishlatish,
`ket_viz` orqali histogram/heatmap/chart/table va boshqa vizuallarni olish,
natijalarni `.ket/out`da saqlash uchun ochiq manbali desktop muhit. Hozirgi
release Windows 10/11 x64 uchun. To‘liq maxsus kodlar va ishlatish tartibi
[Getting Started](docs/getting-started.md) hamda [Visualization Guide](docs/visualization-guide.md)
da berilgan.
