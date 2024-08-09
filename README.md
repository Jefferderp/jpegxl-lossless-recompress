A small script to losslessly recompress any jpeg/jpg/png/bmp image files in a given directory (recursively) to jpegxl format, which is losslessly and reversible per the format standard.

jpg/jpeg files can be losslessly restored, however png/bmp files can only be recovered with new header metadata.

Usage: `./jpegxl-lossless-compress-keep-if-smaller.sh "./directory name/"`

Requires the following packages on Ubuntu 24/Debian 12: `bash coreutils bc libjxl-tools`

I'm pretty sure the script fails on filenames with 'single-quotes' in them ;)
