#!/bin/bash

set -ex

create_env() {
  local FILENAME="v$NODE_VERSION.tar.gz"

  curl -L https://github.com/nodejs/node/archive/refs/tags/${FILENAME} > $FILENAME
  tar zxvf $FILENAME
  cp android-configure node-$NODE_VERSION/
  cp common.gypi node-$NODE_VERSION/
}

build_android() {
  make clean
  ./android-configure $ANDROID_NDK_HOME $ANDROID_ABI 23
  make -j $(getconf _NPROCESSORS_ONLN)
  mkdir -p ./out/Release/share_library

  NDK_ARCH_NAME=$ANDROID_ABI
  
  if [ $NDK_ARCH_NAME == "arm" ]; then
    NDK_ARCH_NAME="armeabi-v7a"
  elif [ $NDK_ARCH_NAME == "arm64" ]; then
    NDK_ARCH_NAME="arm64-v8a"
  fi

  cp ./out/Release/obj.target/libnode.so ./out/Release/share_library/libnode-v$NODE_VERSION-android-$NDK_ARCH_NAME.so
}

create_env

cd node-$NODE_VERSION

build_android
