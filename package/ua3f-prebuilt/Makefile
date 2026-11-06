include $(TOPDIR)/rules.mk
include $(TOPDIR)/package/proxy-versions.mk

PKG_NAME:=ua3f-prebuilt
PKG_VERSION:=$(UA3F_VERSION)
PKG_RELEASE:=1
PKG_SOURCE:=ua3f_$(PKG_VERSION)-r1_aarch64_cortex-a53.ipk
PKG_SOURCE_URL:=https://ghfast.top/https://github.com/SunBK201/UA3F/releases/download/v$(PKG_VERSION)/ \
 https://github.com/SunBK201/UA3F/releases/download/v$(PKG_VERSION)/
PKG_HASH:=$(UA3F_HASH)
PKG_LICENSE:=GPL-3.0-only

include $(INCLUDE_DIR)/package.mk

define Package/ua3f
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Web Servers/Proxies
  TITLE:=UA3F (official ARM64 binary and LuCI)
  URL:=https://github.com/SunBK201/UA3F
  DEPENDS:=@aarch64 +libc +luci-compat +ipset +iptables +iptables-mod-tproxy +iptables-mod-extra +iptables-mod-ipopt +iptables-mod-nfqueue +iptables-mod-conntrack-extra +kmod-nf-conntrack-netlink +kmod-nft-queue +kmod-nft-tproxy
endef

define Build/Prepare
	$(INSTALL_DIR) $(PKG_BUILD_DIR)/rootfs
	tar -xzOf $(DL_DIR)/$(PKG_SOURCE) ./data.tar.gz > $(PKG_BUILD_DIR)/data.tar.gz
	tar -xzf $(PKG_BUILD_DIR)/data.tar.gz -C $(PKG_BUILD_DIR)/rootfs
endef

define Build/Compile
endef

define Package/ua3f/conffiles
/etc/config/ua3f
endef

define Package/ua3f/install
	$(CP) $(PKG_BUILD_DIR)/rootfs/. $(1)/
endef

$(eval $(call BuildPackage,ua3f))
