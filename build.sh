#!/usr/bin/bash

sudo apt update
sudo apt install p7zip aria2

ffmpeg_url="https://mxplayer.s3.amazonaws.com/open-source/ffmpeg/ffmpeg_1.44.0_build_221.7z"
ndk_url="https://dl.google.com/android/repository/android-ndk-r20b-linux-x86_64.zip"
ffmpeg_version="1.44.0"
aio="libffmpeg.mx.so.aio.$ffmpeg_version"

aria2c $ffmpeg_url
7za x ffmpeg_1.44.0_build_221.7z
CPUs=$(cat /proc/cpuinfo| grep "processor"| wc -l)
sed -i "s/CPU_CORE=[0-9]*/CPU_CORE=$CPUs/g" ffmpeg/JNI/build-ffmpeg.sh
sed -i "s/CPU_CORE=[0-9]*/CPU_CORE=$CPUs/g" ffmpeg/JNI/build.sh

aria2c  
7za x android-ndk-r20b-linux-x86_64.zip
export NDK=$(pwd)/android-ndk-r20b
cd ffmpeg/JNI
./rebuild-ffmpeg.sh

mkdir $aio
function rename() {
  mv $(find "libs/$1" -name "*so") $aio/libffmpeg.mx.so.$2.$ffmpeg_version
}

rename arm64-v8a neon64
rename armeabi-v7a neon
rename x86 x86
rename x86_64 x86_64

