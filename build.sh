#!/bin/bash

set -ex

download_and_extract() {
  local FILENAME="v$NODE_VERSION.tar.gz"

  curl -L https://github.com/nodejs/node/archive/refs/tags/${FILENAME} > $FILENAME
  tar zxvf "$FILENAME"
  cp android-configure node-$NODE_VERSION/
  cp common.gypi node-$NODE_VERSION/
}

build_android() {
  ./android-configure $ANDROID_NDK_HOME $ANDROID_ABI 23
  make -j $(getconf _NPROCESSORS_ONLN)

  tree ./out
}

download_and_extract > /dev/null
cd node-$NODE_VERSION
build_android
