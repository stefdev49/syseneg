#URB   238  control  0x40 0x0c 0x8c 0x10 len     1 wrote 0x0b 
/control  0x40 0x0c 0x8c 0x10 len     . wrote/ {
	val=strtonum($11)
	if(val >= 8)
		enable=1;
	else
		enable=0;
	clock=0;
	if(and(val,7)==0)
		clock=12;
	if(and(val,7)==1)
		clock=20;
	if(and(val,7)==2)
		clock=24;
	if(and(val,7)==3)
		clock=30;
	if(and(val,7)==4)
		clock=40;
	if(and(val,7)==5)
		clock=48;
	if(and(val,7)==6)
		clock=60;
	printf "setScannerClock(0x%02x)  enable=%d , clock=%d MHz\n",val,enable,clock
	next;
}
/control  0x40 0x0c 0x8c 0x13 len     . wrote/ {
	val=strtonum($11)
	if(val >= 8)
		enable=1;
	else
		enable=0;
	clock=0;
	if(and(val,7)==0)
		clock=12;
	if(and(val,7)==1)
		clock=20;
	if(and(val,7)==2)
		clock=24;
	if(and(val,7)==3)
		clock=30;
	if(and(val,7)==4)
		clock=40;
	if(and(val,7)==5)
		clock=48;
	if(and(val,7)==6)
		clock=60;
	printf "setAmbaClock(0x%02x)  enable=%d , clock=%d MHz\n",val,enable,clock
	next;
}
{
	print $0;
}
