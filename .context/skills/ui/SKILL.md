# UI Design Pattern & Skills - Mundial 2026

## Paleta de Colores
El proyecto utiliza una paleta de colores inspirada en los 3 países anfitriones del Mundial 2026, buscando representar la identidad de cada uno junto con colores neutros para fondos y detalles.

- **Canadá (Rojo Antorcha / Torch Red)**: `#E61D25` (RGB: 230, 29, 37) - Usar para acentos, alertas o elementos destacados.
- **Estados Unidos (Azul Hermes / Hermes Blue)**: `#2A398D` (RGB: 42, 57, 141) - Color principal (Primary), ideal para AppBars, botones principales y fondos de tarjetas importantes.
- **México (Verde Medio / Average Green)**: `#3CAC3B` (RGB: 60, 172, 59) - Usar para estados de éxito, botones de acción secundaria o indicadores de partidos "En vivo".
- **Detalles (Gris Claro / Light Gray)**: `#D1D4D1` (RGB: 209, 212, 209) - Usar para bordes, divisores, texto secundario y fondos de tarjetas.
- **Fondos (Gris Oscuro / Dark Heather Grey)**: `#474A4A` (RGB: 71, 74, 74) - Color de fondo principal de la aplicación (Scaffold Background) para un aspecto moderno y resaltado de los colores vivos.

## Estilo Visual y Animación
Para lograr una experiencia de usuario de primera calidad (Premium), el diseño debe adherirse a los siguientes principios:

1. **Fluidez y Dinamismo**:
   - Todas las transiciones entre pantallas (como la navegación al detalle del partido con `Navigator.push`) deben sentirse suaves.
   - Usar `Hero` animations al hacer tap en la tarjeta de un partido hacia la vista de detalle para dar continuidad visual (por ejemplo, animar el escudo o marcador).

2. **Prolijo y Suave**:
   - Sombras sutiles y bordes redondeados (border radius de 12px a 16px) en las tarjetas de partidos (`Card`).
   - Evitar diseños abarrotados. Mantener márgenes y paddings generosos (`16px` o `20px` de espacio uniforme).

3. **Interactividad sin saturar**:
   - Feedback visual al presionar elementos (usar `InkWell` o `MaterialButton` nativo de Flutter para mostrar el ripple effect).
   - Indicadores de carga elegantes (un `CircularProgressIndicator` o `CupertinoActivityIndicator` estilizado con los colores de la marca, o un skeleton loader suave) cuando el `FutureBuilder` esté en estado `waiting`.

## Tipografía
Para complementar el diseño premium, se ha establecido la familia tipográfica **SN Pro** (archivos locales `SNPro-Regular.ttf` y `SNPro-Bold.ttf` ubicados en `assets/fonts`) como el estándar del proyecto. Toda la aplicación utilizará esta fuente, configurada en el `ThemeData`, por lo que no usaremos `google_fonts`.

## Componentes UI Clave
- **Date Picker**: Al abrirse, debe mantener el contraste adecuado con la paleta de colores y tener las fechas deshabilitadas claramente marcadas visualmente (del 11 de junio al 19 de julio de 2026).
- **Match Card**: Debe ser limpia. Fondo gris claro o blanco, texto oscuro o contraste alto. Mostrar escudos claramente, marcador (o `vs`), y detalles de fecha/fase sutiles.
