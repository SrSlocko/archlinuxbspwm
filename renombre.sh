#!/bin/bash

# Itera sobre todos los archivos en el directorio actual
for archivo in *; do
  # Verifica si el archivo contiene corchetes y su contenido
  if [[ $archivo =~ \[.*\] ]]; then
    nuevo_nombre=$(echo "$archivo" | sed 's/\[[^]]*\]//g')
    mv "$archivo" "$nuevo_nombre"
    echo "Corchetes y su contenido eliminados en: $archivo"
  fi
done
