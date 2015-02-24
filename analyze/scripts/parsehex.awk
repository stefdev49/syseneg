function reset() {
	direction="";
	type="";
	bmRequestType="";
	bRequest="";
	payload="";
	urbFunction="";
	control="";
    	wValue="";
    	wLength="";
    	wIndex="";
}

function decodeControl() {
	if(payload=="")
	{
		control="1";
		next;
	}
	else
	{
		printf "URB %6d control  %s 0x%02x 0x%x 0x%02x len %5d ",cnt, bmRequestType, bRequest, wValue, wIndex, wLength;
		if(direction=="OUT")
		{
			printf "wrote";
		}
		else
		{
			printf "read ";
		}
		for(i=pseudo;i<pseudo+data;i++)
		{
			printf " 0x%02x",binary[i];
		}

		control="";
	}
}

function decodeBulk() {
	if(direction=="OUT")
	{
		dir="out";
		rw="wrote";
	}
	else
	{
		dir="in ";
		rw="read ";
	}
	printf "URB %6d bulk_%s len %5d %s",cnt, dir, data, rw;
	for(i=pseudo;i<pseudo+data;i++)
	{
		printf " 0x%02x",binary[i];
	}
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
/IRP USBD_STATUS:/ {
	status=$3
}
/^++++/ {
	# ACK
	if(urbFunction=="URB_FUNCTION_CONTROL_TRANSFER" && data==0)
	{
		printf "URB %6d ACK",cnt
	}
	# data transfers
	else if(urbFunction=="URB_FUNCTION_BULK_OR_INTERRUPT_TRANSFER")
	{
		decodeBulk();
	}
	# control transfers
	else if(type=="URB_CONTROL" && (bRequest=="4" || bRequest=="12"))
	{
		decodeControl();
	}
	else
	# URB not yet decoded
	{
		# incomplete control blocks
		if(control=="1")
		{
			printf "** incomplete **\n"
		}
		printf "URB %6d unprocessed",cnt
	}

	# for all packets
	printf "\n"
	reset();
}
