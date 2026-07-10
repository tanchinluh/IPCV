# IPCV Roadmap

Last updated: 10-Jul-26

IPCV follows the OpenCV release used by its native backend. The active baseline
is OpenCV/OpenCV contrib 5.0.0. During rapid development, roadmap Steps track
progress without creating a new package version, branch, or tag for every
batch of work. `VERSION` and `DESCRIPTION` change only during deliberate
release preparation.

## Status Legend

- **Baseline**: current OpenCV compatibility line.
- **Complete**: implementation is complete for the stated development scope.
- **In validation**: implemented; platform or hardware evidence remains.
- **Planned**: scope agreed, implementation not yet started.
- **Backlog**: desired direction without a committed release slot.

## Current Status

| Step | Status | Current evidence | Remaining gate |
| --- | --- | --- | --- |
| OpenCV 5.0.0 baseline | **Baseline** | OpenCV 5/C++ migration is on `master` and tagged `5.0.0`. | Continue improvements on `codex/new-features`. |
| Step 1 - Stability and compatibility | **Complete** | Image exchange, teardown, handles, paths, help links, and the initial stability runner were hardened. | Retain cross-platform regression coverage. |
| Step 2 - Correctness and test foundation | **In validation** | On Windows, the rebuilt toolbox passes stability 21/21, release 111/111, GUI 21/21, and network/model 1/1. Static checks pass. | Run on macOS/Linux and exercise physical-camera hardware where available. |
| Step 3 - Image processing completeness | **Planned** | Scope defined below. | Requires the Step 2 quality baseline. |
| Step 4 - DNN and OpenCV Zoo workflows | **Planned** | Scope defined below. | Requires stable DNN contracts and model fixtures. |
| Step 5 - Performance and product workflows | **Planned** | Scope defined below. | Requires benchmarks from earlier steps. |
| Next OpenCV baseline | **Backlog** | Adopt only after a deliberate dependency review. | OpenCV release availability and migration assessment. |

The repository currently contains 134 active Scilab unit-test scripts. That is
an inventory count, not a claim that every script passes on every platform.
The Step 2 manifest classifies each test and the expanded focused stability
suite contains 21 deterministic or local-asset checks.

## Step 1 - Stability And Compatibility

Status: **Complete**

Goal: make the OpenCV 5 migration safe enough to become the new maintenance
baseline.

Completed:

- Harden Scilab/OpenCV image exchange, including float32 and multipage output.
- Fix native handle collisions between DNN and DNN super-resolution objects.
- Fix Windows teardown corruption caused by global macro-library objects.
- Remove machine-specific paths and add runtime IPCV/OpenCV version reporting.
- Fix `imfuse` defaults and mixed grayscale/RGB input handling.
- Repair help links and add missing help for version, path, and Zoo GUI entry points.
- Enforce Scilab 2026.1 and C++17 build requirements.
- Add a Windows stability runner with explicit process-level PASS/FAIL reporting.

Exit criteria:

- Windows build and focused stability suite pass. **Complete**
- Image-exchange and teardown regressions are covered by the stability suite.
  **Complete**
- macOS and Linux regression evidence continues as a cross-platform workstream,
  not as a separate package version.

## Step 2 - Correctness And Test Foundation

Status: **In validation**

Goal: turn migration tests into a dependable compatibility contract.

Current progress:

- Classify all 134 active tests as core, integration, GUI, network, or hardware,
  with family, requirement, and platform metadata. **Implemented**
- Create deterministic groups with explicit skip reasons, CSV reports, and
  conventional wrapper exit codes. **Implemented; cross-platform validation pending**
- Separate external model downloads from the focused stability suite. **Implemented**
- Add repeatable release runners for build, load, test, and package checks.
  **Build/test/repository runners implemented; package automation pending**
- Define and test image depth, channel count, empty-input, shape, and invalid
  argument contracts. **Initial contract suite implemented; expansion pending**
- Add repeated load/unload stress tests for DNN, video, camera, tracking, and
  display handles. **DNN, tracker, and video implemented; GUI/camera are opt-in**
- Add PNG, JPEG, TIFF, BMP, WebP, and multipage image codec tests. **Implemented**
- Validate metadata, help XML, links, examples, gateway registration, and
  generated loader contents. **Metadata, XML, links, gateways, test references,
  machine paths, and Windows artifacts implemented; runnable help-example checks pending**

Exit criteria:

- Every active test is classified and has a documented platform expectation.
- Core tests pass from one command on each supported operating system.
- Failures and crashes return a non-zero process status.
- No critical native memory or handle-lifecycle defect remains open.

## Step 3 - Image Processing Completeness

Status: **Planned**

Goal: close the most useful MATLAB Image Processing Toolbox workflow gaps while
keeping Scilab-friendly APIs.

