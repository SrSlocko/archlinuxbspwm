#!/bin/bash

# Obtener la lista de redes Wi-Fi disponibles
nmcli dev wifi list | awk 'NR > 1 {print NR-2, $2, $3, $5}'

# Mostrar la lista de redes Wi-Fi con números
if [ $? -eq 0 ]; then
    read -p "Ingresa el número de la red Wi-Fi a la que deseas conectarte: " numero_red

    # Verificar si el número de red es válido
    if [[ $numero_red -ge 0 && $numero_red -lt ${#redes_wifi[@]} ]]; then
        ssid="${redes_wifi[$numero_red]}"
        # Solicitar al usuario que ingrese la contraseña
        read -s -p "Ingresa la contraseña de la red Wi-Fi '$ssid': " password
        echo

        # Iniciar una barra de progreso
        (
            for ((i = 0; i <= 100; i++)); do
                echo $i
                sleep 0.1  # Ajusta el tiempo de espera para que la barra de progreso avance más lentamente
            done
        ) | dialog --title "Conectando a $ssid" --gauge "Porcentaje completado" 10 70 0

        # Conectar a la red Wi-Fi
        nmcli device wifi connect "$ssid" password "$password"

        # Comprobar si la conexión fue exitosa
        if [ $? -eq 0 ]; then
            echo "Conexión a '$ssid' exitosa."
        else
            echo "No se pudo conectar a '$ssid'. Verifica la contraseña."
        fi
    else
        echo "Número de red no válido. Ejecuta el script nuevamente y selecciona un número de red válido."
    fi
else
    echo "No hay redes Wi-Fi disponibles. :("
fi

# Mostrar la imagen ASCII desde el archivo "nekoarc.txt"
if [ -f "nekoarc.txt" ]; then
    cat "nekoarc.txt"
fi
