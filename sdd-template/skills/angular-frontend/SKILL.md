---
name: angular-frontend
description: >-
  Use when working in Angular frontend projects (standalone components, Signals,
  Tailwind). Defines architecture + engineering conventions: feature-first entity
  folders (pages -> components: toolbar, table, modales), path aliases (@shared/@entities/@config/@environments/@utils/@assets),
  HTTP layer (ApiResponse wrapper, ErrorHandler, credentialsInterceptor), Signals
  state patterns (WritableSignal + asReadonly, DataBusService, RefreshTriggerService,
  NotificationService), standalone components with app- prefix, Spanish JSDoc +
  3-blank-line style, Signal Forms (fallback Reactive), and security best practices
  (XSS, secrets, guards, OWASP). Self-improving: refreshes official Angular best
  practices before generating the project skill. Always consult the latest official
  Angular/Tailwind docs. Do NOT use for backend projects (use nest-backend).
---

# Angular Frontend Conventions

Este documento define las convenciones y reglas de diseño para el desarrollo de
aplicaciones **Angular** (componentes standalone, Signals, Tailwind). La arquitectura
**del sistema/proyecto** (monorepo, multi-app, módulos, despliegue) se define en el SDD
(`06-architecture.md`), no aquí.

> **Delegación a pilares (anti-duplicación).** Los atributos de calidad viven en las skills
> transversales y aquí solo se referencian:
> - Seguridad → skill `security` (aquí solo lo propio de Angular: sanitización, guards, CSP).
> - Rendimiento → skill `performance` (aquí solo lo propio del bundle/SSR de Angular).
> - Usabilidad/accesibilidad → skill `usability`.
> - Pruebas → skill `testing`.
> - Limpieza/mantenibilidad → skill `clean-code` (aquí solo el estilo de Angular).

## 0. Buenas prácticas oficiales de Angular (automejora)

> **Automejora obligatoria.** Antes de generar el skill/spec definitivo del proyecto, el agente
> **debe** obtener las buenas prácticas oficiales vigentes y actualizar el *Snapshot* de abajo.
> - **Fuente primaria:** `https://angular.dev/assets/context/best-practices.md` (contexto para LLM).
> - **Fallback:** `https://angular.dev/ai/develop-with-ai` (contiene el mismo archivo + reglas + `llms.txt` + MCP del CLI).
> - **Regla:** digerir y **reemplazar el Snapshot**; nunca borrar las convenciones de equipo de este skill.

### Snapshot vigente (Angular v22 — verificar versión al actualizar)
- **TypeScript:** `strict`; inferencia cuando el tipo es obvio; evitar `any` (usar `unknown`).
- **Angular:** siempre **standalone** (no poner `standalone: true`); **no** poner `changeDetection: OnPush` explícito (default v22+); señales para estado; **lazy loading** en rutas de feature; `NgOptimizedImage` para imágenes estáticas.
- **Componentes:** `input()`/`output()` en vez de decoradores; `model()` para binding bidireccional `[(prop)]`; `computed()` para estado derivado; `linkedSignal()` para estado derivado sincronizado; templates inline en componentes pequeños; `host` object en vez de `@HostBinding`/`@HostListener`.
- **Formularios:** preferir **Signal Forms** (`@angular/forms/signals`, v22+); si no aplica, Reactive (nunca template-driven).
- **Plantillas:** control flow nativo `@if`/`@for`/`@switch`; `class`/`style` bindings (no `ngClass`/`ngStyle`); no importar `CommonModule` (importar solo lo usado); async pipe para observables; no asumir globals (`new Date()`).
- **Estado:** señales `set`/`update` (nunca `mutate`); transformaciones puras.
- **Servicios:** una responsabilidad; `@Service` (v22+) sobre `@Injectable({providedIn:'root'})`; `inject()` en vez de constructor.
- **Accesibilidad:** pasar **AXE** y cumplir **WCAG AA** (foco, contraste, ARIA). Ver skill `usability`.

