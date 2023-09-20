#!/bin/bash

# Verifica si se proporcionó un argumento (nombre del archivo)
if [ -z "$1" ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

# Nombre del archivo proporcionado como argumento
input_file="$1"

# Verifica si el archivo existe
if [ ! -f "$input_file" ]; then
    echo "El archivo '$input_file' no existe."
    exit 1
fi

# Nombre del archivo de salida .mp3 y prueba
mp3_file="${input_file%.*}.mp3"

# Extensión del archivo de entrada
input_extension="${input_file##*.}"

# Verifica si el archivo de entrada es un formato válido para conversión
case "$input_extension" in
    opus | flv | avi | mp4)
        # Convierte el archivo a .mp3 utilizando ffmpeg
        ffmpeg -i "$input_file" -q:a 0 -map a "$mp3_file"
        if [ $? -eq 0 ]; then
            echo "Conversión completada: $mp3_file"
            
            # Elimina el archivo original
            rm "$input_file"
            echo "Archivo original eliminado: $input_file"
        else
            echo "Error en la conversión: $input_file"
        fi
        ;;
    *)
        echo "Formato de archivo no válido para conversión: $input_file"
        exit 1
        ;;
esac
