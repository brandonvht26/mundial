# HU-01: Ver partidos del día actual

**Prioridad:** Alta
**Riesgo:** Medio

**Descripción:**
Como usuario final que consume la API del Mundial 2026, quiero que al abrir la aplicación se muestren automáticamente los partidos del día actual, para ver de forma inmediata qué encuentros están programados sin necesidad de configurar nada.

**Criterios de Aceptación:**
- **Escenario 1 (Partidos programados):** Dado que la aplicación se inicia y la fecha actual corresponde a un día con partidos, el home screen muestra una lista. Cada tarjeta incluye equipos (local/visitante), marcador (o 'vs' si no ha comenzado), y estadio/fase.
- **Escenario 2 (Sin partidos):** Dado que la aplicación se inicia y la fecha actual no tiene partidos programados, la llamada a la API finaliza exitosamente y se muestra el mensaje "No hay partidos del Mundial en esta fecha" en el centro de la pantalla.
- **Escenario 3 (Error de API):** Dado que la aplicación intenta cargar los partidos, si la llamada a la API falla (red, timeout, inválido), se muestra un mensaje de error descriptivo con el tipo de error para diagnóstico.
- **Escenario 4 (Cargando):** Dado que la aplicación inició la llamada a la API, mientras la petición está en curso, se muestra un indicador de carga circular en el centro de la pantalla.
