
#!/bin/bash
alwaysRun=false
generateThumbnail=false
setWallpaper=false
blur=false
fit='fill'
ANIMATION_DIR="$HOME/WallpapersAnimation"

isPlaying=false

PIDFILE="/var/run/user/$UID/vwp.pid"

declare -a PIDs
declare -a Monitors
declare -a ThumbnailList
declare -a ParsedValueList
declare -a IndexMap=(
    [0]="video"
    [1]="blurGeometry"
    [2]="timeStamp"
)

while getopts ":anwbf:d:h" arg; do
    case "$arg" in
        "a")
            alwaysRun=true
            ;;
        "n")
            generateThumbnail=true
            ;;
        "w")
            setWallpaper=true
            ;;
        "b")
            blur=true
            ;;
        "f")
            fit=$OPTARG
            ;;
        "d")
            ANIMATION_DIR=$OPTARG
            ;;
        "h")
            cat <<EOL
Uso:
./setup.sh [OPCIONES] [VIDEO,GEOMETRÍA_DESBLUR,TIEMPO]

Ejemplo:
./setup.sh -anwb video.mp4 video2.mp4,32x32

NOTA: La ruta del video debe ser el último parámetro.

Opciones:
    -a: Ejecutar el fondo de pantalla de video siempre.
    -n: Generar una miniatura usando ffmpeg. Puede ser útil si utilizas la bandeja del sistema integrada de Polybar. (Esto puede corregir el fondo de la bandeja del sistema)
    -w: Establecer la miniatura generada como fondo de pantalla usando feh. Puede ser útil si utilizas la bandeja del sistema integrada de Polybar. (Esto puede corregir el fondo de la bandeja del sistema)
    -b: Desenfocar la miniatura. Puede ser útil si tu compositor no desenfoca el fondo de la bandeja del sistema integrada de Polybar.
    -f: Valor que se pasa a "feh --bg-[valor]". Opciones disponibles: center|fill|max|scale|tile (Valor predeterminado: fill)
    -d: Donde se almacenan las miniaturas. (Valor predeterminado: $HOME/WallpapersAnimation)
    -h: Muestra este texto de ayuda.

EOL
            exit
            ;;
        ":")
            echo "ERROR: La opción $OPTARG requiere argumento(s)"
            exit
            ;;
        "?")
            echo "ERROR: Opción desconocida $OPTARG"
            exit
            ;;
        "*")
            echo "ERROR: Error desconocido al procesar opciones"
            exit
            ;;
    esac
done

# Eliminar las opciones
shift $((OPTIND - 1))

kill_xwinwrap() {
    while read p; do
        [[ $(ps -p "$p" -o comm=) == "xwinwrap" ]] && kill -9 "$p"
    done <$PIDFILE
    sleep 0.5
}

play_video() {
    if [ $alwaysRun == true ]; then
        xwinwrap -ov -ni -g "$1" -- mpv --fs --loop-file --no-audio --no-osc --no-osd-bar -wid WID --no-input-default-bindings "$2" &
    else
        xwinwrap -ov -ni -g "$1" -- mpv --fs --loop-file --input-ipc-server="/tmp/mpvsocket$3" --pause --no-audio --no-osc --no-osd-bar -wid WID --no-input-default-bindings "$2" &
    fi
    PIDs+=($!)
}

