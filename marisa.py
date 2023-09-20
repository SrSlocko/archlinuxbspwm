
import json
import difflib


def cargar_cerebro():
    try:
        with open("cerebro.json", "r") as f:
            return json.load(f)
    except FileNotFoundError:
        return {}


def guardar_cerebro(cerebro):
    with open("cerebro.json", "w") as f:
        json.dump(cerebro, f, indent=4)


def buscar_respuesta(cerebro, pregunta):
    pregunta = pregunta.lower()
    if pregunta in cerebro:
        return cerebro[pregunta]
    else:
        matches = difflib.get_close_matches(pregunta, cerebro.keys())
        if matches:
            respuesta = cerebro[matches[0]]
            print(
                f"No tengo una respuesta directa para tu pregunta. ¿Pero quizás quisiste decir '{matches[0]}'?")
            return respuesta
        else:
            return "Lo siento, no tengo respuesta para esa pregunta."


def main():
    print("¡Hola! Soy Marisa. ¿En qué puedo ayudarte?")
    cerebro = cargar_cerebro()

    while True:
        pregunta = input("> ").strip()

        if pregunta.lower() == "salir":
            guardar_cerebro(cerebro)
            print("Hasta luego. ¡Vuelve pronto!")
            break

        if pregunta.lower() == "ver_cerebro":
            print(json.dumps(cerebro, indent=4))
            continue

        if pregunta.startswith("aprender "):
            _, archivo = pregunta.split(" ", 1)
            try:
                with open(archivo, "r") as f:
                    codigo = f.read()
                exec(codigo)
                print(f"He aprendido algo nuevo del archivo '{archivo}'.")
            except Exception as e:
                print(f"No pude aprender del archivo '{archivo}': {str(e)}")
            continue

        respuesta = buscar_respuesta(cerebro, pregunta)
        print(respuesta)


if __name__ == "__main__":
    main()
