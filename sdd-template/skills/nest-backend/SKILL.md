---
name: nest-backend
description: >-
  Use ONLY when the project is a NestJS backend with raw SQL (engine-agnostic:
  MySQL, PostgreSQL, SQL Server, SQLite). Triggers when creating or modifying
  DAOs, services, controllers, models, entity modules, SQL queries,
  transactions, JWT auth with refresh tokens (Valkey/Redis sliding session),
  email notifications, or payload obfuscation. Do NOT use for frontend projects
  (another skill covers those). Follow the folder architecture, JSDoc standard
  (author | YYYY-MM-DD), 3-blank-line spacing, pool/transaction pattern (all
  writes in a transaction), descriptive SQL aliases, logging, security (helmet),
  environment config, emailing and payload obfuscation. Always consult the latest
  official NestJS docs and the driver docs for the chosen engine.
---

# Nest Backend Conventions

Convenciones para backends NestJS con **SQL puro** (sin ORM). Motores soportados: **MySQL, PostgreSQL, SQL Server, SQLite**.

> IMPORTANTE: Este skill aplica SOLO a proyectos backend NestJS. Si el proyecto es frontend, no aplicar.

> **Delegación a pilares (anti-duplicación).** Los atributos de calidad viven en las skills
> transversales y aquí solo se referencian:
> - Seguridad → skill `security` (este documento solo añade lo propio de NestJS: helmet, guards).
> - Rendimiento/escalabilidad → skills `performance` y `scalability`.
> - Pruebas → skill `testing`.
> - Limpieza/mantenibilidad → skill `clean-code`.
> - Observabilidad → skill `observability` (aquí solo el logger winston de NestJS).

## 0. Automejora (fuentes oficiales)

> **Automejora obligatoria.** Antes de generar el skill/spec definitivo del proyecto, el agente
> **debe** obtener las buenas prácticas oficiales vigentes y actualizar el *Snapshot*.
> - **Fuente oficial (framework):** `https://docs.nestjs.com/`
> - **Fuente de versiones (LTS):** framework `https://docs.nestjs.com/` · runtime Node LTS `https://nodejs.org/en/about/previous-releases` · drivers en la sección de motores.
> - **Regla:** digerir y **reemplazar el Snapshot**; nunca borrar las convenciones de equipo del skill.

### Snapshot vigente (verificar versión al actualizar)
- NestJS moderno: módulos por entidad, DI con `inject`/constructor, `ValidationPipe` global, `Helmet`, guards/interceptors/filters globales, `OnModuleInit`/`OnModuleDestroy` para ciclo de vida.
- Sin ORM: SQL puro con driver nativo y parámetros; **toda escritura en transacción**.
- Ciclo de vida: cerrar pool/sockets/workers en `onModuleDestroy` (ver "Sin resource leaks").

## Folder architecture

```
src/
├── config/
│   ├── database.config.ts        # pool del driver de datos elegido (configurable)
│   ├── http-exception.config.ts  # AllExceptionsFilter (filtro global de excepciones)
│   └── logger.config.ts          # logger winston (rotación diaria, timestamp de la zona configurada)
├── decorators/
│   ├── token-free.decorator.ts   # @TokenFree() → rutas públicas (sin JWT)
│   └── extend-session.decorator.ts # @ExtendSession() → ventana deslizante de sesión
├── guards/
│   └── jwt-auth.guard.ts         # guard global de autenticación (3 capas: JWT, refresh, sliding)
├── interceptors/
│   ├── camel-to-snake.interceptor.ts  # body camelCase → snake_case (entrada)
│   └── cookie-injector.interceptor.ts # reinyecta cookies tras renovación de tokens
├── services/
│   ├── crypto.service.ts         # CryptoService (bcrypt + ofuscación de respuestas)
│   ├── emailing.service.ts       # EmailingService (nodemailer)
│   └── session.service.ts        # ValkeyService (store de refresh tokens + TTL)
├── utils/
│   ├── file-validator.util.ts    # validación de archivos (uploads)
│   └── time.util.ts              # timestamp en la zona horaria configurada (util)
├── entities/
│   └── <entidad>/
│       ├── <entidad>.module.ts   # registra controllers + providers (pool, daos, services)
│       ├── controllers/          # ListarXxxController, InsertarXxxController (HTTP, por operación)
│       ├── dao/                  # listarXxx.dao.ts, insertarXxx.dao.ts (solo queries)
│       ├── models/               # interfaces DTO (prefijo I, ej. IEntidad)
│       └── services/             # ListarXxxService, InsertarXxxService (lógica de negocio)
└── main.ts
```

