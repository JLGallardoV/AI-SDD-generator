---
name: react-native-expo
description: Use when working in React Native + Expo + TypeScript apps. Defines architecture + engineering conventions: feature-first folders (features/<entidad>/pages + components), path aliases (@shared/@features/@services/@database/@storage/@config/@utils), HTTP layer (ApiResponse wrapper, ErrorHandler, Bearer auth), Zustand stores with selectors, SQLite offline-first Outbox pattern, SecureStore sessions, NetInfo sync listener, camera + GPS capture, Spanish JSDoc + 3-blank-line style, and security best practices (OWASP). Do NOT use for backend projects (use nest-backend).
---

# React Native + Expo Conventions

Convenciones y reglas de diseño para aplicaciones móviles **React Native + Expo (TypeScript)**.
La arquitectura **del sistema/proyecto** (tipo de app, módulos, backend, despliegue) se define
en el SDD (`06-architecture.md`), no aquí.

> **Delegación a pilares (anti-duplicación).** Los atributos de calidad viven en las skills
> transversales y aquí solo se referencian:
> - Seguridad → skill `security` (aquí solo lo propio de Expo: SecureStore, permisos).
> - Rendimiento → skill `performance`.
> - Usabilidad/accesibilidad → skill `usability`.
> - Pruebas → skill `testing`.
> - Limpieza/mantenibilidad → skill `clean-code`.
> - Observabilidad → skill `observability`.

## 1. Estructura de carpetas (feature-first por entidad)

```
«app-mobile»/
├── app.json / app.config.ts
├── App.tsx
├── babel.config.js / metro.config.js / tsconfig.json
└── src/
    ├── config/                 # environment.config.ts, theme.config.ts
    ├── database/               # sqlite.database.ts, migrations.migration.ts, repositories/*.repository.ts
    ├── services/               # http/*.service.ts, netinfo/*.service.ts, location/*.service.ts, filesystem/*.service.ts
    ├── shared/
    │   ├── components/<X>/     # X.component.tsx (+ index.ts barrel)
    │   ├── constants/          # *.constant.ts
    │   ├── enums/              # *.enum.ts
    │   ├── hooks/              # *.hook.ts (globales)
    │   ├── interfaces/         # *.interface.ts (compartidas + components.interface.ts)
    │   ├── services/outbox/    # outbox.service.ts
    │   ├── store/              # *.store.ts (Zustand globales, ej. outbox.store.ts)
    │   └── utils/              # *.util.ts
    └── features/<entidad>/
        ├── interfaces/         # <entidad>.interface.ts + components.interface.ts
        ├── pages/              # <Entidad>Page.page.tsx (orquestador de pantalla)
        ├── components/<X>/     # X.component.tsx (+ index.ts barrel)
        ├── hooks/              # *.hook.ts de la entidad
        └── services/
            ├── *.service.ts    # llamadas REST / casos de uso de la entidad
            └── store/          # *.store.ts (Zustand de la entidad)
```

Nota: **no hay carpetas raíz `storage/` ni `store/`**. La sesión (`expo-secure-store`) vive en
`features/auth/services/store/secure-store.store.ts`, y los stores/servicios globales (Outbox) en
`shared/store/` y `shared/services/`. Las interfaces **nunca** se declaran junto a la lógica: viven en
`features/<entidad>/interfaces/` o `shared/interfaces/`.

### 1.1 Jerarquía de componentes por entidad

`Page (orquestador: estado + HTTP) → componentes de sección → componentes presentacionales`

- **`pages/`**: pantalla principal/orquestadora (`<Entidad>Page`). Integra el estado, las llamadas HTTP y la composición de secciones.
- **`components/`**: elementos de la entidad (encabezado, cards, secciones, footer). Reciben props; no hacen HTTP.
- **`components/modales/`**: modales dedicados (`<modal-nombre>/` con su subcarpeta `components/` si tienen partes complejas).
- La comunicación entre componentes hermanos se hace por el store de la entidad o por props desde la page. No se pasan callbacks por cadenas largas.

## 2. Stack tecnológico

- **React Native + Expo (TypeScript)** — versión LTS más reciente.
- **Estado global**: **Zustand** con selectores. Sin Redux, sin Context para estado de servidor.
- **Base de datos local**: `expo-sqlite` (API asíncrona moderna).
- **Sesión**: `expo-secure-store` (nunca `AsyncStorage` para tokens).
- **Conectividad**: `@react-native-community/netinfo`.
- **Cámara**: `expo-camera`. **Ubicación**: `expo-location`. **Archivos**: `expo-file-system`.
- **Navegación**: `@react-navigation/native` + `native-stack`.
- **Pruebas**: `jest-expo` + `@testing-library/react-native`.

## 3. Aliases de rutas (`tsconfig.json` + `babel.config.js`)

Configurar y usar estrictamente:

