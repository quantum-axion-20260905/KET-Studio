# Unitary Foundation microgrant application draft

**Status:** Draft — not submitted

This draft is prepared for the Unitary Foundation quantum open-source microgrant.
Complete the applicant fields and review every technical claim before submitting.

- Official programme: [Unitary Foundation microgrants](https://unitary.foundation/)
- Application form: [Unitary Foundation application](https://unitaryfund.typeform.com/to/j0kAOd)
- Project website: <http://169.58.123.200:3010>
- Source repository: <https://github.com/quantum-axion-20260905/KET-Studio>
- License: [MIT](../LICENSE)

## Proposal title

KET Studio: reproducible visual workflows for quantum experiments

## Project summary

KET Studio is an open-source Windows desktop research workspace for running
Python quantum experiments and reviewing their results as structured visual
evidence. It connects a real terminal, Python execution, a small JSON-lines
visualization protocol and a research-oriented project workflow in one local
application. The current release supports Qiskit/Aer-style simulation workflows,
histograms, heatmaps, charts, tables, state views, circuit/image artifacts and
bounded session context.

The proposed work will make the existing prototype substantially more useful for
reproducible open-source research. The project will add exportable run bundles,
environment and provenance capture, deterministic regression examples, stronger
validation, and documentation that lets a new user move from a Python script to
a reviewable result. All source, documentation and engineering outputs will
remain openly available under the MIT-licensed project repository.

## Why this matters

Quantum SDKs and simulators are increasingly capable, but a small research or
education experiment still requires users to assemble an editor, shell, plotting
tool and ad-hoc result files. This makes it difficult to see what happened and
to reproduce a result later. KET Studio focuses on this practical gap: it makes
the path from experiment code to terminal output, visual artifact and run context
explicit without claiming to replace a quantum SDK, simulator or hardware
provider.

## Proposed work and deliverables

1. **Reproducible run bundle**
   - Add a `.ket/runs/<run-id>/` bundle containing a manifest, JSONL events,
     stdout/stderr, raw results and visual artifacts.
   - Record application version, Git commit, script hash, OS, Python version,
     packages, backend, seed and experiment parameters.
   - Add export/import or ZIP export with a documented schema.

2. **Verified Python environment**
   - Introduce a human-readable dependency specification and a pinned lock file
     for the supported Qiskit/Aer workflow.
   - Report installation and verification failures as failed setup states with
     actionable recovery guidance.
   - Export an environment snapshot alongside an important run.

3. **Validation and regression tests**
   - Add parser and renderer tests for valid, malformed, truncated and oversized
     `KET_VIZ` events.
   - Add deterministic Bell-state and seeded simulator examples with expected
     outputs.
   - Test the Windows terminal host lifecycle, input, resize, interrupt and exit
     behavior in the release workflow.

4. **Research UX and documentation**
   - Add run comparison, checkpoints or provenance navigation where the design
     can support them without hiding raw data.
   - Expand English and Uzbek documentation with runnable templates, practical
     payload limits, artifact handling and troubleshooting.
   - Document how to keep raw results and visual evidence suitable for review.

5. **Public release quality**
   - Publish a tagged release with checksums, clean-machine installation notes,
     accessibility checks and a transparent limitations section.
   - Keep Linux and macOS as an explicit roadmap item until their native terminal
     and release QA are complete.

## What is new or different

Qiskit, Aer and other quantum tools already provide important circuit, simulation
and plotting capabilities. KET Studio is complementary: it is a desktop layer
for running a user's Python workflow, receiving structured events and keeping
the resulting evidence visible in context. Its contribution is the workflow
contract around execution, terminal output, bounded renderers and provenance,
not a new simulator or a claim of hardware superiority.

The grant work will turn the current manual research checklist into a concrete,
portable artifact format that can be inspected outside the application. That
boundary is deliberately modest and testable: raw scientific results remain
owned by the user's backend or simulator, while KET Studio makes the execution
context and visual evidence easier to preserve and review.

## Technical challenges

- Capturing complete event streams without allowing large experiments to freeze
  the UI.
- Separating bounded display previews from lossless raw research artifacts.
- Recording environment and script identity consistently across local runs.
- Designing a stable schema that can evolve without invalidating old bundles.
- Testing a real Windows terminal host and packaged release on clean machines.
- Keeping examples deterministic while still supporting user-selected backends.

## Users and ecosystem

The primary users are quantum-computing students, independent researchers,
educators and open-source contributors who already work with Python quantum
frameworks. KET Studio is designed to interoperate with those frameworks rather
than lock users into a proprietary backend. The public repository, issue tracker,
runnable tutorials and documented `KET_VIZ` protocol provide the collaboration
surface. Feedback will be collected through GitHub issues and small reproducible
examples.

## Expected outcomes and success measures

At the end of the effort, a new user should be able to install the supported
release, run a deterministic tutorial, export one run bundle and inspect its
manifest, raw event stream, logs and visual artifacts without relying on hidden
application state. The project will measure success with:

- one documented bundle schema and a working export/import path;
- at least two deterministic end-to-end regression examples;
- pinned environment verification for the supported desktop workflow;
- parser, renderer and terminal lifecycle tests in CI or release QA;
- updated English and Uzbek docs and a public tagged release;
- a limitations and reproducibility checklist that reviewers can follow.

## Proposed 12-week plan

| Period | Work | Public result |
|---|---|---|
| Weeks 1–3 | Bundle schema, manifest fields and environment snapshot design | Schema proposal and fixtures |
| Weeks 4–6 | Run capture, raw artifact handling and export/import | Working run bundle prototype |
| Weeks 7–9 | Parser, renderer, deterministic example and terminal tests | Regression suite and CI/release checks |
| Weeks 10–12 | Docs, tutorials, accessibility pass and release QA | Tagged release and migration notes |

## Requested support

**Requested amount:** USD 4,000, subject to the programme's current terms.

| Area | Amount | Purpose |
|---|---:|---|
| Run bundles and provenance | $1,600 | Manifest, event archive, raw results and export/import |
| Validation and release QA | $1,000 | Regression tests, terminal lifecycle and clean-machine checks |
| Documentation and research UX | $800 | Runnable tutorials, English/Uzbek docs and accessibility review |
| Packaging and project maintenance | $600 | Checksums, release notes, issue triage and contributor support |
| **Total** | **$4,000** | |

The final application should replace this table with the applicant's actual
effort, rate and expense assumptions if the form requests a more detailed budget.

## Applicant background

Replace the placeholders below with accurate information in the applicant's own
words:

- **Name or pseudonym:** `[TO COMPLETE]`
- **Email:** `[TO COMPLETE]`
- **Country of residence:** `[TO COMPLETE]`
- **Applicant type:** `[individual / organisation / other]`
- **Organisation:** `[TO COMPLETE or not applicable]`
- **Relevant experience:** `[TO COMPLETE with truthful projects, roles and links]`
- **Previous funding:** `[TO COMPLETE]`

## AI disclosure

The final form should answer its AI-disclosure questions honestly. This draft was
prepared with generative-AI assistance for structure, editing and technical
clarity. The applicant should review the text, correct it in their own words and
attach the actual prompts/interactions if the fund requires them. AI assistance
does not replace verification of the project's code, results, identity or budget.

## Submission checklist

- [ ] Choose the exact fund and confirm that the current call is open.
- [ ] Complete applicant identity, country, contact and payment/tax details if
      requested by the fund.
- [ ] Replace the background and funding placeholders with verifiable facts.
- [ ] Record and attach the requested two-minute project video.
- [ ] Review the budget and timeline against the programme's rules.
- [ ] Check the public repository, website, license and current release links.
- [ ] Review the AI disclosure and provide the required interaction log.
- [ ] Submit only after a human review of every answer.

This document is an application draft, not evidence that an application has been
submitted or accepted.
