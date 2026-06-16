# Arquitectura del Proyecto

**ESTE ARCHIVO NO PUEDE ELIMINARSE NI ACTUALIZARSE SIN AUTORIZACIÓN DEL USUARIO.** Describe rigurosamente la estructura y flujo de la aplicación.

## Clean Architecture + Feature-First

El proyecto divide la lógica en `core` (utilidades compartidas) y `features` (módulos funcionales, ej. `matches`).

### 1. Capa de Dominio (`domain`)
- **Entities:** Clases puras de Dart que representan los objetos de negocio (ej. `Match`).
- **Use Cases:** Casos de uso específicos de la aplicación (ej. `GetMatchesByDate`, `GetMatchDetail`).
- **Repositories (Interfaces):** Contratos que definen cómo se obtendrán los datos.

### 2. Capa de Infraestructura (`infrastructure`)
- **DataSources:** Fuentes de datos.
  - *Remote:* Se usa `Dio` para llamadas a API (ej. `FootballRemoteDataSource`).
  - *Local:* Fuentes locales (ej. `LocalCountriesDataSource`).
- **Repositories (Implementations):** Implementación de los contratos definidos en `domain` (ej. `MatchRepositoryImpl`), que orquestan los `DataSources`.
- **Models/Mappers:** Modelos de datos para mapear JSON a Entities.

### 3. Capa de Presentación (`presentation`)
- **Screens:** Widgets principales de la pantalla (ej. `HomeScreen`, `MatchDetailScreen`).
- **Widgets:** Componentes visuales reutilizables (ej. `MatchCard`).
- **State Management:** No se utiliza BLoC, Provider ni Riverpod. El estado efímero se maneja con `StatefulWidget` y las peticiones de datos se resuelven visualmente usando `FutureBuilder`.

## Inyección de Dependencias (DI)
Se maneja a través de un patrón *Service Locator* personalizado implementado en `lib/core/service_locator.dart`. La inicialización ocurre en `main.dart` antes de `runApp()`.
