# Patrón de Diseño UI/UX

Este proyecto sigue una estética moderna e inmersiva adaptada a la temática del Mundial 2026.

## Principios
- **Material Design:** Adaptado y estilizado.
- **Tema Central:** Se utiliza un tema personalizado definido en `AppTheme` (`core/theme/app_theme.dart`).
- **Colores:** Se emplea una paleta basada en `AppTheme` (ej. `hermesBlue`, `darkHeatherGrey`, `torchRed`, gradientes personalizados).
- **Tipografía:** Se utiliza `google_fonts`, específicamente una familia de fuentes `SNPro` declarada en `pubspec.yaml` o de Google Fonts.
- **Animaciones:** El proyecto hace uso intensivo de `flutter_animate` para dar vida a la UI. (Por ejemplo, los elementos de la lista en `HomeScreen` usan un `.fade()` y `.slideY()` secuencial).
- **Componentes:** Se priorizan componentes visualmente limpios (Cards), contenedores con imágenes de fondo translúcidas/gradientes y elementos con bordes redondeados.