## 1. Arquitectura de componentes (convenciones globales)

> La arquitectura del sistema (monorepo, multi-app, micro-frontends, despliegue) se define
> en `06-architecture.md` del SDD. Aquí solo las convenciones de estructura de Angular.

### 1.1 Estructura de Carpetas (Feature-First por Entidades)
```
src/
├── main.ts                   # bootstrapApplication(App, appConfig)
├── styles.css
├── assets/
│   └── theme.css             # Clases utilitarias y tokens globales de diseño
├── environments/
│   ├── environment.ts        # producción
│   └── environment.development.ts # desarrollo (apiEndpoint, VERSION, flags)
└── app/
    ├── app.ts / app.config.ts / app.routes.ts / app.html / app.css
    ├── shared/
    │   ├── components/       # componentes reutilizables (sidebar, topbar, toast, spinner, etc.)
    │   ├── enums/            # enums globales
    │   ├── interfaces/       # interfaces compartidas
    │   └── services/         # servicios globales (http + signals)
    └── entities/<nombre>/
        ├── pages/            # Componentes orquestadores de ruta (<nombre>-page.component.ts)
        │   └── <nombre>-page/
        ├── components/       # Subcomponentes clasificados por responsabilidad
        │   ├── toolbar/      # Filtros, búsqueda y barra de acciones (<nombre>-toolbar.component.ts)
        │   ├── table/        # Tabla o grilla de resultados (<nombre>-table.component.ts)
        │   └── modales/      # Modales principales de la entidad y sus subcomponentes
        │       └── <modal-nombre>/
        │           ├── <modal-nombre>.component.ts
        │           └── components/ # Subcomponentes internos del modal
        ├── enums/            # enums de la entidad
        ├── interfaces/       # interfaces de la entidad
        └── services/
            ├── http/         # llamadas REST de la entidad
            └── signals/      # estado y control de modales/pantallas
```

### 1.2 Jerarquía de Componentes por Entidad (`page -> toolbar -> table -> modales`)
- **`pages/`**: Contiene la página principal/orquestador de ruta (`<Entidad>PageComponent`). Integra sidebar, topbar, la toolbar de la entidad, la tabla/grilla de resultados y la inyección condicional de modales.
- **`components/toolbar/`**: Componente dedicado a la barra de herramientas, filtros reactivos, inputs de búsqueda y botones primarios de acción.
- **`components/table/`**: Componente dedicado a renderizar la tabla de datos, grilla de tarjetas o listas con sus estados de carga (loading) y sin resultados (empty state).
- **`components/modales/`**: Carpetas dedicadas por cada modal principal (`<entidad>-modal`). Cuando un modal posee componentes internos complejos, estos deben ubicarse en su subcarpeta `components/`.

## 2. Stack Tecnológico
- **Frontend**: Angular LTS (Componentes Standalone Puros, Gestión de estado con Signals, SIN NgRx).
- **Estilos**: Tailwind CSS + `src/assets/theme.css` como sistema principal de diseño. Notificaciones Toast gestionadas reactivamente por el servicio `NotificationService` y el componente `ToastComponent` en `@shared/components/toast`.
- **Backend**: definido en el SDD (skill de stack correspondiente). Este skill cubre SOLO el frontend Angular.

## 3. Aliases de Rutas (Paths en tsconfig.json)
Se deben configurar y usar estrictamente los siguientes path aliases:
- `@shared/*`      -> `src/app/shared/*`
- `@config/*`      -> `src/app/config/*`
- `@entities/*`    -> `src/app/entities/*`
- `@environments/*`-> `src/environments/*`
- `@utils/*`       -> `src/app/utils/*`
- `@assets/*`      -> `src/assets/*`

