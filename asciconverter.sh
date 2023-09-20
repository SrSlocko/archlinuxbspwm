#!/bin/bash

# Comprueba si se proporcionó un archivo multimedia como argumento
if [ $# -ne 1 ]; then
  echo "Uso: $0 archivo_multimedia"
  exit 1
fi

archivo="$1"
extension="${archivo##*.}"

# Comprueba si el archivo es una imagen (jpg, png, gif)
if [[ "$extension" == jpg || "$extension" == png || "$extension" == gif ]]; then
  img2txt "$archivo" # Convierte la imagen a ASCII utilizando libcaca
  exit 0
fi

# Comprueba si el archivo es un video (mp4, avi, etc.)
if [[ "$extension" == mp4 || "$extension" == avi || "$extension" == mkv ]]; then
  # Establece el controlador de salida de libcaca en "ncurses"
  export CACA_DRIVER=ncurses
  
  # Usa mplayer con libcaca para mostrar el video en modo ASCII
  mplayer -really-quiet -vo caca "$archivo"
  exit 0
fi

echo "El archivo no es una imagen ni un video compatible."
exit 1

