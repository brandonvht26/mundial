# Reglas del Proyecto (Rules)

Este archivo actúa como la constitución del proyecto y define las reglas de oro. **ESTE ARCHIVO SOLO PUEDE SER MODIFICADO CON LA AUTORIZACIÓN EXPLÍCITA DEL USUARIO**.

## Stack Tecnológico
- **Framework:** Flutter
- **Lenguaje:** Dart
- **Dependencias Principales:** 
  - `dio` (Cliente HTTP)
  - `google_fonts` (Tipografías)
  - `intl` (Internacionalización y manejo de fechas)
  - `flutter_animate` (Animaciones de UI)
  - `cached_network_image` / `flutter_svg` (Manejo de imágenes)

## Patrones y Arquitectura
- **Arquitectura:** Clean Architecture (Domain, Infrastructure, Presentation) orientada a Features (Feature-First).
- **Inyección de Dependencias:** Implementación propia de Service Locator (`core/service_locator.dart`), sin uso de librerías externas como `get_it`.
- **Manejo del Estado:** Uso nativo de Flutter mediante `StatefulWidget`, `setState` y `FutureBuilder` para asincronía.

## Guías de Estilo y Lenguaje
- **Código Fuente:** Nombres de variables, clases, métodos y archivos deben estar en **Inglés**.
- **Interfaz de Usuario (UI):** Todos los textos visibles para el usuario deben estar en **Español** (ej. "Calendario FIFA WC26").
- **Documentación y Contexto (.context):** Debe mantenerse en **Español**.
- **Estilo de Código:** Seguir las reglas de `flutter_lints`.

## Relación con otros archivos de contexto
- `architecture.md`: Manda sobre la estructura técnica. No debe contradecir a `rules.md`.
- `roadmap.md` y `session.md`: Archivos volátiles para gestión y seguimiento.
- `skills/`: Patrones de diseño y comportamiento específico.
