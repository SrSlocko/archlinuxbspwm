
#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Uso: $0 <nombre_del_archivo.py>"
    exit 1
fi

python_file="$1"
requirements_file="requirements.txt"  # Cambia esto al nombre de tu archivo requirements.txt

if [ ! -f "$python_file" ]; then
    echo "El archivo $python_file no existe."
    exit 1
fi

# Obtén una lista de todas las bibliotecas utilizadas en el archivo de Python
python_libraries=$(grep -oE "import [A-Za-z0-9_]+" "$python_file" | cut -d' ' -f2)

# Instala las bibliotecas del archivo requirements.txt
while read -r library; do
    if ! pip show "$library" &>/dev/null; then
        echo "Instalando $library desde $requirements_file..."
        pip install "$library"
    fi
done < "$requirements_file"

# Instala las bibliotecas utilizadas en el archivo de Python
for library in $python_libraries; do
    if ! pip show "$library" &>/dev/null; then
        echo "Instalando $library desde $python_file..."
        pip install "$library"
    fi
done
