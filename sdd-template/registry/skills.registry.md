# Registro de skills / Skills registry

> **ES** — Catálogo de skills de opencode y mapa **tipo de proyecto → skills**.
> Fuente versionada: `sdd-template/skills/`. Destino: `~/.config/opencode/skills/`
> (instalar/sincronizar con `sdd-template/scripts/sync-skills.ps1`).
> **EN** — Skill catalog and project-type → skills mapping.
>
> **ES** — Una skill es conocimiento reutilizable; el SDD es conocimiento de un proyecto.
> No dupliques: la skill define *cómo*, el SDD decide *qué* para este proyecto.

---

## 1. Skills disponibles (Available skills)

### 1.1 Transversales (aplican a cualquier proyecto)

| Skill | Pilar | Cuándo usarla |
|---|---|---|
| `security` | Seguridad | Siempre. AuthN/AuthZ, secretos, validación, OWASP, supply chain. |
| `performance` | Rendimiento | Siempre que haya latencia/throughput relevante. |
| `scalability` | Escalabilidad | Sistemas con crecimiento o concurrencia. |
| `availability` | Disponibilidad/Fiabilidad | Servicios con SLO/SLA, recuperación. |
| `usability` | Usabilidad/Accesibilidad | Cualquier UI o flujo de usuario. |
| `clean-code` | Limpieza/Mantenibilidad | Siempre. Estándares, SRP, reutilización. |
| `testing` | Calidad/Pruebas | Siempre. Estrategia, automatización, DoD. |
| `observability` | Observabilidad | Servicios en producción. Logs, métricas, trazas. |

### 1.2 De stack (por tecnología)

| Skill | Tecnología | Cuándo usarla | Fuente oficial (automejora) |
|---|---|---|---|
| `angular-frontend` | Angular (standalone + Signals + Tailwind) | Apps web Angular. | `https://angular.dev/assets/context/best-practices.md` (fallback: `https://angular.dev/ai/develop-with-ai`) |
| `nest-backend` | NestJS + MySQL (mysql2/promise) | Backends/API NestJS. | `[TO DEFINE]` (p. ej. `https://docs.nestjs.com/`) |
| `react-native-expo` | React Native + Expo (TypeScript) | Apps móviles. | `[TO DEFINE]` (p. ej. `https://docs.expo.dev/`) |

> **Automejora:** `sdd-boot` refresca cada skill de stack desde su **Fuente oficial** antes de
> generar el SDD definitivo (best-effort; si no hay red, usa el Snapshot embebido). La convención
> vive en `skill-template/SKILL.template.md §0`.

### 1.3 Orquestadora

| Skill | Propósito |
|---|---|
| `sdd-boot` | Recorre el SDD, corre la entrevista y crea/liga skills faltantes. |

---

## 2. Mapa tipo de proyecto → skills (Project-type mapping)

| Tipo de proyecto | Skills de stack | Transversales mínimas |
|---|---|---|
| Web frontend (Angular) | `angular-frontend` | `security`, `clean-code`, `testing`, `usability`, `performance` |
| Backend / API (NestJS) | `nest-backend` | `security`, `clean-code`, `testing`, `observability`, `scalability`, `availability` |
| Mobile (React Native/Expo) | `react-native-expo` | `security`, `clean-code`, `testing`, `usability`, `observability` |
| Full-stack / Monorepo | combinación de las anteriores | unión de las transversales aplicables |
| Desktop (.NET, Electron…) | `[ninguna aún]` → crear | `security`, `clean-code`, `testing`, `usability` |
| CLI / Librería | `[ninguna aún]` → crear | `security`, `clean-code`, `testing` |
| Data / IA / ML | `[ninguna aún]` → crear | `security`, `clean-code`, `testing`, `performance`, `scalability` |

> **ES** — El agente determina el tipo en `01-discovery.md`, propone este mapa y registra en
> la tabla **Stack & Skills** de ese archivo qué skill queda `INSTALADO`, `FALTA` o `NUEVO`.

---

## 3. Añadir una skill nueva (Adding a skill)

Cuando un stack no tenga skill (p. ej. .NET, Kotlin), `sdd-boot` puede:

1. Crear `<stack>/SKILL.md` a partir de `sdd-template/skill-template/SKILL.template.md`.
2. Registrarla en la tabla 1.2 de este archivo.
3. Instalarla con `sdd-template/scripts/sync-skills.ps1` (con autorización).
4. Enlazarla en `<projectName>-sdd/01-discovery.md` y `06-architecture.md`.

### Reglas para una skill de stack
- Solo contiene **tecnología**: arquitectura de carpetas, aliases, patrones, herramientas e
  idioms propios del framework/lenguaje.
- **No** reexplica pilares: los referencia (p. ej. "para seguridad, ver skill `security`").
- Describe en su `description` **qué hace y cuándo activarse** (keywords de disparo).

### Checklist de una skill nueva
- [ ] `name` = nombre de la carpeta, en kebab-case.
- [ ] `description` cubre **qué** y **cuándo** (front-load keywords).
- [ ] Arquitectura de carpetas + convenciones de la tecnología.
- [ ] **Fuente oficial** declarada (§0 Automejora) y Snapshot de buenas prácticas.
- [ ] Enganches a `security`, `testing`, `clean-code` (sin duplicar).
- [ ] Registrada aquí y enlazada desde el discovery del proyecto.
