# 01 — Discovery / Perfil del proyecto

> **ES** — Primer archivo de la entrevista. Define **qué** se va a construir y **con qué**.
> Sus respuestas deciden qué secciones aplican y qué **skills** se cargan.
> **EN** — First interview file. Determines stack, repository organization, project type
> and quality targets, in that order.
> Every `Q` must end with an `Answer` and no `[TO DEFINE]`.

---

## 1.1 Identidad (Project identity)

### Q. ¿Cuál es el nombre del proyecto/producto?
**Answer:** `[TO DEFINE]`

### Q. ¿Cuál es el propósito en una línea?
**Answer:** `[TO DEFINE]`

### Q. ¿Quién es el dueño/stakeholder y quién mantiene el código?
**Answer:** `[TO DEFINE]`

### Q. ¿Nombre o alias del autor (para la autoría del código y la frase de cierre)?
**Answer:** `[TO DEFINE]` · Es el valor de `[Autor]` usado por `AGENTS.md` ("Entregado [Autor]") y
por `@author [Autor] | YYYY-MM-DD` en la documentación.

### Q. ¿En qué ruta vive el repositorio y cuál es su nombre corto (projectName)?
**Answer:** `[TO DEFINE]` · Ejemplo: `C:\...\proyectos\mi-producto`, projectName = `mi-producto`.

## 1.2 Stack & Skills

> **ES** — Primero el stack: por cada app/plataforma define la tecnología y la **skill** que
> la gobierna. El mapa de tipo de proyecto → skill vive en
> `sdd-template/registry/skills.registry.md`. Si no existe skill para el stack, decide aquí:
> **crear skill nueva**, **convenciones inline en este SDD** o **pendiente**.

### Q. ¿Qué stack usa cada app y qué skill lo gobierna?
**Answer:**

| App / plataforma | Stack | Skill (stack) | Estado | Decisión si falta |
|---|---|---|---|---|
| `[TO DEFINE]` | `[TO DEFINE]` | `[TO DEFINE]` | INSTALADO / FALTA / NUEVO | crear / inline / pendiente |
| `[TO DEFINE]` | `[TO DEFINE]` | `[TO DEFINE]` | `[TO DEFINE]` | `[TO DEFINE]` |

### Q. Si hay backend con base de datos, ¿qué motor se usa?
**Answer:** `[TO DEFINE]` · Ligar `[FIXED ← skill: nest-backend · driver: <mysql|postgresql|sqlserver|sqlite>]`. El motor también se declara en `04-data-model.md`.

### Q. ¿Qué skills transversales (pilares) aplican siempre?
**Answer:** `security`, `clean-code`, `testing` (mínimo) + `[TO DEFINE]`
(`performance`, `scalability`, `availability`, `usability`, `observability`).

### Q. ¿Qué lenguaje(s) y versiones mínimas se usan?
**Answer:** `[TO DEFINE]` · El **gestor de paquetes** se decide en §1.3 si el proyecto es un
monorepo JS/TS o derivados; en el resto de casos queda `[FIXED ← skill: <stack>]` o se
registra aquí.

### Q. Versiones del equipo vs última LTS (a la fecha de creación)
> Se llena durante la **auditoría de versiones** de `sdd-boot` (consultar la última estable/LTS en la fuente oficial; ver `10-environment-deployment.md`).
**Answer:**

| Tecnología | Versión del equipo | Última LTS (fecha) | Estado | Upgrade aprobado |
|---|---|---|---|---|
| `[TO DEFINE]` | `[TO DEFINE]` | `[TO DEFINE]` | OK / Desactualizada | Sí / No / — |

## 1.3 Organización del repositorio (Repository organization)

> **ES** — Se decide **después del stack**. Si es **monorepo** y el stack es
> **JavaScript/TypeScript o derivados**, se pregunta el gestor de paquetes y si se trabaja
> con workspaces. Si una pregunta condicional no aplica, márcala `[NO APLICA]`.

### Q. ¿El proyecto es un monorepo o proyectos separados (multi-repo)?
**Answer:** `[TO DEFINE]` · `Monorepo` / `Proyectos separados`
> Si es **Monorepo**, continúa con las dos preguntas condicionales siguientes. Si son
> **Proyectos separados**, márcalas `[NO APLICA]` y pasa a §1.4.

### Q. (Solo monorepo + JS/TS o derivados) ¿Qué gestor de paquetes prefieres?
**Answer:** `[TO DEFINE]` · `npm` / `pnpm` / `yarn (classic|berry)` / `bun` / `[NO APLICA]`
> La decisión se detalla y se aplica en `06-architecture.md` §6.1 y en `10-environment-deployment.md`.

### Q. (Solo monorepo) ¿Quieres trabajar con workspaces?
**Answer:** `[TO DEFINE]` · `Sí` (apps/paquetes compartidos: `[TO DEFINE]`) / `No` / `[NO APLICA]`
> Si **Sí**: registra los globs de workspaces en `06-architecture.md` §6.1.

## 1.4 Tipo de proyecto, plataformas y clientes (Project type, platforms & clients)

