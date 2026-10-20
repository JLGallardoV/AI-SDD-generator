---
name: clean-code
description: >-
  Use ALWAYS when writing, reviewing or refactoring code in any language. Triggers on
  naming, functions/methods, classes, modules, duplication, coupling, cohesion, SOLID/SRP,
  comments/JSDoc, error handling, formatting, linting, reusability, dead code or
  code review. Defines the clean code, maintainability and reusability pillar: code that is
  readable, testable and cheap to change. Stack-specific style lives in the stack skill.
---

# Skill: clean-code (pilar de limpieza y reutilización)

> **ES** — Pilar transversal. Código limpio = se lee fácil, se cambia barato y se prueba
> sin dolor. Aplica a cualquier lenguaje.
> **EN** — Cross-cutting pillar. Readable, cheap to change, easy to test.

## 1. Reglas rectoras

1. **Legibilidad primero.** El código se lee muchas más veces de las que se escribe.
2. **Una responsabilidad por unidad** (SRP): función, clase y módulo.
3. **No te repitas (DRY)** sin caer en abstracciones prematuras.
4. **Nombres que revelan intención**; sin abreviaturas crípticas.
5. **Sin código muerto, comentado ni `TODO` sin dueño.**
6. **Errores explícitos**: nunca silenciar un `catch`.
7. **Deja el código mejor de como lo encontraste.**

## 2. Funciones y métodos

- Hacen **una sola cosa** y su nombre lo dice.
- Pocos parámetros; evitar booleanos de control.
- Cortas (referencia ~40 líneas); extrae privadas de responsabilidad única.
- Sin efectos colaterales ocultos.
- Funciones puras para cálculo/formateo.

## 3. Nombres y estructura

- Nombres de dominio claros (`calcularTotal`, no `calc`).
- Convenciones de archivos/símbolos consistentes (ver skill de stack).
- Organización por dominio/entidad, no por tipo técnico suelto.
- Módulos con alta cohesión y bajo acoplamiento.

## 4. SOLID y diseño

- **S**: una razón para cambiar por unidad.
- **O**: extender sin modificar cuando aplique.
- **L/I/D**: sustitución, interfaces pequeñas, dependencias inyectadas.
- Preferir composición sobre herencia profunda.
- Fronteras claras entre capas (presentación, dominio, datos).

## 5. Manejo de errores

- Errores tipados/claros; no tragar excepciones.
- **Registrar** el error con contexto (stack) antes de relanzar.
- Validar en los bordes; asumir válido hacia adentro.
- No usar excepciones para control de flujo normal.

## 6. Documentación y comentarios

- Comentarios solo cuando explican **por qué**, no **qué**.
- Documentar APIs públicas (formato e idioma según skill de stack / `AGENTS.md`).
- Sin comentarios obsoletos ni código comentado.

## 7. Reutilización

- Extraer utilidades/componentes compartidos cuando se repite (regla de tres).
- Librerías internas con API estable; sin copiar-pegar entre proyectos.

## 8. Herramientas y verificación

- **Linter + formatter + typecheck** en CI; sin warnings ignorados.
- **Sin código muerto** (deadcode/knip o equivalente): verificar **antes de la fase de pruebas de cada cambio**, **no** en pre-push.
- **Sin resource leaks** (conexiones, timers, listeners, memoria, procesos): verificar antes de dar por terminada una característica (anti bill-shock).
- Revisión de código obligatoria; cambios pequeños y enfocados.
- **Reporte de cierre:** mostrar las pruebas que pasaron (todas) e indicar que el knip se aplicó (ver skill `testing`).
- Cobertura razonable en lógica crítica (ver skill `testing`).

> **ES** — El estilo concreto (espaciado, JSDoc, sufijos de archivo) lo define la skill de
> stack del proyecto.
