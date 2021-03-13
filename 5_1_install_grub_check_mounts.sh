# Step 5: GRUB Installation - Check mounts

set -e
set -x

zed -F &

zfs set canmount=on bpool/BOOT/ubuntu_$UUID
zfs set canmount=on rpool/ROOT/ubuntu_$UUID

[ -s /etc/zfs/zfs-list.cache/bpool ] || echo "/etc/zfs/zfs-list.cache/bpool is empty" && exit 1
[ -s /etc/zfs/zfs-list.cache/rpool ] || echo "/etc/zfs/zfs-list.cache/rpool is empty" && exit 1

killall zed

sed -Ei "s|/mnt/?|/|" /etc/zfs/zfs-list.cache/*
