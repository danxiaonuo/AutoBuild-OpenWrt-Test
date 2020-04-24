# 修改root密码
password=$(openssl passwd -1 'admin')
sed -i "s|root::0:0:99999:7:::|root:$password:0:0:99999:7:::|g" package/base-files/files/etc/shadow
# 删除一些配置
sed -i '/shadow/d' package/lean/default-settings/files/zzz-default-settings
# 修改默认登陆IP地址
sed -i 's/192.168.1.1/10.8.1.1/g' package/base-files/files/bin/config_generate
sed -i 's/192.168/10.8/g' package/base-files/files/bin/config_generate
# 设置主机名称
sed -i 's/OpenWrt/danxiaonuo/g' package/base-files/files/bin/config_generate
sed -i '/uci commit system/i\uci set system.@system[0].hostname='danxiaonuo'' package/lean/default-settings/files/zzz-default-settings
# 设置时区
sed -i 's/UTC/CST-8/g' package/base-files/files/bin/config_generate
# 增加IPV6
sed -i '/exit 0/i\# 增加IPV6\nuci set network.globals.ula_prefix="ddaa:6666:8888::/48"\nuci commit network' package/lean/default-settings/files/zzz-default-settings
curl -fsSL https://raw.githubusercontent.com/danxiaonuo/AutoBuild-OpenWrt/master/99-ipv6 > package/base-files/files/etc/hotplug.d/99-ipv6
sed -i '/exit 0/i\mv /etc/hotplug.d/99-ipv6 /etc/hotplug.d/iface/99-ipv6' package/lean/default-settings/files/zzz-default-settings
sed -i '/99-ipv6/a\chmod u+x /etc/hotplug.d/iface/99-ipv6' package/lean/default-settings/files/zzz-default-settings
sed -i '/exit 0/i\sed -i "s/option ip6assign ".*"/option ip6assign "64"/g" /etc/config/network' package/lean/default-settings/files/zzz-default-settings
# 增加IPV6防火墙
sed -i '/uci commit network/a\# IPV6防火墙\necho "ip6tables -t nat -I POSTROUTING -s $(uci get network.globals.ula_prefix) -j MASQUERADE" >> /etc/firewall.user' package/lean/default-settings/files/zzz-default-settings
# 重启WIFI
sed -i '/exit 0/i\# 启动WIFI\nnohup sleep 60 && /sbin/wifi up &' package/base-files/files/etc/rc.local
# 增加 SSID 2.5G
sed -i '/channel="11"/a\\t\tssid="danxiaonuo-2HZ"' package/kernel/mac80211/files/lib/wifi/mac80211.sh
# 增加 SSID 5.0G
sed -i '/channel="36"/a\\t\t\tssid="danxiaonuo-5HZ"' package/kernel/mac80211/files/lib/wifi/mac80211.sh
# 修改默认 SSID
sed -i 's/OpenWrt/${ssid}/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
# 修改默认密钥
sed -i 's/none/sae-mixed/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
# 增加默认WIFI密码
sed -i '/set wireless.radio${devidx}.hwmode=11/a\\t\t\tset wireless.radio${devidx}.country=CN\n\t\t\tset wireless.radio${devidx}.legacy_rates=1\n\t\t\tset wireless.radio${devidx}.mu_beamformer=1' package/kernel/mac80211/files/lib/wifi/mac80211.sh
sed -i '/set wireless.default_radio${devidx}.encryption=sae-mixed/a\\t\t\tset wireless.default_radio${devidx}.key=password\n\t\t\tset wireless.default_radio${devidx}.ieee80211k=1' package/kernel/mac80211/files/lib/wifi/mac80211.sh
# 芝麻开门
sed -i '/exit 0/i\# 芝麻开门\necho 0xDEADBEEF > /etc/config/google_fu_mode' package/lean/default-settings/files/zzz-default-settings
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

# DiskMan for LuCI (WIP)
# git clone https://github.com/lisaac/luci-app-diskman.git package/mine/luci-app-diskman
# mkdir -p package/mine/parted && cp -i package/mine/luci-app-diskman/Parted.Makefile package/mine/parted/Makefile

# KPR plus+
# git clone https://github.com/project-openwrt/luci-app-koolproxyR.git package/mine/luci-app-koolproxyR

# Server酱
#git clone https://github.com/tty228/luci-app-serverchan.git package/mine/luci-app-serverchan

# FileBrowser
# git clone https://github.com/project-openwrt/FileBrowser.git package/mine/FileBrowser

# 网易云音乐
# git clone https://github.com/project-openwrt/luci-app-unblockneteasemusic.git package/mine/luci-app-unblockneteasemusic

# OpenClash
#git clone https://github.com/vernesong/OpenClash.git package/mine/OpenClash

# 网易云音乐GoLang版本
# git clone https://github.com/project-openwrt/luci-app-unblockneteasemusic-go.git package/mine/luci-app-unblockneteasemusic-go

# 网易云音乐mini
# git clone https://github.com/project-openwrt/luci-app-unblockneteasemusic-mini.git package/mine/luci-app-unblockneteasemusic-mini

# disable usb3.0
# git clone https://github.com/rufengsuixing/luci-app-usb3disable.git package/mine/luci-app-usb3disable

# 管控上网行为
# git clone https://github.com/destan19/OpenAppFilter.git package/mine/OpenAppFilter

# Rclone-OpenWrt
# git clone https://github.com/ElonH/Rclone-OpenWrt.git package/mine/Rclone-OpenWrt
