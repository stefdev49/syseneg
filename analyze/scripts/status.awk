/== SCAN ... STATUS/ {
	extracted="extracted"$3".scan"
}
/== SCAN ... STATUS/,/SCAN STATUS END/ {
	print $0 > extracted
}
