#!/bin/bash

export kernel=Werewolf
export device=hammerhead
export deviceconfig=werewolf_defconfig
export outdir=/usr/share/nginx/html/Werewolf
export makeopts="-j$(nproc)"
export zImagePath="arch/arm/boot/zImage-dtb"
export KBUILD_BUILD_USER=USA-RedDragon
export KBUILD_BUILD_HOST=EdgeOfCreation
export CROSS_COMPILE="ccache /root/deso/prebuilts/gcc/linux-x86/arm/arm-eabi-5.3-xanax/bin/arm-eabi-"
export ARCH=arm
export variant=caf
export PTHREADS=1

export version=$(cat version)

if ${CROSS_COMPILE}gcc --version | grep -q UBERTC ; then
	export PTHREADS=0
fi

if [[ $1 =~ "clean" ]] ; then
	make clean
	make mrproper
fi

make ${makeopts} ${deviceconfig}
make ${makeopts}

if [ -a ${zImagePath} ] ; then
	cp ${zImagePath} zip/zImage
	cd zip
	zip -q -r ${kernel}-${device}-${version}-${variant}.zip anykernel.sh  META-INF  modules  ramdisk  tools zImage
else
	echo -e "\n\e[31m***** Build Failed *****\e[0m\n"
fi

if ! [ -d ${outdir} ] ; then
	mkdir ${outdir}
fi

if [ -a ${kernel}-${device}-${version}-${variant}.zip ] ; then
	install -g www-data -o www-data -m 655 -v ${kernel}-${device}-${version}-${variant}.zip ${outdir}
fi

rm -f zImage
rm -f modules/*
rm -f ${kernel}-${device}-${version}-${variant}.zip
