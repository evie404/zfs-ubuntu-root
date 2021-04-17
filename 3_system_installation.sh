# Step 3: System Installation

set -e
set -x

zfs create -o canmount=off -o mountpoint=none rpool/ROOT
zfs create -o canmount=off -o mountpoint=none bpool/BOOT

export UUID=$(dd if=/dev/urandom bs=1 count=100 2>/dev/null |
	tr -dc 'a-z0-9' | cut -c-6)

zfs create -o mountpoint=/ \
	-o com.ubuntu.zsys:bootfs=yes \
	-o com.ubuntu.zsys:last-used=$(date +%s) rpool/ROOT/ubuntu_$UUID

zfs create -o mountpoint=/boot bpool/BOOT/ubuntu_$UUID

zfs create -o com.ubuntu.zsys:bootfs=no \
	rpool/ROOT/ubuntu_$UUID/srv
zfs create -o com.ubuntu.zsys:bootfs=no -o canmount=off \
	rpool/ROOT/ubuntu_$UUID/usr
zfs create rpool/ROOT/ubuntu_$UUID/usr/local
zfs create -o com.ubuntu.zsys:bootfs=no -o canmount=off \
	rpool/ROOT/ubuntu_$UUID/var
zfs create rpool/ROOT/ubuntu_$UUID/var/games
zfs create rpool/ROOT/ubuntu_$UUID/var/lib
zfs create rpool/ROOT/ubuntu_$UUID/var/lib/AccountsService
zfs create rpool/ROOT/ubuntu_$UUID/var/lib/apt
zfs create rpool/ROOT/ubuntu_$UUID/var/lib/dpkg
zfs create rpool/ROOT/ubuntu_$UUID/var/lib/NetworkManager
zfs create rpool/ROOT/ubuntu_$UUID/var/log
zfs create rpool/ROOT/ubuntu_$UUID/var/mail
zfs create rpool/ROOT/ubuntu_$UUID/var/snap
zfs create rpool/ROOT/ubuntu_$UUID/var/spool
zfs create rpool/ROOT/ubuntu_$UUID/var/www

zfs create -o canmount=off -o mountpoint=/ \
	rpool/USERDATA
zfs create -o com.ubuntu.zsys:bootfs-datasets=rpool/ROOT/ubuntu_$UUID \
	-o canmount=on -o mountpoint=/root \
	rpool/USERDATA/root_$UUID
chmod 700 /mnt/root

zfs create -o com.ubuntu.zsys:bootfs=no bpool/grub

mkdir /mnt/run
mount -t tmpfs tmpfs /mnt/run
mkdir /mnt/run/lock

debootstrap focal /mnt

mkdir /mnt/etc/zfs
cp /etc/zfs/zpool.cache /mnt/etc/zfs/
