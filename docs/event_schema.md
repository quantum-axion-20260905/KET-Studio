# KET Studio Event Schema v1

KET Studio Python jarayonining `stdout` oqimi orqali vizualizatsiya eventlarini
qabul qiladi. Har bir event `KET_VIZ` prefiksi bilan boshlanadigan bitta UTF-8
qatorda kelishi kerak.

```text
KET_VIZ {"kind":"histogram","payload":{"histogram":{"0":490,"1":534}}}
```

## Umumiy format

```json
{
  "kind": "histogram",
  "payload": {},
  "ts": 1710000000000
}
```

- `kind` — event turi.
- `payload` — shu turga mos JSON object, array yoki string.
- `ts` — optional Unix timestamp milliseconds.
- `flush` — protocol field emas, lekin real-time ko‘rinish uchun stdout’ni
  har eventdan keyin flush qilish kerak.

## Event turlari

### `histogram`

O‘lchov yoki ehtimollik taqsimoti.

```json
{
  "kind": "histogram",
  "payload": {
    "histogram": {"00": 510, "11": 514},
    "title": "Bell state"
  }
}
```

`histogram` qiymatlari manfiy bo‘lmagan son bo‘lishi kerak. Renderer 64 ta
bucketgacha joy ajratadi; ortiqcha bucket’lar eng katta 63 tasi va `other`
bucket’iga yig‘iladi.

### `heatmap` / `matrix`

2D numeric matrix:

```json
{
  "kind": "heatmap",
  "payload": {
    "data": [[1.0, 0.2], [0.2, 0.8]],
    "title": "Correlation"
  }
}
```

Qatorlar bir xil uzunlikda bo‘lishi kerak. Renderer chegarasi: 128 qator,
128 ustun, jami 16 384 katak.

### `chart`

Numeric series:

```json
{
  "kind": "chart",
  "payload": {
    "data": [0.5, 0.31, 0.18, 0.09],
    "title": "Convergence"
  }
}
```

2 000 nuqtadan ortig‘i ko‘rsatilmaydi.

### `table`

```json
{
  "kind": "table",
  "payload": {
    "title": "Summary",
    "rows": [["Metric", "Value"], ["Shots", 1024]]
  }
}
```

Limit: 100 qator va 32 ustun.

### `statevector`

```json
{
  "kind": "statevector",
  "payload": {
    "title": "State",
    "amplitudes": [
      {"label": "00", "mag": 0.707, "phase": 0.0},
      {"label": "11", "mag": 0.707, "phase": 3.14159}
    ]
  }
}
```

`mag` magnitude, `phase` radians. Renderer 64 amplitudani ko‘rsatadi.

### `bloch`

Bir holat:

```json
{"kind":"bloch","payload":{"theta":1.5708,"phi":0.0}}
```

Ko‘p holat uchun array yuborish mumkin. Renderer 100 ta Bloch state bilan
cheklanadi.

### `inspector`

Algoritm qadamlarini ko‘rsatadi:

```json
{
  "kind": "inspector",
  "payload": {
    "title": "Grover steps",
    "frames": [
      {
        "gate": "H(0)",
        "state_description": "Superposition",
        "bloch": [{"theta": 1.57, "phi": 0.0}]
      }
    ]
  }
}
```

Renderer 100 ta frame’ni qabul qiladi.

### `metrics`

Arbitrary JSON object. Masalan:

```json
{
  "kind": "metrics",
  "payload": {
    "status": "running",
    "progress": "60%",
    "step": 12,
    "energy": -1.1372
  }
}
```

### `estimator`

Ish boshlanishidan oldingi resurs bahosi:

```json
{
  "kind": "estimator",
  "payload": {
    "qubits": 8,
    "depth": 42,
    "total_gates": 180,
    "gate_counts": {"H": 8, "CX": 64}
  }
}
```

### `image` / `circuit`

Desktop loyiha papkasidagi yoki absolute path’dagi rasm:

```json
{
  "kind": "circuit",
  "payload": {
    "path": ".ket/out/circuit.png",
    "title": "Optimized circuit"
  }
}
```

KET Studio circuit obyektini parse qilmaydi; Qiskit/Cirq circuit’i avval PNG,
SVG yoki boshqa render qilingan faylga aylantirilishi kerak.

### `text` / `error`

```json
{"kind":"text","payload":{"content":"Simulation finished"}}
```

`error` foydalanuvchiga xato kartasi sifatida ko‘rsatiladi.

## Himoya chegaralari

| Chegara | Qiymat | Natija |
|---|---:|---|
| Bitta encoded event | 8 MiB | Event tashlab yuboriladi, warning chiqadi |
| Pending event queue | 100 | Eng eski eventlar olib tashlanadi |
| Event/session | 50 | Eng eski event olib tashlanadi |
| Session history | 50 | Eng eski session olib tashlanadi |
| Matrix | 128×128 | Limit notice ko‘rsatiladi |
| Histogram | 64 bucket | `other` bucket qo‘shiladi |
| Chart | 2 000 point | Dastlabki nuqtalar ko‘rsatiladi |
| Table | 100×32 | Limit notice ko‘rsatiladi |
| Statevector | 64 amplitude | Dastlabki amplitudalar ko‘rsatiladi |
| Inspector/Bloch | 100 item | Ortiqcha itemlar cheklanadi |

Cheklovlar tajribani to‘xtatmaydi: event katta yoki noto‘g‘ri bo‘lsa, KET Studio
terminal va boshqa natijalarni ko‘rsatishda davom etadi.

## Transport talablari

1. stdout UTF-8 bo‘lishi kerak.
2. Har bir event bitta to‘liq qator bo‘lishi kerak.
3. `KET_VIZ` JSON’ini boshqa log bilan bir qatorda aralashtirmang.
4. Real-time natija uchun `flush=True` ishlating.
5. Web preview Python process va local file API’larini ishlatmaydi; to‘liq
   event pipeline desktop build’da ishlaydi.
