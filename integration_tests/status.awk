/SCAN 002 STATUS/,/SCAN STATUS END/ {
	print $0 > "extracted.scan"
}
