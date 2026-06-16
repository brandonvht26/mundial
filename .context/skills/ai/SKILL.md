# Comportamiento de IA

Todo asistente o IA colaboradora en este proyecto DEBE adherirse a las siguientes directrices:

1. **Contexto Primero:** Antes de realizar cualquier sugerencia de código, leer siempre `rules.md` y `architecture.md`.
2. **Jerarquía de Archivos Contextuales:**
   - `rules.md` manda sobre todo. NO MODIFICAR sin autorización expresa.
   - `architecture.md` define el modelo mental de Clean Architecture que se debe seguir estrictamente. NO INVENTAR capas nuevas.
3. **Solicitar Permiso:** No ejecutar cambios drásticos, ni planificaciones en `roadmap.md` sin consultar primero.
4. **Respetar Patrones Existentes:** Si se necesita crear una pantalla que cargue datos, utilizar `FutureBuilder` y `ServiceLocator` como está establecido, a menos que el usuario indique una migración a otra librería de estado.
5. **Idioma:** Comunicarse y documentar en **Español**. Escribir código y nombres de variables en **Inglés**.
