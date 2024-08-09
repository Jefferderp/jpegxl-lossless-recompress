#! /bin/bash

# Safer error handling
set -eu -o pipefail

# Requires: bash coreutils bc libjxl-tools

comp () {
	RATIO_WANT=96 # Output file must be X% smaller than original to be kept.
	OUTPUT_EXT="jxl"

	file="$1"

	#echo -n $file ': ' ;
	echo $file

	size_b=$(du "$file" | cut -f1) || exit
	basename=$(printf "$file" | sed 's/\.[^.]*$//') || exit
	output="$basename.$OUTPUT_EXT" || exit

	cjxl --quiet --effort 10 --brotli_effort=11 --distance 0 --num_threads 1 --lossless_jpeg=1 --allow_jpeg_reconstruction=1 -- "$file" "$output" || exit

	size_a=$(du "$output" | cut -f1)
	ratio_got=$(bc <<< "scale=2; x = $size_a / $size_b * 100; scale = 0; x / 1")

	if (( $ratio_got < $RATIO_WANT )); then
		touch -r "$file" "$output" 2>/dev/null
		rm "$file" # && printf "PASS ($ratio_got%%) kept output\n"
	else
		rm "$output" # && printf "FAIL ($ratio_got%%) kept original\n";
	fi

	sleep 1s
}

export -f comp

find "$@" -type f \( -iname '*.jpg' -or -iname '*.png' -or -iname '*.bmp' \) -print0 | xargs --replace=@ -P12 -0 bash -c ' comp '"'"'@'"'"' '
