# KET Studio vizualizatsiya qo‘llanmasi

KET Studio Python dasturining chiqishini event sifatida qabul qiladi va uni
Visualization, Metrics, Inspector, Estimator va History panellarida ko‘rsatadi.
Vizualizatsiya olish uchun maxsus backend shart emas: skript `ket_viz` API’si
orqali ma’lumot yuboradi.

## Birinchi ishlaydigan misol

Desktop KET Studio’da yangi `.py` fayl oching, quyidagini yozing va `Run`
(`F5`) tugmasini bosing:

```python
import ket_viz

ket_viz.metrics({
    "status": "completed",
    "qubits": 2,
    "shots": 1024,
})

ket_viz.histogram(
    {"00": 510, "11": 514},
    title="Bell-state measurement",
)
```

`ket_viz` KET Studio tomonidan skript ishga tushirilganda vaqtincha
taqdim qilinadi. Uni alohida `pip install` qilish shart emas.

## Qo‘llab-quvvatlanadigan API

### Histogram

O‘lchov natijalari, ehtimolliklar va klassifikatsiya taqsimotlari uchun:

```python
import ket_viz

counts = {"000": 420, "001": 96, "110": 72, "111": 436}
ket_viz.histogram(counts, title="Measurement distribution")
```

Qiymatlar son yoki `int`/`float` bo‘lishi va manfiy bo‘lmasligi kerak. 64 tadan
ko‘p bucket bo‘lsa, eng katta 63 tasi va qolganlari `other` sifatida ko‘rsatiladi.

### Heatmap va matrix

Korrelyatsiya, cost landscape yoki zichlik matritsasi uchun:

```python
import ket_viz

matrix = [
    [1.0, 0.2, 0.0],
    [0.2, 0.8, 0.1],
    [0.0, 0.1, 0.4],
]
ket_viz.heatmap(matrix, title="Qubit correlation")
```

Matrix barcha qatorlarda bir xil uzunlikdagi sonli qiymatlardan iborat bo‘lishi
kerak. Xavfsiz ko‘rsatish chegarasi 128×128 (16 384 katak).

### Chart

Vaqt bo‘yicha energiya, loss yoki convergence qiymatlari uchun:

```python
import ket_viz

energies = [0.5, 0.31, 0.18, 0.09, 0.04]
ket_viz.chart(energies, title="VQE convergence")
```

Chart 2 000 nuqtagacha to‘liq chiziladi. Ko‘proq nuqta kelganda dastlabki
2 000 tasi ko‘rsatiladi va panelda ogohlantirish chiqadi. Juda katta oqim uchun
har bir iteratsiyada emas, masalan, har 10- yoki 50-qadamda event yuboring.

### Table

Hisobot yoki parametrlarni jadval ko‘rinishida chiqarish:

```python
import ket_viz

rows = [
    ["Metric", "Value"],
    ["Qubits", 4],
    ["Shots", 1024],
    ["Fidelity", 0.998],
]
ket_viz.table("Experiment summary", rows)
```

Jadvalning xavfsiz chegarasi 100 qator va 32 ustun. Katta dataset uchun CSV
export qiling yoki ma’lumotni oldindan agregatsiya qiling.

### Statevector

Amplituda magnitudasi va fazasini ko‘rsatish uchun:

```python
import ket_viz

ket_viz.statevector([
    {"label": "00", "mag": 0.707, "phase": 0.0},
    {"label": "11", "mag": 0.707, "phase": 3.14159},
], title="Bell state amplitudes")
```

Interaktiv chart 64 amplitudagacha ko‘rsatadi. Katta statevector uchun faqat
eng muhim/sparse holatlarni yuborish tavsiya etiladi; to‘liq `2**n` massivni
har bir iteratsiyada yuborish foydasiz va og‘ir bo‘ladi.

### Bloch va Inspector

Bir yoki bir nechta qubit holati:

```python
ket_viz.bloch({"theta": 1.57, "phi": 0.0})

ket_viz.inspector("Bell-state steps", [
    {
        "gate": "H(0)",
        "state_description": "Qubit 0 superpositionga o‘tdi",
        "bloch": [
            {"theta": 1.57, "phi": 0.0},
            {"theta": 0.0, "phi": 0.0},
        ],
    },
])
```

Inspector 100 ta frame bilan cheklanadi, Bloch paneli esa 100 ta holatgacha
ko‘rsatadi.

### Metrics va Estimator