Nota: los modelos globals entre entidades viven en una entidad `globals/models/` (ej. `IJwtPayload`) y se importan desde las demás entidades.

## Comentarios (estándar JSDoc)

Todos los métodos —públicos, privados y funciones auxiliares— llevan JSDoc con este formato exacto:

```ts
/**
 * @description Describe qué hace el método
 * @param {string} nombre - Descripción del parámetro
 * @author [Autor] | YYYY-MM-DD
 * @returns {Promise<boolean>} Descripción del retorno
 */
public async metodo(param: string): Promise<boolean> { ... }
```

## Espacio entre métodos

Entre método y método se dejan **3 líneas en blanco**.

## Principio de Responsabilidad Única (SRP)

- **Cada método hace una sola cosa** y su nombre lo dice. Si un método mezcla validación + acceso a datos + armado de respuesta (o supera ~40 líneas), se parte en métodos privados de responsabilidad única.
- **Los services orquestan, no acumulan**: coordinan DAOs y helpers; la transformación/armado vive en métodos privados o utilidades puras.
- **Fronteras claras**: DAO solo consulta, Controller es capa HTTP fina, Service es lógica de negocio. Respetarlas es aplicar SRP.
- **Funciones puras** de cálculo/formateo en `src/utils/` o métodos privados puros, nunca embebidas en un método grande.

## Capa de datos (SQL puro, driver-agnostic)

> El **motor** se elige en el SDD (`01-discovery.md` / `04-data-model.md`) y se liga
> `[FIXED ← skill: nest-backend · driver: <motor>]`. Usar siempre la **última versión estable**
> del driver y su doc oficial (ver tabla). **Sin ORM.**

- **Pool único** en `src/config/database.config.ts`, reutilizado por toda la app (nunca un pool por petición).
- **Queries parametrizadas** según el driver (`?` en MySQL/SQLite, `$1..$n` en PostgreSQL, `input()`/named en SQL Server); nunca interpolar input.
- **Alias descriptivos**: en SQL usar alias completos (`usuario`, `empleado`, `pedido`); **nunca** de una letra (`u`, `e`, `p`) ni abreviaturas crípticas.
- **Mapeo de filas** a interfaces camelCase (alias `columna AS campoCamel` en SQL o mapeo en TS).
- **Esquema calificado**: `esquema.tabla`.
- **Paginación**: `LIMIT ? OFFSET ?` (offset = inicio - 1, limit = fin - inicio + 1).
- **SELECT de columnas necesarias**: no usar `SELECT *`; proyectar solo los campos del DTO.
- **Transacciones**: **toda operación de escritura** va dentro de una transacción mediante el helper `withTransaction(fn)` (abre conexión, `BEGIN`, `COMMIT`/`ROLLBACK`, `release` en `finally`). Las lecturas puras usan el pool directo.
- **Resource leaks**: toda conexión/stream/recurso se libera (`release`/`close` en `finally`); ver "Sin resource leaks".

### Drivers soportados

| Motor | Driver (última versión) | Pool | Placeholders | Transacción | Insert/RETURNING | Fechas/tipos | Doc oficial |
|---|---|---|---|---|---|---|---|
| MySQL | `mysql2` | `createPool` | `?` | `beginTransaction`/`commit`/`rollback` | `insertId` | `dateStrings: true` (string) | https://sidorares.github.io/node-mysql2/docs |
| PostgreSQL | `pg` | `new Pool()` | `$1..$n` | `BEGIN`/`COMMIT`/`ROLLBACK` (client) | `RETURNING` | parser/tipos; ajustar por columna | https://node-postgres.com/ |
| SQL Server | `mssql` (tedious) | `new ConnectionPool()` | `request.input('x', val)` | API `transaction` | `OUTPUT` / `SCOPE_IDENTITY()` | tipos nativos `mssql` | https://github.com/tediousjs/node-mssql |
| SQLite | `better-sqlite3` / `node:sqlite` | `new Database()` | `?` / named | `BEGIN`/`COMMIT` | `lastInsertRowid` / `RETURNING` | tipos dinámicos | https://github.com/WiseLibs/better-sqlite3 |

