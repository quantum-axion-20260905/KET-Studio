# KET Studio research readiness

Ushbu hujjat KET Studio’ni grant, ilmiy prototip va keyingi publication-grade
workflow uchun baholaydi. U ikki narsani ajratadi: bugun ishlaydigan imkoniyatlar
va grant bosqichida qo‘shilishi kerak bo‘lgan research infrastructure.

## Qisqa xulosa

KET Studio v1.3.1 exploratory research, ta’lim, algoritm prototyping va
Qiskit/Aer simulation uchun ishlatilishi mumkin. U Python kodini ishga tushiradi,
real desktop terminal beradi va natijalarni event-driven vizualizatsiya qiladi.

Hozircha KET Studio’ni mustaqil ilmiy natijalarni tasdiqlovchi backend yoki
laboratoriyaning yagona production platformasi sifatida ishlatmaslik kerak.
Ilmiy xulosa uchun simulation/backend natijalarini alohida tekshirish, seed va
environment ma’lumotlarini saqlash, raw result’larni arxivlash va workflow’ni
mustaqil qayta ishga tushirish talab qilinadi.

## Hozirgi imkoniyatlar va chegaralar

| Yo‘nalish | Hozirgi holat | Research izohi |
|---|---|---|
| Python execution | Desktop’da ishlaydi | Skript alohida process’da ishga tushadi |
| Qiskit/Aer | Python muhitiga bog‘liq | Simulation uchun mos, native backend emas |
| Qiskit IBM Runtime | Optional package orqali | Credential, queue va job monitoring native emas |
| Cirq va boshqa frameworklar | Raw Python orqali | KET Studio framework obyektini ichkaridan parse qilmaydi |
| Circuit visualization | PNG/SVG yoki matplotlib | Circuit semantikasi tahlil qilinmaydi |
| `ket_viz` events | Desktop’da ishlaydi | Event schema va safe renderer limitlari mavjud |
| Raw result export | Metrics CSV va chart image | To‘liq run archive hali yo‘q |
| Session history | UI xotirasida, bounded | Ilova yopilganda to‘liq session arxivi saqlanmaydi |
| Reproducibility | Manual checklist bilan | Avtomatik manifest va dependency lock hali yo‘q |
| Windows desktop | Tekshirilgan | ConPTY terminal va release build mavjud |
| Linux/macOS | Release yo‘q | Roadmap; alohida build, PTY va integration tekshiruvi kerak |
| Web | Demo/preview | Local Python, file system va PTY ishlamaydi |

### Vizualizatsiya xavfsiz limitlari

Renderer UI muzlab qolmasligi uchun quyidagi limitlar mavjud:

| Payload | Limit | Limitdan oshganda |
|---|---:|---|
| Bitta event | 8 MiB | Event ignore qilinadi, warning ko‘rsatiladi |
| Pending queue | 100 event | Eng eski eventlar tashlanadi |
| Session | 50 event | Eng eski eventlar tashlanadi |
| History | 50 session | Eng eski session tashlanadi |
| Matrix | 128×128 / 16 384 cell | Limit notice ko‘rsatiladi |
| Histogram | 64 bucket | Ortiqcha qiymatlar `other`ga yig‘iladi |
| Chart | 2 000 point | Dastlabki point’lar ko‘rsatiladi |
| Table | 100×32 | Limit notice ko‘rsatiladi |
| Statevector | 64 amplitude | Dastlabki amplitude’lar ko‘rsatiladi |
| Inspector/Bloch | 100 item | Ortiqcha item’lar cheklanadi |

Katta tajribalar uchun full statevector yoki har bir iteratsiyani UI’ga yuborish
o‘rniga sparse/top states, agregatsiya, checkpoint va raw file ishlatish tavsiya
etiladi.

## Hozirgi research workflow

Publication yoki grant tajribasini hozircha quyidagi manual tartibda saqlang:

