# Reglas de Oro del Proyecto (Rules)

Este archivo actúa como el índice y la **Constitución del directorio `.context`**. Las reglas aquí definidas mandan sobre los demás archivos. 

> [!CAUTION]
> **ESTE ARCHIVO SOLO PUEDE MODIFICARSE O ELIMINARSE SI EL USUARIO DA LA AUTORIZACIÓN EXPRESA.**

## 1. Stack Tecnológico
- **Framework Core**: Flutter
- **Lenguaje de Programación**: Dart
- **Cliente HTTP**: Dio
- **Manejo de Estado Asíncrono**: `FutureBuilder` (Nativo)
- **Gestión de Entorno**: `flutter_dotenv`
- **Manejo de Fechas**: `intl`
- **Manejo de Imágenes/Vectores**: `cached_network_image`, `flutter_svg`

## 2. Idioma y Nomenclatura
- **Código Fuente**: Inglés (Nombres de clases, variables, métodos, archivos).
- **Documentación y Comentarios**: Español.
- **Commits**: Español (siguiendo convenciones de Conventional Commits si aplica).

## 3. Guías de Estilo
- Seguir la guía oficial de estilo de Dart (`flutter_lints`).
- Interfaces de usuario regidas por el archivo `.context/skills/ui/SKILL.md` (Tipografía SNPro, paleta de colores del Mundial 2026).

## 4. Metadatos de la Aplicación
- **Nombre de la App**: WC26 Calendar
- **Ícono de la App**: `assets/icons/icon.png` (se adaptará a formato PNG para los launchers nativos de iOS y Android).

## 5. Gestión del Directorio `.context`
- `rules.md`: Constitución. Requiere autorización para modificar.
- `architecture.md`: Inmutable en estructura. Requiere autorización para modificar.
- `roadmap.md`: Volátil, planificable por el usuario.
- `session.md`: Volátil, registro del progreso diario.
- `skills/`: Contiene habilidades y patrones específicos (UI, alertas, AI).
- `hu/`: Contiene el contexto detallado de las Historias de Usuario.
