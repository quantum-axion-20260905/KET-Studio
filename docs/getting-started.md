# KET Studio: amaliy boshlash qo‘llanmasi

Bu hujjat KET Studio’ni o‘rnatishdan boshlab, Python tajribasini ishga
tushirish, real terminaldan foydalanish, natijalarni vizual panellarga
uzatish va reproducible research yozuvlarini saqlashgacha bo‘lgan to‘liq
minimal workflow’ni beradi. KET Studio — experiment runner va visualization
workspace; u Qiskit, Cirq yoki boshqa quantum backend o‘rnini bosmaydi.

## 1. Qo‘llab-quvvatlash chegarasi

Hozirgi release Windows 10/11 x64 uchun ishlab chiqilgan va tekshirilgan.
Windows build real ConPTY terminal, Python process, local file access, MSIX va
EXE installer bilan keladi. Linux va macOS interfeysda roadmap sifatida
ko‘rsatilishi mumkin, lekin hozir ular uchun yuklab olinadigan release artifact
yo‘q.

Web preview faqat UI va demo oqimini ko‘rsatadi. Brauzer sandbox’i sababli u
foydalanuvchi kompyuterida Python process, haqiqiy PTY terminal yoki local
rasm faylini ishga tushira olmaydi.

## 2. O‘rnatish

### MSIX — tavsiya etilgan paket

1. `ket-studio-windows-x64.msix` va development/self-signed build bo‘lsa
   `ket-studio-msix-test-certificate.cer` fayllarini yuklab oling.
2. Certificate faylini **Install Certificate → Local Machine → Place all
   certificates in the following store → Trusted People** orqali o‘rnating.
3. MSIX’ni oching va publisher nomi certificate bilan mosligini tekshiring.
4. Windows SmartScreen yoki package trust ogohlantirishi chiqsa, bu test
   certificate ommaviy CA tomonidan tasdiqlanmaganini anglatadi.

Self-signed certificate faqat nazorat qilinadigan development, review yoki
pilot mashina uchun mos. Ommaviy tarqatishda trusted code-signing certificate
ishlating yoki EXE fallback’ni tanlang.

### EXE fallback

`ket-studio-windows-x64-setup.exe` per-user installer bo‘lib, administrator
huquqisiz o‘rnatish uchun mo‘ljallangan. Paket ichida KET Studio va native
terminal uchun kerakli Microsoft Visual C++ x64 runtime DLL’lari ham bor.
MSIX trust ishlamasa yoki reviewerga oddiy setup flow kerak bo‘lsa shu paketdan
foydalanish mumkin. Installer imzolanmagan bo‘lsa, Windows SmartScreen baribir
ogohlantirishi mumkin; bu holatni faqat trusted code-signing certificate bilan
hal qilish mumkin.

### O‘rnatilgandan keyingi tekshiruv

`SHA256SUMS.txt` faylidagi hash’ni yuklab olingan artifact bilan solishtiring:

```powershell
Get-FileHash .\ket-studio-windows-x64.msix -Algorithm SHA256
Get-FileHash .\ket-studio-windows-x64-setup.exe -Algorithm SHA256
```

Hash mos kelmasa, package’ni ishga tushirmang va qayta yuklab oling.

## 3. Birinchi ishga tushirish

1. KET Studio’ni oching.
2. **Settings** ichida Python interpreter yo‘lini tekshiring. Masalan,
   `python`, `py -3` yoki aniq `C:\Python312\python.exe` yo‘lidan biri
   ishlatilishi mumkin.
3. Yangi project oching yoki mavjud project papkasini tanlang.
4. `.py` fayl yarating.
5. `Run` yoki `F5` ni bosing.
6. Kod chiqishi Terminal’da, tanilgan `KET_VIZ` event’lari esa Visualization,
   Metrics, Inspector, Estimator yoki History panellarida paydo bo‘ladi.

