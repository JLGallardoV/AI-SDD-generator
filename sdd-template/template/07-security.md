# 07 — Seguridad / Security

> **ES** — Metas y modelo de seguridad **del proyecto**. Las técnicas y checklists viven en
> `[FIXED ← skill: security]`; aquí solo las decisiones y particularidades.
> **EN** — Project security targets & threat model. Techniques live in the `security` skill.

---

## 7.1 Modelo de amenazas (Threat model)

### Q. ¿Cuáles son los activos a proteger (datos, dinero, sesiones, disponibilidad)?
**Answer:** `[TO DEFINE]`

### Q. ¿Quiénes son los adversarios y sus vectores (STRIDE: spoofing, tampering, repudio, info disclosure, DoS, elevación)?
**Answer:**

| Amenaza | Activo | Impacto | Mitigación | Traza |
|---|---|---|---|---|
| `[TO DEFINE]` | `[TO DEFINE]` | `[TO DEFINE]` | `[TO DEFINE]` | `REQ-*` |

## 7.2 Autenticación y autorización (AuthN/AuthZ)

### Q. ¿Cómo se autentica (SSO, usuario/contraseña, OAuth2/OIDC, MFA, tokens) y con qué proveedor?
**Answer:** `[TO DEFINE]`

### Q. ¿Cómo se autoriza (RBAC, ABAC, claims, permisos por recurso)?
**Answer:** `[TO DEFINE]`

### Q. ¿Cómo se gestionan sesiones, expiración, refresco y revocación?
**Answer:** `[TO DEFINE]` · `[FIXED ← skill: security]`

## 7.3 Protección de datos (Data protection)

### Q. ¿Qué datos son sensibles y cómo se protegen en tránsito y en reposo?
**Answer:** `[TO DEFINE]`

### Q. ¿Qué datos se cifran, se ofuscan o se tokenizan? ¿Qué nunca se almacena?
**Answer:** `[TO DEFINE]`

### Q. ¿Se envía al frontend algún payload ofuscado (p. ej. sesión/privilegios) y se desofusca en el cliente? ¿Con qué algoritmo/clave y dónde se guarda?
**Answer:** `[TO DEFINE]` · `[EJEMPLO]` XOR + nonce + Base64 con `OBFUSCATION_KEY`, desofuscado en el cliente. Es **ofuscación, no cifrado** (la clave viaja al cliente); la autorización real va en el servidor. Ver skills `nest-backend`/`angular-frontend`.

### Q. ¿Qué se registra en logs y qué se debe redactar (PII, credenciales, tokens)?
**Answer:** `[FIXED ← skill: observability]` + `[TO DEFINE]`

## 7.4 Secretos y configuración (Secrets & config)

### Q. ¿Dónde viven los secretos por entorno (variables, vault, secret manager)?
**Answer:** `[TO DEFINE]`

### Q. ¿Cómo se rotan y quién tiene acceso?
**Answer:** `[TO DEFINE]`

## 7.5 Entradas y superficie de ataque (Input & attack surface)

### Q. ¿Qué validaciones/sanitizaciones son obligatorias en cada borde (API, formularios, uploads, SQL, comandos)?
**Answer:** `[FIXED ← skill: security]` + `[TO DEFINE]`

## 7.6 Cadena de suministro (Supply chain)

### Q. ¿Cómo se gestionan dependencias, licencias, vulnerabilidades (SCA) y builds reproducibles?
**Answer:** `[TO DEFINE]` · Regla: autorización explícita antes de instalar.

## 7.7 Cumplimiento (Compliance)

### Q. ¿Qué normativas aplican y qué controles concretos se implementan?
**Answer:** `[TO DEFINE]` / `[NO APLICA]`

## 7.8 Respuesta a incidentes (Incident response)

### Q. ¿Cómo se detecta, alerta, contiene y recupera un incidente de seguridad?
**Answer:** `[TO DEFINE]`

## 7.9 Verificación de seguridad (Security verification)

### Q. ¿Qué pruebas/revisiones de seguridad son obligatorias antes de producción?
**Answer:** `[TO DEFINE]` · `[EJEMPLO]` análisis de dependencias, revisión de authz, pruebas de
inyección, escaneo de secretos. Ver `09-testing.md`.

## 7.10 Cobertura OWASP (versión vigente)

> **Regla:** el OWASP es **dinámico**; **no fijar año**. Antes de definir los controles, consultar la
> versión **más reciente** en `https://owasp.org/projects/top-ten` (siempre apunta a la vigente).
> El estándar depende del tipo de proyecto. Objetivo: **resistente a los vectores OWASP aplicables**
> (no vulnerable / sin hallazgos explotables críticos/altos).

### Q. ¿Qué estándar OWASP aplica y cuál es la versión vigente al iniciar?
**Answer:** `[TO DEFINE]` · `[EJEMPLO]` Web → OWASP Top 10 · API → OWASP API Security Top 10 · Móvil → OWASP MASVS · Escritorio/CLI → mismos principios.

### Q. ¿Cómo se cubre cada familia de riesgo? (llenar la tabla)
**Answer:**

| Familia de riesgo | Aplica | Control implementado | Evidencia / Test | Traza |
|---|---|---|---|---|
| Control de acceso | `[TO DEFINE]` | `[TO DEFINE]` | `[TO DEFINE]` | `REQ-*` |
| Configuración insegura | `[TO DEFINE]` | `[TO DEFINE]` | `[TO DEFINE]` | `REQ-*` |
| Cadena de suministro | `[TO DEFINE]` | `[TO DEFINE]` | `[TO DEFINE]` | `REQ-*` |
| Criptografía | `[TO DEFINE]` | `[TO DEFINE]` | `[TO DEFINE]` | `REQ-*` |
| Inyección | `[TO DEFINE]` | `[TO DEFINE]` | `[TO DEFINE]` | `REQ-*` |
| Diseño inseguro | `[TO DEFINE]` | `[TO DEFINE]` | `[TO DEFINE]` | `REQ-*` |
| Autenticación | `[TO DEFINE]` | `[TO DEFINE]` | `[TO DEFINE]` | `REQ-*` |
| Integridad de software/datos | `[TO DEFINE]` | `[TO DEFINE]` | `[TO DEFINE]` | `REQ-*` |
| Logging y alertas | `[TO DEFINE]` | `[TO DEFINE]` | `[TO DEFINE]` | `REQ-*` |
| Manejo de excepciones | `[TO DEFINE]` | `[TO DEFINE]` | `[TO DEFINE]` | `REQ-*` |

### Q. ¿Cómo se garantiza el objetivo "no hackeable" (sin hallazgos explotables) antes de producción?
**Answer:** `[TO DEFINE]` · `[EJEMPLO]` revisión de authz, escaneo de dependencias y pruebas por familia OWASP; ver `12-definition-of-done.md`.