- `@config/*`   → `src/config/*`
- `@database/*` → `src/database/*`
- `@storage/*`  → `src/storage/*`
- `@services/*` → `src/services/*`
- `@store/*`    → `src/store/*`
- `@shared/*`   → `src/shared/*`
- `@features/*` → `src/features/*`
- `@utils/*`    → `src/shared/utils/*`

## 4. Capa HTTP y convenciones globales

- **Cliente único** en `src/services/http/` (wrapper de `fetch`), con:
  - URL base desde `environment.apiEndpoint`.
  - Inyección automática del `Authorization: Bearer <token>`.
  - `Content-Type: application/json` (o `multipart/form-data` en archivos).
  - Manejo central de errores con timeout y `AbortController`.
- **Response wrapper**: el backend responde `{ response: T }`. El cliente desenvuelve y devuelve `T`, tipado.
- **Manejo global de errores** en un `ErrorHandler`:
  - `400/404/422`: mostrar alerta con `error.response`.
  - `401`: intentar refrescar sesión; si falla, limpiar sesión y volver al login.
  - `0` / timeout: marcar como pendiente de reintento (no descartar datos).
  - `5xx`: alerta genérica y reintento por Outbox.
- **Sin duplicar lógica de red** en componentes: siempre por el servicio de la entidad.

## 5. Gestión de estado (Zustand)

- Un store por dominio: `<entidad>.store.ts` (y globales como `outbox.store.ts`).
- Estado y acciones viven en el store; **los componentes solo leen selectores y llaman acciones**.
- Selectores finos para evitar re-render (`useAuthStore(s => s.token)`).
- El estado derivado (totales, contadores, cálculos) se calcula con funciones puras fuera del componente, no dentro del `render`.
- Persistencia: el estado crítico se respalda en SQLite o SecureStore, nunca solo en memoria.

## 6. Persistencia local (SQLite + Outbox)

- Conexión única en `src/database/sqlite.ts`; migraciones versionadas en `src/database/migrations.ts` (`PRAGMA user_version`).
- Tablas locales típicas (patrón):
  - catálogos cacheados (`catalogo_*`);
  - `«evento»_pendientes` (caché de elementos elegibles);
  - `outbox_*` (payload JSON + estado + intentos + último error);
  - `outbox_archivos` (URI local de cada archivo, nunca el binario en la DB).
- **Estados de Outbox**: `PENDIENTE`, `ENVIANDO`, `ERROR`.
- **Regla de oro**: un registro del Outbox se elimina **solo** con `HTTP 201`. Tras eliminar el registro se borran los archivos locales asociados.
- Las consultas SQLite son asíncronas y parametrizadas; nunca concatenar valores.
- Todo acceso a SQLite pasa por un repositorio (`src/features/<x>/services/` o `src/database/`), nunca directo desde un componente.

## 7. Sincronización

- Listener de NetInfo a nivel raíz (`useNetworkListener`).
- Al recuperar red: procesar el Outbox en orden FIFO, un registro a la vez.
- Reintentos con backoff; tras N intentos el registro queda en `ERROR` visible al usuario.
- Los catálogos y los pendientes se refrescan al iniciar sesión y al recuperar red; si no hay red se usa la caché local.

## 8. Seguridad y autenticación

> **Principios y OWASP → skill `security`.** Aquí solo lo específico de Expo/RN:

- **Tokens**: access + refresh en `expo-secure-store`. Nunca en `AsyncStorage`, estado persistido sin cifrar ni logs.
- **Refresco**: al recibir `401`, un único intento de refresh; si falla, cerrar sesión.
- **Arranque offline**: si no hay red, permitir el acceso con la sesión local válida (token en caché) sin bloquear al usuario.
- **Permisos**: solicitar cámara/ubicación/archivos en contexto, explicando el motivo; manejar el caso denegado sin romper el flujo.
- **Captura en contexto**: la obligatoriedad de datos (p. ej. ubicación) se define en el SDD; el cliente valida antes de enviar para dar retroalimentación rápida.
- **Payload ofuscado**: si el backend envía sesión/privilegios ofuscados, desofuscar en un servicio dedicado (ver skill `nest-backend`); nunca loguear el resultado.
- **No loguear** tokens, contraseñas, coordenadas ni datos personales.
- **No hardcodear** credenciales, API keys ni URLs de producción en el código.
- **Validación**: la validación del servidor es la fuente de verdad.
- **Enlaces/URLs**: no abrir URLs construidas con datos del usuario.

## 9. Estilo de código y estándares

> **Principios de código limpio → skill `clean-code`.** Aquí solo el estilo de RN/Expo:

- Componentes **funcionales** con hooks. Un componente por archivo.
- Tipado estricto; prohibido `any` sin justificación.
- **JSDoc obligatorio en español** en **todo** método, función, componente y tipo (público o interno), no solo al inicio del archivo:

```ts
/**
 * @description Describe qué hace la función
 * @param {string} nombre - Descripción del parámetro
 * @author [Autor] | YYYY-MM-DD
 * @returns {Promise<Resultado>} Descripción del retorno
 */
```

