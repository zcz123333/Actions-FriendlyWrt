#!/bin/bash

#remove emmc-tools
rm -rf device/common/emmc-tools/
sed -i '/device\/common\/emmc-tools/d' device/friendlyelec/rk3328/base.mk

#fix flash.js
cp ../patches_my/0002-fix-to-make-factory-reset-button-work-on-FriendlyWrt.patch device/common/src-patchs/23.05/feeds/luci/
