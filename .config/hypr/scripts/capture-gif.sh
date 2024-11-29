#!/bin/bash

TMP_FILE_UNOPTIMIZED="$HOME/gif/recording_unoptimized.gif"
TMP_PALETTE_FILE="$HOME/gif/palette.png"
FILEDATE=$(date '+%Y%m%d-%H:%M:%S')
TMP_FILE="$HOME/gif/$FILEDATE.gif"
TMP_MP4_FILE="$HOME/gif/recording.mp4"
APP_NAME="GIF recorder"

is_recorder_running() {
  pgrep -x wf-recorder >/dev/null
}

convert_to_gif() {
  ffmpeg -i "$TMP_MP4_FILE" -filter_complex "[0:v] palettegen" "$TMP_PALETTE_FILE"
  ffmpeg -i "$TMP_MP4_FILE" -i "$TMP_PALETTE_FILE" -filter_complex "[0:v] fps=30,scale=720:-1 [new];[new][1:v] paletteuse" "$TMP_FILE_UNOPTIMIZED"
  if [ -f "$TMP_PALETTE_FILE" ]; then
    rm "$TMP_PALETTE_FILE"
  fi
  if [ -f "$TMP_MP4_FILE" ]; then
    rm "$TMP_MP4_FILE"
  fi
}

notify() {
  notify-send -a "$APP_NAME" "$1"
}

optimize_gif() {
  gifsicle -O3 --lossy=100 -i "$TMP_FILE_UNOPTIMIZED" -o "$TMP_FILE"
  if [ -f "$TMP_FILE_UNOPTIMIZED" ]; then
    rm "$TMP_FILE_UNOPTIMIZED"
  fi
}

if is_recorder_running; then
  kill $(pgrep -x wf-recorder)
else
  GEOMETRY=$(slurp)
  if [[ ! -z "$GEOMETRY" ]]; then
    if [ -f "$TMP_FILE" ]; then
      rm "$TMP_FILE"
    fi
    notify "Started capturing GIF to clipboard."
    timeout 5 wf-recorder -g "$GEOMETRY" -f "$TMP_MP4_FILE"
    if [ $? -eq 124 ]; then
      notify "Post-processing started. GIF capturing timed out."
    else
      notify "Post-processing started. GIF was stopped."
      notify $?
    fi
    convert_to_gif
    optimize_gif
    wl-copy -t image/gif < $TMP_FILE
    notify "GIF capture completed. GIF saved to clipboard and $TMP_FILE"
  fi
fi
