# Step 4: System Configuration - In chroot

set -e
set -x

apt update
dpkg-reconfigure locales tzdata keyboard-configuration console-setup

apt install --yes vim

apt install --yes dosfstools

mkdosfs -F 32 -s 1 -n EFI ${DISK1}-part1
mkdosfs -F 32 -s 1 -n EFI ${DISK2}-part1
mkdir /boot/efi
echo /dev/disk/by-uuid/$(blkid -s UUID -o value ${DISK1}-part1) \
	/boot/efi vfat defaults 0 0 >>/etc/fstab
mount /boot/efi

mkdir /boot/efi/grub /boot/grub
echo /boot/efi/grub /boot/grub none defaults,bind 0 0 >>/etc/fstab
mount /boot/grub

apt install --yes grub-pc linux-image-generic zfs-initramfs zsys
apt install --yes \
	grub-efi-amd64 grub-efi-amd64-signed linux-image-generic \
	shim-signed zfs-initramfs zsys

apt remove --purge os-prober

passwd

apt install --yes mdadm

# Adjust the level (ZFS raidz = MD raid5, raidz2 = raid6) and
# raid-devices if necessary and specify the actual devices.
mdadm --create /dev/md0 --metadata=1.2 --level=mirror \
	--raid-devices=2 ${DISK1}-part2 ${DISK2}-part2
mkswap -f /dev/md0
echo /dev/disk/by-uuid/$(blkid -s UUID -o value /dev/md0) \
	none swap discard 0 0 >>/etc/fstab

cp /usr/share/systemd/tmp.mount /etc/systemd/system/
systemctl enable tmp.mount

addgroup --system lpadmin
addgroup --system lxd
addgroup --system sambashare
