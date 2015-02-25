#!/bin/bash
#
# convert pcap format into 'parse' intermediate form
# and decode simple operations in one pass
#
tshark -r $1 -x -P -S++++ -V | awk -f parsedecode.awk >$1.tmp
#
# apply all scripts for low-level decoding of remaining operations
#
for script in \
bulk_write_data.awk \
bulk_read_data.awk \
clock.awk \
usb_speed.awk \
;
do
	echo "executing "$script"..."
	awk -f $script $1.tmp >$1.res
	mv $1.res $1.tmp
done
mv $1.tmp `basename $1 .pcap`.decode
