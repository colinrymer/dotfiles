nsm () { nasm -f elf -o "$1".o -l "$1".l "$1".s;}

vidcut () { ffmpeg -sameq -ss 0 -t "$2" -i "$1" shortened_"$1"; }