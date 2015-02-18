function reset() {
	direction="";
	type="";
	bmRequestType="";
	bRequest="";
	payload="";
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
	if(bRequest=="4" && bmRequestType=="0x40" && type="URB_CONTROL")
	{
		if(payload=="")
		{
			#URB 00000 control 0x40 0x04 0x83 0x00 len 00000 
			printf "URB %5d control  0x40 0x04 0x%02x 0x%02x len %5d ",cnt, and(wValue,255), wValue/256, wLength;
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
		}
	}
	else
	{
		printf "URB %5d unprocessed",cnt
	}
	printf "\n"
	reset();
}
