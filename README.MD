# IPCV

IPCV is an Image Processing and Computer Vision toolbox for Scilab. It provides Scilab macros and native gateways for image I/O, filtering, morphology, feature detection, DNN inference, video/camera handling, object tracking, and other OpenCV-backed workflows.

The current development line is IPCV 5.0.0, based on OpenCV/OpenCV contrib 5.0.0 and Scilab 2026.1. The native implementation uses category-based C++ source modules and a current Scilab gateway API.

Rapid development is organized as numbered roadmap steps on the single
`codex/new-features` branch. The current evidence, remaining
gates, and longer-term priorities are maintained in [ROADMAP.md](ROADMAP.md).

## Highlights

- OpenCV 5 native backend with category-based C++ source files under `src/cpp`.
- Scilab gateway image exchange rewritten for the current Scilab API.
- DNN support updated for OpenCV 5, including ONNX examples and OpenCV Zoo model download support.
- `dnn_forward_preset` provides reusable ImageNet, CLIP, and OpenCV Zoo preprocessing configurations, including per-channel standard deviation.
- `dnn_forward_outputs` runs named or unconnected output layers and returns tensors in a list with matching layer names.
- OpenCV Zoo browser GUI: `opencv_zoo_gui()`.
- Step 3 thresholding, binarization, connected-component measurement, binary geometry, reconstruction, extrema, Sobel gradients, filtering, denoising, and local-statistics APIs.
- Foundation help examples now show threshold, binary-mask, connected-component, label, area-filter, and border-cleanup results on OpenCV sample images.
- Batch 5 help examples now use OpenCV sample images for filtering, enhancement, gradients, extrema, reconstruction, and binary measurement workflows.
- Step 3 image workflows: flipping, padding, tiling, bottom-hat filtering, k-means segmentation, GrabCut, superpixels, region properties, entropy, range, variance, order-statistic filtering, callback neighborhood filtering, and flat-field correction.
- Batch 6 help examples now use OpenCV sample images and show source/result comparisons for the main workflows.
- Step 3 Batch 7 adds translation, pairwise display comparison, contrast limits, local brightening, grayscale region growing, multilevel quantization, binary topology and geodesic distance, inverse Radon, Hough peak/line conversion, corners, HOG, and regularized deconvolution helpers.
- Batch 7 help examples now use OpenCV sample images and show source/result or score-map comparisons for the main workflows.
- Step 3 Batch 8 adds histogram matching, local contrast, extrema suppression, marker minima, ROI masks, texture maps, mean-shift-like smoothing, template matching, histogram back-projection, optical-flow translation fields, lens correction, and projective rectification.
- Batch 8 help examples now use the OpenCV smarties, fruits, and chessboard sample assets with before/after or score-map output where appropriate.
- Step 3 Batch 9 adds flood fill, local range, color transfer, diffusion, guided filtering, local normalization, seamless compositing, phase-correlation registration, camera-calibration initialization, stereo BM/SGBM baselines, and line/ellipse fitting. Each new public function includes a runnable help example, author metadata, and History.
- Batch 9 examples use the OpenCV chessboard, smarties, and fruits sample assets where appropriate; stereo and calibration examples identify their illustrative input assumptions.
- Proposed duplicate names are intentionally not added: use `rgb2gray` or `immat2gray` instead of `im2gray`, `imoverlaymask` instead of `imoverlay`, `imlabel2rgb` with overlay helpers instead of `imlabeloverlay`, `imphasecorr` instead of `imregcorr`, and `imtransform` instead of `imwarp`.
- Step 3 Batch 10 adds robust statistics, FCM and active-contour segmentation, phase-congruency and ridge maps, 3D volume operations, and OpenCV 5 camera geometry with `imsolvepnp`, `imestimatefundamental`, and `imtriangulate`. Circle detection remains available through the existing `imhoughc` API.
- Step 3 Batch 11 adds adaptive thresholds, gradient weights, GLCM texture statistics, LBP descriptors, image moments, orientation and Feret measurements, local variance, color masks, aspect-ratio crop, and 3D intensity/filtering helpers.
- Step 3 Batch 12 adds `im2uint32`, `imlut`, `imapplycolormap`, `imintegral`, `imbwdist`, `imgraydist`, `imbwulterode`, `imlocallapfilt`, `imreducehaze`, `improfile3`, `imtranslate3`, `imregionalmax3`, `imbwmorph3`, `imminarearect`, and `imminenclosingcircle`.
- Batch 12 examples use the OpenCV fruits and smarties images, synthetic volumes, and plotted point sets so each new function has a visible workflow.
- Batch 12 intentionally skips duplicate or near-duplicate proposals: `im2gray` because `rgb2gray` already covers the conversion, `imstdfilt` because `imlocalstd` exists, `imentropyfilt` because `imlocalentropy` exists, `imrangefilt` because `imlocalrange` exists, `imwarp` because `imtransform` and the affine/perspective helpers exist, and `imregcorr` because `imphasecorr` exists.
- Step 3 Batch 13 adds 2-D/3-D binary component and boundary helpers, image-reference and registration configuration structures, 3-D k-means segmentation, bitwise and remapping utilities, and Harris, KAZE, and AKAZE feature workflows.
- Batch 13 examples follow OpenCV workflows for Harris corner detection, AKAZE/KAZE local features, contour analysis, and connected-component filtering. `im2gray`, `imstdfilt`, `imentropyfilt`, `imrangefilt`, `imnormxcorr2`, `imwarp`, `imregcorr`, and `imbwskel` remain intentionally skipped because active IPCV equivalents already exist.
- Batch 13 help examples now show their source reference and provide two independent executable blocks: an adapted OpenCV workflow and a separate IPCV workflow.
- Browser-based `imtool()` supports images and OpenCV-decoded video, including paused-frame inspection, zoom, pan, rotation, color-space inspection, pixel grids, temporal difference/heatmap/average analysis, optical-flow overlays, and recording of the rendered analysis stream.
- Native OpenCV 5 gateways now cover k-means segmentation, GrabCut, superpixels, Harris/KAZE/AKAZE features, KAZE/AKAZE descriptors, template matching, phase registration, solve-PnP, fundamental-matrix estimation, and triangulation.
- Volumetric functions are grouped under the dedicated `3D Image Processing` category, including filtering, morphology, profiles, transforms, region measurements, segmentation, and `imshow3d`.
- Display and geometry workflows consistently distinguish upper-left image coordinates from lower-left Scilab plot coordinates. Help overlays use `rect2cart()` or `sub2cart()` where required.
- The help audit replaces toy or misleading examples with executable image workflows, adds missing Parameters/Author/History sections, removes stale duplicate pages, and links examples to their actual OpenCV references.
- AVI examples use explicit writable output paths and the broadly compatible `MJPG` codec. `addframe` remains available as a deprecated compatibility alias of `aviaddframe`.
- Public `im...` names are canonical in the OpenCV 5 development line; archived MATLAB-style aliases are retained only under `macros/old`.
- Duplicate MATLAB-style help pages and stale examples are removed; help links now target the active `im...` replacements.
- Current OpenCV 5 migration tests are in `tests/unit_tests`; legacy 4.5 tests are kept only as an optional archive/reference set.
- Large DNN `.onnx` models are excluded from git and downloaded on demand.

