#
# Copyright (C) 2024 Foster Snowhill
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
# https://wiki.openwrt.org/doc/devel/packages
#

include $(TOPDIR)/rules.mk

PKG_NAME:=fruit-usb-status
PKG_BIN:=$(PKG_NAME)
PKG_VERSION:=$(shell date +"%Y-%m-%d")
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tgz
PKG_MAINTAINER:=Foster Snowhill <forst@pen.gy>
PKG_LICENSE:=GPL-2.0

ifeq (,$(findstring apple,$(shell $(COMPILE.cpp) --version)))
# Linux
	USE_SOURCE_DIR:=$(TOPDIR)/../$(PKG_NAME)
else
# macOS
	USE_SOURCE_DIR:=$(TOPDIR)/../$(PKG_NAME)
endif

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=utils
	CATEGORY:=Utilities
	TITLE:=Fruit USB status
	URL:=https://github.com/Forst/$(PKG_NAME)/
	DEPENDS:=+libusb-1.0
endef

define Package/$(PKG_NAME)/description
	So what I'm looking for is essentially this:
	For iPhone 3G and 4s
	1. Connect iPhone to a Linux machine with running usbmuxd mode 1
	2. Enable internet sharing on the phone
	3. Make sure pings to the iPhone go through
	4. Run the tool and save its output
	5. Disable internet sharing on the phone
	6. Run the tool again and save its output
	I'd like to see how the control register values change depending
	on whether internet sharing is turned on or off
endef

define Build/Configure
endef

TARGET_CFLAGS:= \
	$(TARGET_CFLAGS) -fno-exceptions \
	-D_GNU_SOURCE -DEMBEDDED=1 -DOPENWRT=1 -D__OPENWRT__=1

MAKE_FLAGS += \
	CFLAGS="$(TARGET_CFLAGS) -ffunction-sections -fdata-sections" \
	LDFLAGS="$(TARGET_LDFLAGS) -Wl,--gc-sections -nodefaultlibs -lc" \
	V=1

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/$(PKG_BIN) $(1)/usr/sbin/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