## 4. Capa HTTP y Convenciones Globales
- **Inyección**: Inyectar `HttpClient` y el servicio global `ErrorHandlerService` localizado en `@config`.
- **Response Wrapper**: Todos los endpoints del backend deben retornar `{ response: T }`. Los servicios de Angular deben retornar `Observable<{ response: T }>`.
- **Manejo Global de Errores**: Cada llamada HTTP debe aplicar:
  `catchError(err => this.errorHandler.httpHandleError(err))`
  - **400 / 404**: Mostrar alerta con `error.error.response`.
  - **401**: Limpiar la sesión (`«CLAVE_SESION»`) y redirigir al login.
  - **Otros**: Mostrar alerta genérica de error del sistema.
- **Credenciales**: Utilizar un interceptor funcional (`credentialsInterceptor`) en `app.config.ts` estableciendo `withCredentials: true` globalmente. No añadir `withCredentials` por llamada HTTP individual.
- **Subscriptions**: No declarar el callback `error` en `subscribe(...)` de los componentes: los servicios ya capturan el error con `catchError` (devolviendo `EMPTY`). Para limpieza al finalizar (ej. ocultar spinner/loading) usar el operador `finalize(() => ...)`.

## 5. Gestión de Estado y Control (Signals)
- **Patrón Reactivo**: El estado interno de los servicios debe usar `WritableSignal` expuesto como señal inmutable mediante `.asReadonly()`. La mutación directa de estados fuera de los servicios está prohibida.
- **Data Bus (`DataBusService`)**: Implementar `setData(operation: OperationEnum, data: unknown)`, `getData()`, y `resetData()`. Las operaciones deben usar un enum de tipo string.
- **Refresh Triggers (`RefreshTriggerService`)**: Coordinar re-fetch de componentes sin acoplamiento fuerte mediante `executeTrigger(id: string)` y `resetTrigger()`.
- **Modal Control Services**: Controlar visibilidad de modales mediante señal `isVisible` + payload `modalData` y métodos explícitos `open*()` y `close*()`.
- **Servicios de Utilidad**:
  - `SpinnerService`: Señal reactiva `loading` con métodos `show()` y `hide()`.
  - `NotificationService`: Servicio reactivo de notificaciones con el método `mostrarAlerta(respuesta: 1 | 0 | -1, mensaje: string)` (1 = éxito, 0 = error, -1 = advertencia). Se renderiza mediante `ToastComponent` (`@shared/components/toast`).

## 6. Seguridad y Autenticación
- **Sesión**: SSO multi-subdominio a través de cookies HTTP-only con wildcard (`Domain=«dominio configurado»`).
- **Ruta Protegida**: Proteger rutas privadas usando un guard funcional `CanActivateFn` que verifique el estado de la sesión bajo la clave `«CLAVE_SESION»` en `localStorage`.
- **OWASP**: aplicar las guías de seguridad de Angular y la cobertura OWASP vigente (ver skill `security`).

### 6.1 Desofuscación del payload (sesión/privilegios)
> Cuando el backend envía el payload de sesión/privilegios **ofuscado** (ver skill `nest-backend`), el frontend lo desofusca antes de usarlo. Es **ofuscación**, no cifrado: evita la lectura casual (consola/localStorage), la autorización real se impone en el servidor.
- **`CryptoService`** (cliente): método `desofuscar(payload: string): string` — inverso exacto del backend (`Base64` → separar `nonce` → `XOR` con la clave → `UTF-8`).
- **`B64Transformer`** (util): `encode`/`decode` de Base64 a/desde UTF-8 sin `atob`.
- **`PrivilegiosService`**: lee el payload ofuscado desde una **clave fija** de storage, lo desofusca y hace `JSON.parse` al tipo (`IPrivilegios`). Si no existe o es inválido → limpiar sesión y redirigir al login.
- **Clave**: `environment.OBFUSCATION_KEY` (nunca hardcodeada; misma que el backend).
- **Nunca** loguear el payload desofuscado ni la clave.