- **3 líneas en blanco** entre miembros/funciones de un mismo archivo.
- Sin comentarios innecesarios; el código debe explicarse solo.
- Nombres de archivos con sufijo de tipo `<nombre>.<tipo>.ts(x)` (kebab-case para el nombre):
  - `.interface.ts`, `.enum.ts`, `.constant.ts`, `.config.ts`, `.model.ts`, `.store.ts`, `.service.ts`, `.repository.ts`, `.util.ts`, `.hook.ts`, `.component.tsx`, `.page.tsx`, `.navigation.tsx`, `.migration.ts`, `.database.ts`.
  - Pruebas: `<archivo>.spec.ts(x)`.
  - Entradas y barriles sin sufijo: `App.tsx`, `index.ts`, `main.ts`, `babel.config.js`, etc.
  - Componentes en `PascalCase`; hooks con prefijo `use` (`useOutbox.hook.ts`).

## 10. UI y sistema de diseño

> **Usabilidad y accesibilidad → skill `usability`.** Aquí solo la mecánica de estilo:

- **Tema centralizado** en `src/config/theme.ts` (tokens de color, spacing, tipografía, radios). Consumir los tokens; **no** repetir valores hex sueltos.
- El **sistema visual** (paleta, semáforos, branding) se define en el SDD/`06-architecture.md`; la skill no fija colores.
- Componentes base reutilizables en `@shared/components` (botón, input, toggle, chip, card, badge, progreso, header).
- Estilos con `StyleSheet` o utilidades tipadas.
- Accesibilidad: `accessibilityLabel`, áreas táctiles mínimas de 44px, contraste adecuado.
- El prototipo/diseño visual es la fuente de verdad del layout cuando exista.

## 11. Pruebas (obligatorias)

> **Estrategia y DoD → skill `testing`.** Aquí solo el framework del stack:

- Framework: `jest-expo` + `@testing-library/react-native`.
- Comandos: `pnpm test` (jest-expo, one-shot) y `pnpm run typecheck` (según el gestor del proyecto).
- Probar comportamiento y contratos, no detalles de implementación.
- Casos mínimos por feature: camino feliz, validaciones, errores de red y reglas de negocio.
- Toda prueba nueva se registra en `<projectName>-sdd/09-testing.md` con su ID antes de reportar el cambio como terminado.

## 12. Documentación oficial (verificar siempre)

- **Regla**: antes de implementar cualquier API o patrón, consultar la documentación oficial vigente de la versión en uso. No asumir firmas ni imports de memoria; la doc oficial gana ante cualquier suposición.
  - Expo: `https://docs.expo.dev/`
  - React Native: `https://reactnative.dev/docs/`
  - React Navigation: `https://reactnavigation.org/docs/`
  - Zustand: `https://zustand.docs.pmnd.rs/`

## 13. Dependencias — autorización obligatoria

- **Regla rectora**: NO instalar ninguna dependencia sin antes avisar exactamente qué se va a instalar (paquete, versión y por qué) y obtener autorización explícita.
- Instalar con el gestor del proyecto (nunca `.ps1` en Windows).
- No añadir librerías sin necesidad; preferir APIs nativas de Expo cuando existan.

## 14. Archivos `*.env` — privacidad

- **NUNCA** leer ni versionar `*.env`.
- Las variables del móvil viven en el `.env` de la app (gitignored) y se exponen vía `app.config.ts` / `environment.ts` con `EXPO_PUBLIC_*` (Expo las inyecta al empaquetar: hay que reiniciar Metro tras cambiarlas). Recordar que el bundle móvil es público: **nunca** poner secretos de backend en el cliente.
- `EXPO_PUBLIC_API_URL` debe apuntar a la IP de LAN de la máquina de desarrollo cuando se usa Expo Go en un teléfono físico (`localhost` no es alcanzable desde el teléfono).

## 15. Principio de Responsabilidad Única (SRP)

> **Principios de código limpio → skill `clean-code`.** Aquí el SRP aplicado a RN/Expo:

- **Cada función/método hace una sola cosa** y su nombre lo dice; si mezcla validación + acceso a datos + armado de estado/UI, se parte.
- **Stores delgados**: el store orquesta y expone estado; la lógica de carga, transformación y armado de payload vive en helpers/servicios puros (`services/*.data.ts`, `services/*.payload.ts`) y en `shared/utils`.
- **Componentes presentacionales vs orquestadores**: `pages/` orquesta (estado + HTTP); los `components/` reciben props y no llaman HTTP ni SQL.
- **Acceso a datos encapsulado**: todo SQLite/HTTP pasa por repositorios/servicios, nunca desde componentes ni dentro de acciones grandes del store.
- Si un método supera ~40 líneas o tiene más de una razón para cambiar, extráelo a un helper puro o a un método privado con responsabilidad única.