### Q. ¿Qué tipo de proyecto es? (marcar todos los que apliquen)
**Answer:**
- [ ] **Web frontend** (browser SPA/SSR)
- [ ] **Backend / API** (REST, GraphQL, gRPC, etc.)
- [ ] **Mobile** (iOS/Android)
- [ ] **Desktop** (Windows/macOS/Linux)
- [ ] **CLI / Librería** (herramienta de línea de comandos o paquete reutilizable)
- [ ] **Data / IA / ML** (pipelines, modelos, servicios)
- [ ] **Full-stack** (varias apps combinadas; la organización —monorepo/separados— se definió en §1.3)
- [ ] **Otro:** `[TO DEFINE]`

### Q. ¿Es un producto nuevo (greenfield) o evoluciona un sistema existente (brownfield)?
**Answer:** `[TO DEFINE]`

### Q. ¿Quiénes son los usuarios finales y desde qué dispositivo/plataforma acceden?
**Answer:** `[TO DEFINE]`

### Q. ¿Qué plataformas de despliegue se soportan (web, iOS, Android, Windows, Linux, nube)?
**Answer:** `[TO DEFINE]`

## 1.5 Escala y carga (Scale & load)

### Q. ¿Cuántos usuarios concurrentes/activos se esperan (hoy y a 1 año)?
**Answer:** `[TO DEFINE]`

### Q. ¿Qué volumen de datos y de tráfico (RPS, registros, GB)?
**Answer:** `[TO DEFINE]`

### Q. ¿Hay picos previsibles (campañas, horarios, cierres)?
**Answer:** `[TO DEFINE]`

## 1.6 Restricciones (Constraints)

### Q. ¿Qué restricciones de tiempo, presupuesto, equipo y tecnología existen?
**Answer:** `[TO DEFINE]`

### Q. ¿Hay sistemas, APIs o datos existentes que deban respetarse?
**Answer:** `[TO DEFINE]`

## 1.7 Datos y cumplimiento (Data & compliance)

### Q. ¿Se manejan datos personales o sensibles (PII, salud, financiero, credenciales)?
**Answer:** `[TO DEFINE]`

### Q. ¿Qué normativas aplican (GDPR, PCI-DSS, HIPAA, LFPDPPP, ISO 27001, ninguna)?
**Answer:** `[TO DEFINE]`

### Q. ¿Qué retención, auditoría y borrado de datos se requiere?
**Answer:** `[TO DEFINE]`

## 1.8 Autenticación y acceso (Auth & access)

### Q. ¿Cómo se autentican los usuarios (SSO, usuario/contraseña, OAuth, tokens, mTLS)?
**Answer:** `[TO DEFINE]`

### Q. ¿Qué roles/permisos existen?
**Answer:** `[TO DEFINE]`

### Q. ¿Hay integraciones de identidad (Azure AD, Google, LDAP, proveedor propio)?
**Answer:** `[TO DEFINE]`

## 1.9 Despliegue (Deployment target)

### Q. ¿Dónde se despliega (Cloud Run, AWS, Azure, on-premise, local, tiendas de apps)?
**Answer:** `[TO DEFINE]`

### Q. ¿Cómo se integra y entrega (CI/CD, git flow, revisión, entornos)?
**Answer:** `[TO DEFINE]`

### Q. ¿El sistema debe funcionar sin conexión (offline-first)?
**Answer:** `[TO DEFINE]`

## 1.10 Integraciones externas (Integrations)

### Q. ¿Con qué servicios/terceros se integra (pagos, correo, mapas, ERP, mensajería)?
**Answer:** `[TO DEFINE]`

## 1.11 Metas de calidad (Quality targets)

> **ES** — Estos números alimentan `08-quality-attributes.md`. Sé concreto y medible.

### Q. ¿Qué nivel exige cada pilar?
**Answer:**

| Pilar (skill) | Meta medible | Prioridad |
|---|---|---|
| Seguridad | `[TO DEFINE]` | Alta |
| Rendimiento | `[TO DEFINE]` (p. ej. p95 < 300 ms) | `[TO DEFINE]` |
| Escalabilidad | `[TO DEFINE]` | `[TO DEFINE]` |
| Disponibilidad | `[TO DEFINE]` (p. ej. 99.9 %) | `[TO DEFINE]` |
| Usabilidad/A11y | `[TO DEFINE]` (p. ej. WCAG 2.2 AA) | `[TO DEFINE]` |
| Observabilidad | `[TO DEFINE]` | `[TO DEFINE]` |
| Limpieza/Mantenibilidad | `[TO DEFINE]` | `[TO DEFINE]` |

## 1.12 Perfil resultante (Project profile — output)

> **ES** — El agente resume aquí, al cerrar este archivo, el perfil que gobierna el resto
> del SDD: tipo, apps, stack+skills, secciones aplicables y secciones `[NO APLICA]`.

**Answer:**
- **Tipo:** `[TO DEFINE]`
- **Apps y stack:** `[TO DEFINE]`
- **Skills activas:** `[TO DEFINE]`
- **Secciones aplicables:** `[TO DEFINE]`
- **Secciones `[NO APLICA]`:** `[TO DEFINE]`
