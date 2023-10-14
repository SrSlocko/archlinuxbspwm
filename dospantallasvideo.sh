
#!/bin/bash
# Directorio de destino para los videos de alta resolución.
DESTINATION_DIR="./Wallpapers2Animation"

# Itera a través de los archivos nuevamente para mover los de alta resolución.
for file in ./*.mp4; do
    resolution=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "$file")
    if [[ $resolution == 2732x* || $resolution == 28* || $resolution == 3840x* ]]; then
        mv "$file" "$DESTINATION_DIR"
    fi
done

# Muestra un mensaje después de mover los videos.
echo "Videos de 2732x768 o superiores movidos a $DESTINATION_DIR"
