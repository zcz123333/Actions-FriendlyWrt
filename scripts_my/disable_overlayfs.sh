#!/bin/bash

#rm -rf scripts/sd-fuse/friendlywrt24/userdata.img
cp scripts/sd-fuse/prebuilt/parameter-plain.txt scripts/sd-fuse/prebuilt/parameter.template
#sed -i '/USERDATA_PARTITION_ADDR/d' scripts/sd-fuse/tools/generate-partmap-txt.sh
sed -i '/platform_copy_config/,+10 s/export_partdevice partdev [0-9]\+/export_partdevice partdev 8/' `find friendlywrt/ -follow -type f -path '*/lib/upgrade/platform.sh'`
#sed -i '/TMPDIR=/a \\tsudo touch ${TMPDIR}/.ext4.resized' scripts/sd-fuse/tools/update_prebuilt.sh
