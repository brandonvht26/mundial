# Sesión Actual

> [!NOTE]
> Archivo volátil. Se reescribe con todo lo trabajado en la jornada.

## Progreso de la Jornada (Fase 1: Capa de Dominio - COMPLETADA)

### Configuración Base (Sesión Anterior)
- Se configuró el archivo `pubspec.yaml` añadiendo las dependencias requeridas (`dio`, `flutter_dotenv`, `intl`, `cached_network_image`, `flutter_svg`).
- Se definieron e incorporaron las fuentes locales `SNPro` como el estándar tipográfico del proyecto.
- Se configuró el cliente HTTP `DioClient` para soportar interceptores y la variable de entorno `API_FOOTBALL_KEY`.
- Se configuró `.env` (excluido en `.gitignore`) y `.env.example`.
- Se estableció el documento base `.context/skills/ui/SKILL.md` con los colores y directrices de animación.
- Se estructuró el directorio `.context` conformando sus 4 pilares constitucionales.

### Fase 1: Capa de Dominio (Actual)

#### Archivos Creados

**Entities:**
- `lib/features/matches/domain/entities/match_status.dart` — Enum `MatchStatus` con valores: `scheduled`, `live`, `finished`, `unknown`. Incluye getters `isLive`, `isFinished`, `isScheduled`.
- `lib/features/matches/domain/entities/team.dart` — Clase `Team` con atributos: `id` (int), `name` (String), `shortName` (String?), `logoUrl` (String?). Inmutable con `const`, equality por `id`.
- `lib/features/matches/domain/entities/country.dart` — Clase `Country` con atributos: `name` (String), `flagUrl` (String?), `fifaCode` (String?). Inmutable con `const`, equality por `name`.
- `lib/features/matches/domain/entities/match.dart` — Clase `Match` con atributos: `id` (int), `homeTeam` (Team), `awayTeam` (Team), `homeScore` (int?), `awayScore` (int?), `status` (MatchStatus), `dateTime` (DateTime), `stadium` (String?), `group` (String?), `phase` (String). Incluye getter `scoreDisplay` que retorna `'vs'` para partidos no iniciados o el marcador `'X - Y'`. Inmutable con `const`, equality por `id`.

**Repositories (Interfaces):**
- `lib/features/matches/domain/repositories/match_repository.dart` — Clase abstracta `MatchRepository` con dos métodos:
  - `Future<List<Match>> getMatchesByDate(DateTime date)` — Obtiene partidos por fecha.
  - `Future<Match> getMatchDetail(int matchId)` — Obtiene el detalle de un partido específico.

**Use Cases:**
- `lib/features/matches/domain/usecases/get_matches_by_date.dart` — Clase `GetMatchesByDate` que recibe `MatchRepository` por inyección y expone `call(DateTime date)`.
- `lib/features/matches/domain/usecases/get_match_detail.dart` — Clase `GetMatchDetail` que recibe `MatchRepository` por inyección y expone `call(int matchId)`.

### Cobertura de Historias de Usuario
- **HU-01 (Ver partidos del día actual):** Cubierta por `GetMatchesByDate` + `Match` + `Team` + `MatchStatus`.
- **HU-02 (Filtrar partidos por fecha):** Cubierta por `GetMatchesByDate` con parámetro `DateTime`.
- **HU-03 (Ver detalle de un partido):** Cubierta por `GetMatchDetail` + `Match` con todos sus atributos (stadium, group, phase, dateTime, scoreDisplay).

**Próximo paso esperado:**
Iniciar la Fase 2: Capa de Infraestructura (DataSources API-Football y REST Countries, Modelos DTO con fromJson/toJson, e implementación concreta de `MatchRepository`).
