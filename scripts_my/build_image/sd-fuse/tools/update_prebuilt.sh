#!/bin/bash
set -eu

[ -f ${PWD}/mk-emmc-image.sh ] || {
	echo "Error: please run at the script's home dir"
	exit 1
}

cp -f $2/boot.img $1/
cp -f $2/idbloader.img $1/
cp -f $2/misc.img $1/
cp -f $2/dtbo.img $1/

TOP=$PWD
HOST_ARCH=
if uname -mpi | grep aarch64 >/dev/null; then
    HOST_ARCH="aarch64/"
fi

export MKE2FS_CONFIG="${TOP}/tools/mke2fs.conf"
if [ ! -f ${MKE2FS_CONFIG} ]; then
    echo "error: ${MKE2FS_CONFIG} not found."
    exit 1
fi
true ${MKFS:="${TOP}/tools/${HOST_ARCH}mke2fs"}

RET=0
if [ ! -f $1/userdata.img ]; then
	#USERDATA_SIZE=209715200
	#default size for without overlay
	USERDATA_SIZE=629145600
	echo "Generating empty userdata.img (size:${USERDATA_SIZE})"
	TMPDIR=`mktemp -d`
	#used for without overlay
	#sudo touch ${TMPDIR}/.ext4.resized
	#sudo mkdir ${TMPDIR}/root
	IMG_BLK=$((${USERDATA_SIZE} / 4096))
	${MKFS} -E android_sparse -t ext4 -L userdata -M /userdata -b 4096 -d ${TMPDIR} $1/userdata.img ${IMG_BLK}
	RET=$?
	rm -rf ${TMPDIR}
fi

if [ ! -f $1/extdata.img ]; then
	EXTDATA_SIZE=50331648
	echo "Generating empty extdata.img (size:${EXTDATA_SIZE})"
	TMPDIR=`mktemp -d`
	IMG_BLK=$((${EXTDATA_SIZE} / 4096))
	${MKFS} -E android_sparse -t ext4 -L extdata -b 4096 -d ${TMPDIR} $1/extdata.img ${IMG_BLK}
	RET=$?
	rm -rf ${TMPDIR}
fi

exit $RET
