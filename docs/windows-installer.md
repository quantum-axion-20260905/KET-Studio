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
pwsh -File .\scripts\prepare_windows_runtime.ps1
```

The native host is copied beside the Flutter executable by the installer
script. Do not distribute only the Flutter executable: the real terminal needs
`ket_host.exe` at runtime. `prepare_windows_runtime.ps1` also copies the
Microsoft Visual C++ runtime DLLs beside the app, so a clean Windows machine
does not need a separate VC++ installation just to launch KET Studio.

## Clean-machine runtime dependency

Flutter and the native terminal host use the Microsoft Visual C++ runtime. The
release scripts bundle the required x64 files app-local:

```text
msvcp140.dll
msvcp140_atomic_wait.dll
vcruntime140.dll
vcruntime140_1.dll
```

If the preparation script reports a missing file, install the official
Microsoft Visual C++ 2015–2022 Redistributable (x64) and run it again. The
runtime DLLs must come from the official Microsoft installation; do not copy
debug DLLs or files from an unrelated architecture.

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

The script builds the release application, includes `ket_host.exe`, bundles the
VC++ runtime and uses Inno Setup to create a per-user installer under:

```text
dist\windows-installer\
```

## Code signing and SmartScreen

An installer can be technically valid and still trigger Windows SmartScreen if
it is unsigned or signed with a private/self-signed certificate. The current
development artifact is in that category. No script can make an unsigned file
universally trusted on every Windows machine.

For a public release, obtain an organization-verified code-signing certificate
from a trusted certificate authority, keep its PFX/private key outside Git,
then sign the app binaries, native host, installer and MSIX with an RFC 3161
timestamp:

```powershell
pwsh -File .\scripts\sign_windows_release.ps1 `
  -CertificatePath .\release-signing.pfx
```

For a local interactive run, the signing script prompts for the PFX password.
In CI, provide `KET_SIGN_CERT_PASSWORD` from the platform secret store instead
of committing a certificate or password. Verify the result:

```powershell
Get-AuthenticodeSignature .\dist\windows-installer\ket-studio-setup-1.3.1.exe
Get-AuthenticodeSignature .\dist\windows-installer\ket-studio-windows-x64.msix
```

Signing reduces warnings and proves publisher integrity, but SmartScreen
reputation can still take time for a new publisher or a new binary. Keep the
EXE and MSIX hashes in the release notes and do not call a self-signed build a
universally trusted release.

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
