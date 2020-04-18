#!/bin/bash 

# Compile only k3
sed -i 's|^TARGET_|# TARGET_|g; s|# TARGET_DEVICES += phicomm-k3|TARGET_DEVICES += phicomm-k3|' target/linux/bcm53xx/image/Makefile
sed -i '/<div class="tr"><div class="td left" width="33%"><%:Kernel Version%></div><div class="td left"><%=unameinfo.release or "?"%></div></div>/a <div class="tr"><div class="td left" width="33%"><%:CPU Temperature%></div><div class="td left"><%=luci.sys.exec("cut -c1-2 /sys/class/thermal/thermal_zone0/temp")%></div></div>' feeds/luci/modules/luci-mod-admin-full/luasrc/view/admin_status/index.htm
# 移除不用软件包
rm -rf k3screenctrl package/lean
# 添加额外软件包
git clone https://github.com/lwz322/luci-app-k3screenctrl.git package/k3/luci-app-k3screenctrl
git clone https://github.com/lwz322/k3screenctrl.git package/k3/k3screenctrl
git clone https://github.com/lwz322/k3screenctrl_build.git package/k3/k3screenctrl_build
