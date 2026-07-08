=============================================================================
 IPCV - Thirdparty OpenCV Build Guide
=============================================================================

This folder contains helper scripts used to build the native thirdparty
dependencies required by IPCV:

  - build.bat  : Windows x64 OpenCV/OpenCV contrib build
  - build.sh   : Linux and macOS OpenCV/OpenCV contrib build

This document covers the supported Windows and Linux workflows for the IPCV
5.0.0 / OpenCV 5 migration. The scripts build OpenCV/OpenCV contrib 5.0.0 and
install the result into the platform-specific folder expected by the IPCV
Scilab builders.


Build Output Expected By IPCV
=============================

After a successful thirdparty build, IPCV expects this layout:

Windows:

  thirdparty/Windows/AMD64/include/
  thirdparty/Windows/AMD64/lib/

Linux:

  thirdparty/Linux/x86_64/include/opencv5/
  thirdparty/Linux/x86_64/lib/

The IPCV builders use these paths:

  src/cpp/builder_cpp.sce
  sci_gateway/cpp/builder_gateway_cpp.sce

Do not rename the platform folders unless you also update those Scilab builder
scripts.


Windows Build
=============

Prerequisites:

  - Windows 10 or Windows 11, 64-bit
  - Visual Studio 2022 or Visual Studio 2022 Build Tools
  - Desktop development with C++ workload
  - CMake available in PATH
  - Ninja available in PATH
  - curl available in PATH
  - tar available in PATH

Use the x64 Native Tools Command Prompt for Visual Studio 2022. This is
important because CMake and Ninja must see the MSVC compiler environment.

Commands:

  cd <IPCV_ROOT>\thirdparty\build
  build.bat

The script will:

  1. Download OpenCV 5.0.0 and OpenCV contrib 5.0.0 tarballs.
  2. Extract them under thirdparty/build.
  3. Apply the IPCV local OpenCV DNN MLAS skip patch.
  4. Configure OpenCV with Ninja.
  5. Build opencv_world and selected contrib modules.
  6. Install to thirdparty\Windows\%PROCESSOR_ARCHITECTURE%.
  7. Copy generated DLL/import-library files into the lib folder used by IPCV.

Expected key files after build:

  thirdparty\Windows\AMD64\include\opencv2\opencv.hpp
  thirdparty\Windows\AMD64\lib\opencv_world500.dll
  thirdparty\Windows\AMD64\lib\opencv_world500.lib
  thirdparty\Windows\AMD64\lib\opencv_img_hash500.dll
  thirdparty\Windows\AMD64\lib\opencv_img_hash500.lib

After this, keep the same Visual Studio x64 Native Tools Command Prompt open,
launch Scilab from that prompt, then run IPCV builder.sce from Scilab.


Linux Build
===========

The Linux release binary for IPCV 5.0.0 was built on Ubuntu 22.04 LTS for
better forward compatibility with recent Scilab-supported GNU/Linux systems.

Prerequisites on Ubuntu/Debian-like systems:

  sudo apt-get update
  sudo apt-get install -y \
      build-essential \
      ca-certificates \
      cmake \
      curl \
      gfortran \
      make \
      ninja-build \
      pkg-config \
      tar \
      xz-utils

Commands:

  cd <IPCV_ROOT>/thirdparty/build
  chmod +x build.sh
  ./build.sh

The script will:

  1. Download and build FFmpeg 4.3.6 as shared libraries.
  2. Install FFmpeg into thirdparty/Linux/<architecture>.
  3. Download OpenCV 5.0.0 and OpenCV contrib 5.0.0 tarballs.
  4. Extract them under thirdparty/build.
  5. Apply the IPCV local OpenCV DNN MLAS skip patch.
  6. Configure OpenCV with Ninja.
  7. Build opencv_world and selected contrib modules.
  8. Install to thirdparty/Linux/<architecture>.

On common x86_64 Linux systems, <architecture> is x86_64.

Expected key files after build:

  thirdparty/Linux/x86_64/include/opencv5/opencv2/opencv.hpp
  thirdparty/Linux/x86_64/lib/libopencv_world.so
  thirdparty/Linux/x86_64/lib/libopencv_world.so.5.0.0
  thirdparty/Linux/x86_64/lib/libopencv_img_hash.so
  thirdparty/Linux/x86_64/lib/libopencv_img_hash.so.5.0.0
  thirdparty/Linux/x86_64/lib/libavcodec.so
  thirdparty/Linux/x86_64/lib/libavformat.so

The Linux build sets the installed OpenCV shared-library rpath to $ORIGIN.
This lets packaged IPCV libraries find neighboring OpenCV/FFmpeg shared
libraries after installation by ATOMS.

After this, start Scilab from a shell where your compiler tools are available,
then run IPCV builder.sce from Scilab.


Quick Verification
==================

From the IPCV root, confirm that the expected thirdparty folders exist.

Windows:

  dir thirdparty\Windows\AMD64\lib

Linux:

  ls thirdparty/Linux/x86_64/lib

Then build IPCV from Scilab:

  cd("<IPCV_ROOT>");
  exec("builder.sce", -1);
  exec("loader.sce", -1);
  S = imread(fullpath(getIPCVpath() + "/images/baboon.png"));
  disp(size(S));


Notes And Troubleshooting
=========================

Clean rebuild:

  Remove the extracted OpenCV/FFmpeg source folders under thirdparty/build
  before rerunning the scripts:

    opencv-5.0.0/
    opencv_contrib-5.0.0/
    ffmpeg-4.3.6/

  Keep the downloaded tarballs if you want to avoid another download.

Windows compiler not found:

  Start again from the "x64 Native Tools Command Prompt for VS 2022". Running
  build.bat from a normal PowerShell or cmd.exe session may leave CMake unable
  to find MSVC.

Linux missing tools:

  Install cmake, ninja-build, build-essential, curl, make, and pkg-config.

OpenCV DNN MLAS link/build problems:

  The scripts patch OpenCV's DNN CMake file to skip vendored MLAS for this
  local IPCV build. This was required for the OpenCV 5 migration release.

Runtime library load problems on Linux:

  Make sure the final package preserves symbolic links in
  thirdparty/Linux/x86_64/lib. Create Linux release tarballs on Linux, WSL, or
  Docker rather than with Windows tar if symlink preservation matters.

Generated source folders:

  The folders created by these scripts can be large. They are build artifacts
  and are not required in binary ATOMS packages.
