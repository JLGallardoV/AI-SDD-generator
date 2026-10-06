# 09 — Plan de pruebas / Testing Plan

> **ES** — Casos de prueba production-grade. Estado: `DONE` (verificado), `AUTO` (automatizado),
> `MANUAL`. Cada caso cita su `REQ-*`.
> **EN** — Production-grade test cases; each case cites its `REQ-*`.

## Regla obligatoria (Definition of Done)
> **Ningún cambio se da por terminado —ni se sube a producción— sin pruebas.**
> - Todo proyecto debe tener **pruebas reales** (no andamiaje) antes de producción.
> - Tras **cualquier cambio**, el agente corre las pruebas del proyecto afectado y las deja verdes.
> - El agente identifica **dónde** probar, **desarrolla** las pruebas y **actualiza este archivo**
>   con los casos nuevos **antes** de reportar el cambio como terminado.
> - Al cerrar cada característica, **reporta**: (1) las **pruebas que pasaron** —deben pasar **todas**;
>   si alguna falla, la característica **no** se da por cumplida— y (2) que el chequeo de **código
>   muerto (knip/deadcode)** se aplicó y salió limpio.

## Frameworks y comandos (Frameworks & commands)
### Q. ¿Qué framework de pruebas usa cada app y cómo se ejecutan?
**Answer:** `[TO DEFINE]` · `[EJEMPLO]` backend: `pnpm test`; frontend: `pnpm test` + `pnpm typecheck`.

## Estrategia (Strategy)
- **P0 — crítico (siempre automatizado):** reglas de dominio, contratos, seguridad y flujo principal.
- **P1 — extra (automatizado si es barato; si no, `MANUAL`):** validaciones, componentes, UX verificable.
- **MANUAL:** layout, responsive, foco, efectos dependientes del dispositivo/entorno.
- Probar **comportamiento y contratos**, no métodos privados. Sin pruebas nuevas sin ID en este archivo.

## Antes de la fase de pruebas de cada cambio (obligatoria)
1. **Sin código muerto** (deadcode/knip o equivalente) limpio.
2. **Pruebas verdes** del proyecto afectado —deben pasar **todas**; si alguna falla, la
   característica **no** se da por cumplida.
3. Actualizar esta matriz (`09-testing.md`) con los casos nuevos.

## Reporte al cerrar cada característica (obligatoria)
- Mostrar las **pruebas que pasaron** (todas en verde); si alguna falla, **no** reportar la
  característica como terminada.
- Indicar que el chequeo de **código muerto (knip/deadcode)** se aplicó y salió limpio.

## Verificación pre-push (obligatoria antes de commit/push)
1. **Pruebas verdes** y build/lint sin errores en el proyecto afectado.
2. **Nada confidencial:** revisar `git status` y `git diff --cached`; no subir `.env*`,
   logs, `dist/`, `coverage/`, `node_modules/`, llaves/certificados ni secretos.
3. Recién entonces: `git add` → `git commit` → `git push`.

## Inventario (Test inventory)
| App | Framework | Suites | Tests | Estado |
|---|---|---|---|---|
| `[TO DEFINE]` | `[TO DEFINE]` | `[TO DEFINE]` | `[TO DEFINE]` | `[TO DEFINE]` |

## Casos por módulo (Cases)

### Módulo: `[TO DEFINE]` · `REQ-*`
| ID | Pri | Caso | Resultado esperado | Traza `REQ` | Estado |
|---|---|---|---|---|---|
| `[TO DEFINE]-01` | P0 | `[TO DEFINE]` | `[TO DEFINE]` | `REQ-` | — |

### Seguridad (Security) — familias OWASP vigente

> Cubrir al menos una prueba por familia aplicable. El estándar OWASP es **dinámico**: usar la versión vigente al iniciar (`07-security.md`).

| ID | Pri | Caso (familia OWASP) | Resultado esperado | Traza | Estado |
|---|---|---|---|---|---|
| SEC-01 | P0 | Control de acceso | Acceso denegado sin permiso/rol; anti-IDOR | `NFR-` | — |
| SEC-02 | P0 | Configuración insegura | Sin credenciales por defecto; debug off; headers | `NFR-` | — |
| SEC-03 | P0 | Cadena de suministro | Sin dependencias vulnerables críticas/altas | `NFR-` | — |
| SEC-04 | P0 | Criptografía | Algoritmos fuertes; sin datos sensibles expuestos | `NFR-` | — |
| SEC-05 | P0 | Inyección | Entrada parametrizada/validada, sin fuga | `NFR-` | — |
| SEC-06 | P1 | Diseño inseguro | Límites de negocio y rate limiting | `NFR-` | — |
| SEC-07 | P0 | Autenticación | Bloqueo de credenciales inválidas; sesión revocable | `NFR-` | — |
| SEC-08 | P1 | Integridad de software/datos | Artefactos/datos verificados | `NFR-` | — |
| SEC-09 | P0 | Logging y alertas | Eventos registrados sin PII | `NFR-` | — |
| SEC-10 | P0 | Manejo de excepciones | Sin stack traces ni internals al cliente | `NFR-` | — |
| SEC-11 | P0 | Credenciales en logs | Redactadas | `NFR-` | — |

### Calidad (Quality — de `08-quality-attributes.md`)
| ID | Pri | Caso | Resultado esperado | Pilar | Estado |
|---|---|---|---|---|---|
| QA-01 | P1 | Presupuesto de rendimiento | Dentro de la meta | performance | — |

## Backlog de automatización (Automation backlog)
- Documenta aquí los casos P1 pendientes de automatizar, citando su `REQ-*`.
