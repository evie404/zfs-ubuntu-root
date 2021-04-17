# Step 6: First Boot - After reboot

set -e
set -x

echo "Install GRUB to additional disks:"
echo "Select (using the space bar) all of the ESP partitions (partition 1 on each of the pool disks)."

dpkg-reconfigure grub-efi-amd64

UUID=$(dd if=/dev/urandom bs=1 count=100 2>/dev/null |
	tr -dc 'a-z0-9' | cut -c-6)
ROOT_DS=$(zfs list -o name | awk '/ROOT\/ubuntu_/{print $1;exit}')
zfs create -o com.ubuntu.zsys:bootfs-datasets=$ROOT_DS \
	-o canmount=on -o mountpoint=/home/$USERNAME \
	rpool/USERDATA/$USERNAME_$UUID
adduser $USERNAME

cp -a /etc/skel/. /home/$USERNAME
chown -R $USERNAME:$USERNAME /home/$USERNAME
usermod -a -G adm,cdrom,dip,lpadmin,lxd,plugdev,sambashare,sudo $USERNAME