**Pool (ejemplos):**
```ts
// MySQL (mysql2)
import * as mysql from 'mysql2/promise';
export const AppPool = mysql.createPool({ host: process.env.DB_HOST, user: process.env.DB_USER, password: process.env.DB_PASSWORD, database: process.env.DB_NAME, port: Number(process.env.DB_PORT), dateStrings: true });

// PostgreSQL (pg)
import { Pool } from 'pg';
export const AppPool = new Pool({ host: process.env.DB_HOST, user: process.env.DB_USER, password: process.env.DB_PASSWORD, database: process.env.DB_NAME, port: Number(process.env.DB_PORT), ssl: process.env.DB_SSL === 'true' ? { rejectUnauthorized: false } : false });
```

**Transacción con helper `withTransaction` (patrón estándar):**
```ts
export async function withTransaction<T>(fn: (conn: PoolConnection) => Promise<T>): Promise<T> {
  const conn = await AppPool.getConnection();
  try {
    await conn.beginTransaction();
    const result = await fn(conn);
    await conn.commit();
    return result;
  } catch (error) {
    await conn.rollback();
    logger.error('Transacción revertida', error.stack);
    throw error;
  } finally {
    conn.release();   // SIEMPRE liberar (evita fugas del pool)
  }
}
```
> El helper se adapta al driver (PG: `BEGIN`/`COMMIT` vía `client.query`; SQL Server: `transaction`). Los DAOs reciben `conn?` y usan `const db = conn || AppPool;`.

## Nomenclatura de métodos (solo `src/entities/`)

Todo método de **entidad o subentidad** (DAOs, services y controllers dentro de `src/entities/`) usa
uno de estos prefijos según la operación:

| Prefijo | Uso |
|---|---|
| `insertar` | crea una fila/registro (`insertarEntidad`, `insertarDetalle`). |
| `actualizar` | modifica una fila existente (`actualizarUltimoAcceso`). |
| `upsert` | inserta o actualiza según exista. |
| `eliminar` | borra o desactiva (`eliminarRegistro`). |
| `validar` | comprueba una regla y devuelve boolean/estado (`validarPermiso`). |
| `listar` | **toda lectura**: listas, un booleano, un id, una sola columna-bandera o una fila (`listarEntidades`, `listarPorEvento`, `listarCatalogo`). |

- El nombre incluye la entidad/subentidad: `insertarDetalles`, `listarActividades`.
- **Los servicios transversales de `src/services/` (crypto, emailing, orion, session), guards,
  interceptors y config NO se rigen por esta convención.**
- Los métodos privados utilitarios conservan su nombre descriptivo (`mapear`, `construirX`,
  `parsearX`, `normalizarX`, `escaparLike`, `firmarToken`).

## DAO — solo queries, sin lógica

- Solo ejecutan queries y mapean filas a interfaces; nunca mezclar lógica de negocio.
- Retornan DTOs (interfaces de models), no filas crudas.
- Un archivo por operación: `listarX.dao.ts`, `insertarX.dao.ts`, `actualizarX.dao.ts`, `eliminarX.dao.ts`.
- try/catch → `logger.error(...)` (con stack y contexto) + `throw error`.

## Service — lógica de negocio

- Inyectar DAOs/servicios por constructor (`private readonly xDao: XDao`).
- Un archivo/método por operación: `listarX.service.ts`, `insertarX.service.ts`, `validarX.service.ts`.
- Métodos pequeños y cohesivos (orquestador + privados); evitar métodos espagueti.
- **Toda escritura** se ejecuta dentro de una transacción mediante el helper `withTransaction`; las lecturas puras usan el pool directo.
- try/catch → `logger.error(...)` (con stack y contexto) + `throw error`.