KET Studio ishga tushirish paytida `ket_viz` modulini vaqtincha process ichiga
qo‘shadi. Shu sababli alohida `pip install ket_viz` talab qilinmaydi. Birinchi
desktop setup application support ichida izolyatsiyalangan `ket_venv` yaratadi,
`qiskit[visualization]`, `qiskit-aer` va `numpy` core paketlarini o‘rnatishga
urinadi va kichik verification circuit bilan muhitni tekshiradi. Matplotlib
visualization extra orqali keladi; `pandas`, `scipy`, IBM runtime yoki boshqa
optional paketlar avtomatik o‘rnatilmaydi — ularni Settings → Environment’dan
qo‘shing.

Script’ni oddiy terminalda `python experiment.py` qilib ishga tushirsangiz,
`ket_viz` topilmasligi mumkin, chunki injection faqat KET Studio Run/F5
launcher’ida ishlaydi. Bunday holatda raw `KET_VIZ` protocol’dan foydalaning.

## 4. Project tuzilmasi va natijalar

Ishga tushirilgan script joylashgan project ichida KET Studio quyidagi ishchi
papkalarni yaratadi:

```text
my-project/
├── experiment.py          # foydalanuvchi script’i
└── .ket/
    ├── out/               # PNG/SVG va boshqa visualization artifact’lar
    └── temp/              # launcher.py va vaqtinchalik runtime fayllari
```

`.ket/out` — saqlab qolish va grant/publication materialiga qo‘shish mumkin
bo‘lgan output joyi. `.ket/temp` — runtime tomonidan boshqariladi; unga qo‘lda
natija arxivlashga tayanmang.

## 5. Eng kichik ishlaydigan tajriba

```python
import ket_viz

counts = {"00": 510, "11": 514}
ket_viz.metrics({
    "status": "completed",
    "qubits": 2,
    "shots": sum(counts.values()),
    "seed": 20260915,
})
ket_viz.histogram(counts, title="Bell-state measurement")
ket_viz.table("Experiment summary", [
    ["Qubits", 2],
    ["Shots", 1024],
    ["Seed", 20260915],
])
```

`ket_viz` chaqiriqlari darhol stdout’ga structured event chiqaradi. Event
real-time ko‘rinishi uchun launcher `flush`ni o‘zi boshqaradi; boshqa processdan
raw protocol yuborayotgan bo‘lsangiz, `flush=True`ni o‘zingiz qo‘shing.

## 6. Natijani qaysi panelga qanday uzatish kerak

### Histogram: counts yoki probability

```python
ket_viz.histogram(
    {"000": 420, "001": 96, "110": 72, "111": 436},
    title="Measurement distribution",
)
```

Kalitlar bitstring yoki label, qiymatlar esa manfiy bo‘lmagan son bo‘lsin.
Counts, probability yoki klassifikatsiya score’larini yuborish mumkin, ammo
bir tajriba ichida birlikni title yoki metrics’da aniq yozing.

### Heatmap: matrix va landscape

```python
matrix = [
    [1.0, 0.2, 0.0],
    [0.2, 0.8, 0.1],
    [0.0, 0.1, 0.4],
]
ket_viz.heatmap(matrix, title="Qubit correlation")
```

Har bir qator bir xil uzunlikda va barcha cell’lar numeric bo‘lishi kerak.

### Chart: convergence, loss va energy

```python
energies = [0.50, 0.31, 0.18, 0.09, 0.04]
ket_viz.chart(energies, title="VQE convergence")
```

Optimizer loop katta bo‘lsa, har bir ichki qadamni yubormang; masalan, har
10- yoki 50-qadamda bitta nuqta yuboring.

### Table: qisqa, audit qilinadigan xulosa

```python
ket_viz.table("Run summary", [
    ["Parameter", "Value"],
    ["Backend", "AerSimulator"],
    ["Qubits", 8],
    ["Depth", 42],
    ["Shots", 4096],
])
```

### Statevector va Bloch

