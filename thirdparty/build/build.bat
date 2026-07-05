:: Copyright (C) 2023-2025 - UTC - Stéphane MOTTELET
:: This program is free software; you can redistribute it and/or
:: modify it under the terms of the GNU General Public
:: License as published by the Free Software Foundation; either
:: version 2.1 of the License, or (at your option) any later version.
::
:: openCV build script for Windows
:: cmake.exe (standalone or Visual Studio cmake.exe) and ninja.exe should be in the PATH

set OPENCV_VER=5.0.0
curl -o opencv.tgz https://codeload.github.com/opencv/opencv/tar.gz/refs/tags/%OPENCV_VER%
curl -o opencv_contrib.tgz https://codeload.github.com/opencv/opencv_contrib/tar.gz/refs/tags/%OPENCV_VER%
tar -xf opencv.tgz
tar -xf opencv_contrib.tgz
cd ..
set THIRDPARTY=%cd%
set PREFIX=%THIRDPARTY%\Windows\%PROCESSOR_ARCHITECTURE%
cd build\opencv-%OPENCV_VER%
powershell -NoProfile -ExecutionPolicy Bypass -Command "$p='modules\dnn\CMakeLists.txt'; $lines=Get-Content $p; $seen=$false; $out=foreach($line in $lines){ if($line -eq '# Vendored MLAS (Microsoft Linear Algebra Subprograms) from ONNX Runtime.'){ $seen=$true; $line } elseif($seen -and $line -eq 'if(NOT EMSCRIPTEN)'){ $seen=$false; 'if(FALSE) # IPCV local Windows build: skip MLAS; MSVC/Ninja ASM runtime mapping fails.' } else { $line } }; Set-Content -Path $p -Value $out"
mkdir build
cd build
cmake -G Ninja -DCMAKE_INSTALL_PREFIX="%PREFIX%" ^
-DCMAKE_BUILD_TYPE=Release ^
-DCMAKE_CXX_STANDARD=17 ^
-DCMAKE_CXX_STANDARD_REQUIRED=ON ^
-DWITH_VTK=OFF ^
-DOPENCV_EXTRA_MODULES_PATH="%THIRDPARTY%\build\opencv_contrib-%OPENCV_VER%\modules" ^
-DBUILD_ZLIB=ON ^
-DBUILD_JPEG=ON ^
-DBUILD_WEBP=ON ^
-DBUILD_PNG=ON ^
-DBUILD_TIFF=ON ^
-DBUILD_JASPER=ON ^
-DBUILD_OPENEXR=ON ^
-DBUILD_OPENJPEG=ON ^
-DBUILD_opencv_apps=OFF ^
-DBUILD_opencv_java=OFF ^
-DBUILD_opencv_python=OFF ^
-DBUILD_opencv_python2=OFF ^
-DBUILD_opencv_python3=OFF ^
-DBUILD_opencv_python_bindings_g=OFF ^
-DBUILD_opencv_python_tests=OFF ^
-DBUILD_opencv_world=ON ^
-DBUILD_opencv_hdf=OFF ^
-DBUILD_opencv_freetype=OFF ^
-DOPENCV_FFMPEG_SKIP_BUILD_CHECK=ON ^
-DBUILD_PERF_TESTS=OFF ^
-DBUILD_TESTS=OFF ^
-DBUILD_DOCS=OFF ^
-DBUILD_EXAMPLES=OFF ^
-DCMAKE_CXX_FLAGS="/D _SILENCE_STDEXT_HASH_DEPRECATION_WARNINGS=1" ^
..
cd %THIRDPARTY%\build
cmake --build opencv-%OPENCV_VER%\build --config Release
cmake --install opencv-%OPENCV_VER%\build
if exist "%PREFIX%\bin\*.dll" move /Y "%PREFIX%\bin\*.dll" "%PREFIX%\lib"
if exist "%PREFIX%\x64\vc17\bin\*.dll" copy /Y "%PREFIX%\x64\vc17\bin\*.dll" "%PREFIX%\lib"
if exist "%PREFIX%\x64\vc17\lib\opencv*.lib" copy /Y "%PREFIX%\x64\vc17\lib\opencv*.lib" "%PREFIX%\lib"
if exist "%PREFIX%\x64\vc17\lib\OpenCV*.cmake" copy /Y "%PREFIX%\x64\vc17\lib\OpenCV*.cmake" "%PREFIX%\lib"
