# 12 — Definition of Done / Criterios de cierre

> **ES** — Checklist que el agente valida al cerrar la entrevista (listo para desarrollar) y
> antes de liberar (listo para producción).
> **EN** — Checklist validated at interview close (ready to develop) and before release.

---

## 12.1 Listo para desarrollar (Definition of Ready)

- [ ] `01-discovery.md` completo: tipo, apps, stack+skills, escala, restricciones, metas.
- [ ] La tabla **Stack & Skills** no tiene skills `FALTA`/`NUEVO` sin decisión.
- [ ] No queda ningún `[TO DEFINE]` en `02`–`12` (o está justificado en `11-handoff.md`).
- [ ] Secciones no aplicables marcadas `[NO APLICA]` y coherentes.
- [ ] `03-requirements.md` tiene todos los `REQ-*` con criterio de aceptación.
- [ ] `05-contracts.md` traza cada contrato a su `REQ-*`.
- [ ] `06-architecture.md` referencia las skills correctas (`[FIXED ← skill: X]`).
- [ ] `09-testing.md` cubre los caminos P0.
- [ ] `10-environment-deployment.md` declara puertos, variables y comandos.
- [ ] `11-handoff.md` incluye comandos de ejecución.
- [ ] `AGENTS.md` generado en la raíz (entry point + context-mode + comandos).

## 12.2 Listo para producción (Definition of Done / Release)

- [ ] Todas las pruebas P0 automatizadas en verde (ver `09-testing.md`).
- [ ] Build, lint y typecheck sin errores; sin código muerto.
- [ ] Seguridad verificada: authz, validación, secretos, dependencias (`07-security.md`, skill `security`).
- [ ] Cobertura **OWASP vigente** revisada según el tipo de proyecto; sin hallazgos críticos/altos (`07-security.md`).
- [ ] Objetivo "no hackeable": sin hallazgos explotables conocidos.
- [ ] Metas de calidad medidas y dentro de objetivo (`08-quality-attributes.md`).
- [ ] Observabilidad activa: logs, métricas, alertas (`skill observability`).
- [ ] Sin secretos ni PII en el repositorio, logs o bundles.
- [ ] Migraciones/semillas aplicadas y reversibles.
- [ ] Documentación y `11-handoff.md` actualizados.
- [ ] Rollback/recovery probado (`skill availability`).

## 12.3 Criterios específicos del proyecto (Project-specific)

### Q. ¿Qué criterios adicionales debe cumplir este proyecto?
**Answer:** `[TO DEFINE]`

## 12.4 Firmas (Sign-off)

| Rol | Nombre | Fecha |
|---|---|---|
| Producto | `[TO DEFINE]` | |
| Técnico | `[TO DEFINE]` | |