```python
ket_viz.statevector([
    {"label": "00", "mag": 0.707, "phase": 0.0},
    {"label": "11", "mag": 0.707, "phase": 3.14159},
], title="Bell amplitudes")

ket_viz.bloch({"theta": 1.5708, "phi": 0.0})
```

Statevector uchun `mag` magnitude, `phase` radians. Katta `2**n` massivni har
iteratsiyada yuborish o‘rniga eng muhim yoki sparse amplitudalarni yuboring.

### Inspector: algoritm qadamlarining izohi

```python
ket_viz.inspector("Bell-state steps", [
    {
        "gate": "H(0)",
        "state_description": "Superposition",
        "bloch": [{"theta": 1.5708, "phi": 0.0}],
    },
    {
        "gate": "CX(0, 1)",
        "state_description": "Entangled state",
    },
])
```

### Metrics va Estimator

```python
ket_viz.estimator({
    "qubits": 8,
    "depth": 42,
    "total_gates": 180,
    "gate_counts": {"H": 8, "CX": 64, "RZ": 108},
})

ket_viz.metrics({
    "status": "optimizing",
    "step": 12,
    "energy": -1.1372,
    "progress": "60%",
})
```

Estimator ish boshlanishidan oldingi resurs bahosi, Metrics esa jonli holat
uchun. Research log’ida ikkalasini aralashtirmang.

## 7. Rasm, circuit va Matplotlib natijasini uzatish

KET Studio circuit obyektini o‘zi parse qilmaydi. Qiskit yoki boshqa library
avval rasm faylini render qiladi, keyin KET Studio’ga path yuboriladi:

```python
from qiskit import QuantumCircuit
import ket_viz

qc = QuantumCircuit(2)
qc.h(0)
qc.cx(0, 1)
qc.measure_all()

qc.draw(output="mpl", filename=".ket/out/bell-circuit.png")
ket_viz.circuit(".ket/out/bell-circuit.png", title="Bell circuit")
```

Matplotlib figure uchun:

```python
import matplotlib.pyplot as plt
import ket_viz

plt.plot([0, 1, 2, 3], [0.8, 0.4, 0.2, 0.1])
plt.title("Loss")
plt.savefig(".ket/out/loss.png", bbox_inches="tight")
ket_viz.image(".ket/out/loss.png", title="Loss curve")
```

Desktop launcher Matplotlib’ning `plt.show()` chaqirig‘ini ham `.ket/out`
ichiga PNG qilib, `image` event sifatida uzatishga moslaydi. Explicit
`savefig` esa artifact nomini, formatini va arxivini o‘zingiz nazorat
qilishingiz uchun afzal.

## 8. Raw KET_VIZ protocol

Python bo‘lmagan jarayon, subprocess yoki custom adapter ishlatilsa, stdout’ga
quyidagi ko‘rinishda bitta UTF-8 qator chiqaring:

```python
import json
import time

event = {
    "kind": "histogram",
    "payload": {
        "histogram": {"0": 490, "1": 534},
        "title": "Raw protocol example",
    },
    "ts": int(time.time() * 1000),
}
print("KET_VIZ " + json.dumps(event, ensure_ascii=False), flush=True)
```

Qoidalar:

- `KET_VIZ ` prefiksi va JSON bitta to‘liq qatorda bo‘lsin;
- `kind` va unga mos `payload` yuborilsin;
- oddiy log’ni shu qatorda aralashtirmang;
- real-time oqim uchun stdout buffer’ini flush qiling;
- rasm path project papkasiga nisbatan yoki absolute bo‘lishi mumkin;
- rasm event’idan oldin fayl haqiqatan yozilgan bo‘lsin.

To‘liq schema va barcha maydonlar [event_schema.md](event_schema.md)da.

## 9. Sig‘im, limit va amaliy tavsiyalar

Bu limitlar UI’ni katta oqimda muzlab qolishidan himoya qiladi:

