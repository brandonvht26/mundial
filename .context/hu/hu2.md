# HU-02: Filtrar partidos por fecha

**Prioridad:** Alta
**Riesgo:** Bajo

**Descripción:**
Como usuario final que usa la aplicación del Mundial 2026, quiero seleccionar una fecha específica mediante un DatePicker, para consultar los partidos programados en cualquier día del torneo sin estar limitado a la fecha actual.

**Criterios de Aceptación:**
- **Escenario 1 (Selección con partidos):** Dado que el usuario abre el DatePicker, elige una fecha válida (dentro del Mundial 2026) que tiene partidos y confirma, la pantalla realiza una nueva llamada a la API con la fecha seleccionada y actualiza la lista.
- **Escenario 2 (Selección sin partidos):** Dado que el usuario selecciona una fecha del torneo sin partidos programados, cuando la llamada a la API finaliza, se muestra el mensaje "No hay partidos del Mundial en esta fecha".
- **Escenario 3 (Rango limitado):** Dado que el usuario abre el DatePicker, este deshabilita e impide seleccionar fechas anteriores al 11 de junio de 2026 y posteriores al 19 de julio de 2026, manteniendo la vigencia de la fecha actual si lo intenta.
- **Escenario 4 (Cancelar selección):** Dado que el usuario abre el DatePicker y lo cierra sin confirmar ninguna fecha, la pantalla mantiene la fecha y la lista de partidos que tenía previamente intactas.
