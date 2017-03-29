#!/bin/bash

SRC=$1
DEST=$2
DEST_EXT=mkv
BATCH=batch_encode.sh

rm $BATCH

# Process each video file in $SRC
find "$SRC" -name "*.mkv" | sort | tr \\n \\000 | while IFS= read -r -d $'\0' FILE; do
  filename=$(basename "$FILE")
  dname=$(dirname "$FILE")
  subdir=${dname#$SRC/}
  extension=${filename##*.}
  filename=${filename%.*}
  dest=$DEST/$subdir

  echo "echo Transcoding input file: \"$dname/$filename.$extension\"" >> $BATCH
  echo "mkdir -p \"$dest/original\"" >> $BATCH
  # Handbrake settings described here: https://handbrake.fr/docs/en/latest/cli/cli-guide.html
  echo "HandBrakeCLI\
`# General options      ` --verbose=1\
`# Source options       ` --input \"$FILE\" --main-feature --angle 1\
`# Dest options         ` --output \"$dest/$filename.$DEST_EXT\" --format \"$DEST_EXT\" --markers\
`# Video options        ` --encoder x264 --encoder-profile high --encoder-level 4.1 --quality 20 --cfr\
`# Audio options        ` --aencoder copy,av_aac --audio-copy-mask dtshd,dts,ac3 --ab auto,160 --mixdown dpl2\
`# Picture options      ` --auto-anamorphic\
`# Filter options       ` --decomb\
`# Subtitle options     ` --native-language eng\
 2> \"$dest/$filename.log\" < /dev/null" >> $BATCH

  echo "mv -f \"$FILE\" \"$dest/original/$filename.$extension\"" >> $BATCH
  echo "" >> batch_encode.sh
done

# Prune empty dirs
echo "find $SRC/* -type d -empty -delete" >> $BATCH
