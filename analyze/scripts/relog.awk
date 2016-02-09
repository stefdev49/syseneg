#
# reformat genesys backend log output to format handled by
# the decoding scripts so both ouputs can be compared
#

/sanei_genesys_write_register/ || /sanei_genesys_write_hregister/ {
	print "registerWrite"$3$4
	next
}
/sanei_genesys_write_gl847_register/ {
	print "registerWrite"$3$4
	next
}
/sanei_genesys_write_register \(0x0f, 0x01\)/ {
	print "registerWrite"$3$4
	next
}
/sanei_genesys_write_gl847_register \(0x0f, 0x01\)/ {
	print "registerWrite"$3$4
	next
}
/sanei_genesys_fe_write_data \(/ {
	print "genesys_fe_write_data"$3$4
	next
}
!/sanei_genesys_write_register/ {
	print $0
}
