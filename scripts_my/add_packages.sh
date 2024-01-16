#!/bin/bash

function merge_package(){
    repo=`echo $1 | rev | cut -d'/' -f 1 | rev`
    pkg=`echo $2 | rev | cut -d'/' -f 1 | rev`
    find package/ -follow -name $pkg -not -path "package/custom/*" | xargs -rt rm -rf
    git clone --depth=1 --single-branch $1
    mv $2 package/custom/
    rm -rf $repo
}

function merge_package2(){
    pkg=`echo $1 | rev | cut -d'/' -f 1 | rev`
    find package/ -follow -name $pkg -not -path "package/custom/*" | xargs -rt rm -rf
    mv $1 package/custom/
}

function merge_feed(){
    if [ ! -d "feed/$1" ]; then
        echo >> feeds.conf.default
        echo "src-git $1 $2" >> feeds.conf.default
    fi
    # ./scripts/feeds update $1
    # ./scripts/feeds install -a -p $1
}

rm -rf friendlywrt/package/custom/
mkdir -p friendlywrt/package/custom/

# {{ Add luci-app-diskman
(cd friendlywrt && {
    merge_package https://github.com/lisaac/luci-app-diskman luci-app-diskman/applications/luci-app-diskman

    mkdir -p package/parted
    wget https://raw.githubusercontent.com/lisaac/luci-app-diskman/master/Parted.Makefile -O package/parted/Makefile
})
cat >> configs/rockchip/01-nanopi <<EOL
CONFIG_PACKAGE_luci-app-diskman=y
CONFIG_PACKAGE_luci-app-diskman_INCLUDE_btrfs_progs=y
CONFIG_PACKAGE_luci-app-diskman_INCLUDE_lsblk=y
CONFIG_PACKAGE_smartmontools=y
EOL
# }}

# {{ Add luci-theme-argon
(cd friendlywrt/package && {
    [ -d luci-theme-argon ] && rm -rf luci-theme-argon
    git clone https://github.com/jerrykuku/luci-theme-argon.git --depth 1 -b master
})
echo "CONFIG_PACKAGE_luci-theme-argon=y" >> configs/rockchip/01-nanopi
sed -i -e 's/function init_theme/function old_init_theme/g' friendlywrt/target/linux/rockchip/armv8/base-files/root/setup.sh
cat > /tmp/appendtext.txt <<EOL
function init_theme() {
    if uci get luci.themes.Argon >/dev/null 2>&1; then
        uci set luci.main.mediaurlbase="/luci-static/argon"
        uci commit luci
    fi
}
EOL
sed -i -e '/boardname=/r /tmp/appendtext.txt' friendlywrt/target/linux/rockchip/armv8/base-files/root/setup.sh
# }}


#(cd friendlywrt && merge_feed helloworld "https://github.com/stupidloud/helloworld;tmp")
#(cd friendlywrt && merge_package https://github.com/xiaorouji/openwrt-passwall-packages openwrt-passwall-packages)
(cd friendlywrt && merge_feed PWpackages "https://github.com/xiaorouji/openwrt-passwall-packages")
#(cd friendlywrt && merge_package "-b main https://github.com/xiaorouji/openwrt-passwall" openwrt-passwall)
(cd friendlywrt && merge_feed PWluci "https://github.com/xiaorouji/openwrt-passwall;main")
#(cd friendlywrt && merge_feed lean_luci "https://github.com/coolsnowwolf/luci")

# (
#     cd friendlywrt && {
#         git clone --depth=1 --single-branch https://github.com/coolsnowwolf/packages.git lean_packages

#         merge_package2 lean_packages/net/vlmcsd
#         echo "CONFIG_PACKAGE_vlmcsd=y" >> ../configs/rockchip/01-nanopi

#         rm -rf lean_packages
#     }
# )

(
    cd friendlywrt && {
        git clone --depth=1 --single-branch https://github.com/coolsnowwolf/luci.git lean_luci

        # merge_package2 lean_luci/applications/luci-app-autoreboot
        # sed -i 's/include ..\/..\/luci.mk/include $(TOPDIR)\/feeds\/luci\/luci.mk/' package/custom/luci-app-autoreboot/Makefile
        # echo "CONFIG_PACKAGE_luci-app-autoreboot=y" >> ../configs/rockchip/01-nanopi

        merge_package2 lean_luci/applications/luci-app-serverchan
        sed -i 's/include ..\/..\/luci.mk/include $(TOPDIR)\/feeds\/luci\/luci.mk/' package/custom/luci-app-serverchan/Makefile
        echo "CONFIG_PACKAGE_luci-app-serverchan=y" >> ../configs/rockchip/01-nanopi

        # merge_package2 lean_luci/applications/luci-app-vlmcsd
        # sed -i 's/include ..\/..\/luci.mk/include $(TOPDIR)\/feeds\/luci\/luci.mk/' package/custom/luci-app-vlmcsd/Makefile
        # echo "CONFIG_PACKAGE_luci-app-vlmcsd=y" >> ../configs/rockchip/01-nanopi

        # use luci-app-cpufreq in friendlywrt
        # merge_package2 lean_luci/applications/luci-app-cpufreq
        # sed -i 's/include ..\/..\/luci.mk/include $(TOPDIR)\/feeds\/luci\/luci.mk/' package/custom/luci-app-cpufreq/Makefile
        # echo "CONFIG_PACKAGE_luci-app-cpufreq=y" >> ../configs/rockchip/01-nanopi

        # merge_package2 lean_luci/applications/luci-app-turboacc
        # sed -i 's/include ..\/..\/luci.mk/include $(TOPDIR)\/feeds\/luci\/luci.mk/' package/custom/luci-app-turboacc/Makefile
        # echo "CONFIG_PACKAGE_luci-app-turboacc=y" >> ../configs/rockchip/01-nanopi

        rm -rf lean_luci
    }
)

#git clone --depth=1 --single-branch https://github.com/chenmozhijin/turboacc -b package friendlywrt/patch/turboacc

(
    cd friendlywrt && {
        ./scripts/feeds update -a
        ./scripts/feeds install -a
    }
)
