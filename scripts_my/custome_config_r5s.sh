#!/bin/bash

#sed -i -e '579i\CONFIG_TARGET_ROOTFS_EXT4FS=y' configs/rockchip/01-nanopi
sed -i -e '460i\CONFIG_PACKAGE_luci-app-passwall=y' configs/rockchip/01-nanopi
sed -i -e '460a\CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Trojan_Plus=n' configs/rockchip/01-nanopi
sed -i -e '460a\CONFIG_PACKAGE_luci-app-passwall_INCLUDE_V2ray_Plugin=n' configs/rockchip/01-nanopi
#sed -i -e '243i\CONFIG_PACKAGE_keepalived=y' configs/rockchip/01-nanopi
sed -i -e '184i\CONFIG_PACKAGE_ddns-scripts-cloudflare=y' configs/rockchip/01-nanopi
sed -i -e '184i\CONFIG_PACKAGE_ddns-scripts-godaddy=y' configs/rockchip/01-nanopi
sed -i -e '184i\CONFIG_PACKAGE_ddns-scripts-aliyun=y' configs/rockchip/01-nanopi
sed -i -e '184i\CONFIG_PACKAGE_ddns-scripts-dnspod=y' configs/rockchip/01-nanopi
sed -i '/CONFIG_PACKAGE_luci-app-aria2=y/d' configs/rockchip/01-nanopi
sed -i '/CONFIG_PACKAGE_vsftpd=y/d' configs/rockchip/01-nanopi
sed -i 's/CONFIG_TARGET_ROOTFS_PARTSIZE=.*/CONFIG_TARGET_ROOTFS_PARTSIZE=768/g' configs/rockchip/01-nanopi

sed -i -e '/CONFIG_MAKE_TOOLCHAIN=y/d' configs/rockchip/01-nanopi
sed -i -e 's/CONFIG_IB=y/# CONFIG_IB is not set/g' configs/rockchip/01-nanopi
sed -i -e 's/CONFIG_SDK=y/# CONFIG_SDK is not set/g' configs/rockchip/01-nanopi

sed -i 's/=y/=n/g' configs/rockchip/02-luci_lang
sed -i 's/CONFIG_LUCI_LANG_en=n/CONFIG_LUCI_LANG_en=y/' configs/rockchip/02-luci_lang
sed -i 's/CONFIG_LUCI_LANG_zh_Hans=n/CONFIG_LUCI_LANG_zh_Hans=y/' configs/rockchip/02-luci_lang

sed -i "s/option limit_enable '1'/option limit_enable '0'/" `find friendlywrt/package/ -follow -type f -path '*/nft-qos/files/nft-qos.config'`

## set ip address
chmod a+x ../patches_my/ip_addr_r5s.sh
cp ../patches_my/ip_addr_r5s.sh `find friendlywrt/target/ -follow -type d -path '*rockchip*/root'`
echo '[ -f /root/ip_addr_r5s.sh ] && /root/ip_addr_r5s.sh' >> `find friendlywrt/target/ -follow -type f -path '*rockchip*/uci-defaults/vendor.defaults'`
