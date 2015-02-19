function reset() {
	direction="";
	type="";
	bmRequestType="";
	bRequest="";
	payload="";
	urbFunction="";
	control="";
}
BEGIN {
	reset();
}
/^Frame/ {
	cnt=strtonum($2)
}
/Endpoint: ...., Direction: / {
	direction=$4;
}
/bmRequestType:/ {
	bmRequestType=$2
}
/bRequest:/ {
	bRequest=$2
}
/wValue:/ {
    wValue=strtonum($2)
}
/wIndex:/ {
    wIndex=$2
}
/wLength:/ {
    wLength=$2
}
/URB transfer type:/ {
	type=$4;
}
/Packet Data Length:/ {
	data=$4
}
/USBPcap pseudoheader length:/ {
	pseudo=strtonum($4)
}
/URB Function:/ {
	urbFunction=$3;
}
/^[0-9a-f][0-9a-f][0-9a-f][0-9a-f]  / {
	addr=strtonum("0x"$1);
	for(i=2;i<NF && i<18;i++)
	{
		binary[addr+i-2]=strtonum("0x"$i);
	}
}
/CONTROL response data/ {
	payload="1";
}
/^++++/ {
	if(type=="URB_CONTROL" && (bRequest=="4" || bRequest=="12"))
	{
		if(payload=="")
		{
			control="1";
			printf "URB %5d control  %s 0x%02x 0x%x 0x%02x len %5d ",cnt, bmRequestType, bRequest, wValue, wIndex, wLength;
			if(direction=="OUT")
			{
				printf "wrote";
			}
			else
			{
				printf "read ";
			}
			next;
		}
		else
		{
			for(i=pseudo;i<pseudo+data;i++)
			{
				printf " 0x%02x",binary[i];
			}
			control="";
		}
	}
	else
	{
		# incomplete control blocks
		if(control=="1")
		{
			printf "** incomplete **\n"
		}
		printf "URB %5d unprocessed",cnt
	}
	printf "\n"
	reset();
}
