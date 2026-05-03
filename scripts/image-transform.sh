#! /usr/bin/env bash

# Usage: ./resize-and-open.sh <path/to/image> [width] [format] [engine]
# Example: ./resize-and-open.sh media/img/photo.jpg 800 avif podman

img_path="${1:-}"
width="${2:-}"
format="${3:-jpg}"
engine="${4:-podman}"

if [ -z "$img_path" ] || [ -z "$width" ]; then
  echo "Usage: $0 <path/to/image> [width] [engine]" >&2
  exit 2
fi

img_path="$(realpath "$img_path")"
img_dir="$(dirname "$img_path")"
img_name="$(basename "$img_path")"
workdir="/workspace"

"$engine" run --rm -i \
    -v "$img_dir":"$workdir":Z \
    --workdir "$workdir" \
    dgilli/imagemagick sh -c \
    "w=${width}; f=${img_name}; magick \"\$f\" -resize \"\${w}x\" -quality 80 -strip \"\${f%.*}_\${w}w.${format}\""