pause_video() {
    for ((i = 1; i <= ${#Monitors[@]}; i++)); do
        echo '{"command": ["cycle", "pause"]}' | socat - "/tmp/mpvsocket$i"
    done
}

comprobar_si_archivo_existe() {
    local ruta=$1

    if [ -f "$ruta" ];then
        echo "true"
    else
        echo "false"
    fi
}

generar_miniatura_si_no_existe() {
    local video=$1
    local timeStamp=$2
    local rutaMiniatura=$3

    if [ "$(comprobar_si_archivo_existe "$rutaMiniatura")" == false ];then
        ffmpeg -i "$video" -y -f image2 -ss "$timeStamp" -vframes 1 "$rutaMiniatura"
    fi
}

generar_miniatura_principal() {
    local video=$1
    local timeStamp=$2
    local blurGeometry=$3

    local nombreVideo
    nombreVideo="$(basename "$video" ".${video##*.}")"
    local miniatura="$ANIMATION_DIR/$nombreVideo"
    local rutaMiniatura="$miniatura.png"
    local rutaMiniaturaDesenfocada="$miniatura-desenfocada-$blurGeometry.png"

    if [ ! -d "$ANIMATION_DIR" ]; then
        mkdir -p "$ANIMATION_DIR"
    fi

    if [ $blur == true ]; then
        if [ "$(comprobar_si_archivo_existe "$rutaMiniaturaDesenfocada")" == false ];then
            generar_miniatura_si_no_existe "$video" "$timeStamp" "$rutaMiniatura"
            convert "$rutaMiniatura" -blur "$blurGeometry" "$rutaMiniaturaDesenfocada"
        fi
        rutaMiniatura=$rutaMiniaturaDesenfocada
    else
        generar_miniatura_si_no_existe "$video" "$timeStamp" "$rutaMiniatura"
    fi

    ThumbnailList+=("$rutaMiniatura")
}

generar_todas_las_miniaturas() {
    for p in "${ParsedValueList[@]}"; do
        declare -a ParsedValue
        local video=''
        local blurGeometry=''
        local timeStamp=''

        IFS=',' read -ra ParsedValue <<< "$p"

        for ((i = 0; i < ${#IndexMap[@]}; i++)); do
            eval "${IndexMap[$i]}=${ParsedValue[$i]}"
        done

        generar_miniatura_principal "$video" "$timeStamp" "$blurGeometry"
    done
}

comprobar_si_video_existe() {
    local rutaVideo=$1

    if [ "$(comprobar_si_archivo_existe "$rutaVideo")" == false ];then
        echo "ERROR: La ruta del video $rutaVideo está vacía."
        exit
    fi
}

trim() {
    echo "$1" | grep -o "[^ ]\+\( \+[^ ]\+\)*"
}

parsear_y_reproducir() {
    declare -a ValorArr
    local video=''
    local blurGeometry='16x16'
    local timeStamp='00:00:01'
    local geometria=$2
    local indiceMonitor=$3

    IFS=',' read -ra ValorArr <<< "$1"

    for ((i = 0; i < ${#ValorArr[@]}; i++)); do
        ValorArr[$i]=$(trim "${ValorArr[$i]}")
    done

    for ((i = 0; i < ${#IndexMap[@]}; i++)); do
        if [ -n "${ValorArr[$i]}" ]; then
            eval "${IndexMap[$i]}=${ValorArr[$i]}"
        fi
    done

    comprobar_si_video_existe "$video"

    play_video "$geometria" "$video" "$indiceMonitor"

    ParsedValueList+=("$video,$blurGeometry,$timeStamp")
}

principal() {
    for g in $(xrandr -q | grep 'connected' | grep -oP '\d+x\d+\+\d+\+\d+'); do
        Monitors+=("$g")
        local valor
        valor=$(eval echo "\$${#Monitors[@]}")

        if [ -z "$valor" ]; then
            valor=$(eval echo "\$$#")
        fi

        parsear_y_reproducir "$valor" "$g" "${#Monitors[@]}"
    done

    printf "%s\n" "${PIDs[@]}" >$PIDFILE

    if [ $generateThumbnail == true ]; then
        generar_todas_las_miniaturas
    fi

    if [ $setWallpaper == true ]; then
        feh "--bg-$fit" "${ThumbnailList[@]}"
    fi

    if [ $alwaysRun != true ]; then
        while true; do
            if [ "$(xdotool getwindowfocus getwindowname)" == "i3" ] && [ $isPlaying == false ]; then
                pause_video
                isPlaying=true
            elif [ "$(xdotool getwindowfocus getwindowname)" != "i3" ] && [ $isPlaying == true ]; then
                pause_video
                isPlaying=false
            fi
            sleep 0.5
        done
    fi
}

if [ -z "$*" ]; then
    echo "ERROR: Se requiere la ruta del video"
    exit
fi

kill_xwinwrap
principal "$@"
