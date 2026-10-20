# AGENTS.md — <projectName>

> **ES** — Plantilla. `sdd-boot` la copia a la **raíz del proyecto** como `AGENTS.md`
> (al mismo nivel que `<projectName>-sdd/`) y rellena los `[TO DEFINE]`.
> **EN** — Template. Copied to the project root as `AGENTS.md`.
>
> opencode auto-carga este archivo. Es el **primer archivo real** y el puente hacia la
> especificación. Guía operativa para asistentes (opencode) que trabajen en **`[TO DEFINE: projectName]`**.

## Fuente de verdad
- Especificaciones SDD: `<projectName>-sdd/` (leer `00` → `12`).
- Convenciones (autoritativas): skills globales `~/.config/opencode/skills/` —
  `[TO DEFINE: skills activas, p. ej. security, clean-code, testing, <stack>]`.
- `[TO DEFINE: descripción del producto en una línea y su modelo (monorepo/repos)]`.
  - `[TO DEFINE: carpeta de cada app y su tecnología]`.
  - Gestor de paquetes: `[TO DEFINE]`.

## Context-mode (activo en toda la conversación)
Usar las herramientas de context-mode por defecto para reducir contexto:

- **Recolección**: `ctx_batch_execute(commands, queries)` cuando haya 3+ comandos o el output sea grande.
- **Procesamiento**: `ctx_execute` / `ctx_execute_file` para filtrar, contar, parsear o agregar;
  imprimir solo el resultado derivado (no los bytes crudos).
- **Consulta**: `ctx_search` para recuperar de la base de conocimiento antes de releer archivos.
- **Indexado**: `ctx_index` / `ctx_fetch_and_index` para specs, skills, docs y salidas grandes.

Usar `Read`/`Bash` solo para:
- observar una salida corta y fija, o
- operaciones que mutan estado o cuando el archivo se va a editar con `Edit`.

> **ES** — El plugin `context-mode` se activa por configuración de opencode (arreglo `plugin`
> o auto-descubrimiento en `.opencode/plugin/`), no desde este archivo; aquí solo se instruye su uso.
> `[TO DEFINE: nombre exacto del paquete o ruta local del plugin context-mode]`

## Reglas de trabajo (resumen)
- **PowerShell:** usar `[TO DEFINE: gestor, p. ej. pnpm.cmd]` (nunca `.ps1`). **NUNCA** leer archivos `*.env`.
- **Convenciones clave por app** (la fuente autoritativa son las skills): `[TO DEFINE]`.
  `[EJEMPLO]` backend: wrapper `{ response: T }`, SQL puro parametrizado (ORM prohibido), JSDoc con
  `@author [Autor] | YYYY-MM-DD`, 3 líneas en blanco entre miembros. Móvil/frontend: componentes
  funcionales, estado con el store del stack, aliases, tema y patrón de persistencia.
- **Dependencias:** no instalar sin autorización previa (avisar paquete/versión/propósito).
- **Cambios de base de datos:** entregarlos siempre como **SQL copy-paste** en la respuesta y
  reflejarlos en `<projectName>-sdd/04-data-model.md`. El usuario los ejecuta manualmente; no hay
  scripts `db/DDL_*.sql` en el repo.
- **Formato de `04-data-model.md`:** en ese archivo **solo se agrega**, respetando el formato
  canónico de su §de convenciones (tabla `Column | Type | Null | Key / Reference | Notes`, fila
  `Indexes:`, sin DDL crudo). Nunca reescribirlo completo ni romper ese formato.
- **Pruebas obligatorias (no negociable):** todo proyecto debe tener pruebas **reales** antes de
  subir a producción. Tras **cualquier cambio**, correr las pruebas del proyecto afectado. El
  asistente **identifica dónde probar, escribe las pruebas, las corre y actualiza
  `<projectName>-sdd/09-testing.md`** (nuevos IDs de caso) **antes** de reportar el cambio como terminado.
- Al final de todas tus respuestas debes decirme **"Entregado [Autor]"** (donde `[Autor]` es el
  definido en `<projectName>-sdd/01-discovery.md`).

## Antes de cada cambio (per-change)
- Antes de la fase de pruebas: verificar que no haya **código muerto** (deadcode/knip o equivalente) y **resource leaks** (conexiones, timers, listeners, memoria, procesos).
- Luego correr las pruebas del proyecto afectado —deben pasar **todas**; si alguna falla, la
  característica **no** se da por cumplida.

## Verificación antes de cerrar una tarea
- `[TO DEFINE: comando(s) de verificación por app — test / build / lint / typecheck]`
  `[EJEMPLO]` backend: `pnpm.cmd test`, `pnpm.cmd run build`, `pnpm.cmd run lint`;
  frontend/móvil: `pnpm.cmd run typecheck`, `pnpm.cmd test`.
- Reflejar cambios en `<projectName>-sdd/` (los archivos que apliquen) cuando corresponda —
  incluyendo los casos nuevos en `09-testing.md`.
- No dar por terminado un cambio sin las pruebas del proyecto afectado en verde.
- **Reporte de cierre (por característica):** mostrar las **pruebas que pasaron** (todas; si alguna
  falla, la característica **no** se da por cumplida) e indicar que el **knip** se aplicó y que **no hay resource leaks**.
