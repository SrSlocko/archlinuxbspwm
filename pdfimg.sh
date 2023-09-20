
#!/bin/bash

if [ -z "$1" ]; then
    echo "Uso: $0 archivo.pdf"
    exit 1
fi

input_file="$1"
filename="${input_file##*/}"  # Obtiene el nombre del archivo PDF
foldername="${filename%.pdf}"  # Elimina la extensión .pdf

if [ ! -d "$foldername" ]; then
    mkdir "$foldername"
fi

gs -dNOPAUSE -sDEVICE=png16m -r300 -o "$foldername/page_%04d.png" "$input_file"

echo "PDF convertido a imágenes PNG en la carpeta: $foldername"
