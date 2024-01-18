#!/bin/bash

#sed -i -e '579i\CONFIG_TARGET_ROOTFS_EXT4FS=y' configs/rockchip/01-nanopi
sed -i -e '460i\CONFIG_PACKAGE_luci-app-passwall=y' configs/rockchip/01-nanopi
sed -i -e '243i\CONFIG_PACKAGE_keepalived=y' configs/rockchip/01-nanopi
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

# config_file_turboacc=`find friendlywrt/package/ -follow -type f -path '*/luci-app-turboacc/root/etc/config/turboacc'`
# sed -i "s/option hw_flow '1'/option hw_flow '0'/" $config_file_turboacc
# sed -i "s/option sfe_flow '1'/option sfe_flow '0'/" $config_file_turboacc
# sed -i "s/option sfe_bridge '1'/option sfe_bridge '0'/" $config_file_turboacc
# sed -i "/dep.*INCLUDE_.*=n/d" `find friendlywrt/package/ -follow -type f -path '*/luci-app-turboacc/Makefile'`

sed -i "s/option limit_enable '1'/option limit_enable '0'/" `find friendlywrt/package/ -follow -type f -path '*/nft-qos/files/nft-qos.config'`

# line_number_INCLUDE_Xray=$[`grep -m1 -n 'Include Xray' friendlywrt/package/feeds/PWluci/luci-app-passwall/Makefile|cut -d: -f1`-1]
# sed -i $line_number_INCLUDE_Xray'd' friendlywrt/package/feeds/PWluci/luci-app-passwall/Makefile
# sed -i $line_number_INCLUDE_Xray'd' friendlywrt/package/feeds/PWluci/luci-app-passwall/Makefile
# sed -i $line_number_INCLUDE_Xray'd' friendlywrt/package/feeds/PWluci/luci-app-passwall/Makefile
# line_number_INCLUDE_V2ray=$[`grep -m1 -n 'Include V2ray' friendlywrt/package/feeds/PWluci/luci-app-passwall/Makefile|cut -d: -f1`-1]
# sed -i $line_number_INCLUDE_V2ray'd' friendlywrt/package/feeds/PWluci/luci-app-passwall/Makefile
# sed -i $line_number_INCLUDE_V2ray'd' friendlywrt/package/feeds/PWluci/luci-app-passwall/Makefile
# sed -i $line_number_INCLUDE_V2ray'd' friendlywrt/package/feeds/PWluci/luci-app-passwall/Makefile

# use luci-app-cpufreq in friendlywrt
# config_file_cpufreq=`find friendlywrt/package/ -follow -type f -path '*/luci-app-cpufreq/root/etc/config/cpufreq'`
# truncate -s-1 $config_file_cpufreq
# echo -e "\toption governor0 'schedutil'" >> $config_file_cpufreq
# echo -e "\toption minfreq0 '816000'" >> $config_file_cpufreq
# echo -e "\toption maxfreq0 '1512000'\n" >> $config_file_cpufreq

## ugly fix of the read-only issue
#sed -i '3 i sed -i "/^exit.*/i\\/bin\\/mount -o remount,rw /" /etc/rc.local' `find friendlywrt/package -type f -path '*/default-settings/files/*-default-settings'`

## set ip address
chmod a+x ../patches_my/ip_addr.sh
cp ../patches_my/ip_addr.sh `find friendlywrt/target/ -follow -type d -path '*rockchip*/root'`
echo '[ -f /root/ip_addr.sh ] && /root/ip_addr.sh' >> `find friendlywrt/target/ -follow -type f -path '*rockchip*/uci-defaults/vendor.defaults'`
