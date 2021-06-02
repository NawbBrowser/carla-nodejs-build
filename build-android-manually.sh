#!/bin/bash

set -ex

###################################################################
#配置

NODE_VERSION=14.16.1
ANDROID_NDK_HOME=~/Desktop/android-ndk-r22
ALL_SUPPORT_ABIS=(arm64 arm x86 x86_64)
###################################################################

create_env() {
  local FILENAME="v$NODE_VERSION.tar.gz"

  curl -L https://github.com/nodejs/node/archive/refs/tags/${FILENAME} > $FILENAME
  tar zxvf $FILENAME
  cp android-configure node-$NODE_VERSION/
  cp common.gypi node-$NODE_VERSION/
}


build_android(){


    for ANDROID_ABI in ${ALL_SUPPORT_ABIS[*]}; 
    do
    make clean

    ./android-configure $ANDROID_NDK_HOME $ANDROID_ABI 23

    make -j $(getconf _NPROCESSORS_ONLN)


    NDK_ARCH_NAME=$ANDROID_ABI
    
    if [ $NDK_ARCH_NAME == "arm" ]; then
        NDK_ARCH_NAME="armeabi-v7a"
    elif [ $NDK_ARCH_NAME == "arm64" ]; then
        NDK_ARCH_NAME="arm64-v8a"
    fi

    mkdir -p ./out/Release/share_library/android/bin/$NDK_ARCH_NAME/

    cp ./out/Release/obj.target/libnode.so ./out/Release/share_library/android/bin/$NDK_ARCH_NAME/libnode.so

    done 

}


create_env

cd node-$NODE_VERSION

build_android
