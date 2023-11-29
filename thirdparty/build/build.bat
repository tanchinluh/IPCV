:: Copyright (C) 2023 - UTC - Stéphane MOTTELET
:: This program is free software; you can redistribute it and/or
:: modify it under the terms of the GNU General Public
:: License as published by the Free Software Foundation; either
:: version 2.1 of the License, or (at your option) any later version.
::
:: openCV build script for Windows
:: cmake.exe (standalone or Visual Studio cmake.exe) should be in the PATH

set OPENCV_VER=4.5.0
curl -o opencv.tgz https://codeload.github.com/opencv/opencv/tar.gz/refs/tags/%OPENCV_VER%
curl -o opencv_contrib.tgz https://codeload.github.com/opencv/opencv_contrib/tar.gz/refs/tags/%OPENCV_VER%
tar xvzf opencv.tgz
tar xvzf opencv_contrib.tgz
set THIRDPARTY=%cd%
cd opencv-%OPENCV_VER%
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX="%THIRDPARTY%\Windows\%PROCESSOR_ARCHITECTURE%" ^
-DCMAKE_MACOSX_RPATH=ON ^
-DOPENCV_EXTRA_MODULES_PATH="%THIRDPARTY%\opencv_contrib-%OPENCV_VER%\modules" ^
-DWITH_OPENJPEG=OFF ^
-DBUILD_opencv_apps=OFF ^
-DBUILD_opencv_python2=OFF ^
-DBUILD_opencv_world:BOOL=ON ^
-DBUILD_opencv_hdf=OFF ^
-DBUILD_opencv_freetype=OFF ^
-DOPENCV_FFMPEG_SKIP_BUILD_CHECK=ON ^
-DBUILD_PERF_TESTS:BOOL=OFF ^
-DBUILD_TESTS:BOOL=OFF ^
-DBUILD_DOCS:BOOL=OFF ^
-DBUILD_EXAMPLES:BOOL=OFF ^
-DCMAKE_CXX_FLAGS="/D _SILENCE_STDEXT_HASH_DEPRECATION_WARNINGS=1" ^
..
cd %THIRDPARTY% 
cmake --build opencv-%OPENCV_VER%\build
cmake --install opencv-%OPENCV_VER%\build
