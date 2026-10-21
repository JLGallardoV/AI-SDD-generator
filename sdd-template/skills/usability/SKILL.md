---
name: usability
description: >-
  Use when building or reviewing any user-facing interface (web, mobile, desktop) or a
  user flow. Triggers on UX, accessibility (WCAG), forms, navigation, feedback states
  (loading/empty/error), responsiveness, keyboard/focus, screen readers, contrast, touch
  targets or internationalization. Defines the usability and accessibility pillar:
  consistent, inclusive, low-friction experiences. Do NOT duplicate stack UI APIs — use the
  stack skill.
---

# Skill: usability (pilar de usabilidad y accesibilidad)

> **ES** — Pilar transversal. Usable = comprensible, eficiente, accesible y tolerante al
> error. La accesibilidad no es opcional.
> **EN** — Cross-cutting pillar. Understandable, efficient, accessible, forgiving.

## 1. Reglas rectoras

1. **El usuario no debería pensar** para completar un flujo básico.
2. **Estado siempre visible** (loading, empty, error, éxito).
3. **Accesible por defecto** (WCAG 2.2 AA como mínimo).
4. **Consistencia**: mismos patrones, nombres y ubicaciones.
5. **Prevenir errores** antes que mostrar mensajes de error.
6. **Tolerar el error**: mensajes claros, recuperables, sin perder datos.

## 2. Accesibilidad (WCAG 2.2 AA)

- **Contraste** suficiente (texto ≥ 4.5:1).
- **Navegación por teclado** completa y **foco visible**.
- **Etiquetas** accesibles (`aria-*`, `label`, `accessibilityLabel`).
- **Áreas táctiles** ≥ 44×44 px.
- **No depender solo del color** para transmitir información.
- **Textos alternativos** en imágenes con significado.
- **Semántica** correcta (encabezados, landmarks, roles).
- Respetar `prefers-reduced-motion`.

## 3. Flujos e interacción

- **Estados**: loading (skeletons), vacío (con acción), error (con reintento).
- **Feedback inmediato** en acciones; evitar bloqueos sin señal.
- **Formularios**: validación en contexto, mensajes junto al campo, no perder lo escrito.
- **Confirmaciones** para acciones destructivas.
- **Navegación predecible**; el usuario sabe dónde está y cómo volver.

## 4. Diseño y consistencia

- **Sistema de diseño con tokens** (color, tipografía, espaciado); no hex sueltos.
- **Jerarquía visual** clara; un foco primario por pantalla.
- **Responsive** / adaptativo en todos los tamaños objetivo.
- **Internacionalización**: textos externos, formatos de fecha/número/moneda por locale.

## 5. Verificación

- [ ] Flujos críticos sin fricción y con todos los estados.
- [ ] Navegación por teclado y foco correctos.
- [ ] Contraste y etiquetas accesibles.
- [ ] Prueba en tamaños/dispositivos objetivo.
- [ ] Validación con usuarios o al menos revisión heurística.

> **ES** — El prototipo/diseño visual es la fuente de verdad del layout; las APIs de UI
> viven en la skill de stack.
