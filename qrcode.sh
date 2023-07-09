#!/usr/bin/bash

for i in {1..450}
do
    qrencode  --foreground=2c3127 --background=78866b -lQ -s10 -d351 -o js$i.png xx1.es/js$i
done

mogrify-im6 -shave 3x3 -bordercolor Red -border 3x3 *.png

mogrify-im6 -mattecolor White -frame 5x5 *.png
