import 'package:fluent_ui/fluent_ui.dart';

import '../../core/localization/app_localizations.dart';

enum Difficulty { beginner, intermediate, advanced }

class LocalizedText {
  final String en;
  final String uz;

  const LocalizedText({required this.en, required this.uz});

  String resolve(AppLanguage language) {
    return language == AppLanguage.uzbek ? uz : en;
  }
}

class TutorialSection {
  final LocalizedText title;
  final LocalizedText subtitle;
  final LocalizedText content;
  final String? codeSnippet;
  final String? templateId;

  const TutorialSection({
    required this.title,
    required this.subtitle,
    required this.content,
    this.codeSnippet,
    this.templateId,
  });
}

class Tutorial {
  final String id;
  final LocalizedText title;
  final LocalizedText description;
  final IconData icon;
  final Difficulty difficulty;
  final String duration;
  final String category;
  final List<TutorialSection> sections;

  const Tutorial({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.difficulty,
    required this.duration,
    required this.category,
    required this.sections,
  });

  bool get hasRunnableExperiment =>
      sections.any((section) => section.templateId != null);
}

final List<Tutorial> quantumTutorials = [
  Tutorial(
    id: 'qubit_basics',
    title: const LocalizedText(
      en: 'The Qubit: Foundation of Quantum',
      uz: 'Qubit: kvant hisoblash asosi',
    ),
    description: const LocalizedText(
      en: 'Learn about the fundamental unit of quantum information and how it differs from a classical bit.',
      uz: 'Kvant axborotining asosiy birligi va uning klassik bitdan farqini o‘rganing.',
    ),
    icon: FluentIcons.build_definition,
    difficulty: Difficulty.beginner,
    duration: '5 min',
    category: 'foundations',
    sections: [
      TutorialSection(
        title: const LocalizedText(
          en: 'Classical vs Quantum',
          uz: 'Klassik va kvant',
        ),
        subtitle: const LocalizedText(
          en: 'From 0/1 to infinite possibilities',
          uz: '0/1 dan cheksiz imkoniyatlargacha',
        ),
        content: const LocalizedText(
          en: 'A classical bit is like a light switch: it is either ON (1) or OFF (0). A qubit can exist in a combination of both states simultaneously. This is the heart of quantum computing.',
          uz: 'Klassik bit chiroq tugmasiga o‘xshaydi: u yoqilgan (1) yoki o‘chirilgan (0) bo‘ladi. Qubit esa ikkala holatning kombinatsiyasida bir vaqtda mavjud bo‘lishi mumkin. Kvant hisoblashning mohiyati shunda.',
        ),
      ),
      TutorialSection(
        title: const LocalizedText(en: 'The Bloch Sphere', uz: 'Bloch sferasi'),
        subtitle: const LocalizedText(
          en: 'Visualizing the state',
          uz: 'Holatni vizuallashtirish',
        ),
        content: const LocalizedText(
          en: r'We visualize a qubit state as a point on a sphere called the Bloch Sphere. The North Pole represents $|0\rangle$ and the South Pole represents $|1\rangle$. Any point on the surface is a valid quantum state.',
          uz: r'Qubit holatini Bloch sferasi deb ataladigan sferadagi nuqta sifatida ko‘ramiz. Shimoliy qutb $|0\rangle$, janubiy qutb esa $|1\rangle$ holatini bildiradi. Sirtning istalgan nuqtasi yaroqli kvant holatidir.',
        ),
        codeSnippet:
            'from qiskit import QuantumCircuit\nqc = QuantumCircuit(1)\n# A qubit starts at |0>\nprint(qc)',
      ),
    ],
  ),
  Tutorial(
    id: 'superposition',
    title: const LocalizedText(
      en: 'Quantum Superposition',
      uz: 'Kvant superpozitsiyasi',
    ),
    description: const LocalizedText(
      en: 'Understand how a qubit can exist in multiple states before measurement.',
      uz: 'O‘lchashdan oldin qubit qanday qilib bir nechta holatda bo‘lishini tushuning.',
    ),
    icon: FluentIcons.processing,
    difficulty: Difficulty.beginner,
    duration: '8 min',
    category: 'foundations',
    sections: [
      TutorialSection(
        title: const LocalizedText(
          en: 'The spinning coin',
          uz: 'Aylanayotgan tanga',
        ),
        subtitle: const LocalizedText(
          en: 'Neither heads nor tails',
          uz: 'Na gerb, na raqam',
        ),
        content: const LocalizedText(
          en: 'Imagine a spinning coin on a table. While it spins, it is not simply heads or tails—it is a blend of both. Measurement is like stopping the coin: it collapses into one state.',
          uz: 'Stol ustida aylanayotgan tangani tasavvur qiling. U aylanayotganda faqat gerb yoki raqam emas — ikkalasining aralash holatidir. O‘lchash tangani to‘xtatishga o‘xshaydi: u bitta holatga qulaydi.',
        ),
      ),
      TutorialSection(
        title: const LocalizedText(
          en: 'Hadamard Gate (H)',
          uz: 'Hadamard darvozasi (H)',
        ),
        subtitle: const LocalizedText(
          en: 'Creating superposition',
          uz: 'Superpozitsiya yaratish',
        ),
        content: const LocalizedText(
          en: r'The Hadamard gate is the most common way to put a qubit into superposition. It transforms $|0\rangle \rightarrow \frac{1}{\sqrt{2}}(|0\rangle + |1\rangle)$.',
          uz: r'Hadamard darvozasi qubitni superpozitsiyaga o‘tkazishning eng ko‘p ishlatiladigan usulidir. U $|0\rangle \rightarrow \frac{1}{\sqrt{2}}(|0\rangle + |1\rangle)$ o‘zgarishini hosil qiladi.',
        ),
        codeSnippet:
            'from qiskit import QuantumCircuit\nqc = QuantumCircuit(1)\nqc.h(0) # Apply Hadamard gate\nprint(qc)',
      ),
    ],
  ),
  Tutorial(
    id: 'entanglement_lab',
    title: const LocalizedText(
      en: 'Quantum Entanglement',
      uz: 'Kvant chirmashuvi',
    ),
    description: const LocalizedText(
      en: 'Explore the correlations that link qubits together and power teleportation protocols.',
      uz: 'Qubitlarni bog‘laydigan va teleportatsiya protokollariga asos bo‘ladigan korrelyatsiyalarni o‘rganing.',
    ),
    icon: FluentIcons.link,
    difficulty: Difficulty.intermediate,
    duration: '12 min',
    category: 'algorithms',
    sections: [
      TutorialSection(
        title: const LocalizedText(en: 'Shared destiny', uz: 'Umumiy taqdir'),
        subtitle: const LocalizedText(
          en: 'Correlations beyond space',
          uz: 'Fazodan tashqari korrelyatsiyalar',
        ),
        content: const LocalizedText(
          en: 'When two qubits are entangled, their measurement results are correlated. The relationship is stronger than a classical shared random choice and is used in teleportation and cryptography.',
          uz: 'Ikki qubit chirmashganda, ularning o‘lchash natijalari korrelyatsiyalangan bo‘ladi. Bu aloqa klassik umumiy tasodifiy tanlovdan kuchliroq bo‘lib, teleportatsiya va kriptografiyada ishlatiladi.',
        ),
      ),
      TutorialSection(
        title: const LocalizedText(
          en: 'Bell state generation',
          uz: 'Bell holatini yaratish',
        ),
        subtitle: const LocalizedText(
          en: 'The CNOT gate',
          uz: 'CNOT darvozasi',
        ),
        content: const LocalizedText(
          en: 'To entangle two qubits, put one into superposition with H, then apply a controlled-NOT (CX) using the first qubit as control and the second as target.',
          uz: 'Ikki qubitni chirmashtirish uchun avval birinchisini H yordamida superpozitsiyaga o‘tkazing, keyin birinchisini control, ikkinchisini target qilib controlled-NOT (CX) qo‘llang.',
        ),
        templateId: 'bell_state_dynamic',
        codeSnippet:
            'from qiskit import QuantumCircuit\nqc = QuantumCircuit(2)\nqc.h(0)\nqc.cx(0, 1)\nqc.measure_all()\nprint(qc)',
      ),
    ],
  ),
  Tutorial(
    id: 'qiskit_starter',
    title: const LocalizedText(
      en: 'Qiskit: Your First Circuit',
      uz: 'Qiskit: birinchi circuit’ingiz',
    ),
    description: const LocalizedText(
      en: 'Write, simulate, and visualize your first quantum circuit using IBM Qiskit.',
      uz: 'IBM Qiskit yordamida birinchi kvant circuit’ingizni yozing, simulyatsiya qiling va vizuallashtiring.',
    ),
    icon: FluentIcons.code,
    difficulty: Difficulty.beginner,
    duration: '10 min',
    category: 'tooling',
    sections: [
      TutorialSection(
        title: const LocalizedText(
          en: 'The quantum circuit',
          uz: 'Kvant circuit’i',
        ),
        subtitle: const LocalizedText(
          en: 'Building the logic',
          uz: 'Mantiqni qurish',
        ),
        content: const LocalizedText(
          en: 'A quantum circuit is a sequence of gates applied to qubits. In Qiskit, define the number of qubits and classical bits before adding operations.',
          uz: 'Kvant circuit’i qubitlarga qo‘llanadigan darvozalar ketma-ketligidir. Qiskit’da amallarni qo‘shishdan oldin qubit va klassik bitlar sonini belgilang.',
        ),
      ),
      TutorialSection(
        title: const LocalizedText(
          en: 'Simulation and measurement',
          uz: 'Simulyatsiya va o‘lchash',
        ),
        subtitle: const LocalizedText(
          en: 'Getting results',
          uz: 'Natijani olish',
        ),
        content: const LocalizedText(
          en: 'Quantum states are not directly observable, so we measure them. Simulation exposes the resulting probability distribution and helps validate a circuit before hardware execution.',
          uz: 'Kvant holatlarini bevosita ko‘rib bo‘lmaydi, shuning uchun ularni o‘lchaymiz. Simulyatsiya natijadagi ehtimollik taqsimotini ko‘rsatadi va circuit’ni qurilmada ishga tushirishdan oldin tekshirishga yordam beradi.',
        ),
        codeSnippet:
            'from qiskit import QuantumCircuit, transpile\nfrom qiskit_aer import AerSimulator\n\nqc = QuantumCircuit(2)\nqc.h(0)\nqc.cx(0, 1)\nqc.measure_all()\n\nsimulator = AerSimulator()\nresult = simulator.run(transpile(qc, simulator)).result()\nprint(result.get_counts())',
      ),
    ],
  ),
  Tutorial(
    id: 'grover_search',
    title: const LocalizedText(
      en: "Grover's Algorithm",
      uz: 'Grover algoritmi',
    ),
    description: const LocalizedText(
      en: 'Understand amplitude amplification for searching an unsorted space.',
      uz: 'Tartiblanmagan fazoda qidirish uchun amplitudani kuchaytirishni tushuning.',
    ),
    icon: FluentIcons.search_and_apps,
    difficulty: Difficulty.advanced,
    duration: '20 min',
    category: 'algorithms',
    sections: [
      TutorialSection(
        title: const LocalizedText(
          en: 'Amplitude amplification',
          uz: 'Amplitudani kuchaytirish',
        ),
        subtitle: const LocalizedText(
          en: 'The power of interference',
          uz: 'Interferensiya kuchi',
        ),
        content: const LocalizedText(
          en: 'Grover’s algorithm increases the probability amplitude of the marked answer and suppresses incorrect answers through constructive and destructive interference.',
          uz: 'Grover algoritmi konstruktiv va destruktiv interferensiya orqali belgilangan javob amplitudasini oshiradi, noto‘g‘ri javoblarni esa pasaytiradi.',
        ),
      ),
      TutorialSection(
        title: const LocalizedText(
          en: 'Oracle and reflector',
          uz: 'Oracle va reflector',
        ),
        subtitle: const LocalizedText(
          en: 'Inverting the state',
          uz: 'Holatni invert qilish',
        ),
        content: const LocalizedText(
          en: 'The algorithm combines an oracle that marks the answer with a diffusion operator that reflects amplitudes about their average.',
          uz: 'Algoritm javobni belgilovchi oracle va amplitudalarni o‘rtacha qiymatiga nisbatan akslantiruvchi diffusion operatoridan iborat.',
        ),
        templateId: 'grover_professional',
        codeSnippet:
            '# Conceptual Grover step in Ket Studio\ndef grover_iteration(circuit, oracle):\n    circuit.append(oracle, [0, 1, 2])\n    circuit.h([0, 1, 2])\n    circuit.z([0, 1, 2])',
      ),
    ],
  ),
  Tutorial(
    id: 'vqe_optimization',
    title: const LocalizedText(
      en: 'VQE: Variational Energy Optimization',
      uz: 'VQE: variatsion energiya optimallashtirish',
    ),
    description: const LocalizedText(
      en: 'Run a guided variational optimization and inspect energy convergence with live charts and metrics.',
      uz: 'Yo‘naltirilgan variatsion optimallashtirishni ishga tushiring, energiya yaqinlashuvini jonli chart va metrics orqali kuzating.',
    ),
    icon: FluentIcons.test_beaker,
    difficulty: Difficulty.intermediate,
    duration: '15 min',
    category: 'algorithms',
    sections: [
      TutorialSection(
        title: const LocalizedText(
          en: 'What VQE solves',
          uz: 'VQE nimani yechadi',
        ),
        subtitle: const LocalizedText(
          en: 'A hybrid quantum-classical workflow',
          uz: 'Kvant-klassik gibrid jarayon',
        ),
        content: const LocalizedText(
          en: 'The Variational Quantum Eigensolver prepares a parameterized state, measures its energy, and lets a classical optimizer update the parameters. It is useful for chemistry and materials experiments.',
          uz: 'Variatsion Quantum Eigensolver parametrli holat tayyorlaydi, uning energiyasini o‘lchaydi va klassik optimizer parametrlarni yangilaydi. U kimyo va materialshunoslik tajribalarida foydali.',
        ),
      ),
      TutorialSection(
        title: const LocalizedText(
          en: 'Try the live optimizer',
          uz: 'Jonli optimizatorni sinang',
        ),
        subtitle: const LocalizedText(
          en: 'Energy curve, convergence metrics, and resource estimate',
          uz: 'Energiya egri chizig‘i, yaqinlashuv metrics’i va resurs bahosi',
        ),
        content: const LocalizedText(
          en: 'Use the runnable template to produce a convergence chart, per-step metrics, and an estimator report. This demo is a lightweight educational simulation; it does not claim hardware or chemical accuracy.',
          uz: 'Ishga tushadigan template orqali yaqinlashuv chart’i, har bir qadam metrics’i va estimator hisobotini oling. Bu yengil o‘quv simulyatsiyasi bo‘lib, haqiqiy qurilma yoki kimyoviy aniqlikni da’vo qilmaydi.',
        ),
        templateId: 'vqe_realtime',
        codeSnippet:
            'import ket_viz, math, random, time\n\ntarget = -1.1372\nenergy = 0.5\nvalues = []\nfor step in range(30):\n    energy -= (energy - target) * 0.2\n    values.append(energy)\n    ket_viz.chart(values, title="VQE energy convergence")\n    ket_viz.metrics({"step": step, "energy_ha": round(energy, 5)})\n    time.sleep(0.1)',
      ),
    ],
  ),
];
