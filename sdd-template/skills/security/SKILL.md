---
name: security
description: >-
  Use ALWAYS when building, reviewing or refactoring any software (frontend, backend,
  mobile, desktop, CLI, data). Triggers on authentication, authorization, sessions,
  tokens, passwords, secrets, input validation, file uploads, SQL/queries, API endpoints,
  CORS, headers, cryptography, dependency installs, PII handling or compliance. Defines
  the security pillar: OWASP-aligned rules, threat modeling, secret management, secure
  defaults and a pre-release security checklist. Do NOT duplicate stack specifics (use
  the stack skill) — this skill owns the principles.
---

# Skill: security (pilar de seguridad)

> **ES** — Pilar transversal. La seguridad es **prioridad absoluta**. Aplica a cualquier
> lenguaje, plataforma y capa. No reescribe convenciones de stack: las complementa.
> **EN** — Cross-cutting pillar. Security is the top priority across every stack.

## 1. Reglas rectoras (Non-negotiables)

1. **Nunca confiar en el input.** Validar y sanear en cada borde (HTTP, formularios, archivos,
   CLI, colas, base de datos).
2. **Defensa en profundidad.** Varias capas; ninguna sola es suficiente.
3. **Mínimo privilegio.** Usuarios, servicios y procesos con el menor permiso necesario.
4. **Secure by default.** Lo inseguro debe ser imposible o requerir acción explícita.
5. **Nunca hardcodear secretos.** Todo por variables de entorno o un secret manager.
6. **No exponer detalles internos** al cliente (ni stack traces, ni versiones, ni SQL).
7. **Fallar cerrado (fail-closed).** Ante duda de autorización, denegar.
8. **Diseño seguro — objetivo "no hackeable".** La app debe ser **resistente a los vectores del OWASP vigente** según su tipo de proyecto, sin hallazgos explotables críticos/altos. La seguridad no es un estado absoluto: se convierte en requisitos verificables y defensa en profundidad.

## 2. Modelo de amenazas (STRIDE-lite)

- **S**poofing → autenticación fuerte, MFA donde aplique.
- **T**ampering → integridad, firmas, validación.
- **R**epudio → auditoría y logs inmutables.
- **I**nformation disclosure → cifrado, minimización de datos, redacción de logs.
- **D**enial of service → límites, rate limiting, timeouts, cuotas.
- **E**levation of privilege → autorización por recurso y por rol.

## 2bis. Estándares OWASP (consultar la versión vigente al iniciar)

> **Regla:** el OWASP es **dinámico** (cambia con los años). **NO fijar un año**; antes de definir
> los controles del proyecto, consultar la versión **más reciente** en
> `https://owasp.org/projects/top-ten` (ese enlace siempre apunta a la vigente).
> Objetivo: **resistente a los vectores OWASP del tipo de proyecto** (no vulnerable / sin hallazgos explotables).

- **Web** → OWASP Top 10. · **API** → OWASP API Security Top 10. · **Móvil** → OWASP MASVS / Mobile Top 10.
- **Escritorio / CLI / otros** → aplican las mismas familias de riesgo (abajo).

| Familia de riesgo | Mitigación obligatoria |
|---|---|
| Control de acceso | autorización por recurso/rol en el servidor, deny-by-default, anti-IDOR, CORS estricto, sin path traversal |
| Configuración insegura | sin credenciales por defecto, debug off en prod, headers de seguridad, permisos mínimos |
| Cadena de suministro | dependencias auditadas (SCA), lockfile, builds reproducibles, procedencia de artefactos |
| Criptografía | algoritmos fuertes vigentes, gestión/rotación de claves, TLS, cifrado en reposo |
| Inyección | consultas parametrizadas y salida escapada; nunca concatenar input (SQL/NoSQL/OS/LDAP/plantillas) |
| Diseño inseguro | threat modeling, límites de negocio, rate limiting, cuotas, antifraude |
| Autenticación | hash lento, MFA donde aplique, anti-credential-stuffing, rotación/revocación de sesión |
| Integridad de software/datos | firmas, verificación de artefactos, deserialización segura |
| Logging y alertas | registrar eventos de seguridad sin PII, detectar y alertar, retención y trazabilidad |
| Manejo de excepciones | fail-safe, no filtrar internals, manejo de recursos/errores, degradación elegante |

