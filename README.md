# Checklistapp

**Checklistapp** es una aplicación móvil desarrollada con **Flutter** y **Dart** diseñada para profesionales y técnicos que necesitan documentar procesos paso a paso. La aplicación permite crear múltiples manuales, organizar pasos de forma visual con fotografías y descripciones, y exportar el resultado final a un documento **PDF** listo para compartir.

Este proyecto nació como un ejercicio de aprendizaje autónomo sobre la **IA Agéntica** y la optimización de procesos productivos en 2026.

## Características principales

- **Gestión de Manuales:** Crea y organiza diferentes proyectos o guías técnicas de forma independiente.
- **Registro Visual de Pasos:** Captura evidencia fotográfica (vía cámara o galería) para cada fase del proceso.
- **Edición Dinámica:** Títulos y descripciones detalladas para cada instrucción.
- **Interfaz Reordenable (Drag & Drop):** Cambia el orden de los pasos simplemente arrastrándolos con el dedo.
- **Persistencia Local (JSON):** Todos tus datos se guardan de forma segura en el dispositivo, sin necesidad de servidores externos.
- **Exportación a PDF:** Genera manuales profesionales con formato estructurado en un solo clic.

## Tecnologías utilizadas

- **Lenguaje:** [Dart](https://dart.dev/)
- **Framework:** [Flutter](https://flutter.dev/)
- **Almacenamiento:** Archivos JSON locales con `path_provider`.
- **Manejo de Imágenes:** `image_picker`.
- **Generación de Documentos:** `pdf` y `printing`.

## Instalación y Configuración

Sigue estos pasos para ejecutar el proyecto en tu entorno local:

1. **Clonar el repositorio:**
   ```bash
   git clone [https://github.com/ricardoJBM274/checklistapp](https://github.com/tu-usuario/checklistapp.git)
