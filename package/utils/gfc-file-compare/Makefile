#
# Copyright (C) 2026 httpstorm.com
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
# https://wiki.openwrt.org/doc/devel/packages
#

include $(TOPDIR)/rules.mk

PKG_NAME:=gfc-file-compare
PKG_BIN:=gfc
PKG_VERSION:=$(shell date +"%Y.%m.%d")
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tgz
PKG_SOURCE_URL:=ile://~/g
PKG_HASH:=2c3daf2e61e4a01226c9e96392e76e5384afae9600d0416c0a6c6f04d378d1ef

PKG_MAINTAINER:=Georgi Valkov <gvalkov@gmail.com>
PKG_LICENSE:=GPL-2.0

ifeq (,$(findstring apple,$(shell $(COMPILE.cpp) --version)))
	# Linux
	USE_SOURCE_DIR:=~/g/projects/$(PKG_NAME)
else
	# macOS
	USE_SOURCE_DIR:=~/Documents/vs-projects/projects/$(PKG_NAME)
endif

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=utils
	CATEGORY:=Utilities
	TITLE:=file compare and hash utility
	URL:=https://httpstorm.com/tools/$(PKG_NAME)/
	DEPENDS:=+g_api
endef

define Package/$(PKG_NAME)/description
	file compare and hash utility
endef

define Build/Configure
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/out/$(PKG_BIN) $(1)/usr/sbin/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
