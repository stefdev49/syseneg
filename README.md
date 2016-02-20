# syseneg

Reverse engineered tools for genesys SANE backend


Roadmap:
========

- record USB logs with wireshark
- decode USB logs to extract commands
	- transform pcap output to "parse.awk" format
	- decode read/write register function
	- decode read/write data blocks
	- decode low level firmware commands
	- gather scanner state at scan start motor
	- extract scanned data (*) : currently no usable data is extracted
		from logs. It remains to be found if it is a bug in decoding
		scripts or USBPcap logging
- add unit test programs to test USB commands
- reach first light status with a low resolution non calibrated scan
- add calibration
- add resolutions
- work out shading calibration
- reach calibrated scans status
- turn tests progs in a SANE backend

(*) current state