| Ma’lumot | Ko‘rsatiladigan xavfsiz limit | Katta bo‘lsa |
|---|---:|---|
| Bitta encoded event | 8 MiB | Event tashlanadi, warning chiqadi |
| Pending event queue | 100 | Eng eski eventlar olib tashlanadi |
| Histogram | 64 bucket | Top 63 + `other` |
| Matrix/heatmap | 128 × 128 | Limit notice, agregatsiya qiling |
| Chart | 2 000 point | Dastlabki nuqtalar ko‘rsatiladi |
| Table | 100 × 32 | Jadvalni qisqartiring yoki CSV saqlang |
| Statevector | 64 amplitude | Sparse/top amplitudalarni yuboring |
| Inspector/Bloch | 100 item | Muhim qadamlarni tanlang |
| History | 50 session | Eski sessionlar aylanma saqlanadi |

Amaliy research uchun barcha raw natijani UI’ga tiqish shart emas: JSON/CSV
ni `.ket/out`da saqlang, panelga esa xulosa, sample yoki downsample qilingan
ko‘rinishni yuboring. Qulay ko‘rinish uchun circuit’ni taxminan 20 qubit va
100 depth ichida chizing; bu qat’iy matematik limit emas, o‘qiluvchanlik
bo‘yicha tavsiya.

## 10. Real terminal

Windows desktop Terminal paneli native `ket_host.exe` va Windows ConPTY orqali
shell bilan ishlaydi. U ANSI/VT ranglar, keyboard input, resize, `Ctrl+C`,
process exit va shell cleanup’ni qo‘llaydi. Run tugmasidagi Python process esa
structured visualization oqimini alohida kuzatadi.

Terminal smoke-test:

```powershell
python --version
echo KET Studio terminal OK
python -c "print('stdout OK')"
```

Terminal input ishlamasa Settings’dagi shell/interpreter yo‘lini, keyin esa
native host mavjudligini tekshiring. Browser preview’da real terminal ataylab
yo‘q.

## 11. Research va grant uchun reproducibility checklist

Har bir muhim run bilan quyidagilarni birga arxivlang:

1. KET Studio version, git commit yoki release tag.
2. OS, Python version va `pip freeze`/lockfile.
3. Backend/library versionlari.
4. Qubit soni, circuit depth, gate counts, shots, seed va optimizer sozlamalari.
5. Script, input dataset, raw result, stdout/stderr va `KET_VIZ` event stream.
6. `.ket/out` ichidagi rasm va jadval artifact’lari.
7. Run vaqti, exit code, warning/error va qayta ishga tushirish natijasi.

KET Studio vizualizatsiyani ko‘rsatadi, lekin backend hisobining ilmiy
to‘g‘riligini mustaqil tasdiqlamaydi. Natijani publication yoki grantga
qo‘shishdan oldin mustaqil baseline, deterministic seed va raw data bilan
tekshiring. Chegaralar va tavsiya etiladigan arxiv tuzilmasi
[research-readiness.md](research-readiness.md)da.

## 12. Muammo bo‘lsa

| Belgisi | Tekshirish |
|---|---|
| Python topilmadi | Settings’dagi interpreter path va `python --version` |
| Terminal bo‘sh | Run’dan keyin process chiqishini, shell va `ket_host.exe`ni tekshiring |
| Vizual chiqmaydi | `KET_VIZ ` prefiksi, valid JSON, `flush=True` va payload schema |
| Matplotlib rasm yo‘q | `matplotlib` shu Python muhitida o‘rnatilganmi, `.ket/out`ga yozildimi |
| MSIX o‘rnatilmaydi | Certificate Trusted People store’da va publisher mosligini tekshiring |
| UI sekinlashadi | Matrix/chart/table/statevector limitlarini saqlang, oqimni downsample qiling |

Muammoni report qilganda yuqoridagi muhit ma’lumotlari, minimal reproducer,
terminal log’i, event JSON’i va KET Studio version’ini birga yuboring. Shu
ma’lumotlar grant reviewer yoki contributor uchun muammoni qayta tiklashni
ancha osonlashtiradi.
