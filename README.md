<p align="center">
  <img src="assets/ket_studio_logo.png" width="160" alt="KET Studio logo" />
</p>

<h1 align="center">KET Studio</h1>

<p align="center">
  <b>Kvant hisoblash va ilmiy vizualizatsiya uchun professional Event-Driven IDE</b>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Platform-Windows%2010%2F11%20x64-blue?style=for-the-badge&logo=windows" />
  <img src="https://img.shields.io/badge/Version-v1.3.0-orange?style=for-the-badge" />
  <img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge" />
</p>

KET Studio — Python asosidagi kvant tajribalarini yozish, haqiqiy terminalda
ishga tushirish, natijalarni vizual ko‘rish va tajriba izlarini saqlash uchun
open-source desktop research workspace.

## Platforma holati

| Platforma | Holat | Izoh |
|---|---|---|
| Windows 10/11 x64 | **Mavjud** | Tekshirilgan desktop build, real ConPTY terminal, MSIX va EXE installer |
| Linux | Rejalashtirilgan | Release artifact va native PTY testi hali yo‘q |
| macOS | Rejalashtirilgan | Release artifact va native PTY testi hali yo‘q |
| Web preview | Demo | Browser sandbox sabab Python, fayl tizimi va PTY o‘chirilgan |

Linux va macOS nomlari arxitektura yo‘nalishi sifatida ko‘rsatiladi; ular hozir
foydalanuvchiga tayyor release sifatida va’da qilinmaydi.

## Tez boshlash

Talablar: Flutter 3.47+, Dart, Python 3.10+ va Windows uchun Visual Studio C++
workload. Windows plugin buildlari uchun Developer Mode yoqilgan bo‘lishi
kerak.

```powershell
flutter pub get
flutter run -d windows
```

Browser preview faqat UI ko‘rsatmasi uchun:

```powershell
flutter run -d edge
```

## Haqiqiy terminal

Windows desktop’dagi Terminal paneli `xterm3` va native `ket_host.exe` orqali
ishlaydi:

- Windows ConPTY, ANSI/VT output, keyboard input va terminal resize;
- `Ctrl+C`, shell exit va process-tree cleanup;
- native host bilan length-framed JSON transport;
- browser preview’da aniq “desktop-only” holati.

Native hostni alohida tekshirish:

```powershell
pwsh -File .\scripts\build_native_host.ps1
```

## Vizualizatsiya workflow’i

Python process stdout’iga `KET_VIZ` JSON event chiqaradi. KET Studio event’ni
tekshiradi va mos renderer’da ko‘rsatadi. Tavsiya etiladigan API:

```python
import ket_viz

counts = {"00": 480, "01": 20, "10": 30, "11": 494}
ket_viz.histogram(counts, title="Bell State Results")

matrix = [[0.8, 0.1], [0.1, 0.0]]
ket_viz.heatmap(matrix, title="Density Matrix")

ket_viz.table("Simulation details", [["Qubits", 2], ["Shots", 1024]])
ket_viz.metrics({"seed": 20260914, "backend": "AerSimulator"})
```

Raw protocol ham mavjud:

```text
KET_VIZ {"kind":"text","payload":{"content":"Salom KET Studio"}}
```

Qo‘llab-quvvatlanadigan event turlari, payload limitlari va xatolik holatlari
uchun [Visualization Guide](docs/visualization-guide.md) hamda [Event Schema](docs/event_schema.md)
ni o‘qing. Boshlang‘ichdan to‘liq amaliy workflow uchun [Getting Started](docs/getting-started.md)
qo‘llanmasi ham mavjud.

## Windows installer

Release build uchun:

```powershell
flutter pub get
dart run flutter_launcher_icons
pwsh -File .\scripts\build_native_host.ps1
flutter analyze
flutter test
dart run msix:create
```

To‘liq MSIX, sertifikat, EXE fallback, checksum va clean-machine checklist
[Windows distribution guide](docs/windows-installer.md)da berilgan. Shaxsiy
signing key repository’ga qo‘shilmaydi.

## Research readiness

KET Studio exploratory research, ta’lim va algorithm prototyping uchun
ishlatilishi mumkin. U hozircha ilmiy natijani mustaqil tasdiqlovchi backend
emas: backend SDK, seed, package versiyalari, raw result va commit hash’ni
alohida saqlash kerak.

Publication yoki grant tajribasida quyidagilarni arxivlang:

1. Git commit/tag va script SHA-256.
2. Python version va pinned package snapshot.
3. Backend, qubit, depth, shots, seed va optimizer parametrlari.
4. Raw result, stdout/stderr, visual artifacts va event stream.
5. KET Studio versiyasi, OS va qayta ishga tushirish yozuvi.

Chegaralar va grant deliverable’lari [Research Readiness](docs/research-readiness.md)
da, tizim chegarasi [Architecture](docs/architecture.md)da yozilgan.

## Hissa qo‘shish

```powershell
flutter analyze
flutter test
flutter build windows --release
```

Yangi event yoki renderer qo‘shilganda schema, limit, malformed payload testi,
foydalanuvchi misoli va deterministic expected output ham qo‘shilsin. Batafsil
qoidalar [Development Guide](docs/development.md) va [CONTRIBUTING.md](CONTRIBUTING.md)
da.

## Litsenziya

MIT. KET Studio ochiq manbali loyiha sifatida hamkorlik va takrorlanadigan
research workflow’larini qo‘llab-quvvatlash uchun ishlab chiqiladi.
