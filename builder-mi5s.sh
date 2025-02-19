#!/bin/bash

KERNEL_DIR=$PWD
ANYKERNEL_DIR=$KERNEL_DIR/AnyKernel2
#CCACHEDIR=../CCACHE/capricorn
#TOOLCHAINDIR=/pipeline/build/root/toolchain/aarch64-linux-android-4.9
DATE=$(date +"%d%m%Y")
KERNEL_NAME="Pepsy"
DEVICE="-capricorn-"
VER="-v1.4-custom"
TYPE="-O-MR1-EAS"
FINAL_ZIP="$KERNEL_NAME""$DEVICE""$DATE""$TYPE""$VER".zip

rm $ANYKERNEL_DIR/capricorn/Image.gz-dtb
rm $KERNEL_DIR/arch/arm64/boot/Image.gz $KERNEL_DIR/arch/arm64/boot/Image.gz-dtb

export ARCH=arm64
export KBUILD_BUILD_USER="fitsuli"
export KBUILD_BUILD_HOST="E1-571G"
#export CC=/pipeline/build/root/toolchain/SnapDragonLLVM_6.0/prebuilt/linux-x86_64/bin/clang
#export CXX=/pipeline/build/root/toolchain/SnapDragonLLVM_6.0/prebuilt/linux-x86_64/bin/clang++
#export CLANG_TRIPLE=aarch64-linux-gnu-
export CROSS_COMPILE=/home/user/kernel/linaro-64-dev/bin/aarch64-linux-gnu-
#export LD_LIBRARY_PATH=$TOOLCHAINDIR/lib/
#export USE_CCACHE=1
#export CCACHE_DIR=$CCACHEDIR/.ccache

# make clean && make mrproper
# make capricorn_defconfig
make -j4

{
cp $KERNEL_DIR/arch/arm64/boot/Image.gz-dtb $ANYKERNEL_DIR/capricorn
} || {
  if [ $? != 0 ]; then
    #curl -s -X POST https://api.telegram.org/bot$BOT_API_KEY/sendMessage -d text="Build failed for capricorn :c" -d chat_id=@pepsykernel;
    echo Noooope
    exit
  fi
}

cd $ANYKERNEL_DIR/capricorn
zip -r9 $FINAL_ZIP * -x *.zip $FINAL_ZIP
#curl -F chat_id="-1001152658251" -F document=@"$FINAL_ZIP" https://api.telegram.org/bot$BOT_API_KEY/sendDocument
mv $FINAL_ZIP ~/kernel/pepsy_out/$FINAL_ZIP
