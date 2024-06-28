#!/bin/bash

#set -x
set -e

ndk=$HOME/Library/Android/sdk/ndk/25.2.9519653
tc=$ndk/toolchains/llvm/prebuilt/darwin-x86_64


#for arch in arm64-v8a armeabi-v7a x86 x86_64
for arch in aarch64 armv7a i686 x86_64
do
  sysroot=$tc/sysroot

  xcc=$arch-linux-android23-clang

  toolchain_sysroot=$tc/sysroot/usr/lib/$arch-linux-android/21
  
  if [ "$arch" == "armv7a" ]; then
    arch="arm"
    xcc=armv7a-linux-androideabi21-clang
  fi
  
  EXTFLAGS=""
  EXTFLAGS+=" --sysroot=$sysroot"
  EXTFLAGS+=" --target=$arch-linux-androideabi"
  EXTFLAGS+=" -I$sysroot/usr/include/$arch-linux-androideabi"
  EXTFLAGS+=" -L$sysroot/usr/lib/$arch-linux-androideabi"
  EXTFLAGS+=" -L$toolchain_sysroot"
  EXTFLAGS+=" -O2"

  make clean
  PATH=$tc/bin:$PATH \
    CC=$xcc \
    LD=gold \
    CFLAGS=$EXTFLAGS \
    make ZSTD_LIB_COMPRESSION=0 \
      V=1 UNAME=Linux \
      prefix=$(pwd)/android-install/$arch \
      install-static install-includes -j8


done


mv android-install/aarch64 android-install/arm64-v8a
mv android-install/arm android-install/armeabi-v7a
mv android-install/i686 android-install/x86
