# 04 — Modelo de datos / Data Model

> **ES** — Convenciones primero (P&R) y luego el modelo (normativo). Si el proyecto no
> persiste datos, marca todo como `[NO APLICA]`.
> **EN** — Conventions first (Q&A), then the normative model.
>
> **Flujo de cambios de datos:** todo cambio de esquema se entrega como **SQL copy-paste**,
> se refleja aquí y lo aplica el usuario manualmente. Este archivo es la fuente de verdad.

---

## 4.1 Convenciones (Conventions)

### Q. ¿Qué motor(es) de persistencia se usan (PostgreSQL, MySQL, SQLite, MongoDB, Redis, archivos)?
**Answer:** `[TO DEFINE]`

### Q. ¿Cómo se nombran tablas/colecciones, columnas y llaves?
**Answer:** `[TO DEFINE]` · `[EJEMPLO]` `id_<tabla>`, `snake_case`, `fk_<hija>_<padre>`.

### Q. ¿Qué columnas de auditoría lleva cada entidad?
**Answer:** `[TO DEFINE]` · `[EJEMPLO]` `fecha_alta`, `fecha_mod`, `usuario_alta`, `usuario_mod`.

### Q. ¿Cómo se modelan estados y tipos enumerados?
**Answer:** `[TO DEFINE]`

### Q. ¿Cómo se manejan fechas/horas y zonas horarias?
**Answer:** `[TO DEFINE]` · `[EJEMPLO]` UTC en almacenamiento, `America/Mexico_City` en negocio.

### Q. ¿Estrategia de migraciones y versionado del esquema?
**Answer:** `[TO DEFINE]`

### Q. ¿Estrategia de respaldos, retención y borrado?
**Answer:** `[TO DEFINE]`

### Q. ¿Cómo se documenta cada tabla?
**Answer:** Usar exactamente esta forma, en este orden:

```markdown
### Table: `schema.tabla`
> Propósito en una línea (solo si el nombre no es evidente).

| Column | Type | Null | Key / Reference | Notes |
|---|---|---|---|---|
| id_x | INT AUTO | NO | PK | |
| id_padre | INT | NO | FK → `schema.tabla(columna)` RESTRICT | |
| nombre | VARCHAR(100) | NO | | |
| estatus | TINYINT | NO | | DEFAULT 1 · `1` activo, `0` inactivo |

**Indexes:** `uk_x (col_a, col_b)` UNIQUE · `idx_x (col_c)`
```

Reglas: tipo corto en mayúsculas; `Null` explícito (`NO`/`YES`); llaves solo con
`PK`, `UK`, `FK → ...`, `—`; columnas de auditoría listadas una por fila; `Indexes:` solo si
hay llaves extra; **sin DDL crudo** salvo en un bloque `> **DDL note (copy-paste)**`.

## 4.2 Entidades (Entities)

### Q. ¿Cuáles son las entidades/tablas del sistema?
**Answer:**

| Entidad | Propósito | Persistencia |
|---|---|---|
| `[TO DEFINE]` | `[TO DEFINE]` | `[TO DEFINE]` |

## 4.3 Detalle de tablas (Table details)

### Table: `[TO DEFINE]`
> `[TO DEFINE]`

| Column | Type | Null | Key / Reference | Notes |
|---|---|---|---|---|
| id_`<tabla>` | INT AUTO | NO | PK | |
| `[TO DEFINE]` | `[TO DEFINE]` | `[TO DEFINE]` | `[TO DEFINE]` | `[TO DEFINE]` |

**Indexes:** `[TO DEFINE]`

> **ES** — Duplica este bloque por cada entidad. Si el motor no es relacional, adapta la
> tabla a "campo / tipo / requerido / índice" y anótalo.

## 4.4 Catálogos y semillas (Catalogs & seeds)

### Q. ¿Qué catálogos/semillas deben existir antes de ejecutar?
**Answer:** `[TO DEFINE]` / `[NO APLICA]`

## 4.5 Diagrama de relaciones (Relationships)

### Q. ¿Qué relaciones e integridad referencial existen?
**Answer:** `[TO DEFINE]`