## 7. Estilo de Código y Estándares
- **Componentes**: Standalone con `templateUrl` (.html) y `styleUrl` (.css) separados (rutas **relativas** al archivo `.ts`); para componentes pequeños, template inline. El prefijo del selector debe ser `app-`.
- **Inyección**: usar `inject()` en vez de inyección por constructor.
- **Formateo**: Exactamente **3 líneas en blanco** entre métodos y miembros de clase.
- **JSDoc (Obligatorio en Español)**: Todo método (público o privado) y miembro debe incluir documentación JSDoc con:
  - `@description`
  - `@author [Autor] | YYYY-MM-DD`
  - `@param`
  - `@returns`
- **Formularios**: preferir **Signal Forms** (`@angular/forms/signals`, v22+); si no aplica, **Reactive Forms** con `FormBuilder`; evitar template-driven. Inicializar la lógica estrictamente dentro de `ngOnInit()`.
- **Paleta de Colores y Estilos Globales (theme.css)**: Definir y reutilizar clases CSS globales en `src/assets/theme.css` (e.g., `.app-card`, `.app-input`, `.app-btn-primary`, `.app-label`, `.app-link`) para evitar la repetición de estilos y clases utilitarias en las plantillas HTML de los componentes; solo crea nuevos estilos/clases cuando el uso de tailwind no sea suficiente.

## 8. Inicialización de la App y Localización
- `app.config.ts`: Registrar proveedores de rutas, HTTP con interceptor y la localización (`«locale configurado»`, ej. `es-MX`).
- `environments/`: Configurar `apiEndpoint`, `VERSION`, `OBFUSCATION_KEY` y variables de entorno.

## 9. Seguridad y Buenas Prácticas (Frontend)

> **Principios y OWASP → skill `security`.** Aquí solo lo específico de Angular:
- **XSS / Sanitización**: confiar en el escape automático de Angular (interpolación `{{ }}` y binding `[property]`). NUNCA usar `bypassSecurityTrustHtml/Css/Script/Url/ResourceUrl` sin necesidad real y revisión; evitar `[innerHTML]` con datos no confiables. Prohibido `eval`, `new Function` y `document.write`.
- **Enlaces peligrosos**: no usar `href="javascript:void(0)"` ni `javascript:`; usar `button` + `(click)` o `routerLink`. Validar URLs antes de `window.open`/`location.href` (evitar open redirect).
- **Secretos**: jamás hardcodear credenciales, tokens ni API keys en el código cliente. Todo en `environments/` o variables de entorno del build; recordar que el código cliente es público, nunca poner secretos de backend en el frontend.
- **Autenticación/Sesión**: preferir cookies httpOnly (SSO) antes que tokens en `localStorage`. Si se usa token en cliente, minimizar exposición (memoria/`sessionStorage` con justificación) y nunca loguearlo.
- **Autorización**: proteger rutas con guards (`CanActivateFn`) y validar permisos/roles en cada ruta; no confiar solo en ocultar la UI.
- **Validación de inputs**: `Validators` en formularios reactivos y sanitizar al renderizar. La validación del servidor es la fuente de verdad.
- **No loguear datos sensibles**: nunca `console.log` de tokens, credenciales ni datos personales.
- **Manejo de errores**: centralizar 401/403 en `ErrorHandler` (cerrar sesión y redirigir); no exponer detalles internos al usuario.
- **Dependencias**: mantener Angular y paquetes actualizados (`ng update`, revisar `npm audit`/`pnpm audit`); no añadir librerías sin necesidad.
- **CSP**: configurar Content Security Policy (headers o meta) evitando `unsafe-inline`/`unsafe-eval` cuando sea viable.
- **Uploads**: validar tipo, tamaño y contenido de archivos antes de enviarlos.

## 10. Documentación Oficial (verificar siempre)
- **Regla**: ANTES de implementar cualquier API, feature o patrón de Angular, verificar la documentación oficial vigente de la versión en uso. No asumir firmas ni imports de memoria; la doc oficial gana ante cualquier suposición.
  - Angular (guías/API): `https://angular.dev/overview`
  - **Buenas prácticas (contexto LLM):** `https://angular.dev/assets/context/best-practices.md` — si no está disponible, `https://angular.dev/ai/develop-with-ai`.
  - Contexto masivo: `https://angular.dev/llms.txt` · `https://angular.dev/assets/context/llms-full.txt`
  - Angular CLI MCP server: `https://angular.dev/ai/mcp` (setup en `https://angular.dev/ai/develop-with-ai`)
  - Seguridad: `https://angular.dev/best-practices/security` · Accesibilidad: `https://angular.dev/best-practices/a11y` · Errores: `https://angular.dev/best-practices/error-handling`
  - Tailwind: `https://tailwindcss.com/docs` (utilidades y config de la versión instalada).