## Controller — capa HTTP fina

- `@Controller('ruta')`, un archivo por operación o agrupado; rutas `@Get()`, `@Post()`, etc.
- Retorna siempre `{ response: ... }` (wrapper estándar que espera el frontend).
- Acceso a sesión: `@Request() request: { jwtPayload: IJwtPayload }`.
- `@TokenFree()` en rutas públicas (login, sso-check, health).
- `@ExtendSession()` en rutas que deben renovar la ventana deslizante.
- try/catch → `logger.error(...)` (con stack y contexto) + `throw error` (el filtro global lo formatea).

```ts
@Controller('catalogos')
export class ListarXxxController {
  constructor(private readonly listarXxxService: ListarXxxService) { }

  @Get('areas')
  public async listarAreas(): Promise<{ response: ICatalogo[] }> {
    try {
      const areas = await this.listarXxxService.listarAreas();
      return { response: areas };
    } catch (error) {
      logger.error('Error listando áreas', error.stack);
      throw error;
    }
  }
}
```

## Autenticación JWT + Refresh Token (importante)

Arquitectura de sesión con access token (JWT) en cookie + refresh token (UUID) en cookie httpOnly, con sesión en Valkey/Redis (ventana deslizante).

### Cookies de sesión
- `<app>` → access JWT (httpOnly: false en dev).
- `<app>_refresh` → refresh token UUID (httpOnly: true, anti-XSS).
- Opciones: `secure: process.env.NODE_ENV === 'production'`, `sameSite: 'lax'`, `path: '/'`, `maxAge` acorde al TTL.

### main.ts (configuración global)
```ts
import helmet from 'helmet';
// ...
const app = await NestFactory.create(AppModule);
app.use(helmet()); // headers de seguridad HTTP
app.use(cookieParser());
if (process.env.NODE_ENV === 'development') {
  app.enableCors({ origin: [...orígenes], credentials: true, methods: [...], allowedHeaders: [...] });
}
app.setGlobalPrefix('api/<version>');
app.useGlobalFilters(new AllExceptionsFilter());
app.useGlobalGuards(new JwtAuthGuard(app.get(JwtService), app.get(Reflector), app.get(ValkeyService)));
app.useGlobalInterceptors(new CookieInjectorInterceptor());
await app.listen(process.env.PORT ?? 3000);
```

### JwtAuthGuard — 3 capas
1. **Rutas públicas**: si `@TokenFree()` → permite sin token.
2. **Extracción**: lee cookies `<app>` (JWT) y `<app>_refresh`; si falta alguna → 401.
3. **Verificación JWT**: `verifyAsync` con `JWT_SECRET`; guarda payload en `request['jwtPayload']`. Si el JWT **expiró** → Capa 2: consultar Valkey con el refresh token; si la sesión vive, regenerar JWT (`ignoreExpiration`) y setear `request['nuevoToken']`; si no → 401.
4. **Ventana deslizante**: si la ruta tiene `@ExtendSession()` → extender TTL del refresh token en Valkey, regenerar JWT y setear `request['nuevoToken']` + `request['extendRefreshCookie']`.

### Flujo de login
1. DAO valida usuario/credenciales + permisos de app (bitmask).
2. `bcrypt.compare(password, hash)`.
3. Firmar access JWT (`JWT_SECRET`, `JWT_EXPIRES_IN`, `JWT_ALGORITHM`).
4. Generar refresh token: `randomUUID()`.
5. Persistir en Valkey: `refresh_token:<uuid>` → idUsuario, TTL 8h.
6. Setear cookies `<app>` y `<app>_refresh`.
7. Ofuscar el payload del usuario (sesión + privilegios) y retornar `{ response: <string ofuscado> }` (ver "Ofuscación de payload y privilegios").

### CookieInjectorInterceptor
Después de cada respuesta, si `request['nuevoToken']` → reescribe cookie `<app>`; si `request['extendRefreshCookie']` → reescribe cookie `<app>_refresh`. Mantiene la sesión viva en el navegador sin re-login.