> La cobertura se declara y verifica en el SDD (`07-security.md`) y se prueba (`09-testing.md`).

## 3. Autenticación y sesión

- Contraseñas con **hash lento + salt** (bcrypt/scrypt/Argon2); nunca texto plano ni MD5/SHA1.
- Sesiones: tokens de acceso cortos + refresh revocable; cookies `httpOnly`, `Secure`,
  `SameSite`; o tokens en almacenamiento seguro del cliente (nunca en logs).
- Revalidar permisos en cada operación sensible, no solo en el login.
- Cerrar sesión invalida el refresh/token en el servidor.

## 4. Autorización (AuthZ)

- Verificar **permiso por recurso** en el servidor; ocultar UI no es autorización.
- Preferir roles/claims explícitos; denegar por defecto.
- Evitar IDOR: nunca exponer IDs secuenciales sin validar pertenencia.

## 5. Entrada, salida y datos (OWASP)

- **Inyección:** consultas parametrizadas; nunca concatenar input. Cuidado con SQL/NoSQL,
  comandos de shell, LDAP, plantillas y rutas (path traversal).
- **XSS:** escapar salida; evitar HTML no confiable; sanitizar; CSP.
- **CSRF:** tokens/`SameSite` en flujos con cookies.
- **SSRF:** validar URLs de salida; allowlist de destinos.
- **Deserialización/insecure by design:** evitar `eval`, `new Function`, `document.write`.
- **Uploads:** validar tipo (MIME real), tamaño y nombre; almacenar fuera del web root.
- **Cifrado:** TLS en tránsito; cifrado en reposo para datos sensibles.
- **Aleatoriedad:** usar CSPRNG para tokens/IDs.
- **SSRF/redirecciones:** evitar open redirect.

## 6. Secretos y configuración

- Secretos solo en `.env` (gitignored) o secret manager; nunca en código, bundles, logs,
  imágenes ni historial git.
- Plantillas `.env.example` con placeholders (sin valores reales).
- Rotación y acceso mínimo documentados.
- **Nunca leer ni commitear `*.env`.**

## 7. Cadena de suministro (Supply chain)

- **Autorización explícita** antes de instalar cualquier dependencia (paquete, versión, propósito).
- Preferir paquetes mantenidos; revisar licencias y vulnerabilidades (SCA/`audit`).
- Builds reproducibles; evitar scripts de instalación no revisados.

## 8. Logging y privacidad (privacy)

- Redactar credenciales, tokens, PII y datos de salud/financieros.
- No loguear payloads completos en producción.
- Minimizar recolección de datos; cumplir retención y borrado.

## 9. Headers y plataforma

- HTTP: `helmet` o equivalente (HSTS, X-Content-Type-Options, X-Frame-Options, CSP).
- CORS restringido a orígenes conocidos; sin `*` con credenciales.
- Rate limiting y timeouts en bordes públicos.

## 10. Checklist pre-release (obligatoria)

- [ ] AuthN/AuthZ verificadas en cada operación sensible.
- [ ] Entradas validadas y consultas parametrizadas.
- [ ] Sin secretos ni PII en repo, logs ni bundles.
- [ ] Dependencias auditadas; sin vulns críticas/altas abiertas.
- [ ] TLS y cabeceras de seguridad activas.
- [ ] Manejo de errores sin filtrar internals.
- [ ] Casos de seguridad en `09-testing.md` en verde.

> **ES** — Los detalles específicos de una tecnología los aporta la skill de stack; este
> pilar define el **qué** y el **por qué**.
