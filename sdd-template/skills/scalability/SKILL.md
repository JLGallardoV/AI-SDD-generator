---
name: scalability
description: >-
  Use when designing systems expected to grow in users, data or traffic, or when splitting
  a monolith, adding replicas, caches, queues, sharding or async processing. Triggers on
  concurrency, load balancing, statelessness, horizontal scaling, bottlenecks, partitioning
  or capacity planning. Defines the scalability pillar: stateless design, decoupling,
  caching, queues and graceful growth. Do NOT duplicate stack specifics — delegate to the
  stack skill.
---

# Skill: scalability (pilar de escalabilidad)

> **ES** — Pilar transversal. Escalar = sostener el crecimiento sin reescribir. Diseña para
> crecer **y** para decrecer (coste).
> **EN** — Cross-cutting pillar. Design to grow and to shrink.

## 1. Reglas rectoras

1. **Stateless primero**: el estado va en almacenes externos (cache, DB, sesión), no en el proceso.
2. **Escala horizontal** por defecto; la vertical es una salida temporal.
3. **Desacopla** con colas/eventos lo que no necesita ser síncrono.
4. **Asume fallos parciales**: reintentos, idempotencia, backoff.
5. **Capacidad medida**, no adivinada: conoce tus límites y cuellos.

## 2. Diseño escalable

- **Sin estado en el proceso** para poder replicar libremente.
- **Idempotencia** en operaciones reintentables (claves únicas, dedupe).
- **Particionado/sharding** cuando un recurso se vuelve cuello.
- **Multi-tenant** con aislamiento claro (por esquema, fila o instancia).
- **Configuración externalizada** (12-factor).

## 3. Datos

- **Réplicas de lectura** para distribuir carga.
- **Índices** y consultas eficientes (ver skill `performance`).
- **Caché** con invalidación: aliviar la DB antes de escalarla.
- **Colas/streaming** para picos y desacople (backpressure).
- **Paginación por cursor** en datasets grandes.

## 4. Comunicación

- **APIs sin afinidad de servidor** (no sticky sessions si se puede evitar).
- **Rate limiting** y **cuotas** para proteger el sistema.
- **Timeouts** y **circuit breakers** hacia dependencias.
- **Contratos versionados** para evolucionar sin romper.

## 5. Crecimiento por etapas

1. Monolito modular bien separado (el mejor punto de partida).
2. Réplicas + cache + CDN.
3. Colas/async + réplicas de lectura.
4. Servicios/particiones solo cuando el dato lo justifique.

## 6. Verificación

- [ ] Servicios sin estado (o estado externalizado).
- [ ] Operaciones reintentables idempotentes.
- [ ] Cache con invalidación definida.
- [ ] Picos absorbidos por colas/backpressure.
- [ ] Pruebas de carga y plan de capacidad documentados.

> **ES** — Evita sobre-ingeniería: escala cuando los datos lo pidan, no antes.
