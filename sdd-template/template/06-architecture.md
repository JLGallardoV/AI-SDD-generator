# 06 — Arquitectura / Architecture

> **ES** — Estándar técnico del proyecto. **No reescribe skills**: registra decisiones
> propias y referencia las skills con `[FIXED ← skill: X]`.
> **EN** — Fixed technical standard. Decisions + skill references, never skill copies.
>
> Skills de stack: ver `01-discovery.md` (sección Stack & Skills) y
> `sdd-template/registry/skills.registry.md`.

---

## 6.1 Layout del repositorio (Repository layout)

### Q. ¿Cómo se organiza el repositorio (monorepo/repos, carpetas por app)?
**Answer:** `[TO DEFINE]` · La decisión monorepo/proyectos separados ya se tomó en
`01-discovery.md §1.3`; aquí solo se **detalla el árbol** de carpetas. `[EJEMPLO]`

```
<repo>/
├── AGENTS.md
├── <projectName>-sdd/        # este SDD
├── <app-web>/
├── <app-backend>/
└── <app-mobile>/
```

### Q. ¿Qué gestor de paquetes y workspaces se usan?
**Answer:** `[TO DEFINE]` · Para monorepos JS/TS la elección (`npm`/`pnpm`/`yarn`/`bun` y el
uso de workspaces) ya se registró en `01-discovery.md §1.3`; aquí solo se detallan los
**globs de workspaces** y los **scripts raíz** (`[EJEMPLO]`: `"workspaces": ["apps/*", "packages/*"]`).

## 6.2 Patrón arquitectónico (Architecture pattern)

### Q. ¿Qué patrón se adopta (capas, limpia, hexagonal, microservicios, modular monolith)?
**Answer:** `[TO DEFINE]`

### Q. ¿Qué límites de módulos/dominios existen y cómo se comunican?
**Answer:** `[TO DEFINE]`

## 6.3 Estructura por app (Per-app structure)

### Q. ¿Cuál es la estructura de carpetas de cada app?
**Answer:** `[TO DEFINE]` / `[FIXED ← skill: <stack skill de esa app>]`

> **ES** — La arquitectura de carpetas, aliases, capas y convenciones de lenguaje viven en
> la skill de stack. Aquí solo se registran las particularidades del proyecto.

### Q. ¿Cómo se organiza la jerarquía de componentes/capas?
**Answer:** `[TO DEFINE]` / `[FIXED ← skill: <stack skill>]`

## 6.4 Estado y datos en cliente (Client state) — si aplica

### Q. ¿Cómo se gestiona el estado y el acceso a datos en el cliente?
**Answer:** `[TO DEFINE]` / `[NO APLICA]`

## 6.5 Manejo de errores y observabilidad (Error handling)

### Q. ¿Cómo se manejan errores, reintentos y logs de forma transversal?
**Answer:** `[FIXED ← skill: observability]` + `[TO DEFINE]`

## 6.6 i18n, accesibilidad y diseño (i18n, A11y & design)

### Q. ¿Idiomas, formato regional y sistema de diseño (tokens/tema)?
**Answer:** `[TO DEFINE]` / `[NO APLICA]`

## 6.7 Calidad de código (Code quality)

### Q. ¿Qué reglas de estilo, linter, formatter y tipado aplican?
**Answer:** `[FIXED ← skill: clean-code]` + `[TO DEFINE]`

### Q. ¿Documentación de código (formato, idioma, autor)?
**Answer:** `[TO DEFINE]` · `[EJEMPLO]` JSDoc en español con `@description`, `@author [Autor] | YYYY-MM-DD`.
> `[Autor]` es el definido en `01-discovery.md §1.1` y el usado por `AGENTS.md` ("Entregado [Autor]").

## 6.8 Estándares que no cambian (Non-negotiables)

### Q. ¿Qué decisiones son estándar y no se discuten por feature?
**Answer:** `[TO DEFINE]` + referencias `[FIXED ← skill: ...]`.
