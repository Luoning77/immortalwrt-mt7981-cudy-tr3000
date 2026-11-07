[定制教程](https://xiabee.eu.org/customize.html) | [刷写教程](https://xiabee.eu.org/install.html)

<div align=center>
<img src="tr3000.png" height=200px align="center">
</div>

---

## immortalwrt 源码

编译自 https://github.com/padavanonly/immortalwrt-mt798x-6.6 ，兼容 Cudy Tr3000 128M 新 flash

---

## 大分区 ubootmod 固件

本仓库仅编译 **128M-Ubootmod（128u）**，默认采用 **122M UBI 分区**。向 `build/no-clash-ua3f-128u` 推送会构建此机型。手动运行 ImmortalWrt Builder 时，请在分支选择器中选中该分支。

`diy-part2.sh` 会同步修改该机型的 UBI 长度为 `0x7a40000`、镜像容量上限为 `125184k`、设备名称为 `Cudy TR3000 v1 ubi 122M`，上游布局发生变化时终止处理。其他机型的分区不修改。

刷写前需确认 U-Boot 和设备分区支持该 122M 布局。修改仓库不会调整当前运行中的路由器分区，也不代表可直接保留旧配置升级。

### UA3F 独立部署支持

128u 配置预装 UA3F 所需的 NFQUEUE（iptables/nftables）、TC/BPF 内核模块、`tc-full` 和 `bpftool-minimal`，并将官方 ARM64 UA3F（含 LuCI）预装到只读固件。不集成 OpenClash、Mihomo 或其他 Clash 内核。

UA3F 版本和官方发布资产 SHA256 统一维护在 `package/proxy-versions.mk`。下载优先尝试镜像，失败回退官方来源；构建系统校验固定 SHA256。

预装程序不等于自动启用代理。刷入后按 UA3F 官方配置启用 TPROXY、GLOBAL 和兼容的 L3/eBPF 功能，再验收透明接管与实际 WAN 出口。

---

## DHCP uboot

编译自 https://github.com/weekdaycare/bl-mt798x-dhcpd 感谢大佬开源，兼容新 flash

![](/uboot.png)

128M uboot 为三分区 uboot 支持原厂 ubi 大小 64MB，扩容 ubi 分区 112MB，最大 ubi 分区 122MB

256M uboot 为单分区 uboot

---

## USB 供电控制

上游的最新源码已经打开了默认供电，具体可以见这条 [commit](https://github.com/padavanonly/immortalwrt-mt798x-6.6/commit/86356f8a2f796e5808fda25ce3e3bf6b3cc3278e)

若你想关闭 USB 供电执行命令

```bash
echo 0 > /sys/class/gpio/modem_power/value
```

恢复供电执行命令

```bash
echo 1 > /sys/class/gpio/modem_power/value
```

---

## 第三方软件包

- UA3F
- [Bandix](https://github.com/timsaya/luci-app-bandix)
- [luci-theme-aurora](https://github.com/eamonxg/luci-theme-aurora)
- [luci-app-aurora-config](https://github.com/eamonxg/luci-app-aurora-config)
- luci-app-ttyd
- luci-app-upnp
- kmod-usb-net-cdc-ether
- kmod-usb-net-rndis

---

## SSH 连接 Action

可以通过 ssh 连接到 Action 工作流来配置 `menuconfig` 。

手动运行 `ImmortalWrt Builder`，选择 `build/no-clash-ua3f-128u` 和 `128M-Ubootmod`，并勾选 SSH 选项。
工作流使用 Upterm 公共中继提供 SSH 会话，仅允许使用触发者 GitHub 账号上的 SSH 公钥连接。
在 `SSH connection to Menuconfig` 步骤的日志中找到 SSH 连接命令；连接后执行：

```sh
cd /workdir/openwrt
make menuconfig
# 保存并退出 menuconfig 后，通知工作流继续推送配置和编译：
touch "$GITHUB_WORKSPACE/continue"
```

SSH 步骤最多运行 15 分钟，请在超时前保存配置并创建 `continue` 文件；直接取消运行或超时会跳过配置推送。
如果不显示连接命令，可在 GitHub 的 Re-run jobs 中勾选 Enable debug logging，
检查 Upterm 启动日志及到 `uptermd.upterm.dev` 的连接情况。

---

## 编译注意事项

构建默认使用固定的 ImmortalWrt 源码提交和 `feeds.conf.default` 中锁定的软件源。`diy-part1.sh` 记录 Aurora 与 Bandix 的提交，`package/proxy-versions.mk` 记录固件和 UA3F 版本。

Actions 产物包含 128u 升级镜像、软件包清单、最终配置、镜像大小及 SHA-256。构建会检查 UA3F 依赖是否进入镜像，并排除 Clash、Mihomo 和已移除的软件包。实际剩余空间应在刷入匹配的 122M UBI 布局后查看。

---

## Credits

- [bl-mt798x-dhcpd](https://github.com/weekdaycare/bl-mt798x-dhcpd)
- [bl-mt798x](https://github.com/hanwckf/bl-mt798x)
- [immortalwrtwrt](https://github.com/padavanonly/immortalwrt-mt798x-6.6)
- [P3TERX](https://github.com/P3TERX)
- [Microsoft Azure](https://azure.microsoft.com)
- [GitHub Actions](https://github.com/features/actions)
- [OpenWrt](https://github.com/openwrt/openwrt)
- [coolsnowwolf/lede](https://github.com/coolsnowwolf/lede)
- [Mikubill/transfer](https://github.com/Mikubill/transfer)
- [softprops/action-gh-release](https://github.com/softprops/action-gh-release)
- [Mattraks/delete-workflow-runs](https://github.com/Mattraks/delete-workflow-runs)
- [dev-drprasad/delete-older-releases](https://github.com/dev-drprasad/delete-older-releases)
- [peter-evans/repository-dispatch](https://github.com/peter-evans/repository-dispatch)

---

## License

[MIT](https://github.com/P3TERX/Actions-OpenWrt/blob/main/LICENSE) © [**P3TERX**](https://p3terx.com)
