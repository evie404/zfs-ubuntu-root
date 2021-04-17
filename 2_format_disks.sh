# Step 2: Disk Formatting

set -e
set -x

sgdisk --zap-all $DISK1
sgdisk --zap-all $DISK2

# efi
sgdisk -n1:1M:+512M -t1:EF00 $DISK1
sgdisk -n1:1M:+512M -t1:EF00 $DISK2

# swap
sgdisk -n2:0:+500M -t2:FD00 $DISK1
sgdisk -n2:0:+500M -t2:FD00 $DISK2

# bpool
sgdisk -n3:0:+2G -t3:BE00 $DISK1
sgdisk -n3:0:+2G -t3:BE00 $DISK2

# rpool
sgdisk -n4:0:+140G -t4:BF00 $DISK1
sgdisk -n4:0:+140G -t4:BF00 $DISK2

# log
sgdisk -n5:0:+4G -t5:BF01 $DISK1
sgdisk -n5:0:+4G -t5:BF01 $DISK2

zpool create \
	-o cachefile=/etc/zfs/zpool.cache \
	-o ashift=12 -o autotrim=on -d \
	-o feature@async_destroy=enabled \
	-o feature@bookmarks=enabled \
	-o feature@embedded_data=enabled \
	-o feature@empty_bpobj=enabled \
	-o feature@enabled_txg=enabled \
	-o feature@extensible_dataset=enabled \
	-o feature@filesystem_limits=enabled \
	-o feature@hole_birth=enabled \
	-o feature@large_blocks=enabled \
	-o feature@lz4_compress=enabled \
	-o feature@spacemap_histogram=enabled \
	-O acltype=posixacl -O canmount=off -O compression=lz4 \
	-O devices=off -O normalization=formD -O relatime=on -O xattr=sa \
	-O mountpoint=/boot -R /mnt \
	bpool mirror \
	$DISK1-part3 \
	$DISK2-part3

zpool create \
	-o ashift=12 -o autotrim=on \
	-O acltype=posixacl -O canmount=off -O compression=lz4 \
	-O dnodesize=auto -O normalization=formD -O relatime=on \
	-O xattr=sa -O mountpoint=/ -R /mnt \
	rpool mirror \
	$DISK1-part4 \
	$DISK2-part4
