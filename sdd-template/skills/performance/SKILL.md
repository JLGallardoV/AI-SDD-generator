---
name: performance
description: >-
  Use when building or optimizing anything performance-sensitive: slow endpoints, pages,
  queries, batches, mobile apps, builds or data pipelines. Triggers on latency, load time,
  throughput, N+1 queries, caching, indexing, bundling, lazy loading, memory usage or
  profiling. Defines the performance pillar: budgets, measurement, and proven optimization
  techniques across frontend, backend and data. Do NOT duplicate stack APIs (use the stack
  skill) — this skill owns the principles and method.
---

# Skill: performance (pilar de rendimiento)

> **ES** — Pilar transversal. Regla de oro: **medir antes de optimizar**. Sin medición no
> hay optimización, solo suposiciones.
> **EN** — Cross-cutting pillar. Measure before optimizing.

## 1. Reglas rectoras

1. **Mide primero** (profiler, métricas, trazas). Optimiza el cuello real, no el imaginado.
2. **Define presupuestos** (latencia, tamaño de bundle, memoria) y hazlos parte del CI.
3. **Optimiza el camino caliente**, no el código que casi no corre.
4. **Complejidad algorítmica antes que micro-optimización.**
5. **No sacrifiques seguridad ni corrección** por velocidad.

## 2. Presupuestos (Budgets)

- Latencia API p95/p99 (p. ej. p95 < 300 ms).
- Tiempo de carga web (p. ej. LCP < 2.5 s en 4G).
- Tamaño de bundle JS/asset (límite por ruta).
- Memoria/tamaño de respuesta por request.
- Consultas por request (evitar N+1).

## 3. Backend y datos

- **Índices** en columnas de filtro/JOIN/orden.
- **Evitar N+1**: cargar en lote (`IN`, joins, dataloader).
- **Paginación** obligatoria en listados; nunca `SELECT *`.
- **Caché** en capas (memoria, distribuida, HTTP) con invalidación explícita y TTL.
- **Transacciones** cortas; no mantener locks innecesarios.
- **Compresión** y streaming para respuestas grandes.
- **Colas/async** para tareas pesadas, fuera del request.

## 4. Frontend y móvil

- **Code splitting** y lazy loading por ruta.
- Minimizar trabajo en render; memoización con criterio.
- Listas virtualizadas para grandes volúmenes.
- Imágenes optimizadas (tamaño/formato/lazy).
- Evitar re-renders innecesarios; estado derivado con funciones puras.
- Medir con Lighthouse/Profiler según plataforma.

## 5. Red y entrega

- HTTP caching (`ETag`, `Cache-Control`), CDN para estáticos.
- Compresión (gzip/brotli); HTTP/2+.
- Reducir round-trips y payloads.

## 6. Verificación

- [ ] Presupuestos definidos y medidos.
- [ ] Sin N+1 ni consultas sin índice en rutas críticas.
- [ ] Cachés con invalidación correcta.
- [ ] Pruebas de carga/estres donde aplique.
- [ ] Regresión de performance en CI (si es viable).

> **ES** — Las APIs concretas de profiling/caching viven en la skill de stack.
