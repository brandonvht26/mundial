# Manejo de Alertas y Errores

## Lista de Fallos Posibles y Reacción del Sistema

1. **Error de Conexión / Fetch de Datos (Dio / Async):**
   - **Detección:** Ocurre en el `FutureBuilder` (`snapshot.hasError`).
   - **Reacción de UI:** Se muestra un ícono de error (`Icons.error_outline`) con el color `AppTheme.torchRed` y el texto del error. El usuario tiene la capacidad de intentar nuevamente mediante un pull-to-refresh (`RefreshIndicator`).

2. **Listas Vacías (No Data):**
   - **Detección:** La respuesta del Future es una lista vacía.
   - **Reacción de UI:** Se muestra un mensaje amigable indicando la ausencia de datos ("No hay partidos del Mundial en esta fecha") y se envuelve en un `RefreshIndicator` para permitir forzar la actualización.

## Directrices para Nuevas Alertas
- **Snackbars:** Usar para confirmaciones de éxito o errores menores no bloqueantes.
- **Diálogos:** Para confirmar acciones críticas.
- **In-Screen States:** Preferir mostrar los errores dentro del layout de la pantalla (como en `HomeScreen`) en lugar de ventanas modales intrusivas si la carga principal de la página falla.
