#URB    61  control  0x40 0x0c 0x83 0x00 len     1 wrote 0x45
#URB    62  control  0x40 0x04 0x82 0x00 len     8 wrote 0x00 0x00 0x00 0x00 0x06
#URB    63  bulk_in  len     6  read  0x00 0x00 0x11 0xab 0x09 0x00
BEGIN {
	nb=0;
	ligne[nb]="control  0x40 0x04 0x82 0x00 len     8 wrote 0x00 0x00";nb++;
	ligne[nb]="bulk_in  len";nb++;
	l=0;
	i=0;
	len=0;
}
{
	if(substr($0,12,length(ligne[i]))==ligne[i])
	{
		pile[i]=$0
		if(i==0)
		{
			str=$16 substr($15,3)
			len=strtonum(str)
		}
		i++;
		if(i==nb)
		{
			printf "bulkRead(?R45?,%d)=",len
			total=0
			while(total<len)
			{
				ll=strtonum($5);
				#truncated lines -> NF test
				for(j=7;j<=NF;j++)
					printf "%s ",$j
				total+=ll
				if(total<len)
				{
					getline
					if(substr($0,12,length(ligne[nb-1]))!=ligne[nb-1])
					{
						if(i>0)
						{
							for(j=0;j<i;j++)
								print pile[j];
						}
						printf "INCOHERENCE!! %d<>%d\n",len,total;
					}
				}
			}
			if(total<len)
			{
				printf "URB %s SHORT READ!! %d<>%d\n",$2,len,total;
			}
			printf "\n";
			i=0
		}
	}
	else
	{
		if(i>0)
		{
			for(j=0;j<i;j++)
				print pile[j];
		}
		i=0
		print $0
	}
}
