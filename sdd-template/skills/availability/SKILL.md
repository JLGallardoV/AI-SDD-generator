---
name: availability
description: >-
  Use when a system has uptime commitments (SLO/SLA), needs fault tolerance, retries,
  failover, backups, disaster recovery or graceful degradation. Triggers on reliability,
  redundancy, health checks, circuit breakers, RTO/RPO, monitoring of errors or outages.
  Defines the availability/reliability pillar: eliminate single points of failure, recover
  fast, and degrade gracefully. Do NOT duplicate stack tooling — delegate to the stack skill.
---

# Skill: availability (pilar de disponibilidad y fiabilidad)

> **ES** — Pilar transversal. Disponibilidad = diseñar para que **falle bien** y se
> recupere rápido, no para que nunca falle.
> **EN** — Cross-cutting pillar. Design to fail well and recover fast.

## 1. Reglas rectoras

1. **Sin punto único de fallo** en lo crítico (réplicas, multi-zona).
2. **Asume que todo falla**: red, disco, dependencias, proveedor.
3. **Fail-fast + recuperación**: health checks, timeout, reintento, circuit breaker.
4. **Backups probados**: un backup no verificado no es un backup.
5. **Degradación elegante**: mejor parcial que caído.

## 2. Métricas y objetivos

- **SLO/SLA** y **error budget** explícitos (p. ej. 99.9 %).
- **RTO** (tiempo de recuperación) y **RPO** (pérdida de datos) definidos.
- **SLIs** monitoreados: latencia, tasa de error, saturación, uptime.

## 3. Tolerancia a fallos

- **Réplicas** y **failover** automático.
- **Health/readiness/liveness checks**.
- **Timeouts, retries con backoff y jitter**, **circuit breakers**, **bulkheads**.
- **Idempotencia** para reintentos seguros.
- **Colas** como buffer ante caídas de dependencias.

## 4. Recuperación (DR)

- Backups automáticos, cifrados y **restauración probada** periódicamente.
- Plan de recuperación documentado y ensayado.
- Migraciones reversibles / rollback de despliegue.

## 5. Degradación (Graceful degradation)

- Servir caché o modo lectura si una dependencia cae.
- Deshabilitar funciones no críticas antes que tumbar el servicio.
- Mensajes claros al usuario ante indisponibilidad.

## 6. Verificación

- [ ] SLO/SLA, RTO y RPO definidos y medidos.
- [ ] Sin SPOF en rutas críticas.
- [ ] Backups restaurables probados.
- [ ] Alertas por error budget.
- [ ] Rollback desplegable y ensayado.

> **ES** — La observabilidad (logs/métricas/alertas) vive en la skill `observability`.