- **Integraciones**: para librerías externas, revisar sus docs oficiales actuales.

## 11. Dependencias — autorización obligatoria
- **Regla rectora**: NO instalar ninguna dependencia sin antes **avisar al usuario exactamente qué se va a instalar** (paquetes, versiones y por qué) y **obtener su autorización explícita**.
- Instalar con el gestor del proyecto (habitualmente `npm`; usar `pnpm` solo si el proyecto lo define) y respetar la regla de no añadir librerías sin necesidad.
- Mantener Angular/paquetes actualizados (`ng update`, `npm audit`), pero siempre avisando y preguntando antes de un `install`/`add`.

## 12. Generación de archivos PDF / Excel — SIEMPRE en el backend
- **Regla rectora**: los PDFs se generan **server-side** (skill de backend, p. ej. `pdfmake`), NUNCA en el navegador ni con librerías cliente.
- El backend retorna `{ response: { base64: string } }`; el frontend convierte el base64 a `Blob` y dispara la descarga (`a[download]`) o lo abre.
- MIME: PDF → `application/pdf`; Excel → `application/vnd.openxmlformats-officedocument.spreadsheetml.sheet`.
- Al disparar una generación/descarga mostrar el **loading global** (`SpinnerService.show()/hide()`).
- No añadir librerías de PDF/Excel al `package.json` del frontend sin necesidad.

## 13. Inputs monetarios
- **Regla rectora**: los inputs de dinero muestran formato de **moneda configurable** (`«locale»`/`«moneda»`, ej. `MXN` → `$1,000.50`) en la vista, pero el **valor del `FormControl` y del request es numérico** (`1000.5`), nunca un string con `$` ni comas.
- Usar una directiva reutilizable (`CurrencyInputDirective`, selector `appCurrencyInput`, standalone, `ControlValueAccessor`) en `@shared/directives/currency-input`; no duplicar lógica de formato por componente.
- **Vista vs modelo**:
  - Al perder foco se formatea con `Intl.NumberFormat(«locale», { style: 'currency', currency: «moneda» })`.
  - Al enfocar se muestra el número editable sin agrupación (`1000.5`) para facilitar la edición.
  - La captura acepta dígitos y un único punto decimal; se descartan letras y caracteres inválidos.
- **Backend**: sigue siendo la fuente de verdad; volver a validar/normalizar el monto (p. ej. `422` si falta o es inválido).
- **Formularios**: `type="text"` + `inputmode="decimal"` + `appCurrencyInput`; el modelo se tipa `number | null`.
- **Dependencias**: no requerir librerías de máscara salvo necesidad y autorización previa (§11).

## 14. Principio de Responsabilidad Única (SRP)

> **Principios de código limpio → skill `clean-code`.** Aquí el SRP aplicado a Angular:
- **Cada método hace una sola cosa** y su nombre lo dice; si mezcla validación + HTTP + mapeo/transformación (o supera ~40 líneas), se parte en métodos privados de responsabilidad única.
- **Componentes delgados**: el componente orquesta y presenta; la lógica de negocio y las llamadas HTTP viven en servicios (`services/http/`), no en el componente.
- **Servicios con responsabilidad única**: un servicio por operación/dominio; el estado reactivo en servicios de `signals/` no mezcla fetching con transformación ni con control de modales.
- **Funciones puras** de cálculo/formateo en `@utils` o métodos privados puros, nunca embebidas en un método grande.
- Si un método tiene más de una razón para cambiar, extráelo.
