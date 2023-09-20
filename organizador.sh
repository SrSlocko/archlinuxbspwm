#!/bin/bash

# Directorio de inicio
home_dir="/home/leonedev"

# Directorios de destino
directorios_destino=(
  "$home_dir/Imágenes"
  "$home_dir/Vídeos"
  "$home_dir/Documentos"
  "$home_dir/Music"
  "$home_dir/ISOS"
  "$home_dir/Archivos Comprimidos"
  "$home_dir/Otros"
)

# Crear directorios si no existen
for directorio in "${directorios_destino[@]}"; do
  mkdir -p "$directorio"
done

# Función para obtener el directorio de destino según la extensión del archivo
obtener_directorio_destino() {
  archivo="$1"
  extension="${archivo##*.}"
  case "$extension" in
    jpg|png|gif) echo "${directorios_destino[0]}" ;;
    mp4|avi) echo "${directorios_destino[1]}" ;;
    pdf|docx|txt) echo "${directorios_destino[2]}" ;;
    mp3|opus) echo "${directorios_destino[3]}" ;;
    iso) echo "${directorios_destino[4]}" ;;
    zip|rar|7z) echo "${directorios_destino[5]}" ;;
    *) echo "${directorios_destino[6]}" ;; # Otros
  esac
}

# Mover archivos a sus respectivas carpetas
for archivo in "$home_dir"/*; do
  if [ -f "$archivo" ]; then
    directorio_destino=$(obtener_directorio_destino "$archivo")
    mv "$archivo" "$directorio_destino/"
    echo "Moviendo '$archivo' a '$directorio_destino'"
  fi
done
