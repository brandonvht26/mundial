# Roadmap (Hoja de Ruta)

> [!NOTE]
> Este es un archivo volátil. Solo se llenará cuando ejecutemos un plan grande. Puede actualizarse, pero no eliminarse, siempre con autorización del usuario.

## Sprint Actual: Implementación Historias de Usuario (Mundial 2026)
*Estado: Pendiente de inicio*

### Fase 1: Capa de Dominio (Domain)
- **Objetivo**: Crear entidades (`Match`, `Team`, `Country`) y definir los contratos en interfaces de repositorios.
- **Modelo sugerido**: **DeepSeek V4 Pro** (Excelente capacidad de razonamiento lógico y abstracción, ideal para diseñar la arquitectura pura, entidades y contratos sin depender de frameworks externos).

### Fase 2: Capa de Infraestructura (Infrastructure)
- **Objetivo**: Configurar DataSources consumiendo API-Football y REST Countries. Mapear JSON a modelos y luego a entidades del dominio.
- **Modelo sugerido**: **Kimi K2.7 Code** (Al ser un modelo especializado en código, es perfecto para tareas tediosas y precisas como el parseo de JSON, tipado fuerte y manejo de excepciones HTTP con Dio).

### Fase 3: Capa de Presentación (Presentation)
- **Objetivo**: Construir `HomeScreen` y `MatchDetailScreen` consumiendo los casos de uso mediante `FutureBuilder`. Implementar `DatePicker` y animaciones.
- **Modelo sugerido**: **Qwen3.7 Max** o **DeepSeek V4 Pro** (Modelos de altísima capacidad, ideales para estructurar la UI de Flutter, manejar estados reactivos complejos y asegurar que se cumpla el `SKILL.md` de diseño visual).
