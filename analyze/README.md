#analyze


Tools:
======


Windows:
--------

	[USBpcap 1.0.0.7](http://desowin.org/usbpcap/)
	[*.pcap file format](http://desowin.org/usbpcap/captureformat.html)


Linux:
------

	[wireshark 1.12.3](https://www.wireshark.org/)



Process:
========

#### Raw data analyze
	convert pcap to raw "parse" format

	1 - record a *.pcap file per USBpcap instructions
	2 - tshark -V -x -r samples.pcap -S++++ >samples.hex
	3 - awk -f scripts/parse.awk samples.hex >samples.raw

#### Higher level protocol analyze
	pcap to fully decoded log

	1 - record a *.pcap file per USBpcap instructions
	2 - run decode.sh in scripts/ subdirectory
		- for gl124 based scanners, run decode124.sh which adds
		  register content decoding for this ASIC
