---
name: testing
description: >-
  Use ALWAYS when adding or changing code, and when defining or reviewing a test plan.
  Triggers on unit/integration/e2e tests, test doubles, fixtures, coverage, test matrix,
  acceptance criteria, CI test gates or reproduction of bugs. Defines the testing pillar:
  test real behavior and contracts, prioritize P0, and enforce a Definition of Done. The
  stack skill provides the concrete test framework and commands.
---

# Skill: testing (pilar de pruebas y calidad)

> **ES** — Pilar transversal. **Ningún cambio se da por terminado sin pruebas.** Se prueba
> comportamiento y contratos, no implementación.
> **EN** — Cross-cutting pillar. No change is done without tests. Test behavior, not internals.

## 1. Reglas rectoras

1. Sin pruebas **reales** no hay release. No andamiaje vacío ni tests que no aseveran.
2. Cada prueba cita su requisito (`REQ-*`).
3. Probar **comportamiento y contratos públicos**, no métodos privados.
4. Rápida, determinista y aislada; sin dependencias de red/tiempo reales.
5. Toda prueba nueva se registra en `09-testing.md` con su ID **antes** de cerrar el cambio.
6. Antes de la fase de pruebas de cada cambio: verificar que no haya **código muerto**
   (deadcode/knip o equivalente).
7. Al cerrar cada característica: **reportar** las pruebas que pasaron —deben pasar **todas**; si
   alguna falla, la característica **no** se da por cumplida— y que el **knip** se aplicó.

## 2. Pirámide y tipos

- **Unitarias (base):** lógica pura, cálculos, reglas de dominio.
- **Integración (media):** capas con DB/servicios reales o dobles.
- **E2E/contrato (cima):** flujos completos y contratos de API.
- **Manual:** solo layout, responsive, foco y efectos dependientes del entorno.

## 3. Priorización

- **P0 (siempre automatizado):** reglas de dominio, contratos, seguridad y camino crítico.
- **P1 (automatizar si es barato; si no, `MANUAL`):** validaciones secundarias y UX verificable.

## 4. Diseño de pruebas

- Patrón **Arrange–Act–Assert**.
- **Un comportamiento por caso**; nombres que describen la expectativa.
- **Test doubles** (stubs/mocks/fakes) en las fronteras, no en el dominio.
- **Fixtures** claros y mínimos; datos realistas.
- Cubrir camino feliz, validaciones, errores y bordes.

## 5. Datos y aislamiento

- Cada prueba crea y limpia sus datos; sin estado compartido entre tests.
- Sin depender del orden de ejecución.
- Sin `sleep` arbitrarios; esperar por condición.

## 6. Seguridad y regresión

- Casos de seguridad (authz, inyección, validación) como P0.
- Cada bug se fija con una prueba que falla antes y pasa después.
- Pruebas de contrato para no romper consumidores.

## 7. CI y Definition of Done

- El pipeline corre lint + typecheck + tests; **verde** para mergear.
- El código muerto se verifica **antes** de la fase de pruebas de cada cambio (ver §1), **no** en pre-push.
- Actualizar la matriz de `09-testing.md` con cada caso nuevo.

## 8. Verificación

- [ ] P0 automatizados y verdes.
- [ ] Casos citan su `REQ-*` y están en `09-testing.md`.
- [ ] Sin flakiness; aisladas y deterministas.
- [ ] Cobertura razonable en lógica crítica.
- [ ] Chequeo de código muerto (deadcode/knip) aplicado antes de la fase de pruebas.
- [ ] Reporte de cierre: pruebas pasadas (todas) + knip aplicado.
- [ ] Pipeline bloquea merges con tests rojos.

> **ES** — El framework de pruebas y los comandos los aporta la skill de stack.
