#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

set -euo pipefail

# Install the local package definitions before scanning feeds.
cp -R "$GITHUB_WORKSPACE/package/." package/

fetch_package() {
  local name="$1" repo="$2" commit="$3"
  local dest="package/$name"
  git init -q "$dest"
  git -C "$dest" fetch --depth=1 "$repo" "$commit"
  git -C "$dest" checkout --detach "$commit"
}

fetch_package luci-theme-aurora https://github.com/eamonxg/luci-theme-aurora.git 298dbcc74ddf820923a51285fb0826d429e5d7ca
fetch_package luci-app-aurora-config https://github.com/eamonxg/luci-app-aurora-config.git a5299ce0144859f47683ec3bc40805bf616f534f
fetch_package luci-app-bandix https://github.com/timsaya/luci-app-bandix.git 108369b8da05f01296a3ed0210a2ab60809712e5
fetch_package openwrt-bandix https://github.com/timsaya/openwrt-bandix.git 0760d1f5b52d1a2317dfd171ab00fe6543a9a0c4
