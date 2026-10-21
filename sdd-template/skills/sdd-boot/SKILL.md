---
name: sdd-boot
description: >-
  Template-local SDD orchestrator (lives ONLY inside sdd-template/, never installed as a
  global skill). Use when the user wants to START a new project or define/refresh its
  specification: triggers on "inicia proyecto", "nueva app", "genera el SDD", "genera el sdd
  definitivo", "define el SDD", "sdd-template", "sdd-boot", "vamos a especificar". Copies
  the SDD template into <projectName>-sdd/, generates the root AGENTS.md, runs the discovery
  interview (stack → repository organization → project type), resolves which skills apply
  (creating and installing missing stack skills like .NET or Kotlin), fills the spec until
  no [TO DEFINE] remains, and validates the Definition of Done. Do NOT use for day-to-day
  feature work on a project that already has a filled <projectName>-sdd/.
---

# Skill: sdd-boot — orquestador del SDD

> **ES** — Esta skill convierte `sdd-template/` en la spec de un proyecto concreto.
> Su salida es `<projectName>-sdd/` + `AGENTS.md`, guiados por entrevista.
> **NO es una skill global**: vive solo dentro de `sdd-template/` y opera desde ahí,
> generando y editando los documentos del SDD según las respuestas del usuario.
> **EN** — Turns the template into a concrete project spec. NOT a global skill: it lives
> only inside `sdd-template/` and operates from there.

## 0. Rutas (Paths)

