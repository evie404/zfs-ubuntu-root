# Step 6: First Boot

set -e
set -x

apt install --yes openssh-server

echo "Set: PermitRootLogin yes"
read -n 1 -r -s -p $'Press enter to continue...\n'
vi /etc/ssh/sshd_config

exit

mount | grep -v zfs | tac | awk '/\/mnt/ {print $3}' |
	xargs -i{} umount -lf {}
zpool export -a

reboot
