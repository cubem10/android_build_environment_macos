#!/bin/zsh

PATH=$1
TOOLCHAIN=$2
ARCH=$3
if [ $# -ne 3 ]; then
	echo "USAGE: ./get_toolchain.sh {PATH} {TOOLCHAIN} {ARCH}\nEXAMPLE: ./get_toolchain.sh ~/toolchain/ arm-eabi-4.8 arm"
else
	/usr/bin/git clone https://android.googlesource.com/platform/prebuilts/gcc/darwin-x86/$ARCH/$TOOLCHAIN $PATH
	echo "DONE!"
fi
