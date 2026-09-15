# Development guide

## Requirements

- Flutter 3.47 or newer (stable channel)
- Dart SDK provided by Flutter
- Python 3.10 or newer for desktop execution
- Windows Developer Mode for Windows plugin builds
- Visual Studio C++ workload for Windows release builds
- CMake 3.20 or newer for the native PTY host

## Quality checks

Run these from the repository root:

```powershell
flutter pub get
pwsh -File .\scripts\build_native_host.ps1
flutter analyze
flutter test
flutter build web --release
flutter build windows --release
dart run msix:create
```

To create the Windows installer (including `ket_host.exe` beside the Flutter
executable), run:

```powershell
pwsh -File .\scripts\build_windows_installer.ps1
```

The Windows build is the only currently supported release target. MSIX is the
preferred package for controlled distribution; Inno Setup remains the EXE
fallback when certificate trust is not available. See the full
[Windows distribution guide](windows-installer.md) for signing, clean-machine
verification and artifact checksums.

## Running locally

```powershell
flutter run -d windows
```

For a browser preview:

```powershell
flutter run -d edge
```

Browser mode is intended for UI demonstrations. Python execution and local
file operations are native desktop features.

## Research-quality changes

Research workflow bilan bog‘liq o‘zgarishlar uchun [research readiness](research-readiness.md)
dagi checklist va roadmap’ni saqlang. Ayniqsa dependency versiyalari, seed,
backend, raw result va provenance ma’lumotlari faqat UI’da ko‘rinib qolmasligi,
arxivlanadigan artifact sifatida test qilinishi kerak.

Har qanday yangi visualization event yoki renderer uchun:

1. `docs/event_schema.md`ga payload va limit yozing.
2. Normal, malformed va oversize payload uchun test qo‘shing.
3. `docs/visualization-guide.md`ga foydalanuvchi misolini qo‘shing.
4. Deterministic example bo‘lsa, expected output’ni ko‘rsating.
