#
# Copyright (C) 2006-2017 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

LUCI_TITLE:=LuCI support for eqos.
LUCI_DESCRIPTION:=LuCI support for Easy QoS(Support speed limit based on IP address).
LUCI_DEPENDS:=+luci-base +tc +kmod-sched-core +kmod-ifb
LUCI_PKGARCH:=all

PKG_NAME:=luci-app-eqos-compat
PKG_VERSION:=1.0.0
PKG_RELEASE:=3

PKG_MAINTAINER:=Jianhui Zhao <jianhuizhao329@gmail.com>

define Package/luci-app-eqos-compat/conffiles
/etc/config/eqos
endef

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature

