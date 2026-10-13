# 08 — Atributos de calidad / Quality Attributes

> **ES** — Metas **medibles** de cada pilar, tomadas de `01-discovery.md`. Las técnicas viven
> en las skills transversales (`[FIXED ← skill: <pilar>]`); aquí se fija el objetivo y cómo
> se verifica.
> **EN** — Measurable targets per pillar; techniques live in the transversal skills.

---

## 8.1 Rendimiento (Performance) · `[FIXED ← skill: performance]`

### Q. ¿Qué presupuestos de rendimiento aplican (latencia, throughput, tiempo de carga)?
**Answer:** `[TO DEFINE]` · `[EJEMPLO]` p95 API < 300 ms; primera carga web < 2 s en 4G.

### Q. ¿Cómo se mide y con qué herramienta?
**Answer:** `[TO DEFINE]`

### Q. ¿Qué límites de recursos y coste se vigilan (memoria, CPU, conexiones, egress)?
**Answer:** `[TO DEFINE]` · `[EJEMPLO]` sin resource leaks; alertas por umbral; evitar bill-shocks.

## 8.2 Escalabilidad (Scalability) · `[FIXED ← skill: scalability]`

### Q. ¿Cómo escala el sistema (horizontal/vertical) y hasta qué límite esperado?
**Answer:** `[TO DEFINE]`

### Q. ¿Qué cuellos de botella se anticipan y cómo se mitigan?
**Answer:** `[TO DEFINE]`

## 8.3 Disponibilidad y fiabilidad (Availability & reliability) · `[FIXED ← skill: availability]`

### Q. ¿Cuál es el objetivo de disponibilidad (SLO/SLA) y el presupuesto de error?
**Answer:** `[TO DEFINE]`

### Q. ¿Qué estrategia de recuperación (redundancia, RTO/RPO, backups, degradación)?
**Answer:** `[TO DEFINE]`

## 8.4 Usabilidad y accesibilidad (Usability & accessibility) · `[FIXED ← skill: usability]`

### Q. ¿Qué nivel de accesibilidad se exige (p. ej. WCAG 2.2 AA)?
**Answer:** `[TO DEFINE]` / `[NO APLICA]`

### Q. ¿Qué flujos críticos deben ser simples y cómo se valida la usabilidad?
**Answer:** `[TO DEFINE]`

## 8.5 Observabilidad (Observability) · `[FIXED ← skill: observability]`

### Q. ¿Qué logs, métricas y trazas se emiten y dónde (stack de observabilidad)?
**Answer:** `[TO DEFINE]`

### Q. ¿Qué alertas y SLOs se monitorean?
**Answer:** `[TO DEFINE]`

## 8.6 Limpieza y mantenibilidad (Clean code & maintainability) · `[FIXED ← skill: clean-code]`

### Q. ¿Qué estándares de código, cobertura y deuda técnica se exigen?
**Answer:** `[TO DEFINE]` · `[EJEMPLO]` lint sin errores, cobertura P0 ≥ 80 %, sin código muerto.

## 8.7 Reusabilidad (Reusability)

### Q. ¿Qué piezas deben ser reutilizables (componentes, utilidades, librerías internas)?
**Answer:** `[TO DEFINE]`

## 8.8 Matriz de verificación (Verification matrix)

### Q. ¿Cómo se comprueba cada pilar antes de producción?
**Answer:**

| Pilar | Meta | Cómo se verifica | Bloquea release |
|---|---|---|---|
| Rendimiento | `[TO DEFINE]` | `[TO DEFINE]` | Sí/No |
| Escalabilidad | `[TO DEFINE]` | `[TO DEFINE]` | Sí/No |
| Disponibilidad | `[TO DEFINE]` | `[TO DEFINE]` | Sí/No |
| Usabilidad/A11y | `[TO DEFINE]` | `[TO DEFINE]` | Sí/No |
| Observabilidad | `[TO DEFINE]` | `[TO DEFINE]` | Sí/No |
| Limpieza | `[TO DEFINE]` | `[TO DEFINE]` | Sí/No |
