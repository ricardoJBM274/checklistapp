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

---

## Especificaciones Técnicas

### Arquitectura de la Aplicación
La app utiliza una estructura de navegación jerárquica y gestión de estado local:
1. **Vista de Proyectos (Dashboard):** Gestión de múltiples manuales.
2. **Vista de Pasos (Detalle):** Organización interna de cada manual mediante `ReorderableListView`.
3. **Editor de Pasos:** Formulario de captura multimedia y metadatos (Título/Descripción).

### Gestión de Datos (Persistencia)
Para garantizar el costo $0 y la privacidad, la app no utiliza bases de datos en la nube. En su lugar, implementa:
- **JSON Local:** Los proyectos se serializan y guardan en `proyectos_v2.json` dentro del directorio de documentos del sistema.
- **Sistema de Archivos:** Las imágenes capturadas se copian desde el directorio temporal del sistema a una ruta permanente interna de la app para evitar su borrado accidental.

### Dependencias Clave
```yaml
dependencies:
  image_picker: ^1.0.7    # Captura de fotos y acceso a galería
  path_provider: ^2.1.2   # Localización de carpetas de sistema
  path: ^1.9.0            # Manipulación de rutas de archivos
  pdf: ^3.10.8            # Motor de generación de documentos PDF
  printing: ^5.11.1       # Previsualización y envío a impresión
---
### 👨‍💻 Autor
Ricardo Javier Beltran Estudiante de Desarrollo de Software - Universidad Luterana Salvadoreña Enfocado en la optimización de procesos.
