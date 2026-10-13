# 00 — README / Protocolo · Spec-Driven Development (SDD)

> **ES** — Este folder es la **especificación autoritativa del proyecto** `<projectName>`
> antes de desarrollar. Está escrito como bloques **Pregunta / Respuesta** para que
> cualquier generador de código (opencode) lo lea y lo implemente de forma consistente.
> **EN** — This folder is the authoritative, pre-development specification of `<projectName>`.

> **ES** — Lee los archivos en orden: `00` → `12`. Solo `06-architecture.md` referencia el
> estándar técnico fijo; el resto se define por entrevista.
> **EN** — Read files in order: `00` → `12`. No `[TO DEFINE]` may remain before developing.

---

## 0.1 Glosario (Glossary ES/EN)

| ES | EN | Significado |
|---|---|---|
| Proyecto | Project | Producto o sistema a construir (puede tener varias apps). |
| Descubrimiento | Discovery | Entrevista inicial que define tipo, stack y metas. |
| Requisito | Requirement | Necesidad funcional/no-funcional con ID `REQ-*`. |
| Contrato | Contract | API, evento, comando CLI o contrato de UI que el sistema expone. |
| Skill | Skill | Conocimiento reutilizable (arquitectura de una tecnología o un pilar de calidad). |
| Pilar | Pillar | Atributo de calidad: seguridad, rendimiento, escalabilidad, etc. |
| DoD | Definition of Done | Criterios para considerar algo terminado. |

## 0.2 Convención de marcadores (Marker convention)

| Marcador | Significado |
|---|---|
| `[TO DEFINE]` | Pendiente de definir en la entrevista. Bloquea el "listo para desarrollar". |
| `[NO APLICA]` | Sección descartada según el descubrimiento (`01-discovery.md`). |
| `[FIXED ← skill: <name>]` | Regla propiedad de una **skill**; NO se reescribe aquí, solo se referencia. |
| `[EJEMPLO]` | Guía ilustrativa; se reemplaza o elimina. Nunca es normativo. |
| `[OPCIONAL]` | Puede omitirse si el proyecto no lo necesita. |

> **Regla de oro (anti-duplicación).** Una sola fuente por tipo de conocimiento:
> tecnología → skill de stack; pilar de calidad → skill transversal; decisión del proyecto
> → archivo de este folder. Este folder **nunca** reescribe una skill: la referencia.

## 0.3 Protocolo de entrevista (Interview protocol)

Cuando el usuario diga *"lee el SDD y definamos las especificaciones"*, el agente debe:

1. Leer todos los archivos `00` → `12` de este folder.
2. Ejecutar primero `01-discovery.md` (tipo de proyecto, plataformas, stack, escala,
   restricciones, metas de calidad, tabla **Stack & Skills**).
3. Con esas respuestas, decidir qué secciones aplican y marcar `[NO APLICA]` las que no.
4. Recorrer los archivos `02` → `12` en orden, leyendo cada `Q` y registrando la `Answer`
   del usuario hasta que **no quede ningún `[TO DEFINE]`**.
5. **No** redefinir convenciones que ya viven en una skill; solo referenciarlas
   (`[FIXED ← skill: X]`).
6. Validar `12-definition-of-done.md` y reportar si el proyecto está **listo para desarrollar**.

## 0.4 Añadir una feature/módulo al SDD (Adding a feature)

1. `01-discovery.md` → si cambia el stack o la escala, actualizar.
2. `02-vision.md` → agregar el módulo a la tabla de módulos.
3. `03-requirements.md` → agregar `REQ-{MODULO}-*` reutilizando reglas globales.
4. `04-data-model.md` → solo si introduce entidades/columnas.
5. `05-contracts.md` → agregar el contrato trazado a `REQ-*`.
6. `09-testing.md` → agregar los casos citando su `REQ-*`.
7. `10-environment-deployment.md` → puertos/variables/nuevas dependencias.
8. `11-handoff.md` → mencionar el módulo y sus comandos.
9. `06-architecture.md` → cambia solo si cambia el estándar técnico.
10. `12-definition-of-done.md` → confirmar que sigue cumpliéndose.

## 0.5 Reglas de dependencias (Dependencies)

Antes de instalar cualquier dependencia, **anunciar** paquete, versión y propósito, y
**obtener autorización explícita**.

> **ES** — Estas reglas generales viven en las skills (`security`, `clean-code`); aquí solo
> se declaran los comandos y particularidades del proyecto.

## 0.6 Índice de archivos (Files index)

| # | Archivo | Tipo |
|---|---|---|
| 00 | `00-README.md` | Protocolo + índice (este archivo) |
| 01 | `01-discovery.md` | Perfil del proyecto + Stack & Skills |
| 02 | `02-vision.md` | P&R — alcance, usuarios, MVP |
| 03 | `03-requirements.md` | P&R — requisitos funcionales/no-funcionales `REQ-*` |
| 04 | `04-data-model.md` | Convenciones + modelo de datos |
| 05 | `05-contracts.md` | Convenciones + contratos (API/eventos/CLI/UI) |
| 06 | `06-architecture.md` | Estándar técnico (referencia skills) |
| 07 | `07-security.md` | Pilar seguridad (proyecto) |
| 08 | `08-quality-attributes.md` | Pilares de calidad medibles |
| 09 | `09-testing.md` | Plan de pruebas |
| 10 | `10-environment-deployment.md` | Puertos, variables, CI/CD |
| 11 | `11-handoff.md` | Transferencia |
| 12 | `12-definition-of-done.md` | Checklist de cierre |

> **ES** — Las skills referenciadas son **globales** de opencode
> (`~/.config/opencode/skills/`). El registro vive en
> `sdd-template/registry/skills.registry.md`.