Planned work:

- Publish a MATLAB/OpenCV/IPCV capability matrix by help category.
- Fill high-value gaps in image types, geometric transforms, filtering,
  morphology, segmentation, measurement, connected components, and region
  analysis.
- Standardize optional arguments, border modes, interpolation modes, output
  types, coordinate conventions, and grayscale/RGB behavior.
- Improve volumetric and multiframe operations where the Scilab data model and
  OpenCV backend can support them safely.
- Add end-to-end examples for registration, segmentation, measurement, feature
  matching, tracking, and batch image processing.

Exit criteria:

- The capability matrix identifies supported, partial, and unsupported behavior.
- Priority gaps have help, examples, unit tests, and documented compatibility.
- Common workflows do not require users to call internal gateways directly.

## Step 4 - DNN And OpenCV Zoo Workflows

Status: **Planned**

Goal: make real model inference easier to reproduce than assembling raw OpenCV
DNN calls by hand.

Planned work:

- Formalize preprocessing specifications: resize policy, crop, color order,
  scalar/per-channel scale, mean, standard deviation, and layout.
- Expand tested decoders for classification, YOLO-family detection, SSD,
  segmentation, face detection, pose estimation, and selected Zoo models.
- Add batch inference and named/multiple-output support with stable tensor shape
  conventions.
- Improve `opencv_zoo_gui` with cached metadata, checksums, download progress,
  cancellation, destination validation, and generated runnable examples.
- Report available OpenCV DNN backends/targets and provide clear fallback errors.
- Use small trusted fixtures and optional network/model tests so the core suite
  remains fast and deterministic.

Exit criteria:

- Representative models from each supported task produce verified visual output.
- Preprocessing and decoding are reusable public APIs rather than demo-only code.
- Model downloads are reproducible and integrity checked.

## Step 5 - Performance And Product Workflows

Status: **Planned**

Goal: differentiate IPCV through efficient native execution and complete Scilab
workflows, not only function-count parity.

Planned work:

- Add reproducible benchmarks for image exchange, filtering, morphology,
  transforms, feature extraction, video, and DNN inference.
- Measure and reduce avoidable Scilab/OpenCV copies while preserving memory
  ownership safety.
- Add batch and streaming APIs for folders, image sequences, video, and camera
  pipelines.
- Improve interactive ROI, annotation, measurement, comparison, and result
  export workflows.
- Add provenance helpers that record IPCV/OpenCV versions, parameters, model
  identity, and timing for reproducible experiments.
- Publish performance and compatibility results with each release.

Exit criteria:

- Benchmarks establish baselines and catch material regressions.
- Optimized paths have correctness and ownership stress tests.
- At least three complete workflows cover input, processing, visualization, and
  export without application-specific glue code.

## Continuous Workstreams

| Workstream | Current status | Direction |
| --- | --- | --- |
| Native C++ migration | **Operational** | Keep category-based C++ sources and remove remaining obsolete compatibility code when verified unused. |
| Scilab/OpenCV memory exchange | **Stabilizing** | Expand type/channel coverage and stress tests before pursuing fewer-copy paths. |
| Documentation | **Improving** | Require help, author, History, linked See Also entries, and runnable examples for public functions. |
| Cross-platform builds | **At risk** | Windows is verified; macOS and Linux need repeatable validation for the OpenCV 5.0.0 development line. |
| Automated quality gates | **Local foundation complete** | Classified suites, reports, watchdogs, static validation, and release orchestration exist; repository-hosted CI is not yet present. |
| DNN and Zoo integration | **Functional, partial** | Core inference, decoders, examples, and Zoo GUI exist; broader model validation is planned. |
| Performance evidence | **Not established** | Add benchmark baselines before making optimization claims. |
| Release engineering | **Manual** | Automate package creation, metadata hashes/sizes, smoke tests, and release checks. |

## Prioritization Rules

1. Crashes, memory corruption, wrong numerical results, and data loss take
   priority over new functions.
2. A public function is complete only when implementation, tests, help, History,
   author attribution, and a runnable example are present.
3. Hardware, network, GUI, and large-model tests remain separate from the fast
   deterministic core suite.
4. Performance changes require a benchmark and a correctness test.
5. Platform-specific behavior must be documented and must not silently change
   results on another supported platform.

## Development Workflow

Rapid development uses one long-lived feature branch:

```text
master
  `-- codex/new-features   Step 1 -> Step 2 -> Step 3 -> ...
```

Step numbers are roadmap checkpoints, not versions, branches, releases, or
tags. Work continues on `codex/new-features` until a deliberate release point
is chosen. At that point, freeze features, choose the public version, update
release metadata and archives, run every release gate, merge to `master`, and
create one release tag. After the release, continue the next roadmap Step on
`codex/new-features` from the updated `master` baseline.
