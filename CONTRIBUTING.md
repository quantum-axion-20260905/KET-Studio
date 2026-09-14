# Contributing to KET Studio

Thank you for helping make quantum programming more accessible. Contributions
are welcome in code, documentation, examples, testing, design, and research.

## Before you start

- Read the project README and the architecture notes in `docs/architecture.md`.
- For a larger feature, open an issue first so the scope and API can be agreed.
- Keep changes focused and avoid committing generated build output.

## Local development

Install Flutter 3.47 or newer and Python 3.10 or newer. Then run:

```powershell
flutter pub get
flutter analyze
flutter test
flutter build web --release
```

For native Windows development, enable Windows Developer Mode so Flutter can
create plugin symlinks, then run `flutter run -d windows`.

## Pull requests

1. Explain the problem and the user-facing result.
2. Add or update tests for behavior that can be tested automatically.
3. Update documentation and the event schema when an API changes.
4. Run `flutter analyze`, `flutter test`, and the relevant release build.
5. Keep commits small enough to review and do not include secrets or local
   machine paths.

## Design principles

- Preserve the event-driven boundary between Python execution and Flutter UI.
- Keep desktop-only capabilities behind platform guards.
- Prefer clear, accessible UI over decorative complexity.
- Treat untrusted Python output as data and enforce sensible rendering limits.
