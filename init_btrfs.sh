#!/usr/bin/env bash
set -euo pipefail

# ── 颜色 ──────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
info()  { echo -e "${GREEN}[+]${NC} $*"; }
warn()  { echo -e "${YELLOW}[!]${NC} $*"; }
error() { echo -e "${RED}[✗]${NC} $*"; exit 1; }

# ── 检测硬盘 ──────────────────────────────────────────
echo ""
info "检测到以下硬盘："
echo ""
lsblk -d -o NAME,SIZE,MODEL,TRAN | grep -v "^loop\|^sr\|^fd"
echo ""

mapfile -t DISKS < <(lsblk -d -n -o NAME | grep -v "^loop\|^sr\|^fd\|^zram")
if [[ ${#DISKS[@]} -eq 0 ]]; then
    error "未检测到可用硬盘"
fi

PS3=$'\n请选择目标硬盘 (编号): '
select DISK_NAME in "${DISKS[@]}"; do
    [[ -n "$DISK_NAME" ]] && break
    warn "无效选择，请重试"
done

DISK="/dev/$DISK_NAME"
info "目标硬盘: $DISK"
echo ""
warn "!! 即将清空 $DISK 上的所有数据 !!"
read -rp "确认继续? (输入 yes): " CONFIRM
[[ "$CONFIRM" == "yes" ]] || error "已取消"

# ── 分区 ──────────────────────────────────────────────
info "分区中..."
wipefs -af "$DISK"
sgdisk -Z "$DISK"
sgdisk -n1:0:+2G   -t1:ef00 -c1:"ESP"   "$DISK"
sgdisk -n2:0:0     -t2:8300 -c2:"nixos" "$DISK"
partprobe "$DISK"
sleep 2

# 兼容 nvme (p1/p2) 和 sda (1/2)
if [[ "$DISK" == *nvme* || "$DISK" == *mmcblk* ]]; then
    PART1="${DISK}p1"
    PART2="${DISK}p2"
else
    PART1="${DISK}1"
    PART2="${DISK}2"
fi

# ── 格式化 ────────────────────────────────────────────
info "格式化 $PART1 → FAT32 (boot)"
mkfs.fat -F32 -n "ESP" "$PART1"

info "格式化 $PART2 → btrfs"
mkfs.btrfs -f -L "nixos" "$PART2"

# ── 创建子卷 ──────────────────────────────────────────
info "创建 btrfs 子卷..."
mount "$PART2" /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@nix
btrfs subvolume create /mnt/@log
btrfs subvolume create /mnt/@snapshots
umount /mnt

# ── 挂载 ──────────────────────────────────────────────
info "挂载子卷..."
OPTS="noatime,compress=zstd,ssd,space_cache=v2"

mount -o "${OPTS},subvol=@"          "$PART2" /mnt
mkdir -p /mnt/{home,nix,boot,var/log,.snapshots}
mount -o "${OPTS},subvol=@home"      "$PART2" /mnt/home
mount -o "${OPTS},subvol=@nix"       "$PART2" /mnt/nix
mount -o "${OPTS},subvol=@log"       "$PART2" /mnt/var/log
mount -o "${OPTS},subvol=@snapshots" "$PART2" /mnt/.snapshots
mount "$PART1" /mnt/boot

# ── 验证挂载 ──────────────────────────────────────────
info "挂载结果:"
findmnt --target /mnt -R -o TARGET,SOURCE,FSTYPE,OPTIONS | head -20
echo ""

# ── 生成配置 ──────────────────────────────────────────
info "生成 NixOS 配置..."
nixos-generate-config --root /mnt

info "完成！后续步骤："
echo ""
echo "  # 用你的 GitHub 配置覆盖（替换为你的仓库地址）："
echo "  nix-shell -p git"
echo "  git clone https://github.com/YOUR/nixconfig /mnt/etc/nixos"
echo ""
echo "  # 或只覆盖 configuration.nix："
echo "  cp /path/to/your/config /mnt/etc/nixos/configuration.nix"
echo ""
echo "  # 然后安装："
echo "  nixos-install"
echo ""