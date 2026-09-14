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
```

To create the Windows installer (including `ket_host.exe` beside the Flutter
executable), run:

```powershell
pwsh -File .\scripts\build_windows_installer.ps1
```

The Windows build may require an elevated or administrator-approved machine
setup, but the application itself is designed to install per-user through the
Inno Setup script in `installer/`.

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
