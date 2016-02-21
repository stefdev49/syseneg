#
# dumps the content of the registers when a scan starts
# scan starts when a non 0 value is written to register 0x0d
#
BEGIN {
	scan=1;
	shading=0;
	# fill all registers values with -1 as a marker to recognize unused ones
	for(i=0;i<300;i++)
		reg[i]=-1
	# same with frontend registers
	for(i=0;i<64;i++)
		fe[i]=-1;
	# empty all 5 slope tables
	for(i=1;i<=5;i++)
		slope[i]="empty"

}
#
# writes to frontend
#
# [genesys_low] sanei_genesys_fe_write_data (0x00, 0x0080)
# sanei_genesys_fe_write_data(0x04,0x0000)
/genesys_fe_write_data/ {
	nbargs=split($0, args, "[(,)]");
	idx=args[2]
	val=args[3]
	gsub(" ","",val)
	fe[strtonum(idx)]=strtonum(val)
}

#
# writes to registers
#
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

#
# gather slope tables writes
#
/write slope/ {
	slope[strtonum($3)]=$0
}

#
# write to motor register 'commits' the scan
# so we dump all information to get complete status
#
/registerWrite\(0x0f,0x/ {
	printf "==================== SCAN %03d STATUS =================\n",scan
	# frontend status
	for(i=0;i<64;i++)
	{
		if(fe[i]>=0)
		{
			printf "genesys_fe_write_data(0x%02x,0x%04x)\n",i,fe[i]
		}
	}
	#registers status
	for(i=0;i<300;i++)
	{
		if(reg[i]>=0)
		{
			printf "registerWrite(%s,%s)\n",tidx[i],reg[i]
		}
	}
	# slope tables values
	for(i=1;i<=5;i++)
	{
		print slope[i]
	}
	print "==================== SCAN STATUS END ============================="
	scan++
}

#
# copy input file to output
#
{
	print $0
}
