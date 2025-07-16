# 🚀 GitLab Project Version Packager

**GitLab Project Version Packager** es un sistema modular de CI/CD diseñado para empaquetar software automáticamente combinando múltiples módulos reutilizables. Permite generar `.zip` de entrega en cada `merge` a `main`, organizando código común y específico de client o funcionalidad de forma estructurada.

> Este proyecto está orientado a entornos con productos multi-client, donde es necesario combinar partes genéricas y personalizaciones, manteniendo trazabilidad, control de versiones y automatización del proceso.

---

## 🧩 Arquitectura modular

El sistema se basa en tres elementos clave:

### 1. Repositorios de módulos (`modulo-generic`, `client-a`, `addon-X`)
- Cada uno contiene parte del producto.
- Al hacer push a `main`, generan su `.zip` individual usando el template `module-packager.yml`.

### 2. Repositorio ensamblador (`repositorio-versionador`)
- Clona los módulos necesarios.
- Usa el template `version-assembler.yml` y el script `assemble.sh`.
- Junta los módulos, crea un `.zip` completo y lo publica como artefacto versionado.

### 3. Este repositorio (`gitlab-project-version-packager`)
- Contiene las plantillas CI/CD reutilizables (`.yml`)
- Scripts de ensamblado (`assemble.sh`)
- Documentación de uso y ejemplos

---

## 📁 Estructura del repositorio

```
.
├── templates/
│   ├── module-packager.yml        # CI para empaquetar un solo módulo
│   └── version-assembler.yml      # CI para ensamblar múltiples módulos
├── scripts/
│   └── assemble.sh                # Script para empaquetar y versionar
├── examples/
│   └── usage-client.yml           # Ejemplo de uso completo
├── docs/
│   └── multi-module.md            # Detalles técnicos de uso
├── README.md
└── CHANGELOG.md
```

---

## ⚙️ Uso desde repositorios externos

### 🔹 Para empaquetar un solo módulo (genérico, client, addon):

```yaml
include:
  - project: 'celiaricogz/gitlab-project-version-packager'
    ref: main
    file: '/templates/module-packager.yml'

variables:
  MODULE_FOLDER: 'client-a'
  PACKAGE_VERSION: "v1.0.${CI_PIPELINE_IID}"
```

### 🔹 Para ensamblar múltiples módulos:

```yaml
include:
  - project: 'celiaricogz/gitlab-project-version-packager'
    ref: main
    file: '/templates/version-assembler.yml'

variables:
  MODULE_REPOS: >
    git@gitlab.com/org/modulo-generic.git
    git@gitlab.com/org/client-a.git
    git@gitlab.com/org/addon-analytics.git
  MODULE_NAMES: "generic client-a analytics"
  PACKAGE_NAME: "client-a-release"
  PACKAGE_VERSION: "v1.2.${CI_PIPELINE_IID}"
```

---

## 🔐 Requisitos

- GitLab CI/CD activo
- Acceso por `CI_JOB_TOKEN` o deploy keys a los repos de módulos
- Runner con soporte `bash`, `git`, `zip`
- Variables protegidas si se usan repos privados

---

## 🧪 Flujo de trabajo

```
[módulo-generico.git] → .zip individual
[client-a.git]       → .zip individual
[merge a main en ensamblador]
          ↓
[CI clona todos los módulos indicados]
          ↓
[./scripts/assemble.sh junta y empaqueta]
          ↓
[Entrega → cliente-a-release-v1.2.34.zip]
```

---

## 📦 Resultado

- `.zip` versionado como artefacto de pipeline
- `manifest.txt` con módulos incluidos
- Historial trazable por hash, fecha o tag

---

## 👩‍💻 Autora

**Celia Rico Gutiérrez**  
Ingeniera DevOps — Automatización CI/CD, modularización, empaquetado reproducible  
🔗 [LinkedIn](https://www.linkedin.com/in/celiaricogutierrez)  
🔗 [Malt](https://www.malt.es/profile/celiaricogutierrez)
🔗 [UpWork](https://www.upwork.com/freelancers/~01898dfb872ff48b7a?mp_source=share)

---

📅 _Última actualización: Julio 2025_