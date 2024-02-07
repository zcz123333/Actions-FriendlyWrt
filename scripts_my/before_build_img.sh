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

#overclock https://wiki.friendlyelec.com/wiki/index.php/NanoPi_R2S/zh#.E4.BF.AE.E6.94.B9.E5.86.85.E6.A0.B8.E8.A7.A3.E9.94.81.E6.9B.B4.E9.AB.98.E7.9A.84CPU.E9.A2.91.E7.8E.87
if [ -d "kernel" ]; then
    sed -i '/opp-1296000000/{N;N;N;N;a\
\t\topp-1512000000 {\n\t\t\topp-hz = /bits/ 64 <1512000000>;\n\t\t\topp-microvolt = <1450000>;\n\t\t\tclock-latency-ns = <40000>;\n\t\t};
}' `find kernel/arch -follow -type f -path '*/rockchip/rk3328.dtsi'`
fi
