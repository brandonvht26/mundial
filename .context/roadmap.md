# Roadmap (Hoja de Ruta)

> [!NOTE]
> Este es un archivo volátil. Solo se llenará cuando ejecutemos un plan grande. Puede actualizarse, pero no eliminarse, siempre con autorización del usuario.

## Sprint Actual: Implementación Historias de Usuario (Mundial 2026)
*Estado: Pendiente de inicio*

### Fase 1: Capa de Dominio (Domain)
- **Objetivo**: Crear entidades (`Match`, `Team`, `Country`) y definir los contratos en interfaces de repositorios.
- **Modelo sugerido**: Gemini 3.1 Pro (Excelente para abstraer lógica de negocio y definir tipados estrictos en Dart).

### Fase 2: Capa de Infraestructura (Infrastructure)
- **Objetivo**: Configurar DataSources consumiendo API-Football y REST Countries. Mapear JSON a modelos y luego a entidades del dominio.
- **Modelo sugerido**: Gemini 3.1 Pro (Potente manejo de estructuras JSON y manejo de errores HTTP con Dio).

### Fase 3: Capa de Presentación (Presentation)
- **Objetivo**: Construir `HomeScreen` y `MatchDetailScreen` consumiendo los casos de uso mediante `FutureBuilder`. Implementar `DatePicker` y animaciones.
- **Modelo sugerido**: Gemini 3.1 Pro (Óptimo para maquetación de UI y uso de widgets nativos siguiendo guías de estilo).
