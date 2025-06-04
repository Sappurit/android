#!/bin/bash

export API="23"
export ABI="arm64-v8a"
export ARCH="arm64"
export PLATFORM="android-$API"
export TARGET="aarch64-linux-android"

export ANDROID_ROOT="$HOME/android"                           # Main folder of android project
export ANDROID_NDK_ROOT="$ANDROID_ROOT/android-ndk-r27c"      # $ANDROID_NDK_ROOT use by openssl-3.5.0
export OUT="$ANDROID_ROOT/aarch64-$API"                       # Root folder for installed packages

export TOOLCHAIN="$ANDROID_NDK_ROOT/toolchains/llvm/prebuilt/linux-x86_64"
export SYSROOT="$TOOLCHAIN/sysroot"
export CC="$TOOLCHAIN/bin/${TARGET}${API}-clang"
export CXX="$TOOLCHAIN/bin/${TARGET}${API}-clang++"
export AR="$TOOLCHAIN/bin/llvm-ar"
export AS="$TOOLCHAIN/bin/llvm-as"
export LD="$TOOLCHAIN/bin/ld"
export RANLIB="$TOOLCHAIN/bin/llvm-ranlib"
export STRIP="$TOOLCHAIN/bin/llvm-strip"
export NM="$TOOLCHAIN/bin/llvm-nm"

if [[ ":$PATH:" != *":$TOOLCHAIN/bin:"* ]]; then
    export PATH="$TOOLCHAIN/bin:$PATH"
fi

export CFLAGS="--sysroot=$SYSROOT -O2 -fPIC -fvisibility=hidden -ffunction-sections -fdata-sections -Wno-error=implicit-function-declaration"
export CXXFLAGS="$CFLAGS"
export CPPFLAGS="-I$OUT/include -I$SYSROOT/usr/include -DNDEBUG"
export LDFLAGS="-L$OUT/lib -L$SYSROOT/usr/lib -static -fuse-ld=lld -Wl,--no-undefined,--gc-sections,--icf=safe"
export LIBS="-lz -ldl -lm"

export PKG_CONFIG_PATH="$OUT/lib/pkgconfig"
export PKG_CONFIG_LIBDIR="$OUT/lib/pkgconfig"
export PKG_CONFIG="pkg-config --static"          # Force configure script to include Libs.private dependencies

export MAKEFLAGS="-j$(nproc)"                    # Parallel jobs
export CMAKE_PREFIX_PATH="$OUT"                  # Root folder to search for installed packages


alias lst="ls -ltr"


function m
{
  echo "::::::::::::::"
  echo "$1"
  echo "::::::::::::::"
  more "$1"
}


function nanoaa
{
  nano "$ANDROID_ROOT/aarch64-$API.sh"
}


function sourceaa
{
  source "$ANDROID_ROOT/aarch64-$API.sh"
}


function cdin
{
  cd "$OUT/include"
}


function lsin
{
  echo
  tree --noreport "$OUT/include"
  echo
  ls -ltr "$OUT/include"
  echo
}


function cdlib
{
  cd "$OUT/lib"
}


function lslib
{
  echo
  tree --noreport "$OUT/lib"
  echo
  ls -ltr "$OUT/lib"
  echo
}


function cdpkg
{
  cd "$OUT/lib/pkgconfig"
}


function lspkg
{
  echo
  tree --noreport "$OUT/lib/pkgconfig"
  echo
  ls -ltr "$OUT/lib/pkgconfig"
  echo
}


function conhelp
{
  echo
  ./configure --help
  echo
}


function makehelp
{
  echo
  grep -P '^[\w\-\/]+\s?:' Makefile
  echo
}


function cmakehelp
{
  echo
  cmake -LH
  echo
}


function makeclean
{
  make distclean
}


function xmake
{
  echo
  local TMP_DIR="$(basename "$PWD")"

  if [[ "$TMP_DIR" == "tmp" && -f "CMakeCache.txt" && -d "CMakeFiles" && ! -f "CMakeLists.txt" ]]; then
    echo
    echo "[xmake] CMake build dir [tmp] : Not empty"
    echo "[xmake] Want to cleaning up?"
    rm -rI *
  fi

  if [[ "$TMP_DIR" == "tmp" && ! -f "CMakeCache.txt" && ! -d "CMakeFiles" && -f "../CMakeLists.txt" ]]; then
    echo "[xmake] CMake build dir [tmp] : Cleaned up"
    echo "[xmake] Running cmake..."
    cmake "$@"
    return
  fi

  echo "[xmake] Something wrong."
  echo
}