### Valkey/Redis (session store)
- `saveRefreshToken(token, idUsuario)` → `SET refresh_token:<token> idUsuario EX <ttl>`.
- `getUserIdByToken(token)` → `GET refresh_token:<token>`.
- `extendSessionTTL(token)` → `EXPIRE refresh_token:<token> <ttl>` (devuelve 1 si existe).
- Conectar en `onModuleInit`, cerrar en `onModuleDestroy`.

## Excepciones globales (AllExceptionsFilter)

- Es la **red de seguridad final**: SIEMPRE registrar cada excepción no manejada con stack y contexto; nunca dejar que un error llegue al cliente sin loguearse.
- `HttpException` → usa su `status` y `message` (404 → 'Recurso no encontrado').
- Otras → `500 Internal server error`.
- Loguea con winston: status, método, URL, `jwtPayload.idtest`, body y stack.
- Responde `{ response: message }` (no expone stack traces).

## Logging (winston) — crítico

> **Estrategia de observabilidad (logs/métricas/trazas) → skill `observability`.** Aquí solo la implementación NestJS/winston:

- **Regla rectora**: atrapar y registrar los errores de la app es exageradamente importante. Ningún `catch` debe silenciar errores: SIEMPRE registrar el error en el logger (con contexto y stack) antes de re-lanzarlo o responder.
- Logger global en `src/config/logger.config.ts`, transporte `DailyRotateFile` a `logs/<año>/<mes>/<nombre>.log`, timestamp en la zona horaria configurada (`«timestampUtil»('full')`).
- `AllExceptionsFilter` loguea TODA excepción (HTTP e interna) con contexto: status, método, URL, `jwtPayload.idtest`, body y stack.
- Usar el `Logger` de `@nestjs/common` (por nombre de clase) en services, guards e interceptors para logs de contexto; en errores críticos usar el logger winston global.
- Logs de operaciones importantes (login, logout, cambios sensibles, refresco de sesión).
- No loguear PII ni payloads completos en producción.

## Fechas

- `dayjs` para formatear fechas; util de timestamp (`«timestampUtil»`) para logs en la zona horaria configurada del negocio.

## Env (development.env)

- Cargado con el flag nativo de Node: `nest start --watch --env-file development.env`.
- Vars típicas: `PORT`, `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASSWORD`, `JWT_SECRET`, `JWT_EXPIRES_IN`, `JWT_ALGORITHM`, `VALKEY_HOST`, `VALKEY_PORT`, `OBFUSCATION_KEY`, `SMTP_HOST`, `SMTP_PORT`, `SMTP_SECURE`, `EMAIL_USER`, `EMAIL_PASS`, `NODE_ENV`.
- Notas por motor: **MySQL** `DB_*` (+ `dateStrings`); **PostgreSQL** `DB_*` (+ `DB_SSL`, `search_path`); **SQL Server** `DB_*` (+ `DB_ENCRYPT`); **SQLite** `DB_FILE`.
- Usar `process.env.VAR` con fallback (`|| valorDefault`).

## Archivos *.env — privacidad (regla obligatoria)

- **NUNCA leer archivos `*.env`** (`.env`, `development.env`, `.env.*`, etc.) a menos que el usuario lo autorice explícitamente.
- Los secretos solo se usan vía `process.env.NOMBRE_VAR`. Si necesitas saber qué variables existen, infiérelo del código (ej. `src/config/database.config.ts` lee `process.env.DB_USER`, `DB_PASSWORD`, `DB_NAME`).
- **NUNCA** enviar el contenido ni los valores de esos archivos a servidores externos, ni incluirlos en respuestas, logs, commits o imágenes Docker.
- Confirmar que `.gitignore` excluye los archivos `*.env`.

## Dependencias

