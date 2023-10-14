
import psutil

# Función para obtener la temperatura de la CPU


def obtener_temperatura_cpu() -> float | str:
    """Una función que devuelve la temperatura de la CPU

    Returns:
        float | str: El valor de temperatura en grados Celsius o 'NA' si la información de temperatura no está disponible
    """
    try:
        # Obtiene información de temperatura utilizando psutil
        # y accede al primer valor de temperatura en la clave 'coretemp'
        temperatura = psutil.sensors_temperatures()['coretemp'][0].current
        return temperatura
    except (KeyError, IndexError):
        # Maneja casos en los que la información de temperatura no está disponible
        return "NA"

# Función para obtener la utilización de RAM y CPU del sistema


def obtener_utilizacion_ram_y_cpu() -> list:
    """Obtiene la utilización de la RAM y la CPU del sistema

    Returns:
        list: Contiene la memoria total del sistema, el porcentaje utilizado y el porcentaje de CPU utilizado
    """
    estadisticas_memoria = psutil.virtual_memory()
    return [
        # Memoria total disponible en el sistema (MB)
        estadisticas_memoria[0]//(1024*1024),
        estadisticas_memoria[2],  # Porcentaje de memoria utilizada
        # Porcentaje de CPU utilizado
        psutil.cpu_percent(interval=4, percpu=True)
    ]


# Llama a la función obtener_temperatura_cpu() para obtener la temperatura de la CPU
temperatura_cpu = obtener_temperatura_cpu()

# Llama a la función obtener_utilizacion_ram_y_cpu() para obtener datos sobre la utilización de recursos del sistema
utilizacion_sistema = obtener_utilizacion_ram_y_cpu()

# Imprime la información del sistema
if (type(utilizacion_sistema[2]) == list):
    porcentaje_cpu = ""
    for i in utilizacion_sistema[2]:
        porcentaje_cpu += "{}%, ".format(i)
else:
    porcentaje_cpu = '{}%'.format(utilizacion_sistema[2])

print(
    f"La temperatura actual de la CPU en grados Celsius es {temperatura_cpu}°C, con un porcentaje de utilización del CPU de {porcentaje_cpu}")
print(
    f"La utilización actual de la RAM es del {utilizacion_sistema[1]}% de {utilizacion_sistema[0]} MB")
