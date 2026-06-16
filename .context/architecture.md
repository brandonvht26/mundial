# Arquitectura del Proyecto

> [!CAUTION]
> **Este archivo no puede eliminarse ni actualizarse sin autorización.** Describe la arquitectura estricta que sigue el proyecto para evitar la invención de estructuras o flujos raros por parte de los colaboradores o modelos de IA.

## Patrón Arquitectónico
El proyecto sigue **Clean Architecture con Vertical Slicing**. Esto significa que en lugar de organizar el código por capas técnicas en la raíz, se organiza por **Funcionalidades (Features)**.

## Estructura de Directorios

La estructura base del directorio `lib/` debe ser rigurosamente la siguiente:

```text
lib/
├── features/
│   └── [nombre_del_feature]/ (Ej. matches)
│       ├── domain/
│       │   ├── entities/        # Objetos de negocio puros (independientes de Flutter/APIs)
│       │   ├── repositories/    # Interfaces de contratos (abstract classes)
│       │   └── usecases/        # Casos de uso de la aplicación
│       ├── infrastructure/
│       │   ├── datasources/     # Consumo de APIs (API-Football, REST Countries)
│       │   ├── models/          # DTOs (Data Transfer Objects) con métodos fromJson/toJson
│       │   └── repositories/    # Implementación de los contratos del dominio
│       └── presentation/
│           ├── screens/         # Pantallas principales (Flutter Widgets)
│           ├── widgets/         # Componentes UI reutilizables dentro del feature
│           └── providers/       # (Si aplicara) Lógica de estado específica del feature
└── shared/ (o core/)
    ├── api/                     # Configuración de clientes (DioClient, interceptores)
    ├── theme/                   # Configuración de colores y tipografía global
    ├── utils/                   # Funciones utilitarias (formateo de fechas, etc)
    └── widgets/                 # Widgets globales que se usan en más de un feature
```

## Flujo de Datos
1. La **Presentation** (UI) solicita datos llamando a un **UseCase**.
2. El **UseCase** delega la obtención de la información a un **Repository** (interfaz en *domain*).
3. La implementación del **Repository** (en *infrastructure*) decide si llama a un o varios **DataSources** (ej. remote API).
4. El **DataSource** devuelve un **Model** (infrastructure) que el Repositorio mapea a una **Entity** (domain) pura.
5. La **Entity** es enviada de regreso a la UI, la cual se actualiza de forma reactiva (ej. `FutureBuilder`).
