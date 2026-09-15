# Windows distribution

KET Studio currently ships one supported desktop target: **Windows 10/11
x64**. Linux and macOS are roadmap targets; this repository does not publish
installers for them yet. The release pipeline below is intentionally explicit
so a grant reviewer can reproduce the build and distinguish a tested artifact
from a future platform plan.

## Release artifacts

| Artifact | Purpose | Trust model |
|---|---|---|
| `ket-studio-windows-x64.msix` | Preferred Windows package | Requires a trusted signing certificate on the target machine |
| `ket-studio-msix-test-certificate.cer` | Public certificate for the test package | Install only for a controlled development/review machine |
| `ket-studio-windows-x64-setup.exe` | Compatibility installer | Per-user Inno Setup package; useful when MSIX certificate trust is unavailable |

The public download page must show MSIX as the primary artifact and explain
the certificate requirement. A self-signed MSIX is suitable for development,
review and controlled pilots, but it is not the same as a publicly trusted
code-signed release.

## Prerequisites

- Flutter 3.47+ on the stable channel
- Dart SDK included with Flutter
- Visual Studio with **Desktop development with C++**
- Windows Developer Mode enabled
- CMake 3.20+
- Python 3.10+ for the runtime smoke test
- Inno Setup 6 when the EXE fallback is required

Verify the core toolchain:

```powershell
flutter doctor -v
flutter --version
dart --version
python --version
```

## Build the Windows application

From the repository root:

```powershell
flutter pub get
dart run flutter_launcher_icons
pwsh -File .\scripts\build_native_host.ps1
flutter analyze
flutter test
flutter build windows --release
Copy-Item .\native\ket_host\build\Release\ket_host.exe .\build\windows\x64\runner\Release\ket_host.exe -Force
```

The native host is copied beside the Flutter executable by the installer
script. Do not distribute only the Flutter executable: the real terminal needs
`ket_host.exe` at runtime.

## Build the MSIX package

The package metadata is in `pubspec.yaml` under `msix_config`. The package logo
and Windows application icon both use the transparent PNG at
`assets/ket_studio_logo.png`.

```powershell
dart run msix:create
```

Inspect the generated package before publishing:

```powershell
Get-ChildItem -Path build,dist -Recurse -Include *.msix,*.cer,*.pfx |
  Select-Object FullName,Length
Get-FileHash .\build\windows\x64\runner\Release\* -Algorithm SHA256
```

The exact output directory can vary by `msix` package version. Find the
artifact with:

```powershell
Get-ChildItem -Path . -Recurse -File -Include *.msix |
  Select-Object FullName,Length,LastWriteTime
```

### Installing a development/self-signed MSIX

1. Download `ket-studio-msix-test-certificate.cer` beside the package and
   install it on the test machine into **Trusted People**.
2. Open the `.msix` file and confirm the publisher matches the certificate.
3. Launch KET Studio and run the terminal smoke test from
   `docs/visualization-guide.md`.
4. Remove the package from **Settings → Apps → Installed apps** when testing
   an upgrade or rollback.

For a public grant demo, either sign the MSIX with a certificate trusted by
the target audience or publish the EXE fallback alongside it. Never describe a
self-signed package as universally trusted.

## Build the EXE fallback

```powershell
pwsh -File .\scripts\build_windows_installer.ps1
```

The script builds the release application, includes `ket_host.exe`, and uses
Inno Setup to create a per-user installer under:

```text
dist\windows-installer\
```

## Release verification checklist

- Confirm the version is identical in `pubspec.yaml`, the MSIX metadata and
  the download page.
- Install on a clean Windows user profile.
- Open a project, edit a Python file and run it from the Run action.
- Type into the real terminal, resize it, send `Ctrl+C`, and exit the shell.
- Emit `KET_VIZ` histogram, heatmap, table and metrics events.
- Verify the app icon has no opaque square background in Start Menu, desktop
  shortcut and taskbar surfaces.
- Record SHA-256 hashes for every published artifact.
- Test uninstall, reinstall and upgrade from the previous release.
- Keep Linux/macOS marked as unavailable until each has a build, install test,
  native terminal test and documented support owner.

## Signing and supply-chain policy

The repository does not contain a private signing key. Signing credentials must
remain in the release environment, never in Git. A production release should
record the certificate subject, thumbprint, timestamp, build commit and SHA-256
hash in the release notes. Dependency lockfiles and the source commit are part
of the release evidence.
