# sdd-template

> **ES** — Plantilla de **Spec-Driven Development**: una carpeta que copias a cada proyecto
> nuevo y de la que el agente genera el SDD definitivo. Define, antes de programar, las
> mejores prácticas de seguridad, rendimiento, escalabilidad, disponibilidad, usabilidad,
> limpieza y observabilidad — para cualquier tipo de proyecto (web, backend, móvil, desktop,
> CLI, data/IA).
> **EN** — Spec-Driven Development template + reusable skills, copied per project.

---

## 1. Flujo de uso (How it works)

```
1. Copias esta carpeta `sdd-template/` y la pegas en el nuevo proyecto.
2. Le dices a opencode: "genera el SDD definitivo siguiendo sdd-template".
3. El orquestador `sdd-boot` (incluido en este template, NO es una skill global) crea
   <nombreProyecto>-sdd/ (archivos 00→12) y AGENTS.md en la raíz, y te ENTREVISTA en este
   orden: **stack → organización (monorepo o proyectos separados; si monorepo + JS, gestor
   de paquetes y workspaces) → tipo de proyecto y plataformas** — hasta no dejar [TO DEFINE].
4. Borras `sdd-template/` manualmente.
5. De ahí en adelante toda la guía vive en <nombreProyecto>-sdd/.
```

```
<projectRoot>/
├── AGENTS.md                 # generado desde project-root/AGENTS.template.md
├── <nombreProyecto>-sdd/     # SDD autoritativo (copiado de template/)
├── <app-web>/ <app-backend>/ <app-mobile>/ ...
└── sdd-template/             # temporal: se borra al terminar
```

> **ES** — Las **skills son globales** de opencode (transversales y de stack; `sdd-boot` no:
> vive solo aquí). Antes de empezar, instálalas una vez con `scripts/sync-skills.ps1` (ver §3).
> `sdd-template/` no se queda en el proyecto.

## 2. Estructura (Structure)

```
sdd-template/
├── README.md                 # este archivo
├── template/                 # 13 archivos → <nombreProyecto>-sdd/
│   ├── 00-README.md          #   protocolo/índice
│   ├── 01-discovery.md       #   perfil + Stack & Skills
│   ├── 02-vision.md          #   visión
│   ├── 03-requirements.md    #   requisitos REQ-*
│   ├── 04-data-model.md      #   datos
│   ├── 05-contracts.md       #   contratos (API/eventos/CLI/UI)
│   ├── 06-architecture.md    #   arquitectura
│   ├── 07-security.md        #   seguridad
│   ├── 08-quality-attributes.md # calidad
│   ├── 09-testing.md         #   pruebas
│   ├── 10-environment-deployment.md # entorno/deploy
│   ├── 11-handoff.md         #   transferencia
│   └── 12-definition-of-done.md # cierre
├── project-root/
│   └── AGENTS.template.md    # → raíz del proyecto como AGENTS.md
├── registry/
│   └── skills.registry.md    # catálogo + mapa tipo de proyecto → skills
├── skill-template/
│   └── SKILL.template.md     # scaffold para skills nuevas (.NET, Kotlin, …)
├── scripts/
│   └── sync-skills.ps1       # despliega skills a ~/.config/opencode/skills
└── skills/                   # FUENTE versionada de las skills
    ├── sdd-boot/             # orquestador (solo template; NO se sincroniza a global)
    ├── angular-frontend/ · nest-backend/ · react-native-expo/   # stack
    └── security/ · performance/ · scalability/ · availability/ \
        usability/ · clean-code/ · testing/ · observability/      # pilares
```

## 3. Modelo de skills (Skills model)

- **Las skills son globales** de opencode (`~/.config/opencode/skills/`); `sdd-boot` **no**:
  es parte del propio `sdd-template/` y opera desde ahí.
- **Esta carpeta es la fuente versionada**; la global es la **copia desplegada**.
- Edita siempre en `sdd-template/skills/` y luego sincroniza:

```powershell
# ver qué se haría
.\scripts\sync-skills.ps1 -WhatIf

# sincronizar todo (excepto sdd-boot)
.\scripts\sync-skills.ps1

# solo algunas
.\scripts\sync-skills.ps1 -Only security,testing
```

### Regla anti-duplicación (una sola fuente por conocimiento)

| Conocimiento | Dónde vive |
|---|---|
| Arquitectura/convenciones de una **tecnología** | skill de **stack** |
| Principios de un **pilar** (seguridad, rendimiento…) | skill **transversal** |
| **Decisiones y metas del proyecto** | archivos de `<nombreProyecto>-sdd/` |

El SDD **nunca** reescribe una skill: la referencia con `[FIXED ← skill: X]`.

## 4. Registrar skills y el plugin context-mode en opencode

**A) Sincronizar a global (recomendado)**
```powershell
.\scripts\sync-skills.ps1
```

**B) Apuntar `skills.paths` a esta carpeta** (sin copiar), en `~/.config/opencode/opencode.json`:
```json
{
  "$schema": "https://opencode.ai/config.json",
  "skills": { "paths": ["<ruta-absoluta>/sdd-template/skills"] }
}
```
> Sustituye `<ruta-absoluta>` por la ubicación donde clonaste `sdd-template`; funciona en
> cualquier equipo/SO (en Windows puedes usar `/` o `\\`). La opción **A** (`sync-skills.ps1`)
> es la recomendada porque no depende de ninguna ruta fija.

**Plugin `context-mode`** (ahorro de tokens): se activa por configuración, **no** desde
`AGENTS.md`. Decláralo en el arreglo `plugin` de `opencode.json`:
```json
{
  "$schema": "https://opencode.ai/config.json",
  "plugin": ["[TO DEFINE: nombre exacto del paquete o ruta local del plugin context-mode]"]
}
```
> Si es local: `"./.opencode/plugin/context-mode.ts"` (auto-descubierto en `.opencode/plugin/`).
> **Reinicia opencode** tras cambiar la config (no hay hot-reload).

Sus herramientas (las usa `AGENTS.md`): `ctx_batch_execute`, `ctx_execute` / `ctx_execute_file`,
`ctx_search`, `ctx_index` / `ctx_fetch_and_index`.

## 5. Extender la plantilla (nuevo stack: .NET, Kotlin, …)

1. `sdd-boot` detecta que no hay skill para el stack y te pregunta qué hacer.
2. Si aceptas, genera `skills/<stack>/SKILL.md` desde `skill-template/SKILL.template.md`
   (mini-entrevista: carpetas, convenciones, tooling, pruebas, seguridad propia).
3. Regístrala en `registry/skills.registry.md` y sincronízala con `sync-skills.ps1`.
4. Queda enlazada en `01-discovery.md` y `06-architecture.md` del proyecto.

## 6. Convenciones del template

- **Bilingüe:** encabezados y claves en inglés, prosa y preguntas en español.
- **Marcadores:** `[TO DEFINE]`, `[NO APLICA]`, `[FIXED ← skill: X]`, `[EJEMPLO]`, `[OPCIONAL]`.
- **Trazabilidad:** `REQ-*` → `05-contracts.md` → `09-testing.md` → `12-definition-of-done.md`.
- **Secretos:** nunca en el repo; solo plantillas `.env.example`.

## 7. Reglas de la plantilla

- No instalar dependencias sin autorización explícita.
- No leer ni commitear `*.env`.
- `sdd-template/` es la fuente única de la plantilla y de las skills; no dupliques su contenido dentro del proyecto.
