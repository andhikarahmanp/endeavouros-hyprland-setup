#!/bin/bash
DIR=~/Pictures/Screenshots
mkdir -p $DIR
FILE=$DIR/$(date +%Y%m%d_%H%M%S).png

case $1 in
  area)
    grim -g "$(slurp)" $FILE && \
    swappy -f $FILE && \
    notify-send -i $FILE "Screenshot" "The screenshot was successfully saved!"
    ;;
  full)
    grim $FILE && \
    swappy -f $FILE && \
    notify-send -i $FILE "Screenshot" "The Screenshot was successfully saved!"
    ;;
  clip)
    grim -g "$(slurp)" $FILE && \
    wl-copy < $FILE && \
    notify-send -i $FILE "Screenshot" "Area copied to clipboard"
    ;;
esac
