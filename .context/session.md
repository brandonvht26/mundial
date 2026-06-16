# Sesión Actual

> [!NOTE]
> Archivo volátil. Se reescribe con todo lo trabajado en la jornada.

## Progreso de la Jornada

### Configuración Base (Sesión Anterior)
- Se configuró el archivo `pubspec.yaml` añadiendo las dependencias requeridas (`dio`, `flutter_dotenv`, `intl`, `cached_network_image`, `flutter_svg`).
- Se definieron e incorporaron las fuentes locales `SNPro` como el estándar tipográfico del proyecto.
- Se configuró el cliente HTTP `DioClient` para soportar interceptores y la variable de entorno `API_FOOTBALL_KEY`.
- Se configuró `.env` (excluido en `.gitignore`) y `.env.example`.
- Se estableció el documento base `.context/skills/ui/SKILL.md` con los colores y directrices de animación.
- Se estructuró el directorio `.context` conformando sus 4 pilares constitucionales.

### Fase 1: Capa de Dominio (Completada)

**Entities creadas:**
- `lib/features/matches/domain/entities/match_status.dart` — Enum `MatchStatus`.
- `lib/features/matches/domain/entities/team.dart` — Entidad `Team`.
- `lib/features/matches/domain/entities/country.dart` — Entidad `Country`.
- `lib/features/matches/domain/entities/match.dart` — Entidad `Match` con getter `scoreDisplay`.

**Repositories / UseCases:**
- `lib/features/matches/domain/repositories/match_repository.dart` — Interfaz `MatchRepository`.
- `lib/features/matches/domain/usecases/get_matches_by_date.dart` — `GetMatchesByDate`.
- `lib/features/matches/domain/usecases/get_match_detail.dart` — `GetMatchDetail`.

### Fase 2: Capa de Infraestructura (Completada)

**Models (DTOs):**
- `lib/features/matches/infrastructure/models/team_model.dart` — `TeamModel` con `fromJson` y `toEntity`.
- `lib/features/matches/infrastructure/models/country_model.dart` — `CountryModel` con `fromJson` y `toEntity`.
- `lib/features/matches/infrastructure/models/match_model.dart` — `MatchModel` con parseo de API-Football, mapping de status y derivación de grupo/fase.

**DataSources:**
- `lib/features/matches/infrastructure/datasources/football_remote_datasource.dart` — `FootballRemoteDataSource` usando `DioClient`.
- `lib/features/matches/infrastructure/datasources/countries_remote_datasource.dart` — `CountriesRemoteDataSource` consumiendo REST Countries.

**Repository Implementation:**
- `lib/features/matches/infrastructure/repositories/match_repository_impl.dart` — `MatchRepositoryImpl` orquestando ambas APIs.

### Fase 3: Capa de Presentación (Actual — COMPLETADA)

**Service Locator:**
- `lib/core/service_locator.dart` — Inyección de dependencias manual. Instancia `DioClient`, `FootballRemoteDataSource`, `CountriesRemoteDataSource`, `MatchRepositoryImpl`, `GetMatchesByDate` y `GetMatchDetail`.

**main.dart actualizado:**
- Carga `.env` con `flutter_dotenv`.
- Inicializa `initializeDateFormatting('es')` para formato de fechas en español.
- Llama a `ServiceLocator.init()`.
- Usa `AppTheme.lightTheme` y arranca en `HomeScreen`.

**Widgets:**
- `lib/features/matches/presentation/widgets/team_badge.dart` — `TeamBadge`:
  - Detecta automáticamente si la URL es SVG (usa `flutter_svg`) o PNG/JPG (usa `cached_network_image`).
  - Placeholder elegante con ícono de escudo.
  - Soporte para `Hero` animation mediante parámetro `tag`.
- `lib/features/matches/presentation/widgets/match_card.dart` — `MatchCard`:
  - Tarjeta con `InkWell` para efecto ripple.
  - Bordes redondeados (16px) y sombras sutiles.
  - Muestra fase, estado (EN VIVO / Finalizado), equipos con `TeamBadge`, marcador con `Hero`, estadio y hora.
  - Usa `intl` para formateo de hora local.

**Screens:**
- `lib/features/matches/presentation/screens/home_screen.dart` — `HomeScreen`:
  - `FutureBuilder` para manejar estado asíncrono de `GetMatchesByDate`.
  - Carga partidos del día actual por defecto (`DateTime.now()`).
  - AppBar con ícono de calendario que abre `showDatePicker`.
  - DatePicker bloqueado estrictamente del 11/Jun/2026 al 19/Jul/2026.
  - Al cambiar fecha, refresca el `FutureBuilder` con `setState`.
  - Maneja estados: carga circular, vacío ("No hay partidos del Mundial en esta fecha"), error descriptivo.
  - Navega a `MatchDetailScreen` con `Navigator.push` al tocar tarjeta.
- `lib/features/matches/presentation/screens/match_detail_screen.dart` — `MatchDetailScreen`:
  - `FutureBuilder` para cargar detalle con `GetMatchDetail(matchId)`.
  - Muestra información completa: fase, grupo (si aplica), equipos con `TeamBadge` (tamaño 80px), marcador con `Hero`, estadio, fecha/hora local, fase.
  - `Hero` animations entre tarjetas del home y pantalla de detalle (escudos y marcador).
  - Grupo condicional: no se muestra si es `null` (fase eliminatoria).
  - Conversión de fecha/hora UTC a hora local con `intl` en formato español.
  - Maneja estados de carga y error.

### Cobertura de Historias de Usuario
- **HU-01 (Ver partidos del día actual):** ✅ `HomeScreen` carga automáticamente partidos de hoy. Maneja estados vacío, error y carga.
- **HU-02 (Filtrar partidos por fecha):** ✅ DatePicker bloqueado 11/Jun - 19/Jul 2026. Refresca lista al cambiar fecha. Cancelar mantiene estado previo.
- **HU-03 (Ver detalle de un partido):** ✅ `MatchDetailScreen` muestra toda la info. Navegación con `Navigator.push`. Grupo condicional. Hora local con `intl`. Hero animations premium.

**Sprint completado:** Las 3 fases del roadmap (Dominio, Infraestructura, Presentación) están finalizadas. La aplicación WC26 Calendar está lista para ejecutarse.
