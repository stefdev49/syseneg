# syseneg

Reverse engineered SANE backend for genesys based scanners


Roadmap:
========

- record USB logs with wireshark
- decode USB logs to extract commands
	- transform pcap output to "parse.awk" format
	- decode read/write register function
	- decode read/write data blocks
	- decode low level firmware commands (*)
	- gather scanner state at scan start motor
- add unit test programs to test USB commands
- reach first light status with a low resolution non calibrated scan
- add calibration
- add resolutions
- work out shading calibration
- reach calibrated scans status
- turn tests progs in a SANE backend

(*) current state
