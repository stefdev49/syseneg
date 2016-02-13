/SCAN ... STATUS/,/SCAN STATUS END/ {
	print $0 > "extracted"$3".scan"
}
