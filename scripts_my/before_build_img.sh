#!/bin/bash

#remove emmc-tools
rm -rf device/common/emmc-tools/
sed -i '/device\/common\/emmc-tools/d' device/friendlyelec/rk3328/base.mk

#fix flash.js
cp ../patches_my/0002-fix-to-make-factory-reset-button-work-on-FriendlyWrt.patch device/common/src-patchs/23.05/feeds/luci/

#fix image build for config preserve flashing
# add extdata partition(mmcblk0p10) for config storage
rsync -r ../scripts_my/build_image/sd-fuse/ scripts/sd-fuse/
# use mmcblk0p10 for config storage on startup
sed -i '/79_move_config/d' device/common/default-settings/install.sh
if [ -d "friendlywrt/build_dir" ]; then
    sed -i 's/export_partdevice partdev [0-9]\+/export_partdevice partdev 10/' `find friendlywrt/ -follow -type f -path '*/lib/preinit/79_move_config'`
    sed -i '/platform_copy_config/,+10 s/export_partdevice partdev [0-9]\+/export_partdevice partdev 10/' `find friendlywrt/ -follow -type f -path '*/lib/upgrade/platform.sh'`
fi