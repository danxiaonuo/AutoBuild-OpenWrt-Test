# 修改root密码
password=$(openssl passwd -1 'admin')
sed -i "s|root::0:0:99999:7:::|root:$password:0:0:99999:7:::|g" package/base-files/files/etc/shadow
# 修改默认登陆IP地址
sed -i 's/192.168.1.1/10.8.1.1/g' package/base-files/files/bin/config_generate
# 修改系统欢迎词
curl -fsSL https://raw.githubusercontent.com/danxiaonuo/AutoBuild-OpenWrt/master/banner > package/base-files/files/etc/banner
# 修改系统内核参数
curl -fsSL https://raw.githubusercontent.com/danxiaonuo/AutoBuild-OpenWrt/master/sysctl.conf > package/base-files/files/etc/sysctl.conf

#add lienol feed: such like passwall
echo "Adding lienol packages feed"
echo "src-git lienol https://github.com/chenshuo890/lienol-openwrt-package.git" >> feeds.conf.default

# 增加openwet常用软件包
#git clone https://github.com/kenzok8/openwrt-packages.git package/mine/

# 更改默认主题为Argon
rm -rf package/lean/luci-theme-argon
sed -i '/uci commit luci/i\uci set luci.main.mediaurlbase="/luci-static/argon"' package/lean/default-settings/files/zzz-default-settings
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/lean/luci-theme-argon

# smartdns
git clone https://github.com/ujincn/smartdns.git package/mine/smartdns
git clone https://github.com/ujincn/luci-app-smartdns-compat.git package/mine/luci-app-smartdns-compat
#git clone https://github.com/pymumu/openwrt-smartdns.git package/mine/smartdns
#git clone --branch lede https://github.com/pymumu/luci-app-smartdns.git package/mine/luci-app-smartdns
#svn co https://github.com/kenzok8/openwrt-packages/tree/master/luci-app-smartdns package/mine/luci-app-smartdns

# 复杂的AdGuardHome的openwrt的luci界面
git clone https://github.com/rufengsuixing/luci-app-adguardhome.git package/mine/luci-app-adguardhome

# Compile only k3
sed -i 's|^TARGET_|# TARGET_|g; s|# TARGET_DEVICES += phicomm-k3|TARGET_DEVICES += phicomm-k3|' target/linux/bcm53xx/image/Makefile
sed -i '/<div class="tr"><div class="td left" width="33%"><%:Kernel Version%></div><div class="td left"><%=unameinfo.release or "?"%></div></div>/a <div class="tr"><div class="td left" width="33%"><%:CPU Temperature%></div><div class="td left"><%=luci.sys.exec("cut -c1-2 /sys/class/thermal/thermal_zone0/temp")%></div></div>' feeds/luci/modules/luci-mod-admin-full/luasrc/view/admin_status/index.htm

# 添加额外软件包
# k3
git clone https://github.com/lwz322/luci-app-k3screenctrl.git package/k3/luci-app-k3screenctrl
git clone https://github.com/lwz322/k3screenctrl.git package/k3/k3screenctrl
git clone https://github.com/lwz322/k3screenctrl_build.git package/k3/k3screenctrl_build

# delete k3screenctrl
rm -rf package/lean/k3screenctrl
