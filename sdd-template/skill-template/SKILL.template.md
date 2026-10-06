---
name: <stack-skill-name>
description: >-
  Use ONLY when the project uses <technology/framework>. Triggers when creating or
  modifying <key artifacts: components, services, DAOs, modules...>. Covers folder
  architecture, naming, path aliases, tooling, testing setup and stack-specific
  security. Do NOT use for <excluded technologies> (use <other skill>). Pillars
  (security, performance, testing, clean-code) are delegated to the transversal
  skills — never duplicated here.
---

# <Technology> — Stack Conventions

> **ES** — Skill de stack: SOLO lo específico de esta tecnología. Los pilares
> (seguridad, rendimiento, testing, limpieza…) viven en las skills transversales; aquí se
> referencian, no se reescriben.
> **EN** — Stack skill: technology-specific only. Pillars are delegated to transversal skills.

## 1. Cuándo usar / Cuándo no (When to use / not)

- **Usar cuando:** `[TO DEFINE: condiciones de disparo]`.
- **No usar cuando:** `[TO DEFINE: tecnologías excluidas y skill alternativa]`.

## 2. Arquitectura de carpetas (Folder architecture)

### Q. ¿Cómo se estructura un proyecto de esta tecnología?
**Answer:** `[TO DEFINE]`

```
src/
├── config/
├── services/
├── <entidad>/
└── main.<ext>
```

### Q. ¿Jerarquía de capas/componentes?
**Answer:** `[TO DEFINE]`

## 3. Convenciones de código (Code conventions)

### Q. ¿Nombres de archivos, símbolos, sufijos y aliases?
**Answer:** `[TO DEFINE]`

### Q. ¿Formato de documentación (JSDoc/comentarios, idioma, autor)?
**Answer:** `[TO DEFINE]`

### Q. ¿Espaciado/estilo obligatorio (p. ej. 3 líneas en blanco entre miembros)?
**Answer:** `[TO DEFINE]`

## 4. Herramientas y comandos (Tooling & commands)

### Q. ¿Gestor de paquetes, linter, formatter, typecheck y build?
**Answer:** `[TO DEFINE]`

### Q. ¿Comandos de arranque, pruebas y verificación?
**Answer:** `[TO DEFINE]`

## 5. Patrones propios (Stack patterns)

### Q. ¿Qué patrones/estructuras son idiomáticos (inyección, estado, transacciones, persistencia)?
**Answer:** `[TO DEFINE]`

### Q. ¿Qué prácticas están prohibidas en esta tecnología?
**Answer:** `[TO DEFINE]`

## 6. Enganches a pilares (Pillar hooks)

- **Seguridad:** ver skill `security`. Específico de esta tecnología: `[TO DEFINE]`.
- **Rendimiento:** ver skill `performance`. Específico: `[TO DEFINE]`.
- **Testing:** ver skill `testing`. Framework de pruebas de esta tecnología: `[TO DEFINE]`.
- **Limpieza:** ver skill `clean-code`. Específico: `[TO DEFINE]`.

## 7. Dependencias (Dependencies)

### Q. ¿Dependencias base del stack?
**Answer:** `[TO DEFINE]`
> Regla: autorización explícita antes de instalar.
