# Step 5: GRUB Installation

set -e
set -x

grub-probe /boot

update-initramfs -c -k all

echo "Disable memory zeroing:"
echo "- Add init_on_alloc=0 to: GRUB_CMDLINE_LINUX_DEFAULT"
echo "Make debugging GRUB easier:"
echo "- Comment out: GRUB_TIMEOUT_STYLE=hidden"
echo "- Set: GRUB_TIMEOUT=5"
echo "- Below GRUB_TIMEOUT, add: GRUB_RECORDFAIL_TIMEOUT=5"
echo "- Remove quiet and splash from: GRUB_CMDLINE_LINUX_DEFAULT"
echo "- Uncomment: GRUB_TERMINAL=console"
read -n 1 -r -s -p $'Press enter to continue...\n'

vi /etc/default/grub

update-grub

grub-install --target=x86_64-efi --efi-directory=/boot/efi \
    --bootloader-id=ubuntu --recheck --no-floppy

systemctl mask grub-initrd-fallback.service

mkdir /etc/zfs/zfs-list.cache
touch /etc/zfs/zfs-list.cache/bpool
touch /etc/zfs/zfs-list.cache/rpool
ln -s /usr/lib/zfs-linux/zed.d/history_event-zfs-list-cacher.sh /etc/zfs/zed.d
