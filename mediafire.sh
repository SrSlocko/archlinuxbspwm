
#!/bin/bash

# Autor: SrSlocko
# Descripción: Este script permite descargar archivos de Mediafire
# proporcionando enlaces de Mediafire. Puede detectar automáticamente
# si se necesita wget o curl para la descarga, verifica la disponibilidad
# de conexión a Internet y ofrece opciones para descargar automáticamente
# los archivos o mostrar las URL de descarga.
# Aun no he solucionado el poder atrapar links de folders y descargar todo
# en segundos, tocara seguir investigando maneras.

# Comprueba si tienes instalados wget o curl para la descarga de archivos.
command -v wget >/dev/null 2>&1 && wget=0 || wget=1
command -v curl >/dev/null 2>&1 && curl=0 || curl=1
if [ $wget -eq 1 ] && [ $curl -eq 1 ]; then
    echo "Error: esta herramienta requiere tener instalado 'wget' o 'curl' para funcionar." >/dev/stderr
    exit 1
fi

# Comprueba si tienes acceso a Internet antes de continuar.
echo -e "GET http://google.com HTTP/1.0\n\n" | nc google.com 80 > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Error: esta herramienta requiere acceso a Internet para funcionar."
    exit 1
fi

# Define expresiones regulares para identificar enlaces de descarga de Mediafire.
MEDIAFIRE_WEB_DELAY=1.5 # s; Mediafire especifica un retraso de 1s para redirigir a las URL de descarga con parámetros, y necesita otros 0.5s para sincronizar correctamente.
VALID_MEDIAFIRE_PRE_DL="(?<=['\"])(https?:)?(\/\/)?(www\.)?mediafire\.com\/(file|view|download)\/[^'\"\?]+\?dkey\=[^'\"]+(?=['\"])"

# Define expresiones regulares para identificar enlaces de descarga dinámicos.
VALID_DYNAMIC_DL="(?<=['\"])https?:\/\/download[0-9]+\.mediafire\.com\/[^'\"]+(?=['\"])"

# Obtener las opciones y argumentos proporcionados al script.
AUTO_DOWNLOAD=0
URLS=() # Se llenará a continuación
VALIDATED_URLS=()
for i in "$@"; do
    case $i
            in
        -n|--no-download)
            AUTO_DOWNLOAD=1
            shift
            ;;
        -*|--*)
            echo "Opción desconocida: $i"
            exit 1
            ;;
        *)
            URLS+=("$i")
            shift
            ;;
    esac
done

# Por cada URL proporcionada...
for url in "${URLS[@]}"; do
    # Comprueba si la URL es válida.
    isIdentifierDL=0
    if [ -z "$url" ]; then
        echo "Error: por favor, ingresa al menos una URL para usar esta herramienta." >/dev/stderr
        exit 1
    else
        # Verifica si la URL es un enlace de identificación Mediafire.
        urlValidated='!'
        urlInvalidated='@'

        testUrl="$(echo "$url" | sed 's/'"${urlValidated}"'/'"${urlInvalidated}"'/g')"
        if [ $(echo "$testUrl" | sed -E 's/^[a-zA-Z0-9]+$/'"${urlValidated}"'/g') = $urlValidated ]; then
            isIdentifierDL=1
            elif ! ([ $(echo "$testUrl" | sed -E 's/^(https?:\/\/)?(www\.)?mediafire\.com\/\?[a-zA-Z0-9]+$/'"${urlValidated}"'/g') = $urlValidated ] ||
            [ $(echo "$url" | sed -E 's/^(https?:\/\/)?(www\.)?mediafire\.com\/(file|view|download)\/[a-zA-Z0-9]+(\/[a-zA-Z0-9_~%\.\-]+)?(\/file)?/'"${urlValidated}"'/g') = $urlValidated ]); then
            # No es una URL de descarga válida de Mediafire.
            echo "Error: \"$url\" no es una URL de descarga válida de Mediafire." >/dev/stderr
            exit 1
        fi
    fi

    # Si es una URL de identificación Mediafire, necesita convertirla en una URL de descarga.
    if [ $isIdentifierDL -eq 1 ]; then
        url="https://mediafire.com/?$url"
    elif [ ! -z "$(echo "$url" | grep '^http:\/\/')" ]; then
        # Puede necesitar reemplazar http:// con https://
        url="${url//http:\/\//https:\/\/}"
    elif [ -z "$(echo "$url" | grep '^https:\/\/')" ]; then
        # Si el enlace no tiene http(s), debe agregarse.
        if [ ! -z "$(echo "$url" | grep '^\/\/')" ]; then
            url="https:$url"
        else
            url="https://$url"
        fi
    fi

    # Utiliza wget o curl para obtener las URLs de descarga.
    dlPreUrl=""
    dlUrl=""
    if [ $wget -eq 0 ]; then
        dlPreUrl=$(wget -qO - "$url" | grep -oP "${VALID_MEDIAFIRE_PRE_DL}" | head -n 1)
        dlUrl=$(wget -qO - "$url" | grep -oP "${VALID_DYNAMIC_DL}" | head -n 1)
    elif [ $curl -eq 0 ]; then
        dlPreUrl=$(curl -sL "$url" | grep -oP "${VALID_MEDIAFIRE_PRE_DL}" | head -n 1)
        dlUrl=$(curl -sL "$url" | grep -oP "${VALID_DYNAMIC_DL}" | head -n 1)
    fi
    # Comprueba si se ha obtenido una URL de descarga válida.
    if [ ! -z "$dlUrl" ]; then
        VALIDATED_URLS+=("$dlUrl")
    else
        echo "Error: \"$url\" no tiene una URL de descarga disponible, prueba con un enlace diferente." >/dev/stderr
        exit 1
    fi
done

# Dependiendo de las opciones, descarga automáticamente o muestra las URLs.
for url in "${VALIDATED_URLS[@]}"; do
    if [ $AUTO_DOWNLOAD -eq 0 ]; then
        if [ $wget -eq 0 ]; then
            echo "Descargando: $url"
            wget "$url" -q --show-progress
            if [ $? -eq 0 ]; then
                filename=$(basename "$url")
                echo "Descargado exitosamente: $filename"
            else
                echo "Error al descargar: $url" >&2
            fi
        elif [ $curl -eq 0 ]; then
            echo "Descargando: $url"
            curl -O -J -s -L "$url"
            if [ $? -eq 0 ]; then
                filename=$(basename "$url")
                echo "Descargado exitosamente: $filename"
            else
                echo "Error al descargar: $url" >&2
            fi
        fi
    else
        echo "$url"
    fi
done