- **Regla rectora**: NO instalar ninguna dependencia sin antes **avisar al usuario exactamente qué se va a instalar** (paquetes, versiones y por qué) y **obtener su autorización explícita**.
- Instalar siempre con `pnpm` (ej. `pnpm add <paquete>`, `pnpm add -D <paquete>`).
- Nunca usar `npm install` ni `yarn add` sin autorización.
- No añadir librerías sin necesidad; al añadir, indicar el paquete y su uso.
- Stack base (framework + auth + emails): `@nestjs/jwt`, `bcrypt`, `cookie-parser`, `dayjs`, `nodemailer`, `iovalkey` (o `redis`), `helmet`, `winston`, `winston-daily-rotate-file`, `ms`; dev: `@types/*` correspondientes.
- **Driver de datos** (elegir según el motor, **última versión estable**): `mysql2` \| `pg` \| `mssql` \| `better-sqlite3` (o `node:sqlite`).

## Seguridad (específico de NestJS)

> **Principios, OWASP y checklist → skill `security`.** Aquí solo lo propio de NestJS:

- **Helmet**: instalar `helmet` y registrarlo en `main.ts` con `app.use(helmet())` para headers de seguridad HTTP (X-Content-Type-Options, HSTS, X-Frame-Options, etc.).
- **Guards**: `@TokenFree()` en rutas públicas; guard global en el resto. Autorización por rol/recurso en el servidor.
- **SQL Injection**: queries parametrizadas según el driver (`?` o `$n`); nunca interpolar input.
- **Errores al cliente**: delegar en el `AllExceptionsFilter`; no exponer stack traces.
- **CORS**: en desarrollo, solo orígenes conocidos con `credentials: true`.
- **Secretos**: vía `process.env` desde `*.env` (gitignored); nunca hardcodear.

## Rendimiento (específico de NestJS)

> **Método y presupuestos → skills `performance` y `scalability`.** Aquí solo lo propio del stack:

- **Un solo pool** reutilizado globalmente; no crear pool por petición.
- **Paginación** con `LIMIT/OFFSET` en lotes razonables.
- **Evitar N+1**: traer lotes y procesarlos en bloque.
- **Índices** en columnas de JOIN/filtro.
- **SELECT de columnas necesarias**; no `SELECT *`.
- **Transacciones**: toda escritura en transacción (helper `withTransaction`); siempre `release`/`close` en `finally`.

## Sin resource leaks (anti bill-shock, específico de NestJS)

> Evitar fugas que consuman recursos (y dinero) de forma indefinida. Revisar esto **antes de dar por terminada** cualquier característica.

- **Conexiones**: siempre `release()` (pool) / `close()` en `finally`; nunca dejar conexiones colgadas (el pool se agota).
- **Pool/DB**: cerrar el pool en `onModuleDestroy`; no crear pools por petición.
- **Timers/intervalos**: limpiar `setInterval`/`setTimeout` (`clearInterval`/`clearTimeout`) y procesos de fondo en `onModuleDestroy`.
- **Listeners/suscripciones**: dar de baja (`removeListener`/`unsubscribe`) y cerrar sockets/clientes.
- **Streams/archivos**: cerrar (`stream.destroy()`/`close`) en `finally`.
- **Workers/hijos**: terminar (`kill`) los `child_process`/workers; no dejar *runaway processes*.
- **Apagado limpio**: implementar `onModuleDestroy` + `enableShutdownHooks` para liberar todo.
- **Coste**: nada que mantenga cómputo/egress/almacenamiento corriendo indefinidamente.

## Email service

- `src/services/emailing.service.ts` — clase `@Injectable()`, usa nodemailer.
- Método genérico `enviarCorreo(de, para, asunto, cuerpo, esMasivo, incluirFirma, archivo?)`.
- Config desde `process.env`: `SMTP_HOST`, `SMTP_PORT`, `SMTP_SECURE`, `EMAIL_USER`, `EMAIL_PASS`.
- Se registra como provider en los módulos que lo usen.

## Modelos

- Interfaces con prefijo `I` (ej. `IEntidad`).
- Usar `Partial<IEntidad>` para retornos parciales de DAO.
- Campos nullable en BD → tipar con `null` (ej. `fechaAlta: Date | string | null`).
- Campos opcionales con `?`.

## Generación de PDFs (pdfmake) — lado servidor

