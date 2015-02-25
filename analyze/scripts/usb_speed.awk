#URB     5  control  0xc0 0x0c 0x8e 0x00 len     1 read  0x00 
/0xc0 0x0c 0x8e 0x00/ {
		if($3=="control" && $9=="1" && $10=="read")
		{	
			printf "usbSpeed()=%s\n",$11;
			next;
		}
	}
{
	print $0;
}
