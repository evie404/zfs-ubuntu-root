sudo usermod -p '*' root

set -e
set -x

echo "Remove: PermitRootLogin yes"
read -n 1 -r -s -p $'Press enter to continue...\n'
vi /etc/ssh/sshd_config

systemctl restart ssh
