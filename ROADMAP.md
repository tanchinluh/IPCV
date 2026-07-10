# IPCV Roadmap

Last updated: 10-Jul-26

IPCV follows the OpenCV release used by its native backend. Versions use
`X.Y.Z.R`, where `X.Y.Z` is the OpenCV baseline and `R` is the IPCV-only
revision on that baseline. A change to the OpenCV baseline resets the IPCV
revision. This roadmap therefore keeps improvements on OpenCV 5.0.0 in the
`5.0.0.R` line.

## Status Legend

- **Released**: tagged and published.
- **In validation**: implemented on a development branch; release gates remain.
- **Planned**: scope agreed, implementation not yet started.
- **Backlog**: desired direction without a committed release slot.

## Current Status

| Milestone | Status | Current evidence | Remaining release gate |
| --- | --- | --- | --- |
| 5.0.0 | **Released** | OpenCV 5/C++ migration is on `master` and tagged `5.0.0`. | Maintenance only. |
| 5.0.0.1 | **In validation** | Implemented on `codex/new-features`; Windows native build succeeds and the focused stability suite passes 17/17. | Validate the native build on macOS and Linux, merge to `master`, build release archives, update archive checksums/sizes in `DESCRIPTION`, tag, and publish. |
| 5.0.0.2 | **Planned** | Scope defined below. | Start after 5.0.0.1 is released. |
| 5.0.0.3 | **Planned** | Scope defined below. | Requires the 5.0.0.2 quality baseline. |
| 5.0.0.4 | **Planned** | Scope defined below. | Requires stable DNN contracts and model fixtures. |
| 5.0.0.5 | **Planned** | Scope defined below. | Requires benchmarks from earlier milestones. |
| Next OpenCV baseline | **Backlog** | Version will follow the next adopted OpenCV release. | OpenCV release availability, dependency audit, and migration branch. |

The repository currently contains 128 active Scilab unit-test scripts. That is
an inventory count, not a claim that every script passes on every platform.
The reproducible release signal for 5.0.0.1 is the focused 17-test stability
suite in `tests/run_stability_tests.sce`.

## 5.0.0.1 - Stability And Compatibility

Status: **In validation**

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
- macOS native build and loader smoke test pass. **Pending**
- Linux native build and loader smoke test pass. **Pending**
- No known loader, image-exchange, or teardown crash remains. **Pending cross-platform confirmation**
- Merge, package, populate release metadata, tag, and publish. **Pending**

## 5.0.0.2 - Correctness And Test Foundation

Status: **Planned**

Goal: turn migration tests into a dependable compatibility contract.

Planned work:

- Audit all 128 active tests and classify them as unit, integration, hardware,
  network, GUI, or model-dependent tests.
- Create deterministic test groups with explicit skip reasons and conventional
  exit codes on Windows, Linux, and macOS.
- Add CI or repeatable release runners for build, load, test, and package checks.
- Define and test the supported input matrix for image depth, channel count,
  empty inputs, non-contiguous data, and invalid arguments.
- Add native handle lifecycle and repeated load/unload stress tests for DNN,
  video, camera, tracking, and display objects.
- Add codec capability tests for PNG, JPEG, TIFF, WebP, and multipage images.
- Validate help XML, links, examples, gateway registration, and generated loader
  contents as part of the release check.

Exit criteria:

- Every active test is classified and has a documented platform expectation.
- Core tests pass from one command on each supported operating system.
- Failures and crashes return a non-zero process status.
- No critical native memory or handle-lifecycle defect remains open.

## 5.0.0.3 - Image Processing Completeness

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

## 5.0.0.4 - DNN And OpenCV Zoo Workflows

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

## 5.0.0.5 - Performance And Product Workflows

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
| Cross-platform builds | **At risk** | Windows is verified; macOS and Linux need repeatable validation for 5.0.0.1. |
| Automated quality gates | **Early** | A focused Windows runner exists; repository-hosted CI is not yet present. |
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

