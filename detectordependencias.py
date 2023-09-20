import platform
import subprocess

# Detectar el sistema operativo
system = platform.system()

# Función para instalar dependencias en Linux usando 'apt' (Debian/Ubuntu)


def install_dependencies_debian():
    try:
        subprocess.run(["sudo", "apt", "update"])
        subprocess.run(["sudo", "apt", "install", "python3-tk",
                       "python3-pip", "python3-pyperclip"])
        subprocess.run(["pip3", "install", "--upgrade",
                       "-r", "requirements.txt"])
        subprocess.run(["sudo", "pip3", "install", "yt-dlp"])
        print("Dependencias instaladas en Debian/Ubuntu.")
    except Exception as e:
        print(f"Error al instalar dependencias en Debian/Ubuntu: {str(e)}")

# Función para instalar dependencias en Linux usando 'dnf' (Fedora)


def install_dependencies_fedora():
    try:
        subprocess.run(["sudo", "dnf", "install",
                       "python3-tkinter", "python3-pip", "python3-pyperclip"])
        subprocess.run(["pip3", "install", "--upgrade",
                       "-r", "requirements.txt"])
        subprocess.run(["sudo", "pip3", "install", "yt-dlp"])
        print("Dependencias instaladas en Fedora.")
    except Exception as e:
        print(f"Error al instalar dependencias en Fedora: {str(e)}")

# Función para instalar dependencias en Linux usando 'pacman' (Arch Linux)


def install_dependencies_arch():
    try:
        subprocess.run(["sudo", "pacman", "-S", "--noconfirm",
                       "python-tk", "python-pip", "python-pyperclip"])
        subprocess.run(["pip", "install", "--upgrade",
                       "-r", "requirements.txt"])
        subprocess.run(["sudo", "pip", "install", "yt-dlp"])
        print("Dependencias instaladas en Arch Linux.")
    except Exception as e:
        print(f"Error al instalar dependencias en Arch Linux: {str(e)}")

# Función para instalar dependencias en Linux usando 'apt' (Kali Linux)


def install_dependencies_kali():
    try:
        subprocess.run(["sudo", "apt", "update"])
        subprocess.run(["sudo", "apt", "install", "python3-tk",
                       "python3-pip", "python3-pyperclip"])
        subprocess.run(["pip3", "install", "--upgrade",
                       "-r", "requirements.txt"])
        subprocess.run(["sudo", "pip3", "install", "yt-dlp"])
        print("Dependencias instaladas en Kali Linux.")
    except Exception as e:
        print(f"Error al instalar dependencias en Kali Linux: {str(e)}")


# Verificar el sistema operativo y llamar a la función correspondiente
if system == "Linux":
    try:
        with open("/etc/os-release", "r") as os_file:
            os_info = os_file.read()
            if "arch" in os_info.lower():
                install_dependencies_arch()
            elif "fedora" in os_info.lower():
                install_dependencies_fedora()
            elif "kali" in os_info.lower():
                install_dependencies_kali()
            else:
                install_dependencies_debian()
    except FileNotFoundError:
        print("No se pudo determinar la distribución Linux.")
elif system == "Windows":
    # Instalar dependencias en Windows usando 'pip'
    try:
        subprocess.run(["pip", "install", "--upgrade",
                       "-r", "requirements.txt"])
        subprocess.run(["pip", "install", "yt-dlp"])
        print("Dependencias instaladas en Windows.")
    except Exception as e:
        print(f"Error al instalar dependencias en Windows: {str(e)}")
else:
    print(f"Sistema operativo no compatible: {system}")
