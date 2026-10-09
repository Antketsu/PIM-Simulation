#!/bin/bash

BUSYBOX_VERSION=1.36.1
DISK_IMG=rootfs
MNTDIR=rootfs_mnt
READFILE=/tmp/bootscript
BASE_IMAGE=base_img


# Cleaning 
rm  $DISK_IMG

#Create base image directory if not exists
if [ ! -d $BASE_IMAGE ]; then
    mkdir $BASE_IMAGE
    sudo mkdir -p $BASE_IMAGE/{bin,sbin,etc,proc,sys,dev,usr/bin,usr/sbin,tmp}
    sudo chmod 1777 $BASE_IMAGE/tmp
fi

# Create mount directory
mkdir -p $MNTDIR

# Empty image
dd if=/dev/zero of=$DISK_IMG bs=1M count=64
mkfs.ext2 -F $DISK_IMG

# Mount image
sudo mount -o loop $DISK_IMG $MNTDIR

# Basic structure
sudo cp -a $BASE_IMAGE/* $MNTDIR/


# Download and compile busybox
if [ ! -f busybox-$BUSYBOX_VERSION.tar.bz2 ]; then
    wget https://busybox.net/downloads/busybox-$BUSYBOX_VERSION.tar.bz2
fi

#Only compile busybox if it is not already compiled
if [ ! -d busybox ]; then
    tar -xf busybox-$BUSYBOX_VERSION.tar.bz2
    mv busybox-$BUSYBOX_VERSION busybox
    cd busybox
    make distclean
    make defconfig
    # Activate static binary for busybox
    sed -i 's/.*CONFIG_STATIC.*/CONFIG_STATIC=y/' .config
    sed -i 's/^CONFIG_TC=.*/# CONFIG_TC is not set/' .config
    sed -i 's/^CONFIG_FEATURE_TC_/# CONFIG_FEATURE_TC_ is not set/' .config
    make -j$(nproc)
    make install
    cd ..
fi


# Copy busybox to image
cp -a busybox/_install/* $MNTDIR/

# m5 utility
pushd ../gem5-pim/util/m5
scons build/x86/out/m5
popd
cp ../gem5-pim/util/m5/build/x86/out/m5 $MNTDIR/sbin/m5

# Init script
unlink $MNTDIR/sbin/init
cat << EOF | sudo tee $MNTDIR/sbin/init > /dev/null
#!/bin/sh
mount -t proc none /proc
mount -t sysfs none /sys
insmod gem5_bridge.ko gem5_bridge_baseaddr=0xffff0000 gem5_bridge_rangesize=0x10000
insmod pim_driver.ko
chmod 666 /dev/pim
/sbin/m5 readfile > $READFILE
if [ -s $READFILE ]; then
    chmod +rx $READFILE
    $READFILE || true
    /sbin/m5 exit
fi
echo "Starting shell..."
exec /bin/sh
/sbin/m5 exit
EOF
sudo chmod +x $MNTDIR/sbin/init

# Device nodes
sudo mknod -m 622 $MNTDIR/dev/console c 5 1
sudo mknod -m 666 $MNTDIR/dev/null c 1 3

#PIM driver
cp ../pim_driver/pim_driver.ko $MNTDIR/pim_driver.ko 
cp ../gem5-pim/util/gem5_bridge/gem5_bridge.ko $MNTDIR/gem5_bridge.ko
cp ../kernels/build/add_pim $MNTDIR/add_pim 

# Unmount
sudo umount $MNTDIR
rmdir $MNTDIR

echo "Disk image created: $DISK_IMG"
