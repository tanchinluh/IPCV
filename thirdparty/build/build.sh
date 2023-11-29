# Copyright (C) 2023 - UTC - Stéphane MOTTELET
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# openCV build script for Linux and macOS
# cmake should be in the PATH

cd ..
THIRDPARTY="$(pwd)/$(uname -s)/$(uname -m)"
cd build
OPENCV_VER=4.5.0
FFMPEG_VER=4.3.6

# ffmpeg build
curl -L https://ffmpeg.org/releases/ffmpeg-${FFMPEG_VER}.tar.xz -o ffmpeg.tar.gz
tar xvzf ffmpeg.tar.xz
cd ffmpeg-${FFMPEG_VER}
./configure --enable-shared --enable-rpath --disable-static --disable-programs --disable-x86asm --prefix="${THIRDPARTY}"
make -j4
make install
cd ..

# opencv build
curl -L https://github.com/opencv/opencv/archive/refs/tags/${OPENCV_VER}.tar.gz -o opencv.tgz
curl -L https://github.com/opencv/opencv_contrib/archive/refs/tags/${OPENCV_VER}.tar.gz -o opencv_contrib.tgz
tar xvzf opencv.tgz
tar xvzf opencv_contrib.tgz
cd opencv-${OPENCV_VER}
mkdir -p build
cd build
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:${THIRDPARTY}/lib/pkgconfig"
cmake -DCMAKE_INSTALL_PREFIX="${THIRDPARTY}" \
-DCMAKE_MACOSX_RPATH=ON \
-DCMAKE_SHARED_LINKER_FLAGS="-Wl,-rpath,${THIRDPARTY}/lib" \
-DCMAKE_INSTALL_RPATH="${THIRDPARTY}/lib" \
-DOPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-${OPENCV_VER}/modules \
-DWITH_OPENJPEG=OFF \
-DBUILD_opencv_apps=OFF \
-DBUILD_opencv_python2=OFF \
-DBUILD_opencv_world:BOOL=ON \
-DBUILD_opencv_hdf=OFF \
-DBUILD_opencv_freetype=OFF \
-DOPENCV_FFMPEG_SKIP_BUILD_CHECK=ON \
-DBUILD_PERF_TESTS:BOOL=OFF \
-DBUILD_TESTS:BOOL=OFF \
-DBUILD_DOCS:BOOL=OFF \
-DBUILD_EXAMPLES:BOOL=OFF \
..
make -j4
make install
