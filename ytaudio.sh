#!/bin/bash
# Script para extraer el enlace base de un enlace de YouTube con parámetros y descargar el audio con yt-dlp

# Comprueba si se proporcionó un enlace
if [ -z "$1" ]; then
    echo "Usage: $0 <YouTube URL with parameters>"
    exit 1
fi

# Extrae el enlace base sin parámetros
youtube_url=$(echo "$1" | awk -F"\\\\?si=" "{print \$1}")

# Descarga el audio utilizando yt-dlp
#yt-dlp -f "ba" -x --no-playlist "$youtube_url"
yt-dlp "$youtube_url" --format "bestaudio/best" --audio-format mp3 --extract-audio --audio-quality 0 --no-playlist
