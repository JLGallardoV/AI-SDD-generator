# 05 — Contratos / Contracts

> **ES** — Convenciones primero (P&R), luego los contratos. Cada contrato se traza a `REQ-*`.
> Aplica a API REST/GraphQL/gRPC, eventos, comandos CLI o contratos de UI según el proyecto.
> **EN** — Conventions first, then contracts. Each contract traces to `REQ-*`.

---

## 5.1 Convenciones (Conventions)

### Q. ¿Qué tipo(s) de contrato expone el proyecto (REST, GraphQL, gRPC, eventos, CLI, UI)?
**Answer:** `[TO DEFINE]`

### Q. ¿Cuál es el prefijo/versionado (p. ej. `/api/v1`)?
**Answer:** `[TO DEFINE]` / `[NO APLICA]`

### Q. ¿Cuál es la forma estándar de respuesta (envelope)?
**Answer:** `[TO DEFINE]` · `[EJEMPLO]` `{ "response": <data> }`; errores `{ "response": "<mensaje>" }`.
> Cuando un payload sensible (sesión/privilegios) viaja al cliente, puede ir **ofuscado** dentro de `response` y desofuscarse en el frontend (ver `07-security.md`). Es ofuscación, no cifrado.

### Q. ¿Qué códigos de estado/errores se usan y con qué semántica?
**Answer:** `[TO DEFINE]` · `[EJEMPLO]` `200` ok · `201` creado · `400` bad request · `401` no
autorizado · `403` prohibido · `404` no encontrado · `409` conflicto · `422` regla de negocio · `500` interno.

### Q. ¿Cómo se autentica y autoriza cada contrato?
**Answer:** `[TO DEFINE]` · `[FIXED ← skill: security]` para el esquema de sesión/tokens.

### Q. ¿Cómo se validan las entradas y se versionan los cambios incompatibles?
**Answer:** `[TO DEFINE]`

## 5.2 API / Contratos (Endpoints & contracts)

### `[METHOD] /[ruta]` · `<auth>` · `REQ-*`
- **Propósito:** `[TO DEFINE]`
- **Request:** `[TO DEFINE]` (params, query, body, headers)
- **Response:** `[TO DEFINE]` (shape, envelope)
- **Errores:** `[TO DEFINE]`
- **Notas:** `[TO DEFINE]`

> **ES** — Duplica este bloque por cada contrato. Para eventos usa `evento: <nombre>` con
> productor, consumidores y esquema; para CLI usa `comando <nombre>` con args y salida.

## 5.3 Eventos y colas (Events & queues)

### Q. ¿Qué eventos se publican/consumen y con qué esquema?
**Answer:** `[TO DEFINE]` / `[NO APLICA]`

| Evento | Productor | Consumidor | Esquema | Entrega |
|---|---|---|---|---|
| `[TO DEFINE]` | `[TO DEFINE]` | `[TO DEFINE]` | `[TO DEFINE]` | at-least-once / exactly-once |

## 5.4 Contratos de UI (UI contracts)

### Q. ¿Qué pantallas/componentes consumen qué contratos y con qué estados (loading/empty/error)?
**Answer:** `[TO DEFINE]` / `[NO APLICA]`

## 5.5 Seguridad de contratos (Contract security)

### Q. ¿Qué reglas de endurecimiento aplican a todos los contratos?
**Answer:** `[FIXED ← skill: security]` + `[TO DEFINE]`
`[EJEMPLO]` validación de entrada, sin secretos en respuestas/logs, rate limiting, CORS.