## Current Development Status

The active work remains on `codex/new-features` under the OpenCV 5.0.0
baseline. On 17-Jul-26, the toolbox completed a clean VS 2022 x64 native build,
repository validation, regenerated help, and the Windows stability suite with
35 passed and 0 failed. Release preparation still requires the broader
release/GUI/network/hardware suites where applicable and macOS/Linux validation.
Generated binaries, help output, downloaded models, and local Codex/Scilab
profiles are not source-controlled.

## Coordinate Convention

Image-processing functions use image coordinates: `[x y]` means column and row,
with the origin at the upper-left image corner. Scilab `plot()` uses Cartesian
coordinates with the origin at the lower-left of the displayed axes. When an
example overlays points, lines, or contours on an image shown with `imshow()`,
it must convert image coordinates with `rect2cart()` or `sub2cart()` before
calling `plot()`.

## OpenCV Example Assets

Current help examples use image assets from the official OpenCV sample-data
repository:

- `images/opencv_smarties.png`: color segmentation, statistics, and volume examples.
- `images/opencv_fruits.jpg`: color/intensity statistics and gradient examples.
- `images/opencv_left01.jpg` and `images/opencv_left02.jpg`: chessboard pose,
  stereo, and camera-geometry examples.

The workflows are adapted from OpenCV's
[camera calibration tutorial](https://docs.opencv.org/master/dc/dbb/tutorial_py_calibration.html),
[pose estimation tutorial](https://docs.opencv.org/master/d7/d53/tutorial_py_pose.html),
and [epipolar geometry tutorial](https://docs.opencv.org/master/da/de9/tutorial_py_epipolar_geometry.html).

## Requirements

- Scilab 2026.x
- Windows build tools for native compilation
- OpenCV/OpenCV contrib 5.0.0 thirdparty build for the IPCV native gateway

For native builds on Windows, start Scilab from a Visual Studio native tools command prompt so the compiler environment is available.

## Naming And Archived Aliases

The public IPCV names now use the `im...` convention. Legacy non-`im` names
remain in `macros/old` for reference only and are intentionally excluded from
the generated macro libraries.

| Archived name | Public IPCV name |
| --- | --- |
| `edge` | `imedge` |
| `filter2` | `imfilter2` |
| `fspecial` | `imfspecial` |
| `mean2`, `std2`, `stdev2`, `corr2` | `immean2`, `imstd2`, `imstdev2`, `imcorr2` |
| `mat2gray` | `immat2gray` |
| `label2rgb` | `imlabel2rgb` |
| `poly2mask` | `impoly2mask` |
| `bwareaopen`, `bwareafilt` | `imbwareaopen`, `imbwareafilt` |
| `bwperim`, `bwselect`, `bwhitmiss`, `bwthin`, `bwmorph`, `bwboundaries` | `imbwperim`, `imbwselect`, `imbwhitmiss`, `imbwthin`, `imbwmorph`, `imbwboundaries` |
| `bwlabel`, `bwconncomp`, `bwfill` | `imlabel`, `imconnectedcomponents`, `imfill` or `imfillholes` |
| `adapthisteq`, `wiener2`, `medfilt2` | `imadapthistequal`, `imwiener2`, `immedian` |

Functions such as `imsharpen`, `imlaplacian`, `imgradientdirection`,
`imlocalmean`, and `imlocalstd` are separate compositions, not aliases.

## Versioning

IPCV public versions follow the OpenCV baseline used by the native backend.
Rapid development work does not increment the package version after every
change; it is tracked as Step 1, Step 2, and so on in the roadmap. `VERSION` and
`DESCRIPTION` change only when a release candidate is deliberately prepared.

The loaded package and native backend versions can be inspected at runtime:

```scilab
info = ipcv_version();
disp(info);
```

## Load IPCV

From Scilab:

```scilab
exec("loader.sce", -1);
```

Then call IPCV functions directly, for example:

```scilab
S = imread(fullpath(getIPCVpath() + "/images/baboon.png"));
imshow(S);
```

## Build From Source

Build order:

1. Prepare compiler tools.
2. Build OpenCV/OpenCV contrib 5.0.0 into `thirdparty`.
3. Start Scilab from the compiler environment.
4. Run IPCV `builder.sce`.
5. Load IPCV and run a quick smoke test.

### 1. Prepare Compiler Tools

On Windows, install Visual Studio 2022 Build Tools or Visual Studio with the C++ workload. Make sure `cmake`, `ninja`, `curl`, and `tar` are available in the command prompt used for the build.

On Linux or macOS, install CMake, Ninja, a C/C++ compiler toolchain, `curl`, `make`, and common build utilities.

### 2. Build OpenCV 5 Thirdparty

IPCV expects a local OpenCV/OpenCV contrib 5.0.0 build under `thirdparty`. The helper scripts in `thirdparty/build` download OpenCV sources, configure CMake with Ninja, build `opencv_world`, and install headers/libraries into the platform-specific thirdparty folder.

For a detailed Windows and Linux thirdparty build guide, see `thirdparty/build/README.txt`.

#### Windows

Open a Visual Studio x64 native tools command prompt, then run:

```bat
cd thirdparty\build
build.bat
```

The script:

- Downloads OpenCV and OpenCV contrib `5.0.0`.
- Applies the IPCV local MLAS skip patch for the OpenCV DNN Windows build.
- Configures OpenCV with `-G Ninja`.
- Builds and installs into `thirdparty\Windows\%PROCESSOR_ARCHITECTURE%`.
- Copies generated OpenCV DLL/import-library files into the local `lib` folder expected by IPCV.

Expected Windows layout after installation:

```text
thirdparty/Windows/AMD64/include/
thirdparty/Windows/AMD64/lib/
```

#### Linux And macOS

Run:

```sh
cd thirdparty/build
./build.sh
```

The script first builds a local shared FFmpeg dependency, then downloads and builds OpenCV/OpenCV contrib `5.0.0`.

Expected layout after installation:

```text
thirdparty/Linux/<architecture>/
thirdparty/Darwin/<architecture>/
```

### 3. Start Scilab From The Compiler Environment

On Windows, keep using the Visual Studio x64 native tools command prompt and launch Scilab from there, for example:

```bat
"<SCILAB_INSTALL_DIR>\bin\WScilex.exe"
```

Using the native tools prompt matters because IPCV builds C++ gateways and must see the same MSVC compiler environment used by OpenCV.

On Linux or macOS, start Scilab from a shell where the compiler, CMake, and OpenCV thirdparty library paths are available.

### 4. Build IPCV

In Scilab, change to the IPCV root folder and run:

```scilab
cd("<IPCV_ROOT>");
exec("builder.sce", -1);
```

The top-level builder compiles macros, native source code, gateways, help, loader, and cleaner files. The source build is organized around `src/cpp/builder_cpp.sce`, which builds the native `libipcv_core` library from category files such as `ipcv_image_io.cpp`, `ipcv_filtering.cpp`, `ipcv_feature_detection.cpp`, and `ipcv_dnn.cpp`.

Expected generated build outputs include:

```text
src/cpp/libipcv_core.*
sci_gateway/cpp/gw_ipcv.*
loader.sce
```

### 5. Load And Smoke Test

After the build completes, load IPCV:

```scilab
exec("loader.sce", -1);
```

Then run a small image I/O and display check:

```scilab
S = imread(fullpath(getIPCVpath() + "/images/baboon.png"));
disp(size(S));
imshow(S);
```

For a focused command-line check, run a current unit test from `tests/unit_tests`, for example:

```scilab
test_run(getIPCVpath(), "ipcv_image_io");
```

## OpenCV Zoo Models

IPCV includes a Scilab browser GUI for OpenCV Zoo models:

```scilab
opencv_zoo_gui();
```

The GUI can:

- Fetch available ONNX models from the official OpenCV Zoo.
- Group models by category.
- Show real Git LFS model sizes.
- Download a selected model.
- Download a selected model, generate a starter Scilab script, and open it in the Scilab editor.

Downloaded `.onnx` files are ignored by git. Starter scripts generated by the OpenCV Zoo GUI in the default DNN download folder are also ignored, so users can create and edit local model-specific experiments without changing the repository. The default download folder is:

```text
images/dnn
```

## DNN Example

```scilab
dnn_path = fullpath(getIPCVpath() + "/images/dnn/");
model_name = "image_classification_mobilenetv2_2022apr.onnx";
model_file = dnn_path + model_name;

if ~isfile(model_file) then
    model_url = "https://github.com/opencv/opencv_zoo/raw/main/models/image_classification_mobilenet/" + model_name;
    http_get(model_url, model_file, follow=%t, timeout=300);
end

net = dnn_readmodel(model_file, "", "onnx");
net = dnn_setpreferable(net, "opencv", "cpu");

S = imread(fullpath(getIPCVpath() + "/images/baboon.png"));
out = dnn_forward(net, S, [224, 224], [], 1 / 127.5, [127.5 127.5 127.5], 1, 0);

[score, index] = max(out);
disp([index, score]);
dnn_unloadmodel(net);
```

## Tests

Current OpenCV 5 migration tests:

```text
tests/unit_tests
```

These are the active tests for the C++/OpenCV 5 code path and are the default place for new regression coverage.

Legacy IPCV 4.5 tests are not part of the default 5.0.0 test run. If they are kept for migration comparison, keep them isolated under:

```text
tests/unit_tests/4.5
```

That archive path is only for historical behavior checks and should not be mixed with the active OpenCV 5 `.tst` and `.dia.ref` files.

Run tests from Scilab after loading/building the toolbox as needed. For focused migration checks, run the relevant `.tst` file directly or use Scilab's `test_run` workflow.

Tests are classified as `core`, `integration`, `gui`, `network`, or `hardware`.
The `stability` suite is the focused migration signal and `release` combines
the deterministic core and local-asset integration tests. Network, GUI, and
physical-camera tests are opt-in.

On Windows, run a suite with:

```powershell
powershell -ExecutionPolicy Bypass -File tests/run_tests.ps1 -ScilabExecutable "C:\Tools\scilab-2026.1.0\bin\WScilex-cli.exe" -Suite stability
```

On Linux or macOS, run:

```sh
sh ./tests/run_tests.sh /path/to/scilab-cli stability
```

Available suite names are `core`, `integration`, `gui`, `network`, `hardware`,
`stability`, `release`, and `all`. Reports are written to `tests/results` and
are ignored by git. Run one or more named tests by setting `IPCV_TEST_NAMES`,
or on Windows by passing `-TestNames "ipcv_image_io,ipcv_codec_matrix"`.

The original `run_stability_tests.ps1` and `run_stability_tests.sce` files are
kept as compatibility entry points and delegate to the suite runner.

Run the Windows repository validator and deterministic release suite together:

```powershell
powershell -ExecutionPolicy Bypass -File tests/run_release_checks.ps1 -ScilabExecutable "C:\Tools\scilab-2026.1.0\bin\WScilex-cli.exe"
```

Add `-Build` when the command is launched from a Visual Studio x64 native tools
environment and a complete native rebuild is required. See
[`tests/README.md`](tests/README.md) for suite definitions, opt-in requirements,
timeouts, reports, and test-authoring rules.

## Repository Layout

```text
macros/              Scilab user-facing functions grouped by help category
macros/GUI/          Browser/UI assets and GUI-specific macros
sci_gateway/cpp/     Scilab gateway wrappers
src/cpp/             OpenCV-backed C++ implementation
help/en_US/          Help pages
demos/               Demo scripts
tests/unit_tests/    Current unit tests
thirdparty/          Local thirdparty build area
images/              Sample images and downloaded model location
```

## Change History

Detailed release notes, migration notes, and the converted-function list are maintained in `ChangeLog.txt`.

## Roadmap

The current OpenCV 5.0.0 development steps are maintained in
[ROADMAP.md](ROADMAP.md). Steps are planning and progress markers, not package
versions or tags.

Category coverage and priority gaps are tracked in
[CAPABILITIES.md](CAPABILITIES.md).

## License

GPL. See the repository license and source headers for details.
