#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

# Modify default theme
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate

# Keep the custom version separate from upstream's package-feed version.
FIRMWARE_VERSION=$(sed -n 's/^FIRMWARE_VERSION:=//p' package/proxy-versions.mk)
[[ "$FIRMWARE_VERSION" =~ ^[0-9]{2}\.[0-9]+\.[0-9]+$ ]] || exit 1
mkdir -p files/etc
printf '%s\n' "$FIRMWARE_VERSION" > files/etc/firmware-build-version

# add date and firmware version in output file name
sed -i -e '/^IMG_PREFIX:=/i BUILD_DATE := $(shell date +%Y%m%d)' \
       -e '/^IMG_PREFIX:=/i BUILD_CUSTOM_VERSION := $(shell cat files/etc/firmware-build-version)' \
       -e '/^IMG_PREFIX:=/ s/\($(SUBTARGET)\)/\1-$(BUILD_DATE)-$(BUILD_CUSTOM_VERSION)/' include/image.mk

# Expand only the 128M Ubootmod layout. Abort if upstream changes its layout.
python3 - <<'PY'
from pathlib import Path
import re

dts = Path("target/linux/mediatek/dts/mt7981b-cudy-tr3000-v1-ubootmod.dts")
image = Path("target/linux/mediatek/image/filogic.mk")
text = dts.read_text()
pattern = r"(reg\s*=\s*<0x5c0000\s+)0x(?:7000000|7a40000)(>;)"
text, count = re.subn(pattern, r"\g<1>0x7a40000\2", text)
if count != 1:
    raise SystemExit("Unexpected Cudy Ubootmod UBI layout; refusing to patch")
text, count = re.subn(r'Cudy TR3000 v1 ubi (?:112|122)M', 'Cudy TR3000 v1 ubi 122M', text)
if count != 1:
    raise SystemExit("Unexpected Cudy Ubootmod model name")

image_text = image.read_text()
pattern = r"(?ms)(^define Device/cudy_tr3000-v1-ubootmod\n)(.*?)(^endef$)"
def expand(match):
    body, count = re.subn(r"IMAGE_SIZE := (?:114688|125184)k", "IMAGE_SIZE := 125184k", match[2])
    if count != 1:
        raise SystemExit("Unexpected Cudy Ubootmod image limit")
    return match[1] + body + match[3]
image_text, count = re.subn(pattern, expand, image_text)
if count != 1:
    raise SystemExit("Cudy Ubootmod image definition missing or ambiguous")
# Both checks passed before either file is written.
dts.write_text(text)
image.write_text(image_text)
PY
