#!/bin/bash
if [[ $EUID != 0 ]]; then
	echo -e "This script requires \e[0;35mROOT\x1B[0m privileges."
	sudo "$0" "$@"
	exit $?
fi

echo ""
echo "******************************************************"
echo "*** out-of-tree xradio driver installer - vers 0.3 ***"
echo "*** https://github.com/karabek/xradio              ***"
echo "******************************************************"
echo ""

filename="/etc/armbian-release"
if [ ! -f $filename ]; then
	echo "This script only works with armbian (armbian.com). File $filename not found!"
	exit 1
fi

while read -r line
do
	val1=${line%=*}			# value
	val2=${line#*=}			# variable
	if [ "$val1" == "VERSION" ]; then
		ARMBIANVERS="$val2"
	fi
	if [ "$val1" == "LINUXFAMILY" ]; then
		LINUXFAM="$val2"
	fi
done < "$filename"

KVERS="$(uname -r)"
KERNELDIR="/lib/modules/$KVERS"
HEADERS="linux-headers-dev-"$LINUXFAM"_"$ARMBIANVERS"_armhf.deb"

echo "==== KERNEL HEADERS"
echo "     Linux family:     $LINUXFAM"
echo "     Kernel version:   $KVERS"
echo "     Armbian version:  $ARMBIANVERS"
if [ ! -d "$KERNELDIR/build" ]; then
	echo "     Attempting to load kernel headers ..."
	echo
	wget "https://apt.armbian.com/pool/main/l/linux-$KVERS/$HEADERS"
	if [ -f "$HEADERS" ]; then
		dpkg -i "$HEADERS"
	else
		echo "==== FATAL: Headers not found at apt.armbian.com - Try installing current ..."
		echo "     linux-headers-headers-"$LINUXFAM"_"$ARMBIANVERS"XXXXXXX_armhf.deb"
		echo "     ... from beta.armbian.com and try again!"
		exit 0
	fi
fi

echo "==== Compiling driver for kernel version $KVERS"
# prepare Makefile for stand alone compilation and compile
cp Makefile.orig Makefile
cp Makefile Makefile.orig
echo "CONFIG_WLAN_VENDOR_XRADIO := y" > Makefile
echo "CONFIG_XRADIO_USE_EXTENSIONS := y" >> Makefile
echo "CONFIG_XRADIO_WAPI_SUPPORT := n" >> Makefile
cat Makefile.orig >> Makefile
make  -C /lib/modules/$KVERS/build M=$PWD modules
if [ ! -d /lib/modules/$KVERS/kernel/drivers/net/wireless/xradio ]; then
	mkdir /lib/modules/$KVERS/kernel/drivers/net/wireless/xradio
fi
cp xradio_wlan.ko /lib/modules/$KVERS/kernel/drivers/net/wireless/xradio/
xmod=`grep xradio /etc/modules`
if [ -z "$xmod" ]; then
        echo -e "xradio_wlan" >> /etc/modules
fi
echo
echo "==== calling depmod"
echo
depmod
echo
echo "DONE! To add an overlay adding the xradio hardware to the device tree use this command:"
echo
echo "OrangePi Zero:	armbian-add-overlay dts/xradio-overlay-orangepizero.dts"
echo "NanoPi Duo:	<tbd>"
echo "Sunvell R69:	<tbd>"
exit
