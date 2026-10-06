---
name: observability
description: >-
  Use when building or operating services that run in production and need logs, metrics,
  traces, health checks or alerts. Triggers on logging, structured logs, correlation IDs,
  monitoring, dashboards, SLOs, error tracking, distributed tracing or debugging in prod.
  Defines the observability pillar: know what the system is doing and detect problems
  before users do. Do NOT duplicate stack logging APIs — delegate to the stack skill.
---

# Skill: observability (pilar de observabilidad)

> **ES** — Pilar transversal. No puedes operar lo que no puedes ver. Logs, métricas y trazas
> responden: ¿qué pasó?, ¿está sano?, ¿por qué está lento?
> **EN** — Cross-cutting pillar. You can't operate what you can't see.

## 1. Reglas rectoras

1. **Todo error se registra** con contexto y stack; ningún `catch` silencia.
2. **Logs estructurados** (JSON o clave-valor), no `print` sueltos.
3. **Correlación** de punta a punta (`correlationId`/`traceId`) por request.
4. **Nunca loguear secretos ni PII**; redactar.
5. **Medir lo importante**: latencia, errores, saturación.
6. **Alertar sobre síntomas**, no sobre cada evento.

## 2. Logs

- Niveles claros: `debug`/`info`/`warn`/`error`; producción sin `debug` ruidoso.
- Contexto: método, ruta, actor (id, no PII), resultado, duración.
- Errores con stack; excepciones globales registradas por un filtro/middleware.
- Rotación/retención y destino definidos; **sin binarios ni base64** en logs.
- Redacción de credenciales, tokens, datos de salud/financieros y PII.

## 3. Métricas

- **RED** (Rate, Errors, Duration) por endpoint/servicio.
- **USE** (Utilization, Saturation, Errors) para recursos.
- **SLIs** ligados a los **SLO** de `availability`.
- Métricas de negocio relevantes (conversiones, colas, pendientes).

## 4. Trazas (Tracing)

- **Distributed tracing** con propagación de contexto entre servicios.
- Spans en operaciones externas (DB, HTTP, colas) y en el camino crítico.
- Muestreo configurable para no encarecer en exceso.

## 5. Salud y alertas

- **Health/readiness/liveness** endpoints.
- Alertas accionables con umbral y dueño; evitar fatiga de alertas.
- Runbooks para las alertas críticas.

## 6. Verificación

- [ ] Logs estructurados con correlationId y sin PII.
- [ ] Métricas RED/USE expuestas y dashboards.
- [ ] Trazas propagadas entre servicios.
- [ ] Health checks y alertas por SLO operativos.
- [ ] Todo error de aplicación queda registrado.

> **ES** — La implementación concreta (winston, OpenTelemetry, etc.) la define la skill
> de stack; este pilar define **qué** observar y **cómo**.
