# KET Studio architecture

KET Studio is a Flutter desktop IDE for Python-based quantum experiments. The
application is intentionally split into a presentation layer, small services,
and an event protocol so visualization features can evolve independently from
the Python runtime.

## Runtime flow

```text
Python script
    │ stdout: KET_VIZ {json}
    ▼
ExecutionService ──► TerminalService
    │ parsed events
    ▼
VizService ──► Visualization panels

Interactive terminal input/output
    │ keyboard + VT bytes
    ▼
TerminalWidget ──► NativeHostClient ──► ket_host ──► ConPTY/POSIX PTY ──► shell
```

`ExecutionService` starts an isolated Python launcher, captures stdout/stderr,
normalizes visualization events, and bounds queue/session sizes. `VizService`
keeps the current run and a bounded history. The UI listens to the services and
does not need to know how the process is launched.

The interactive terminal uses a separate native boundary. `TerminalWidget`
renders a real `xterm3` terminal, `NativeHostClient` transports length-framed
JSON messages, and `ket_host` owns PTY bytes, resize, interrupts and process
lifecycle. This keeps platform-specific console APIs out of Flutter while
preserving a testable protocol.

## UI composition

- `MainLayout` owns the workspace shell and panel placement.
- `PluginRegistry` provides extensible left and right panels.
- `LayoutService` keeps workspace presets and panel state.
- `EditorService` owns open documents, syntax highlighting, and autosave.
- `FileService` and `PythonSetupService` provide native desktop capabilities.

## Platform boundary

The Windows/Linux/macOS application can access local files, run Python, and
manage native window chrome. The web build is a safe visual/demo surface:
templates and the editor remain available, while local filesystem access,
Python execution, package installation, and native window controls are disabled
with clear messaging.

## Extension contract

The `KET_VIZ` protocol is documented in `docs/event_schema.md`. New event kinds
should update that schema, add a renderer, and include a sample or test. Payload
renderers must keep strict size limits so a malformed or oversized event cannot
freeze the UI.
