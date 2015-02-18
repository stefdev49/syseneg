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
	groovy 2.4



Process:
========

	1 - record a *.pcap file per USBpcap instructions
	2 - tshark -V -x -r samples.pcap -S++++ >samples.hex
	3 - scripts/decode samples.hex



Notes:
======

capinfos:
---------

stefdev:/home/stefdev/git/syseneg/analyze>capinfos lide220.pcap 
File name:           lide220.pcap
File type:           Wireshark/tcpdump/... - pcap
File encapsulation:  USB packets with USBPcap header
Packet size limit:   file hdr: 65535 bytes
Number of packets:   132 k
File size:           50 MB
Data size:           48 MB
Capture duration:    173 seconds
Start time:          Thu Feb 12 05:31:52 2015
End time:            Thu Feb 12 05:34:46 2015
Data byte rate:      279 kBps
Data bit rate:       2 239 kbps
Average packet size: 367,21 bytes
Average packet rate: 762 packets/sec
SHA1:                3631714cb94e0e5ccae355464e4d35d66a86935f
RIPEMD160:           e0cf6c5c3cf46b2d78f4bd2e50729f5322ff4eec
MD5:                 28ade7e37e847dd2732ced1bf584f378
Strict time order:   True

editcap, mergecap, dumpcap
	
