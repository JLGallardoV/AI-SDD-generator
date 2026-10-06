# 03 — Requisitos / Requirements

> **ES** — P&R. Primero requisitos **globales**, luego por **módulo**. Los IDs `REQ-*`
> permiten trazar contratos (`05`), pruebas (`09`) y DoD (`12`).
> **EN** — Q&A. Global first, then per module. IDs are traceable across the SDD.
>
> Si el proyecto no es de negocio, sustituye "regla de dominio" por "regla funcional".

---

## 3.1 Convención de IDs (ID convention)

- `REQ-G*` → globales (aplican a todos los módulos).
- `REQ-{MODULO}-*` → específicos del módulo (ej. `REQ-AUTH-01`).
- `NFR-*` → no funcionales (rendimiento, seguridad, etc.), enlazan a `08-quality-attributes.md`.

## 3.2 Globales (Global requirements)

### Q. ¿Qué reglas globales aplican a todo el sistema?
**Answer:**

| ID | Requisito | Prioridad | Traza |
|---|---|---|---|
| `REQ-G01` | `[TO DEFINE]` | Must | `[TO DEFINE]` |

### Q. ¿Qué requisitos no funcionales globales existen?
**Answer:**

| ID | Requisito (NFR) | Meta | Pilar |
|---|---|---|---|
| `NFR-01` | `[TO DEFINE]` | `[TO DEFINE]` | `[TO DEFINE]` |

## 3.3 Módulos (Per-module requirements)

### Q. ¿Qué requisitos tiene el módulo 1 (`[TO DEFINE]`)?
**Answer:**

| ID | Requisito | Criterio de aceptación | Prioridad |
|---|---|---|---|
| `REQ-` | `[TO DEFINE]` | `[TO DEFINE]` | Must/Should/Could |

> **ES** — Duplica este bloque por cada módulo definido en `02-vision.md`.

## 3.4 Reglas de dominio (Domain rules)

### Q. ¿Qué reglas/validaciones de dominio deben cumplirse siempre?
**Answer:** `[TO DEFINE]`
> **ES** — Ej.: cálculos, condiciones, estados válidos, transiciones, límites.

## 3.5 Máquinas de estado (State machines)

### Q. ¿Qué entidades tienen estados y transiciones?
**Answer:**

| Entidad | Estados | Transiciones válidas |
|---|---|---|
| `[TO DEFINE]` | `[TO DEFINE]` | `[TO DEFINE]` |

## 3.6 Trazabilidad (Traceability)

### Q. ¿Cómo se mapean contratos y pruebas a requisitos?
**Answer:** Cada contrato en `05-contracts.md` cita su `REQ-*`; cada test en `09-testing.md`
cita su `REQ-*`. Ningún requisito puede quedar sin contrato ni prueba.
