
from googletrans import Translator


def obtener_sugerencias_idioma(texto):
    translator = Translator()
    deteccion = translator.detect(texto)
    idioma_detectado = deteccion.lang
    confianza = deteccion.confidence

    return idioma_detectado, confianza


def traducir_texto(texto, idioma_destino):
    try:
        translator = Translator()
        texto_traducido = translator.translate(texto, dest=idioma_destino)
        return texto_traducido.text
    except ValueError:
        return f"'{idioma_destino}' no es un idioma de destino válido. Ejemplo: 'en' para inglés."


def main():
    texto = input("Ingresa el texto que deseas traducir: ")

    idioma_destino = input(
        "Presiona Enter para traducir al inglés o ingresa un código de idioma (ejemplo: 'fr' para francés): ")

    if not idioma_destino:
        # Si no se ingresa un idioma, asume que se desea traducir al inglés
        idioma_destino = 'en'

    # Llama a la detección de idioma solo si no se ingresó un idioma explícito
    if idioma_destino == 'auto':
        idioma_detectado, confianza = obtener_sugerencias_idioma(texto)

        if confianza > 0.5:
            print(
                f"Idioma detectado: {idioma_detectado} (Confianza: {confianza})")
        else:
            print("No se pudo detectar el idioma con suficiente confianza.")

    texto_traducido = traducir_texto(texto, idioma_destino)
    print(f"Texto traducido: {texto_traducido}")


if __name__ == "__main__":
    main()
