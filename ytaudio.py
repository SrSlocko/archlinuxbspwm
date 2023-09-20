
import tkinter as tk
from tkinter import filedialog, messagebox
import subprocess
import os
import re
import pyperclip


def download_and_rename():
    # Obtiene el enlace del campo de entrada de texto
    youtube_url = entry.get()

    # Comprueba si se proporcionó un enlace
    if not youtube_url:
        messagebox.showerror(
            "Error", "Por favor, ingrese un enlace de YouTube.")
        return

    # Obtiene el directorio de destino
    destination_directory = filedialog.askdirectory()

    # Comprueba si se seleccionó un directorio
    if not destination_directory:
        return

    # Cambia al directorio de destino
    os.chdir(destination_directory)

    # Muestra un mensaje en el bloque de texto
    result_text.config(state=tk.NORMAL)
    result_text.delete("1.0", tk.END)
    result_text.insert(tk.END, "Descargando audio en formato MP3...\n")

    # Resto del código para descargar y renombrar sigue igual
    # ...
    # Extrae el enlace base sin parámetros
    youtube_url = youtube_url.split("?si=")[0]

    # Muestra un mensaje en el bloque de texto
    result_text.config(state=tk.NORMAL)
    result_text.delete("1.0", tk.END)
    result_text.insert(tk.END, "Descargando audio en formato MP3...\n")

    # Descarga el audio en formato MP3 utilizando yt-dlp
    try:
        subprocess.run(["yt-dlp", "--format", "bestaudio/best", "--audio-format", "mp3",
                       "--extract-audio", "--audio-quality", "0", "--no-playlist", youtube_url])
        result_text.insert(
            tk.END, "Audio descargado en formato MP3 exitosamente.\n")

        # Itera sobre todos los archivos en el directorio actual
        for archivo in os.listdir():
            # Verifica si el archivo contiene corchetes y su contenido
            if re.search(r'\[.*\]', archivo):
                nuevo_nombre = re.sub(r'\[.*\]', '', archivo)
                os.rename(archivo, nuevo_nombre)
                result_text.insert(
                    tk.END, f"Corchetes y su contenido eliminados en: {archivo}\n")

    except Exception as e:
        messagebox.showerror(
            "Error", f"Hubo un error al descargar el audio: {str(e)}")
        result_text.insert(tk.END, f"Error durante la descarga: {str(e)}\n")

    result_text.config(state=tk.DISABLED)


def paste_link():
    # Pega el enlace de YouTube desde el portapapeles
    youtube_url = pyperclip.paste()
    entry.delete(0, tk.END)
    entry.insert(0, youtube_url)


def close_window():
    main.quit()


# Configuración de la ventana
main = tk.Tk()
main.title("Descargar y Renombrar")

# Etiqueta y campo de entrada de texto
label = tk.Label(main, text="Ingrese el enlace de YouTube:",
                 font=("Arial", 14))
label.pack(pady=10)
entry = tk.Entry(main, width=50, font=("Arial", 12))
entry.pack()

# Botón de descargar y renombrar
download_button = tk.Button(
    main, text="Descargar y Renombrar", command=download_and_rename)
download_button.pack(pady=10)

# Botón de pegar enlace
paste_button = tk.Button(main, text="Pegar Enlace", command=paste_link)
paste_button.pack(pady=10)

# Bloque de texto para mostrar el progreso
result_text = tk.Text(main, font=("Arial", 12),
                      wrap=tk.WORD, state=tk.DISABLED)
result_text.pack(padx=30, pady=10, fill=tk.BOTH, expand=True)

# Botón de cerrar
close_button = tk.Button(main, text="Cerrar", command=close_window)
close_button.pack(pady=10)

# Ejecutar la aplicación
main.mainloop()
