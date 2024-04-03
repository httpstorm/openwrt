#
# Copyright (C) 2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk

PKG_NAME:=coreutils
PKG_CPE_ID:=cpe:/a:gnu:coreutils
PKG_VERSION:=9.5

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.xz
PKG_SOURCE_URL:=@GNU/coreutils
PKG_HASH:=cd328edeac92f6a665de9f323c93b712af1858bc2e0d88f3f7100469470a1b8a

HOST_BUILD_PARALLEL := 1

PKG_PROGRAMS:=date readlink touch ln chown ginstall

include $(INCLUDE_DIR)/host-build.mk

export GNULIB_SRCDIR:=$(HOST_GNULIB_SRCDIR)

HOST_CONFIGURE_ARGS += \
	 --enable-install-program=$(subst $(space),$(comma),$(strip $(PKG_PROGRAMS)))

HOST_MAKE_FLAGS += \
	$(AM_TOOL_PATHS_FAKE) \
	PROGRAMS="$(patsubst %,src/%,$(PKG_PROGRAMS))" \
	LIBRARIES= MANS= SUBDIRS=.

define Host/Install
	$(INSTALL_DIR) $(1)/bin
	$(INSTALL_BIN) $(patsubst %,$(HOST_BUILD_DIR)/src/%,$(PKG_PROGRAMS)) $(1)/bin/
	ln -sf ginstall $(1)/bin/install
endef

define Host/Uninstall
	rm -f $(STAGING_DIR_HOST)/bin/install
	-$(call Host/Compile/Default,uninstall)
endef

$(eval $(call HostBuild))
