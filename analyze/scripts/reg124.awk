#
# decodes raw register values into human readable format
#

BEGIN {
	previous1="none"
	previous2="none"
	# first caracter of the value writtent to the register
	start=20
}
/registerWrite\(0x05,0x/ {
	val=strtonum(substr($0,start,4))
	val=and(val,192)/64
	dpi=600
	if(val==1)
	{
		dpi=1200
	}
	if(val==2)
	{
		dpi=2400
	}
	if(val==3)
	{
		dpi=4800
	}
	print $0" => DPIHW="dpi
	done=1
}
/registerWrite\(0x0c,0x/ {
	val=strtonum(substr($0,start,4))
	ccdlmt=and(val,7);
	print $0" => CCDLMT="ccdlmt
	done=1
}
/registerWrite\(0x27,0x/ {
	val=strtonum(substr($0,start,4))
	val+=256*strtonum(substr(previous1,start,4))
	val+=65536*strtonum(substr(previous2,start,4))
	print $0" => LINCNT="val
	done=1
}
/registerWrite\(0x2a,0x/ {
	val=strtonum(substr($0,start,4))
	val+=256*strtonum(substr(previous1,start,4))
	val+=65536*strtonum(substr(previous2,start,4))
	print $0" => MAXWD="val
	done=1
}
/registerWrite\(0x2d,0x/ {
	val=strtonum(substr($0,start,4))
	val+=256*strtonum(substr(previous1,start,4))
	print $0" => DPISET="val
	done=1
}
/registerWrite\(0x3f,0x/ {
	val=strtonum(substr($0,start,4))
	val+=256*strtonum(substr(previous1,start,4))
	val+=65536*strtonum(substr(previous2,start,4))
	feedl=val
	print $0" => FEEDL="val
	done=1
}
/registerWrite\(0xa0,0x/ {
	val=strtonum(substr($0,start,4))
	stepsel=and(val,7)
	fstpsel=and(val/8,7)
	print $0" => fstpsel="fstpsel", stepsel="stepsel
	done=1
}
/registerWrite\(0x81,0x/ {
	val=strtonum(substr($0,start,4))
	val+=256*strtonum(substr(previous1,start,4))
	print $0" => DUMMY="val
	done=1
}
/registerWrite\(0x84,0x/ {
	strpixel=strtonum(substr($0,start,4))
	strpixel+=256*strtonum(substr(previous1,start,4))
	strpixel+=65536*strtonum(substr(previous2,start,4))
	print $0" => STRPIXEL="strpixel
	done=1
}
/registerWrite\(0x87,0x/ {
	endpixel=strtonum(substr($0,start,4))
	endpixel+=256*strtonum(substr(previous1,start,4))
	endpixel+=65536*strtonum(substr(previous2,start,4))
	print $0" => ENDPIXEL="endpixel
	done=1
}
/registerWrite\(0x89,0x/ {
	val=strtonum(substr($0,start,4))
	val+=256*strtonum(substr(previous1,start,4))
	print $0" => EXPDUMMY="val
	done=1
}
/registerWrite\(0x8c,0x/ {
	val=strtonum(substr($0,start,4))
	val+=256*strtonum(substr(previous1,start,4))
	val+=65536*strtonum(substr(previous2,start,4))
	print $0" => EXPR="val
	done=1
}
/registerWrite\(0x8f,0x/ {
	val=strtonum(substr($0,start,4))
	val+=256*strtonum(substr(previous1,start,4))
	val+=65536*strtonum(substr(previous2,start,4))
	print $0" => EXPG="val
	done=1
}
/registerWrite\(0x92,0x/ {
	val=strtonum(substr($0,start,4))
	val+=256*strtonum(substr(previous1,start,4))
	val+=65536*strtonum(substr(previous2,start,4))
	print $0" => EXPB="val
	done=1
}
/registerWrite\(0x95,0x/ {
	val=strtonum(substr($0,start,4))
	val+=256*strtonum(substr(previous1,start,4))
	val+=65536*strtonum(substr(previous2,start,4))
	print $0" => SEGCNT="val
	done=1
}
/registerWrite\(0x97,0x/ {
	val=strtonum(substr($0,start,4))
	val+=256*strtonum(substr(previous1,start,4))
	print $0" => TG0CNT="val
	done=1
}
/registerWrite\(0x76,0x/ {
	ckmap=substr($0,start+2,2)
	ckmap=substr(previous1,start+2,2)""ckmap
	ckmap=substr(previous2,start+2,2)""ckmap
	print $0" => CK1MAP=0x"ckmap
	done=1
}
/registerWrite\(0x79,0x/ {
	ckmap=substr($0,start+2,2)
	ckmap=substr(previous1,start+2,2)""ckmap
	ckmap=substr(previous2,start+2,2)""ckmap
	print $0" => CK3MAP=0x"ckmap
	done=1
}
/registerWrite\(0x7c,0x/ {
	ckmap=substr($0,start+2,2)
	ckmap=substr(previous1,start+2,2)""ckmap
	ckmap=substr(previous2,start+2,2)""ckmap
	print $0" => CK4MAP=0x"ckmap
	done=1
}
/registerWrite\(0x7f,0x/ {
	lperiod=strtonum(substr($0,start,4))
	lperiod+=256*strtonum(substr(previous1,start,4))
	lperiod+=65536*strtonum(substr(previous2,start,4))
	print $0" => LPERIOD="lperiod
	done=1
}
/registerWrite\(0xa3,0x/ {
	val=strtonum(substr($0,start,4))
	val+=256*strtonum(substr(previous1,start,4))
	print $0" => SCANFED="val
	done=1
}
/registerWrite\(0xa5,0x/ {
	val=strtonum(substr($0,start,4))
	val+=256*strtonum(substr(previous1,start,4))
	stepno=val
	print $0" => STEPNO="val
	done=1
}
/registerWrite\(0xa7,0x/ {
	val=strtonum(substr($0,start,4))
	val+=256*strtonum(substr(previous1,start,4))
	print $0" => FWDSTEP="val
	done=1
}
/registerWrite\(0xa9,0x/ {
	val=strtonum(substr($0,start,4))
	val+=256*strtonum(substr(previous1,start,4))
	print $0" => BWDSTEP="val
	done=1
}
/registerWrite\(0xab,0x/ {
	val=strtonum(substr($0,start,4))
	val+=256*strtonum(substr(previous1,start,4))
	print $0" => FASTNO="val
	done=1
}
/registerWrite\(0xad,0x/ {
	val=strtonum(substr($0,start,4))
	val+=256*strtonum(substr(previous1,start,4))
	print $0" => FSHDEC="val
	done=1
}
/registerWrite\(0xaf,0x/ {
	val=strtonum(substr($0,start,4))
	val+=256*strtonum(substr(previous1,start,4))
	print $0" => FMOVNO="val
	done=1
}
/registerWrite\(0xb1,0x/ {
	val=strtonum(substr($0,start,4))
	val+=256*strtonum(substr(previous1,start,4))
	print $0" => FMOVDEC="val
	done=1
}
/registerWrite\(0xb4,0x/ {
	val=strtonum(substr($0,start,4))
	val+=256*strtonum(substr(previous1,start,4))
	val+=65536*strtonum(substr(previous2,start,4))
	print $0" => Z1MOD="val
	done=1
}
/registerWrite\(0xb7,0x/ {
	val=strtonum(substr($0,start,4))
	val+=256*strtonum(substr(previous1,start,4))
	val+=65536*strtonum(substr(previous2,start,4))
	print $0" => Z2MOD="val
	done=1
}
{
	if(done!=1)
	{
		print $0
	}
}
{
	previous2=previous1
	previous1=$0
	done=0
}
