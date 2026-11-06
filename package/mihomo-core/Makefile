include $(TOPDIR)/rules.mk
include $(TOPDIR)/package/proxy-versions.mk

PKG_NAME:=mihomo-core
PKG_VERSION:=$(MIHOMO_VERSION)
PKG_RELEASE:=1
PKG_SOURCE:=mihomo-linux-arm64-v$(PKG_VERSION).gz
PKG_SOURCE_URL:=https://ghfast.top/https://github.com/MetaCubeX/mihomo/releases/download/v$(PKG_VERSION)/ \
 https://github.com/MetaCubeX/mihomo/releases/download/v$(PKG_VERSION)/
PKG_HASH:=$(MIHOMO_HASH)
PKG_LICENSE:=GPL-3.0-only

include $(INCLUDE_DIR)/package.mk

define Package/mihomo-core
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Web Servers/Proxies
  TITLE:=Mihomo core for OpenClash (official ARM64 binary)
  URL:=https://github.com/MetaCubeX/mihomo
  DEPENDS:=@aarch64 +kmod-tun
endef

define Build/Prepare
	$(INSTALL_DIR) $(PKG_BUILD_DIR)
	gzip -dc $(DL_DIR)/$(PKG_SOURCE) > $(PKG_BUILD_DIR)/clash_meta
endef

define Build/Compile
endef

define Package/mihomo-core/install
	$(INSTALL_DIR) $(1)/etc/openclash/core
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/clash_meta $(1)/etc/openclash/core/clash_meta
endef

$(eval $(call BuildPackage,mihomo-core))
