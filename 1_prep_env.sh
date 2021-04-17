# Step 1: Prepare The Install Environment

set -e
set -x

sudo apt update

passwd

# There is no current password.
sudo apt install --yes openssh-server vim

gsettings set org.gnome.desktop.media-handling automount false

sudo apt install --yes debootstrap gdisk zfs-initramfs

sudo systemctl stop zed

sudo -i
