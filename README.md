# 📦 GitLab Project Version Packager

**GitLab Project Version Packager** es un sistema completo de CI/CD distribuido en tres repositorios que colaboran entre sí para generar y almacenar versiones empaquetadas de software. Cada versión se construye combinando una base genérica (`repositorio-generico`) con una parte específica de proyecto (`repositorio-proyecto`), y se almacena automáticamente en un repositorio central de versiones (`repositorio-versiones`).
Se requiere de modularidad completa del código para poder hacer uso de la versión actual.
El principal fin de este proyecto es evitar la duplicidad y facilitar el mantenimiento del código.

> 🔧 Sistema funcional orientado a entornos donde se comparten componentes entre múltiples productos o clientes, facilitando automatización y trazabilidad de versiones.

---

## 🧩 Arquitectura del sistema

El sistema está formado por tres repositorios interconectados:

### 1. `repositorio-generico`
- Contiene el código base común a todos los proyectos repositorio.
- Pipeline:
  - Clona el repositorio del proyecto (`repositorio-proyecto1`)
  - Fusiona los contenidos
  - Genera `.zip` combinados
  - Lanza trigger al repositorio de versiones

### 2. `repositorio-proyecto1`
- Contiene la parte específica de un proyecto repositorio.
- Pipeline:
  - Clona `repositorio-generico`
  - Combina contenido base + específico
  - Genera `.zip` empaquetado
  - Lanza trigger al repositorio de versiones

### 3. `repositorio-versiones`
- Repositorio central para almacenar los artefactos generados.
- Pipeline:
  - Se activa mediante trigger desde los otros dos repos
  - Recoge artefactos
  - Renombra con fecha
  - Hace commit de los `.zip` generados

---

## 📁 Estructura del repositorio actual

Este repositorio contiene y documenta los `.gitlab-ci.yml` utilizados en cada una de las partes:

```
.
├── .gitlab-ci-repositorio-generico.yml       # CI de repositorio-generico
├── .gitlab-ci-repositorio-proyecto.yml      # CI de repositorio-proyecto
├── .gitlab-ci-repositorio-versiones.yml      # CI de repositorio-versiones
├── README.md                         # Este archivo
```

---

## ⚙️ Requisitos para ejecutar el sistema completo

- GitLab con soporte para GitLab CI/CD
- Etiquetas de runner: `zip`, `notifyer`, `listener`, `commit`
- Variables de entorno en GitLab:
  - `CI_JOB_TOKEN`
  - `VERSIONS_TRIGGER_TOKEN`
  - `CI_PUSH_TOKEN`
  - `API_ACCESS_TOKEN`

---

## 🚀 Flujo completo resumido

```
[Push a main en repositorio-generico]
      ↓
[Pipeline combina genérico + específico]
      ↓
[Genera .zip] → [Trigger → repositorio-versiones]
                            ↓
                [Recoge artefactos y guarda]
```

O de forma alternativa:

```
[Push a main en repositorio-proyecto]
      ↓
[Pipeline combina específico + genérico]
      ↓
[Genera .zip] → [Trigger → repositorio-versiones]
                            ↓
                [Recoge artefactos y guarda]
```

---

## 🔍 Estado actual

- ✅ Pipelines funcionales en `repositorio-proyecto`,  `repositorio-generico` e  `repositorio-versiones`
- 🚧 En pruebas para despliegue en flujo completo con la herramienta en cuestión.

---

## 👩‍💻 Autora

**Celia Rico Gutiérrez**  
Ingeniera DevOps & Fullstack — CI/CD, automatización, empaquetado modular  
🔗 [LinkedIn](https://www.linkedin.com/in/celiaricogutierrez)  
🔗 [Perfil en Malt](https://www.malt.es/profile/celiaricogutierrez)

---

📅 _Última actualización: Junio 2025_
