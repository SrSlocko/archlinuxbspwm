#!/bin/bash

# Itera sobre todos los archivos en el directorio actual
for archivo in *; do
    # Verifica si el archivo contiene corchetes y su contenido
    if [[ $archivo =~ \[.*\] ]]; then
        nuevo_nombre=$(echo "$archivo" | sed 's/\[[^]]*\]//g')
        if [ "$archivo" != "$nuevo_nombre" ]; then
            if [ -e "$nuevo_nombre" ]; then
                mv -f "$archivo" "$nuevo_nombre"
                echo "Corchetes y su contenido eliminados en: $archivo"
            else
                mv "$archivo" "$nuevo_nombre"
                echo "Corchetes y su contenido eliminados en: $archivo"
            fi
        fi
    fi

    # Verifica si el archivo es .jpg o .png con nombres complicados
    if [[ ($archivo =~ \.jpg$ || $archivo =~ \.png$) && ! $archivo =~ ^imagen[0-9]+\.(jpg|png)$ ]]; then
        ext="${archivo##*.}"  # Obtiene la extensión del archivo (jpg o png)
        contador=1
        nuevo_nombre="imagen$contador.$ext"
        while [ -e "$nuevo_nombre" ]; do
            contador=$((contador + 1))
            nuevo_nombre="imagen$contador.$ext"
        done
        if [ "$archivo" != "$nuevo_nombre" ]; then
            mv -f "$archivo" "$nuevo_nombre"
            echo "Imagen renombrada a: $nuevo_nombre"
        fi
    fi

    # Verifica si el archivo es .jpeg
    if [[ $archivo == *.jpeg && ! $archivo =~ ^imagenjpeg[0-9]+\.jpeg$ ]]; then
        contador=1
        nuevo_nombre="imagenjpeg$contador.jpeg"
        while [ -e "$nuevo_nombre" ]; do
            contador=$((contador + 1))
            nuevo_nombre="imagenjpeg$contador.jpeg"
        done
        if [ "$archivo" != "$nuevo_nombre" ]; then
            mv -f "$archivo" "$nuevo_nombre"
            echo "Imagen renombrada a: $nuevo_nombre"
        fi
    fi
done
