# Step 4: System Configuration

set -e
set -x

echo $HOSTNAME > /mnt/etc/hostname
echo "127.0.0.1   $HOSTNAME" >> /etc/hosts

ip addr show

echo "Note the interfaces"
read -n 1 -r -s -p $'Press enter to continue...\n'

vi /mnt/etc/netplan/01-netcfg.yaml

echo 'deb http://archive.ubuntu.com/ubuntu focal main restricted universe multiverse' > /mnt/etc/apt/sources.list
echo 'deb http://archive.ubuntu.com/ubuntu focal-updates main restricted universe multiverse' >> /mnt/etc/apt/sources.list
echo 'deb http://archive.ubuntu.com/ubuntu focal-backports main restricted universe multiverse' >> /mnt/etc/apt/sources.list
echo 'deb http://security.ubuntu.com/ubuntu focal-security main restricted universe multiverse' >> /mnt/etc/apt/sources.list

mount --rbind /dev  /mnt/dev
mount --rbind /proc /mnt/proc
mount --rbind /sys  /mnt/sys
chroot /mnt /usr/bin/env DISK1=$DISK1 DISK2=$DISK2 UUID=$UUID bash --login
