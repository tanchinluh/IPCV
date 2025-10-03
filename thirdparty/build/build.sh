#!/bin/bash
# Copyright (C) 2023-2025 - UTC - Stéphane MOTTELET
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# openCV build script for Linux and macOS
# cmake and ninja should be in the PATH

THIRDPARTY="$(cd ..; pwd)"
PREFIX="${THIRDPARTY}/$(uname -s)/$(uname -m)"
OPENCV_VER=4.5.0
FFMPEG_VER=4.3.6

# ffmpeg build
[ ! -f opencv-${OPENCV_VER}.tar.gz ] && curl -LO https://ffmpeg.org/releases/ffmpeg-${FFMPEG_VER}.tar.gz
tar -xf ffmpeg-${FFMPEG_VER}.tar.gz
cd ffmpeg-${FFMPEG_VER}
./configure --enable-shared --enable-rpath --disable-static --disable-programs --disable-x86asm --prefix="${PREFIX}"
make -j4
make install
cd ..

# opencv build
[ ! -f opencv-${OPENCV_VER}.tar.gz ] && curl -L https://github.com/opencv/opencv/archive/refs/tags/${OPENCV_VER}.tar.gz -o opencv-${OPENCV_VER}.tar.gz
[ ! -f opencv_contrib-${OPENCV_VER}.tar.gz ] && curl -L https://github.com/opencv/opencv_contrib/archive/refs/tags/${OPENCV_VER}.tar.gz -o opencv_contrib-${OPENCV_VER}.tar.gz
tar -xf opencv-${OPENCV_VER}.tar.gz
tar -xf opencv_contrib-${OPENCV_VER}.tar.gz
cd opencv-${OPENCV_VER}
rm -rf build
mkdir -p build
cd build
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:${PREFIX}/lib/pkgconfig"
cmake -G Ninja -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
-DCMAKE_BUILD_TYPE=Release \
-DWITH_VTK=OFF \
-DCMAKE_MACOSX_RPATH=ON \
-DCMAKE_SHARED_LINKER_FLAGS="-Wl,-rpath,${PREFIX}/lib" \
-DCMAKE_INSTALL_RPATH="${PREFIX}/lib" \
-DOPENCV_EXTRA_MODULES_PATH=${THIRDPARTY}/build/opencv_contrib-${OPENCV_VER}/modules \
-DBUILD_ZLIB=ON \
-DBUILD_JPEG=ON \
-DBUILD_WEBP=ON \
-DBUILD_PNG=ON \
-DBUILD_TIFF=ON \
-DBUILD_JASPER=ON \
-DBUILD_OPENEXR=ON \
-DBUILD_OPENJPEG=ON \
-DBUILD_opencv_apps=OFF \
-DBUILD_opencv_java=OFF \
-DBUILD_opencv_python=OFF \
-DBUILD_opencv_python2=OFF \
-DBUILD_opencv_python3=OFF \
-DBUILD_opencv_python_bindings_g=OFF \
-DBUILD_opencv_python_tests=OFF \
-DBUILD_opencv_world=ON \
-DBUILD_opencv_hdf=OFF \
-DBUILD_opencv_freetype=OFF \
-DOPENCV_FFMPEG_SKIP_BUILD_CHECK=ON \
-DBUILD_PERF_TESTS=OFF \
-DBUILD_TESTS=OFF \
-DBUILD_DOCS=OFF \
-DBUILD_EXAMPLES=OFF \
..
cd ../..
cmake --build opencv-${OPENCV_VER}/build --config Release
cmake --install opencv-${OPENCV_VER}/build