1. Kodni Git repository’da saqlang va commit hash’ni yozib oling.
2. Python versiyasini tekshiring: `python --version`.
3. Environment snapshot oling: `python -m pip freeze > requirements-lock.txt`.
4. Simulation seed’larini kodda aniq belgilang va seed qiymatini yozib oling.
5. Backend, qubit soni, depth, shots, optimizer va boshqa parametrlarni
   `ket_viz.metrics()` yoki alohida JSON/CSV faylga yozing.
6. Yakuniy histogram/chart/table va raw counts’ni project papkasida saqlang.
7. KET Studio versiyasi, OS, Python environment va script commit’ini natija
   bilan birga arxivlang.
8. Natijani KET Studio’dan tashqarida ham qayta hisoblab, qiymatlarni solishtiring.

Minimal metadata misoli:

```python
import ket_viz

SEED = 20260914

ket_viz.metrics({
    "experiment": "bell_state",
    "seed": SEED,
    "backend": "AerSimulator",
    "qubits": 2,
    "depth": 2,
    "shots": 1024,
    "git_commit": "<commit-hash>",
})
```

`metrics` metadata’ni ko‘rsatadi, lekin hozircha uni avtomatik immutable
research manifest’ga aylantirmaydi. Shuning uchun yuqoridagi manual arxivlash
qadamlarini tashlab ketmaslik kerak.

## Reproducibility talablari

### Dependency locking

Dart/Flutter dependency’lari `pubspec.lock` orqali nazorat qilinadi. Python
environment esa desktop first-run paytida `venv` yaratib, Qiskit, NumPy va
optional package’larni PyPI’dan o‘rnatadi. Package install hozircha to‘liq
version-pinned emas; shu sababli aynan bir xil Python environment avtomatik
kafolatlanmaydi.

Grant bosqichida quyidagilar qo‘shilishi kerak:

- `requirements.in` yoki `pyproject.toml` — inson o‘qiydigan dependency spec;
- platformaga mos `requirements-lock.txt` — aniq versiyalar va hash’lar;
- `python -m pip freeze` va Python executable/version’ni export qilish;
- offline yoki cached install rejimi;
- environment verification’da package version mismatch’ni aniq ko‘rsatish;
- Qiskit, Qiskit Aer va IBM Runtime versiyalarini run metadata’ga yozish.

### Seed va parametrlar

Har bir stochastic experiment quyidagilarni saqlashi kerak:

- Python, NumPy va backend seed’lari;
- backend nomi va konfiguratsiyasi;
- qubit soni, circuit depth, gate count va shots;
- optimizer, learning rate, stopping criteria va initial parameters;
- hardware bo‘lsa device, calibration va job ID;
- input dataset yoki uning hash’i.

### Script identity

Natija qaysi koddan olinganini tekshirish uchun script path yetarli emas. Kelajak
manifest’i script’ning SHA-256 hash’i, Git commit’i, branch/tag’i va KET Studio
release versiyasini saqlashi kerak.

## Rejalashtirilgan experiment bundle

Grant uchun maqsad — har bir run’ni ko‘chirish va qayta tekshirish mumkin bo‘lgan
artifact sifatida saqlash:

```text
.ket/runs/<run-id>/
├── manifest.json       # version, commit, OS, Python, packages, seed, backend
├── events.jsonl        # to‘liq KET_VIZ event stream
├── stdout.log
├── stderr.log
├── script.py           # yoki script hash + repository reference
├── results.json        # raw counts/metrics/structured outputs
└── artifacts/
    ├── circuit.png
    ├── plot.png
    └── table.csv
```

Export tugmasi keyinchalik shu katalogni ZIP sifatida chiqarishi kerak. UI’dagi
bounded history rendering uchun ishlatiladi; research archive esa limitlangan
UI history’dan mustaqil, to‘liq JSONL/raw data bo‘lishi kerak.