- `PROJECT_ROOT = [TO DEFINE: raíz del proyecto donde está sdd-template/]`
- `SDD_TEMPLATE`:
  - Si existe `PROJECT_ROOT\sdd-template\` (flujo normal: la copiaste ahí) → úsala.
  - Si no → ruta maestra `[TO DEFINE: <ruta absoluta donde clonaste sdd-template>]`.
- `TEMPLATE_DIR   = $SDD_TEMPLATE\template`            (13 archivos `00`→`12`)
- `AGENTS_TPL     = $SDD_TEMPLATE\project-root\AGENTS.template.md`
- `SKILLS_SRC     = $SDD_TEMPLATE\skills`
- `REGISTRY       = $SDD_TEMPLATE\registry\skills.registry.md`
- `GLOBAL_SKILLS  = ~\.config\opencode\skills` (solo skills transversales y de stack;
  `sdd-boot` NO se instala ahí)
- `OUTPUT_DIR     = $PROJECT_ROOT\<projectName>-sdd`
- `AGENTS_OUT     = $PROJECT_ROOT\AGENTS.md`

> **ES** — Si algún supuesto de ruta es incorrecto, pregunta antes de copiar nada.

## 1. Cuándo activarse

- El usuario quiere **arrancar** un proyecto o **definir/refrescar** su SDD.
- El proyecto aún **no** tiene `<projectName>-sdd/` (o el usuario pide rehacerlo).

## 2. Flujo (Workflow)

1. **Confirmar datos base** (pregunta, no asumas):
   - `projectName` y `PROJECT_ROOT`.
   - Ubicación de `sdd-template/` (en el proyecto o ruta maestra).
   - Si ya existe `<projectName>-sdd/`, confirmar si sobreescribir, fusionar o abortar.
2. **Crear la estructura**:
   - Copiar `TEMPLATE_DIR\*` → `OUTPUT_DIR\`.
   - Copiar `AGENTS_TPL` → `AGENTS_OUT`.
   - Si existe un `AGENTS.md` previo, **no lo pises** sin autorización; ofrece fusionar.
   - **No** copies `skills/`, `registry/`, `scripts/`, `README.md` ni `skill-template/` al
     resultado: eso vive en la plantilla/global, no en el proyecto.
3. **¿Están instaladas las skills?** Verifica `GLOBAL_SKILLS`. Si faltan las transversales o
   las de stack, ofrece ejecutar `scripts\sync-skills.ps1` (pide autorización). `sdd-boot`
   no se verifica ni se instala: es parte del propio `sdd-template/`.
4. **Entrevista de descubrimiento**: recorre `01-discovery.md` preguntando cada `Q` y
   registrando la `Answer`, en este **orden obligatorio**:
   - Primero el **stack** (`§1.2`): apps, tecnologías y skills que las gobiernan.
   - Luego la **organización** (`§1.3`): monorepo vs proyectos separados. Si es
     **monorepo + JS/TS o derivados** → preguntar el **gestor de paquetes**
     (`npm` / `pnpm` / `yarn` / `bun`) y si quiere trabajar con **workspaces**.
   - Después el **tipo de proyecto** y plataformas (`§1.4`) y el resto del discovery.
   - Marca `[NO APLICA]` las condicionales que no correspondan.
   Al terminarlo, produce el **Perfil resultante** (tipo, apps, stack+skills, organización,
   secciones aplicables y `[NO APLICA]`).
5. **Resolver skills** con `REGISTRY`:
   - Para cada stack, marca `INSTALADO` / `FALTA` / `NUEVO`.
   - Si **FALTA/NUEVO** (p. ej. .NET, Kotlin), pregunta al usuario:
     **(a) crear skill ahora**, **(b) convenciones inline en el SDD**, **(c) dejar pendiente**.
     - Si **(a)**: ejecuta el **bootstrap de skill** (§3), con autorización.
     - Si **(b)**: deja `[FIXED]` inline y anótalo como deuda en `11-handoff.md`.
     - Si **(c)**: registra el pendiente en `11-handoff.md` y `12-definition-of-done.md`.
6. **Auditoría de versiones (LTS)**: por cada tecnología del stack elegido (runtimes + frameworks),
   detectar la **versión del equipo** (manifests del repo: `package.json`, lockfiles, `tsconfig`,
   `.nvmrc`, `global.json`…; si es greenfield, preguntar) y consultar la **última versión
   estable/LTS a la fecha** en la **Fuente de versiones (LTS)** declarada por la skill (§0 Automejora)
   —nunca de memoria—. Comparar y llenar la tabla de versiones en `01-discovery.md`. Si hay
   desactualización: **informar** y proponer un **plan de upgrade** en `10-environment-deployment.md`
   (breaking changes, pasos, riesgos) —**sin aplicarlo**—. Aplicar **solo con aprobación explícita**
   del usuario (dependencias con autorización). Al instalar/actualizar dependencias, auditar sus
   **scripts de ciclo de vida** (`preinstall`/`postinstall`/`prepare` u otros inusuales) con la regla
   de skill `security` §7: no ejecutarlos, investigar, reportar en **tabla** y pedir autorización.
7. **Refrescar buenas prácticas (automejora)**: por cada skill de stack activa con **Fuente
   oficial** declarada (ver `REGISTRY` y el `§0 Automejora` de cada `SKILL.md`), hacer fetch de la
   fuente primaria (fallback si no existe), digerir y **actualizar el Snapshot** de la skill (pide
   autorización antes de escribir). Si no hay red o la fuente no responde, usar el Snapshot embebido.
8. **Llenar el SDD**: recorre `02` → `12` en orden, pregunta por cada `Q` y escribe la
   `Answer`. Marca `[NO APLICA]` donde el perfil lo indique. **No** redefinas skills:
   usa `[FIXED ← skill: X]`.
9. **Generar `AGENTS.md`**: completa los `[TO DEFINE]` del `AGENTS_TPL` (fuente de verdad a
   `<projectName>-sdd/00-README.md`, context-mode, frase de cierre, comandos desde
   `10-environment-deployment.md`, skills activas) y escríbelo en `AGENTS_OUT`.
10. **Validar `12-definition-of-done.md`** (Definition of Ready). Reporta:
   - qué quedó listo, qué `[TO DEFINE]` siguen abiertos y qué está `[NO APLICA]`;
   - si está **listo para desarrollar** (sin `[TO DEFINE]` bloqueantes).
11. **Cierre**: recordar al usuario que ya puede **borrar `sdd-template/`** manualmente; a
   partir de ahí la guía vive en `<projectName>-sdd/`.

## 3. Bootstrap de una skill nueva (nuevo stack)

1. Leer `$SDD_TEMPLATE\skill-template\SKILL.template.md`.
2. Mini-entrevista: arquitectura de carpetas, convenciones, tooling, framework de pruebas,
   particularidades de seguridad, dependencias base, **fuente oficial** y **fallback** (para la automejora).
3. Generar `$SDD_TEMPLATE\skills\<stack>\SKILL.md` (nombre kebab-case, `description` con
   **qué** y **cuándo**); incluir `§0 Automejora` con la Fuente oficial y su Snapshot.
4. Registrarla en `REGISTRY` (tabla de skills de stack, con su **Fuente oficial**) y en la sección de extensión.
5. Instalarla: `scripts\sync-skills.ps1 -Only <stack>` (**pedir autorización**).
6. Enlazarla en `<projectName>-sdd\01-discovery.md` y `06-architecture.md` como
   `[FIXED ← skill: <stack>]`.

## 4. Reglas de la entrevista (Interview rules)

- **Una pregunta a la vez** o por bloques pequeños; no abrumar.
- Presenta las opciones, hallazgos y comparativas en **formato tabla** (markdown); usa otro
  formato solo cuando la tabla no aporte claridad.
- Ofrecer `[EJEMPLO]` cuando ayude, marcándolo como ejemplo.
- No inventar respuestas del usuario; si no sabe, anotar `[TO DEFINE]` y avanzar.
- No tocar archivos fuera de `<projectName>-sdd\` y `AGENTS.md` sin autorización.
- Respetar la regla anti-duplicación: tecnología→skill, pilar→skill, decisión→SDD.

## 5. Cierre (Output contract)

Al terminar, entrega:
- Árbol de `<projectName>-sdd\` creado.
- `AGENTS.md` en la raíz.
- Skills creadas/instaladas y su registro actualizado.
- Estado de `12-definition-of-done.md`.
- Lista de `[TO DEFINE]` restantes (si hay) y próximos pasos.
- Recordatorio: borrar `sdd-template/`.
