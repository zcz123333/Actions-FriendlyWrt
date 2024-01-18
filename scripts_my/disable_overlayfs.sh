#!/bin/bash

#rm -rf scripts/sd-fuse/friendlywrt23/userdata.img
cp scripts/sd-fuse/prebuilt/parameter-ext4.txt scripts/sd-fuse/prebuilt/parameter.template
sed -i '/USERDATA_PARTITION_ADDR/d' scripts/sd-fuse/tools/generate-partmap-txt.sh
sed -i '' friendlywrt/build_dir/target-aarch64_generic_musl/root-rockchip/lib/upgrade/platform.sh
#sed -i '/TMPDIR=/a \\tsudo touch ${TMPDIR}/.ext4.resized' scripts/sd-fuse/tools/update_prebuilt.sh
