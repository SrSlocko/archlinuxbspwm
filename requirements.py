
import subprocess
import pkg_resources


def install_missing_libraries(requirements_file):
    with open(requirements_file, "r") as file:
        required_libraries = [line.strip() for line in file.readlines()]

    installed_libraries = {pkg.key for pkg in pkg_resources.working_set}

    for library in required_libraries:
        if library not in installed_libraries:
            print(f"Instalando {library}...")
            subprocess.run(["pip", "install", library])


if __name__ == "__main__":
    # Cambia esto al nombre de tu archivo requirements.txt
    requirements_file = "requirements.txt"
    install_missing_libraries(requirements_file)