Uzoq hisoblash jarayonini tushunarli qilish uchun:

```python
ket_viz.metrics({
    "status": "optimizing",
    "step": 12,
    "energy": -1.1372,
    "progress": "60%",
})

ket_viz.estimator({
    "qubits": 8,
    "depth": 42,
    "total_gates": 180,
    "gate_counts": {"H": 8, "CX": 64, "RZ": 108},
})
```

Metrics — jonli holat, Estimator — ish boshlanishidan oldingi resurs bahosi.
Ularni har bir ichki loop iteratsiyasida yuborish shart emas; foydalanuvchiga
qaror qabul qilish uchun kerak bo‘lgan qadamlarni yuboring.

## Quantum circuit va matplotlib

KET Studio hozircha `QuantumCircuit` obyektini ichkaridan tahlil qilmaydi.
Circuit natijasi rasm sifatida ko‘rsatiladi. Qiskit bilan:

```python
from qiskit import QuantumCircuit
import matplotlib.pyplot as plt

qc = QuantumCircuit(2)
qc.h(0)
qc.cx(0, 1)
qc.measure_all()

qc.draw(output="mpl")
plt.show()  # KET Studio buni .ket/out ichiga saqlab ko‘rsatadi
```

Bu usul uchun `matplotlib` va tegishli quantum package’lar Python muhitida
o‘rnatilgan bo‘lishi kerak. Amaliy qulaylik uchun circuit’ni taxminan 20
qubit va 100 depth ichida saqlang; bundan kattasida rasm o‘qish qiyinlashadi,
fayl va render vaqti ortadi. Bu tavsiya, qat’iy matematik limit emas.

Qo‘lda rasm yoki circuit path yuborish ham mumkin:

```python
ket_viz.circuit(".ket/out/my_circuit.png", title="Optimized circuit")
ket_viz.image(".ket/out/landscape.png", title="Cost landscape")
```

Path desktop loyiha papkasiga nisbatan yoki absolute path bo‘lishi mumkin.

## Raw protocol

`ket_viz` ishlatish imkoni bo‘lmagan til yoki jarayonlar uchun stdout’ga bir
qatorda `KET_VIZ` prefiksli JSON chiqaring:

```python
import json

event = {
    "kind": "histogram",
    "payload": {
        "histogram": {"0": 490, "1": 534},
        "title": "Raw protocol example",
    },
}
print("KET_VIZ " + json.dumps(event), flush=True)
```

Har bir event to‘liq bitta UTF-8 stdout qatori bo‘lishi va `flush=True` bilan
yuborilishi kerak. Rasmiy maydonlar va renderer limitlari
[event schema](event_schema.md)da berilgan.

## Nima ishlaydi va nima ishlamaydi?

| Imkoniyat | Desktop | Web preview | Izoh |
|---|---:|---:|---|
| Python script run | Ha | Yo‘q | Brauzer local process ishga tushira olmaydi |
| Real terminal | Ha | Yo‘q | Windows ConPTY; Linux/macOS POSIX PTY |
| `ket_viz` events | Ha | Faqat desktop run bilan | Web’da demo UI mavjud |
| Local image/circuit | Ha | Yo‘q | Rasm fayli desktop processdan o‘qiladi |
| Qiskit/Cirq backend | Python muhitiga bog‘liq | Yo‘q | KET Studio backendni o‘zi o‘rnatib bermaydi |
| Native circuit parser | Hozircha yo‘q | Yo‘q | `qc.draw()` yoki raw `circuit` image kerak |

Event hajmi 8 MiB’dan oshsa event tashlab yuboriladi va Visualization panelida
ogohlantirish chiqadi. Bir sessionda 50 ta event, History’da 50 ta session
saqlanadi. Bu chegaralar UI’ni katta tajribada muzlab qolishidan himoya qiladi.

## Foydali tajriba tuzilmasi

1. `estimator` bilan ish hajmini ko‘rsating.
2. `metrics` bilan progress va backend holatini yuboring.
3. `inspector` bilan faqat muhim algoritm qadamlarini ko‘rsating.
4. `histogram`, `heatmap` yoki `chart` bilan yakuniy natijani bering.
5. `table` orqali qisqa xulosa chiqaring.

Tayyor ishlaydigan misollar: [examples/](../examples/), ayniqsa
[bell_state.py](../examples/bell_state.py) va
[grover_search.py](../examples/grover_search.py).