Tavsiya etiladigan `manifest.json` maydonlari:

```json
{
  "schema_version": 1,
  "app_version": "1.3.1",
  "git_commit": "<commit-hash>",
  "script_sha256": "<sha256>",
  "started_at_utc": "2026-09-14T00:00:00Z",
  "os": "Windows",
  "python_version": "3.12.x",
  "packages": {"qiskit": "<version>", "numpy": "<version>"},
  "seed": 20260914,
  "backend": "AerSimulator",
  "parameters": {"qubits": 2, "shots": 1024}
}
```

Bu format hozir avtomatik yaratilmaydi; u grant roadmap’dagi aniq engineering
deliverable sifatida ko‘rsatiladi.

## Backend va real hardware chegaralari

KET Studio backend hisoblashini o‘zi amalga oshirmaydi. U Python process’ini
ishga tushiradi, stdout’dan event’larni oladi va natijani ko‘rsatadi. Qiskit,
Qiskit Aer, Cirq yoki IBM Runtime’ning o‘zi Python environment’da o‘rnatilgan
bo‘lishi kerak.

Real hardware workflow uchun hozir foydalanuvchi Python kodida SDK credential va
backend konfiguratsiyasini boshqaradi. KET Studio quyidagilarni hali native
ravishda bermaydi:

- credential vault yoki token lifecycle;
- backend/device discovery va calibration snapshot;
- remote job queue/status/cancel UI;
- hardware job ID’ni run manifest’ga avtomatik bog‘lash;
- hardware va simulator natijalarini avtomatik cross-check qilish.

## Validation va testing roadmap

Research ishonchliligi uchun quyidagi test qatlamlari kerak:

### P0 — majburiy

- `KET_VIZ` parser uchun malformed JSON, UTF-8, truncation va oversize testlar;
- har bir event type uchun schema/golden payload testlari;
- renderer limitlari uchun widget tests;
- run manifest va environment snapshot testlari;
- Windows native host startup/input/resize/interrupt/exit integration testi;
- release build’dan keyin portable smoke test.

### P1 — grant-ready

- Bell state va Grover kabi deterministic example’lar uchun expected-output test;
- seeded Aer simulation va raw counts regression test;
- Linux/macOS PTY CI;
- export qilingan run bundle’ni yangi process’da qayta o‘qish testi;
- accessibility, keyboard navigation va window resize testlari.

### P2 — production research

- hardware backend adapter contract testlari;
- result provenance va calibration snapshot validation;
- large-run performance benchmarklari;
- signed installer, update channel va crash diagnostics siyosati.

## Grantga kiritiladigan deliverable’lar

Grant scope’ini quyidagi aniq natijalar bilan ifodalash mumkin:

1. Reproducible Python environment: pinned packages, verification va export.
2. Experiment provenance: manifest, seed, parameters, script hash va Git link.
3. Complete run archive: event stream, raw results, logs va visual artifacts.
4. Scientific validation: deterministic examples, regression va integration
   testlar.
5. Backend adapters: simulator va real hardware uchun bir xil result contract.
6. Research UX: run comparison, checkpoint, export/import va provenance paneli.
7. Distribution quality: tested installer, code signing, cross-platform CI va
   accessibility.

## Hozirgi hujjatlar

- Vizual event API: [visualization guide](visualization-guide.md)
- Formal event transport: [event schema](event_schema.md)
- System boundary: [architecture](architecture.md)
- Contributor/test workflow: [development guide](development.md)

## Halol status

KET Studio hozir grant uchun kuchli, ishlaydigan desktop research-workbench
prototipi sifatida ko‘rsatilishi mumkin. Grant matnida uni “fully validated
scientific platform” deb emas, balki reproducibility, provenance, backend
adapterlari va validation qatlamlari bilan kengaytiriladigan ochiq manbali
research environment sifatida ta’riflash to‘g‘ri bo‘ladi.
