#
# dumps the content of the registers when a scan starts
# scan starts when a non 0 value is written to register 0x0d
#
BEGIN {
	scan=1;
	# fill all values wtith -1 as a marker to recogniez unused registers
	for(i=0;i<300;i++)
		reg[i]=-1
}
/registerWrite\(0x..,/ {
	rs=substr($1,15,4);
	vs=substr($1,20,4);
	i=strtonum(rs);
	reg[i]=vs;
	tidx[i]=rs;
}
/registerWrite\(0x...,/ {
	rs=substr($1,15,5);
	vs=substr($1,21,4);
	i=strtonum(rs);
	reg[i]=vs;
	tidx[i]=rs;
}
# write to motor register 'commits' the scan
/registerWrite\(0x0d,0x01\)/ {
	printf "==================== SCAN %03d STATUS =================\n",scan
	scan++
	for(i=0;i<300;i++)
	{
		if(reg[i]>=0)
		{
			printf "registerWrite(%s,%s)\n",tidx[i],reg[i]
		}
	}
	print "==================== SCAN STATUS END ============================="
}
{
	print $0
}
