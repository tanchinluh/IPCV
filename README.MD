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
- OpenCV Zoo browser GUI: `opencv_zoo_gui()`.
- Step 3 thresholding, binarization, connected-component measurement, binary geometry, reconstruction, extrema, Sobel gradients, filtering, denoising, and local-statistics APIs.
- Public `im...` names are canonical in the OpenCV 5 development line; archived MATLAB-style aliases are retained only under `macros/old`.
- Current OpenCV 5 migration tests are in `tests/unit_tests`; legacy 4.5 tests are kept only as an optional archive/reference set.
- Large DNN `.onnx` models are excluded from git and downloaded on demand.

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
