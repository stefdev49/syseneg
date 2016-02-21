# convert register wirte sequence to the analog frontend to high
# level function
BEGIN {
	nb=0;
	ligne[nb]="registerWrite(0x51,"; nb++;
	ligne[nb]="registerWrite(0x5d,"; nb++;
	ligne[nb]="registerWrite(0x5e,"; nb++;
        position=0;
        encours=0;
}
{
        if(encours==1)
        {
                if(substr($0,1,length(ligne[position]))!=ligne[position])
                {
                        for(i=0;i<position;i++)
                        {
                                print pile[i];
                        }
                        print $0
                        encours=0;
                        position=0;
                }
                else
                {
                        pile[position]=$0;
			val[position]=substr($0,20,4);
                        position++;
                        if(position==nb)
                        {
				printf "sanei_genesys_fe_write_data(%s,%s%s)\n",adr,val[1],substr(val[2],3)
                                encours=0;
                        }
                }
        }
        else
        {
                if(substr($0,1,length(ligne[0]))==ligne[0])
                {
			adr=substr($0,20,4);
                        encours=1;
                        position=1;
                        pile[0]=$0;
                }
                else
                {
                        print $0
                }
        }
}
