#!/bin/bash

export OUT="$PWD/aarch64"

export API=23
export ARCH=arm64
export TARGET=aarch64-linux-android
export ABI=arm64-v8a
export PLATFORM=android-$API

export NDK_VER=android-ndk-r21e
export NDK_DIR="$PWD/$NDK_VER"
export TOOLCHAIN="$NDK_DIR/toolchains/llvm/prebuilt/linux-x86_64"

export SYSROOT="$TOOLCHAIN/sysroot"
export CC="$TOOLCHAIN/bin/${TARGET}${API}-clang"
export CXX="$TOOLCHAIN/bin/${TARGET}${API}-clang++"
export AR="$TOOLCHAIN/bin/llvm-ar"
export AS="$TOOLCHAIN/bin/llvm-as"
export LD="$TOOLCHAIN/bin/ld"
export RANLIB="$TOOLCHAIN/bin/llvm-ranlib"
export STRIP="$TOOLCHAIN/bin/llvm-strip"

export CFLAGS="-DNDEBUG -O2 -fPIC -fvisibility=hidden -ffunction-sections -fdata-sections -flto"
export CXXFLAGS="$CFLAGS"
export CPPFLAGS="-I$OUT/include -I$SYSROOT/usr/include"
export LDFLAGS="--sysroot=$SYSROOT -static -L$OUT/lib -L$SYSROOT/usr/lib -fuse-ld=lld -Wl,--no-undefined,--gc-sections,--icf=safe"
export LIBS="-ldl -lz -lm"

export PKG_CONFIG_PATH="$OUT/lib/pkgconfig"
export PKG_CONFIG_LIBDIR="$OUT/lib/pkgconfig"
export PKG_CONFIG_SYSROOT_DIR="$SYSROOT"

export MAKEFLAGS="-j$(nproc)"
export CMAKE_PREFIX_PATH="$OUT"
