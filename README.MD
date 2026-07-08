# IPCV

IPCV is an Image Processing and Computer Vision toolbox for Scilab. It provides Scilab macros and native gateways for image I/O, filtering, morphology, feature detection, DNN inference, video/camera handling, object tracking, and other OpenCV-backed workflows.

The current development line is the OpenCV 5 and C++ migration of IPCV. The native implementation targets OpenCV/OpenCV contrib 5.0.0 and Scilab 2026.x, with the legacy gateway helpers replaced by category-based C++ source modules.

## Highlights

- OpenCV 5 native backend with category-based C++ source files under `src/cpp`.
- Scilab gateway image exchange rewritten for the current Scilab API.
- DNN support updated for OpenCV 5, including ONNX examples and OpenCV Zoo model download support.
- OpenCV Zoo browser GUI: `opencv_zoo_gui()`.
- Current unit tests are in `tests/unit_tests`; older 4.5 tests are archived in `tests/unit_tests/4.5`.
- Large DNN `.onnx` models are excluded from git and downloaded on demand.

## Requirements

- Scilab 2026.x
- Windows build tools for native compilation
- OpenCV/OpenCV contrib 5.0.0 thirdparty build for the IPCV native gateway

For native builds on Windows, start Scilab from a Visual Studio native tools command prompt so the compiler environment is available.

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

Downloaded `.onnx` files are ignored by git. The default download folder is:

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

Current migration tests:

```text
tests/unit_tests
```

Legacy IPCV 4.5 tests:

```text
tests/unit_tests/4.5
```

Run tests from Scilab after loading/building the toolbox as needed. For focused migration checks, run the relevant `.tst` file directly or use Scilab's `test_run` workflow.

## Repository Layout

```text
macros/              Scilab user-facing functions
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

## License

GPL. See the repository license and source headers for details.
