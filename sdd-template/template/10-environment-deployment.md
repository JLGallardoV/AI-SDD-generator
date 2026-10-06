# 10 — Entorno y despliegue / Environment & Deployment

> **ES** — Referencia de configuración. Los secretos no se guardan aquí; solo nombres de
> variables y su propósito.
> **EN** — Configuration reference. Variable names and purpose only, never secrets.

---

## 10.1 Puertos y apps (Ports)

### Q. ¿Qué apps existen, en qué puerto corren y con qué gestor?
**Answer:**

| App | Puerto dev | Gestor de paquetes |
|---|---|---|
| `[TO DEFINE]` | `[TO DEFINE]` | `[TO DEFINE]` |

## 10.2 Variables de entorno (Env variables)

### Q. ¿Qué variables existen por app y qué hacen?
**Answer:** `[TO DEFINE]`

| Variable | App | Propósito | Secreto |
|---|---|---|---|
| `[TO DEFINE]` | `[TO DEFINE]` | `[TO DEFINE]` | Sí/No |

> **ES** — Versionar solo plantillas `.env.example` con placeholders. Los `.env` reales van
> gitignored. Nunca leer ni commitear `*.env`. Las variables de cliente (bundle público)
> nunca llevan secretos.

## 10.3 Sesión y autenticación (Session)

### Q. ¿Cómo se transporta y almacena la sesión por plataforma?
**Answer:** `[TO DEFINE]` · `[FIXED ← skill: security]`

## 10.4 CORS y redes (CORS & networking)

### Q. ¿Qué orígenes/métodos/headers se permiten por entorno?
**Answer:** `[TO DEFINE]` / `[NO APLICA]`

## 10.5 Bootstrap y semillas (Bootstrap & seed)

### Q. ¿Qué debe existir antes de ejecutar (base de datos, esquemas, semillas, servicios)?
**Answer:** `[TO DEFINE]`

## 10.6 Dependencias (Dependencies)

### Q. ¿Qué dependencias base usa cada app?
**Answer:**
- Runtime: `[TO DEFINE]`
- Dev: `[TO DEFINE]`

> **Regla:** instalar solo con autorización previa (paquete, versión y propósito).

## 10.7 CI/CD

### Q. ¿Cómo se integra y despliega (pipelines, entornos, aprobaciones)?
**Answer:** `[TO DEFINE]`

## 10.8 Despliegue por entorno (Deployment)

### Q. ¿Cómo se despliega cada app en cada entorno (build, artefactos, infra)?
**Answer:** `[TO DEFINE]`

### Q. ¿Cómo se aplican cambios de esquema/datos en despliegue?
**Answer:** `[TO DEFINE]`

## 10.9 Run & verify (comandos)

### Q. ¿Cuáles son los comandos de ejecución y verificación del proyecto?
**Answer:** `[TO DEFINE]` · `[EJEMPLO]`

```powershell
# <app-backend>
pnpm install; if ($?) { pnpm run start:dev }

# <app-frontend>
pnpm install; if ($?) { pnpm run dev }

# pruebas
pnpm test
```

> **ES** — Estos comandos se copian al `AGENTS.md` de la raíz (ver `project-root/AGENTS.template.md`).
