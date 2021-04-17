# Step 7: Full Software Installation

set -e
set -x

apt dist-upgrade --yes

apt install --yes ubuntu-standard

# For desktop installation:

# apt install --yes ubuntu-desktop

# rm /etc/netplan/01-netcfg.yaml
# touch /etc/netplan/01-network-manager-all.yaml

# echo "network:" >> /etc/netplan/01-network-manager-all.yaml
# echo "  version: 2" >> /etc/netplan/01-network-manager-all.yaml
# echo "  renderer: NetworkManager" >> /etc/netplan/01-network-manager-all.yaml

for file in /etc/logrotate.d/*; do
	if grep -Eq "(^|[^#y])compress" "$file"; then
		sed -i -r "s/(^|[^#y])(compress)/\1#\2/" "$file"
	fi
done

reboot
