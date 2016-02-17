#!/bin/sh
set -x
printenv > /tmp/printenv

disk=$1
if [ -z $disk ];then
	disk=/dev/mmcblk1
	echo "use /dev/mmcblk1"
fi

cat << EOM
##################################################
create 2 partion
##################################################
EOM
if [ -f /dev/mmcblk1p1 ]; then

umount /dev/mmcblk1p1
umount /dev/mmcblk1p2

fi

sleep 1

fdisk $disk <<EOF
d
1
d
2
w
EOF

fdisk $disk << EOF
n
p
1
2048
216863
t
b
a
1
w
EOF

fdisk $disk << EOF
n
p
2
216864
3751935
t
2
83
w
EOF

sleep 1
umount /dev/mmcblk1p1
sleep 1
umount /dev/mmcblk1p2
sleep 1




cat << EOM
#####################################################
	ge shi hua boot partion
#####################################################
EOM
mkdosfs  -F 32 /dev/mmcblk1p1



cat << EOM
######################################################
	ge shi hua rootfs partion
######################################################
EOM
mkfs.ext3 /dev/mmcblk1p2 


cat << EOM
######################################################
mount /dev/mmcblk1p1 to /media/mmcblk1p1
######################################################
EOM
mkdir -p /media/mmcblk1p1

mount  /dev/mmcblk1p1 /media/mmcblk1p1
cat << EOM
#######################################################
mount /dev/mmcblk1p2 to /media/mmcblk1p2
#######################################################
EOM
mkdir -p /media/mmcblk1p2
mount /dev/mmcblk1p2 /media/mmcblk1p2


cat << EOM
#######################################################
cd /media/mmcb0k0p1   CARD 1 partion
#######################################################
EOM
cd /media/mmcblk0p1


cat << EOM
#######################################################
cp /media/mmcblk0p1/MLO /media/mmcblk1p1
#######################################################
EOM
cp /media/mmcblk0p1/MLO /media/mmcblk1p1

cat << EOM
#######################################################
cp /media/mmcblk0p1/u-boot.img /media/mmcblk1p1
#######################################################
EOM
cp /media/mmcblk0p1/u-boot.img /media/mmcblk1p1

cat << EOM
#######################################################
cp /media/mmcblk0p1/uImage /media/mmcblk1p1
#######################################################
EOM
cp /media/mmcblk0p1/uImage /media/mmcblk1p1


cat << EOM
#######################################################
cp /media/mmcblk0p1/uEnv.txt /media/mmcblk1p1
#######################################################
EOM
cp /media/mmcblk0p1/uEnv.txt /media/mmcblk1p1

sync

tar -mjxvf /media/mmcblk0p1/rootfs.tar.bz2 -C /media/mmcblk1p2

sync

umount /dev/mmcblk1p1
sleep 1
umount /dev/mmcblk1p2
sleep 1

