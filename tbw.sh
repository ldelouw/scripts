#!/bin/bash
# Copyright 2019 by Luc De Louw <luc@delouw.ch>
# 
# License: GPLv3 or later
# 

if [ $UID -ne 0 ]; then
	echo "You must be root to run this script"
	exit 1
fi

if [ $# -ne 1 ]; then
	echo "Missing parameter. Use $(basename $0) <device> i.e. $(basename $0) sda"
	exit 2
fi

if [ $(cat /sys/block/$1/queue/rotational) -ne 0 ]; then
	echo "Device /dev/$1 is a spinning disk, not an SSD. Data not available"
	exit 3
fi

ISO=$(smartctl -A /dev/$1 | awk '/^241/ { print ($10 * 512) * 1.0e-12 }')
IEC=$(smartctl -A /dev/$1 | awk '/^241/ { print ($10 * 512) / 1099511627776 }')
POWERONTIME=$(smartctl -A /dev/$1 | grep "Power_On_Hours" | awk '{print $10}')

echo "SSD Device /dev/$1" $(smartctl -a /dev/$1|grep "Device Model"|cut -f 2 -d ':' |tr -s [:space:])
echo "Total Bytes written: "
echo "$IEC TiB (IEC)"
echo "$ISO TB (ISO)"
echo "---------------------"
echo "$POWERONTIME hours (~"$(echo "($POWERONTIME / 24)"|bc)" days) online"
echo -n "Average "
echo -n $(echo "scale=4;($IEC * 1024) / ($POWERONTIME / 24)"|bc)
echo " GiB written per day"

