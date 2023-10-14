
"""
    Descargador de archivos

    Este script en Python permite a los usuarios descargar archivos de Internet, independientemente de su tamaño. Solo necesitas tener la URL y estás listo.
"""
import os
import requests
from tqdm import tqdm
import math
import time

# Solicita al usuario que ingrese la URL del archivo que desea descargar.
url = input("Ingresa la URL del archivo que deseas descargar: ")

# Realiza una solicitud GET a la URL para obtener los encabezados de respuesta, incluyendo 'Content-Length'.
r = requests.get(url)
# Obtiene los datos de la URL.

# Obtiene el tamaño del archivo a partir del encabezado 'Content-Length'.
file_size = int(r.headers['Content-Length'])

# Define el tamaño de fragmento (chunk_size) como 256 bytes, la cantidad de datos que se descargará a la vez.
chunk_size = 256

# Realiza una solicitud GET nuevamente con stream=True para obtener los datos en secuencias (chunks).
r = requests.get(url, stream=True)

# Obtiene la extensión del archivo a partir de la URL.
extension = (os.path.splitext(url))[-1]
# Crea el nombre del archivo con la extensión.
file = "archivo" + extension

# Calcula el número de iteraciones requeridas para descargar el archivo en fragmentos.
iterations = math.ceil(file_size / chunk_size)

# Abre el archivo en modo binario ("wb") con el nombre "archivo" más la extensión del archivo.
with open(file, "wb") as file:
    for chunk in tqdm(r.iter_content(chunk_size=chunk_size), total=iterations):
        # Pausa durante medio segundo (0.5 segundos) después de descargar cada fragmento.
        time.sleep(0.5)
        # Escribe el fragmento descargado en el archivo local.
        file.write(chunk)
