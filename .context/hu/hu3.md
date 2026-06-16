# HU-03: Ver detalle de un partido

**Prioridad:** Media
**Riesgo:** Bajo

**Descripción:**
Como usuario final que revisa los partidos del Mundial 2026, quiero tocar una tarjeta de partido en la lista para navegar a una pantalla de detalle, donde pueda ver información completa del encuentro como los equipos, el marcador actual, el estadio, el grupo, la fase y la fecha y hora local.

**Criterios de Aceptación:**
- **Escenario 1 (Navegación):** Dado que el usuario ve la lista en el home screen, al tocar la tarjeta de un partido, la aplicación navega (`Navigator.push`) a la pantalla de detalle y consulta la API con el ID del partido.
- **Escenario 2 (Información completa):** Dado que la pantalla cargó exitosamente, se muestran nombres de equipos, marcador/'vs', estadio, grupo (si aplica), fase del torneo y fecha/hora convertida a la hora local del dispositivo.
- **Escenario 3 (Regreso al home):** Dado que el usuario está en el detalle, al presionar el botón de retroceso (dispositivo o AppBar), la app regresa al home screen manteniendo la misma lista y fecha que tenía antes.
- **Escenario 4 (Sin grupo):** Dado que el partido corresponde a una fase eliminatoria (sin agrupación), el campo "grupo" no se muestra en pantalla (no deja espacio vacío ni genera error).
