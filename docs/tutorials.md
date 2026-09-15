# KET Studio tutorials

Tutorials are designed as a short path from concept to a reproducible local
experiment:

1. Open the **Tutorial** panel and choose a lesson.
2. Read the explanation and inspect the code block.
3. Use **Open in editor** to edit the example, or **Run template** to execute
   the curated experiment immediately.
4. Inspect the resulting metrics, charts, histograms, tables, or inspector
   frames in the workspace panels.

The tutorial catalog is bilingual. Choose **Settings → Appearance → Language**
and select **O‘zbekcha** or **English**. Lesson titles, descriptions, section
content, action labels, difficulty and duration labels update with the chosen
language. Code remains in Python because it is executable source code.

## Runnable lessons

Runnable sections are connected to a template by a stable template id. The
current catalog includes:

| Lesson | Template | Output |
| --- | --- | --- |
| Quantum Entanglement | bell_state_dynamic | estimator, inspector, metrics and histogram |
| Grover's Algorithm | grover_professional | estimator, progress metrics and histogram |
| VQE: Variational Energy Optimization | vqe_realtime | live energy chart, convergence metrics and estimator |

The VQE lesson is intentionally marked as an educational simulation. It
demonstrates the hybrid optimization loop and KET Studio visualization API; it
does not claim hardware execution, a calibrated backend, or chemical accuracy.
For a research result, replace the template's simulated objective with a
version-pinned Hamiltonian, backend configuration, shot count and archived
results. See Research Readiness.

## Writing a new runnable tutorial

Add a Tutorial to lib/modules/tutorial/tutorial_model.dart. Use
LocalizedText(en: ..., uz: ...) for every user-facing lesson field. A code
section can be connected to an existing template:

~~~dart
TutorialSection(
  title: const LocalizedText(
    en: 'Measurement workflow',
    uz: 'O‘lchash jarayoni',
  ),
  subtitle: const LocalizedText(
    en: 'Run and inspect the result',
    uz: 'Natijani ishga tushiring va tekshiring',
  ),
  content: const LocalizedText(
    en: 'Run the experiment and inspect the distribution.',
    uz: 'Tajribani ishga tushirib, taqsimotni tekshiring.',
  ),
  templateId: 'bell_state_dynamic',
  codeSnippet: 'import ket_viz\nket_viz.histogram({"0": 50, "1": 50})',
),
~~~

templateId must match an item in
lib/modules/templates/templates_service.dart. A template should use the
injected ket_viz API rather than writing UI-specific code:

~~~python
import ket_viz

ket_viz.metrics({"algorithm": "demo", "status": "complete"})
ket_viz.chart([0.8, 0.5, 0.3], title="Convergence")
~~~

The learner can open the code in the editor or run the template directly. The
desktop app runs it in an isolated temporary project and sends events through
the same execution pipeline as a normal Python file. The web preview displays
the interface but cannot start local Python or a real PTY shell.

## Content quality rules

- Explain whether a result is simulated, emulated, or produced by hardware.
- Keep examples deterministic when reproducibility matters; seed random
  generators and state the seed in the output.
- Include a resource estimate for non-trivial circuits.
- Keep visual payloads within the limits documented in
  Visualization Guide.
- Link every runnable lesson to a maintained template and test its id with
  flutter test.
