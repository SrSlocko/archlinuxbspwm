
#!/bin/bash

# Directorio donde se encuentran los videos a redimensionar.
VIDEO_DIR=$(pwd)  # Establece el directorio actual como ubicación de los videos.

# Recorre los archivos de video en el directorio.
for video_file in "$VIDEO_DIR"/*; do
    # Verifica si el video debe redimensionarse.
    if [ -f "$video_file" ]; then
        width=$(ffprobe -v error -select_streams v:0 -show_entries stream=width -of csv=s=x:p=0 "$video_file")
        height=$(ffprobe -v error -select_streams v:0 -show_entries stream=height -of csv=s=x:p=0 "$video_file")

        if [ "$width" -ge 2732 ] && [ "$height" -eq 768 ]; then
            # Redimensiona a 2732x768.
            ffmpeg -i "$video_file" -vf "scale=2732:768" -c:a copy "${video_file%.mp4}_resized.mp4"
        elif [ "$width" -ge 1366 ] && [ "$height" -eq 769 ]; then
            # Redimensiona a 1366x768.
            ffmpeg -i "$video_file" -vf "scale=1366:768" -c:a copy "${video_file%.mp4}_resized.mp4"
        fi
    fi
done
