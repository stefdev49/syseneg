# convert bulkRead between start motor and end scan to binary
# to run on log processed whith 'scan.awk'
BEGIN {
	scan=0;
}
/= SCAN [0-9]/ {
	scan++;
	filename="scan"scan".bin"
	print "gathering data in "filename" ..."
}
#bulkRead(?R45?,12624)=0xec 0xec 0xed .....
/bulkRead\(\?R45\?/ {
	count=split($0,fields,"[,= ]");
	values=strtonum(substr(fields[2],1,length(fields[2])-1));
	if(count-3!=values)
	{
		print "error!! FNR=" FNR
		printf "count=%d , values=%d\n", count, values
		exit;
	}
	# first field is a string and second the number of bytes
	for(i=3;i<values+3;i++)
	{
		printf "%c",strtonum(fields[i]) >filename
	}
}
