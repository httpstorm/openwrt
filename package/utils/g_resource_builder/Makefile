#
# Copyright (C) 2019 gvalkov.com
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
# https://wiki.openwrt.org/doc/devel/packages
#

include $(TOPDIR)/rules.mk

PKG_NAME:=g_resource_builder
PKG_BIN:=$(PKG_NAME)
PKG_VERSION:=2021-10-01
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tgz
PKG_SOURCE_URL:=file:///home/g/g
PKG_HASH:=2c3daf2e61e4a01226c9e96392e76e5384afae9600d0416c0a6c6f04d378d1ef

PKG_MAINTAINER:=Georgi Valkov <gvalkov@abv.bg>
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
	TITLE:=resource builder for gvalkov.httpstorm
	URL:=https://httpstorm.com/tools/$(PKG_NAME)/
	DEPENDS:=+g_api
endef

define Package/$(PKG_NAME)/description
	resource builder for gvalkov.httpstorm
endef

define Build/Configure
endef

# -fno-exceptions: prevents undefined reference to _Unwind_Resume, __gxx_personality_v0
# test: -fno-rtti -fno-exceptions
TARGET_CPPFLAGS:= \
	$(TARGET_CPPFLAGS) -fno-exceptions \
	-D_GNU_SOURCE -DEMBEDDED=1 -DOPENWRT=1 -D__OPENWRT__=1

# -nodefaultlibs: prevents missing dependencies on libstdc++.so.6
# -lc: prevents undefined reference to printf and many others, when -nodefaultlibs is used
# test: -nodefaultlibs -lgcc -lc -uClibc++ -pthread
MAKE_FLAGS += \
	CFLAGS="$(TARGET_CPPFLAGS) $(TARGET_CFLAGS) -ffunction-sections -fdata-sections" \
	LDFLAGS="$(TARGET_LDFLAGS) -Wl,--gc-sections -nodefaultlibs -lc" \
	V=1

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/out/$(PKG_BIN) $(1)/usr/sbin/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