- **Regla rectora**: los PDFs se generan SIEMPRE en el backend con `pdfmake` y se entregan como
  `{ response: { base64: string } }`; el frontend solo convierte a Blob y descarga (ver skill `angular-frontend` §12).
- Instalar `pdfmake` (+ dev `@types/pdfmake`) y, en Node, usar la instancia con API de servidor vía
  `createRequire` (evita el juego de tipos del build de navegador):
  ```ts
  const requireNode = createRequire(__filename);
  const pdfMakeNode = requireNode('pdfmake') as {
    createPdf(doc: any): { getBuffer(): Promise<Buffer> };
    setLocalAccessPolicy(cb: (archivo: string) => boolean): void;
    setFonts(fuentes: any): void;
  };
  ```
- Fuentes Roboto locales (no requieren descargas): apuntar `FONT_DIR` a
  `node_modules/pdfmake/build/fonts` y llamar `setLocalAccessPolicy` solo para ese directorio + `setFonts` con
  `Roboto-Regular/Medium/Italic/MediumItalic.ttf`. El documento usa `defaultStyle.font: 'Roboto'`.
- Imágenes/logo: leer el archivo con `fs.readFileSync` y convertirlo a `data:image/png;base64,...` para usarlo en el
  documento (evita dependencia del `localAccessPolicy`).
- Generar con `await pdfMakeNode.createPdf(doc).getBuffer()` → `Buffer.from(buffer).toString('base64')`.
- Estructura típica: servicio `@Injectable()` (ej. `XxxPdfService`) con `construirDocumento` (contenido, estilos) y
  `generar(...)` con try/catch + `logger.error`. Endpoint controlador `@ExtendSession()` devuelve `{ response: { base64 } }`.

## Ofuscación de payload y privilegios (hacia el frontend)

> **Objetivo:** que un usuario curioso **no pueda leer fácilmente** la sesión/privilegios desde la
> consola del navegador o el storage. Es **ofuscación, no cifrado** (la clave viaja al cliente): la
> autorización real SIEMPRE se impone en el servidor (ver skill `security`).

- **`CryptoService`** (`src/services/crypto.service.ts`): además de bcrypt, expone `ofuscar(plano: string): string` y `desofuscar(ofuscado: string): string`, simétricas e invertibles.
- **Algoritmo por defecto (ligero, sin dependencias):**
  1. `UTF-8` del JSON → **XOR** contra un keystream derivado de la clave.
  2. Anteponer un **nonce aleatorio** por payload (evita huellas repetidas).
  3. `Base64` del `nonce + cipher`.
  - Inverso: `Base64` → separar `nonce` → `XOR` → `UTF-8`.
- **Clave:** `process.env.OBFUSCATION_KEY` (nunca hardcodeada). `«OBFUSCATION_KEY»` la comparte el frontend.
- **Uso:** en el login (y respuestas sensibles), armar el payload de sesión + privilegios y devolver `{ response: <string ofuscado> }`. El frontend lo desofusca (ver skill `angular-frontend` §6.1).
- **Alternativas:** si se necesita cifrado "de verdad", usar AES-GCM (`crypto.subtle`/WebCrypto) con clave derivada; sigue siendo ofuscación del lado cliente. La decisión se registra en `07-security.md` del SDD.
- **Nunca** loguear el payload ofuscado/desofuscado ni la clave.

## Documentación oficial (verificar siempre)

- **Regla**: ANTES de implementar cualquier API, feature o patrón, verificar la documentación oficial vigente de la versión en uso. No asumir firmas ni imports de memoria; la doc oficial gana ante cualquier suposición.
  - NestJS: `https://docs.nestjs.com/`
  - Drivers: MySQL/mysql2 `https://sidorares.github.io/node-mysql2/docs` · PostgreSQL/node-postgres `https://node-postgres.com/` · SQL Server/mssql `https://github.com/tediousjs/node-mssql` · SQLite `https://github.com/WiseLibs/better-sqlite3`
  - Node.js: `https://nodejs.org/docs/latest/api/`
- **Seguridad:** seguir la cobertura OWASP vigente (ver skill `security`).
