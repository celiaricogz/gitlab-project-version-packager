# 📦 GitLab Project Version Packager

**GitLab Project Version Packager** es un sistema completo de CI/CD distribuido en tres repositorios que colaboran entre sí para generar y almacenar versiones empaquetadas de software. Cada versión se construye combinando una base genérica (`isa-generico`) con una parte específica de proyecto (`isa-proyecto`), y se almacena automáticamente en un repositorio central de versiones (`isa-versiones`).
En este caso ISA es un software especifico, podria usarse con cualquier otro tipo de software que contase con una parte generica y otra especifica de proyecto.
El principal fin de este proyecto es evitar la duplicidad y facilitar el mantenimiento del código.

> 🔧 Sistema funcional orientado a entornos donde se comparten componentes entre múltiples productos o clientes, facilitando automatización y trazabilidad de versiones.

---

## 🧩 Arquitectura del sistema

El sistema está formado por tres repositorios interconectados:

### 1. `isa-generico`
- Contiene el código base común a todos los proyectos ISA.
- Pipeline:
  - Clona el repositorio del proyecto (`isa-proyecto1`)
  - Fusiona los contenidos
  - Genera `.zip` combinados
  - Lanza trigger al repositorio de versiones

### 2. `isa-proyecto1`
- Contiene la parte específica de un proyecto ISA.
- Pipeline:
  - Clona `isa-generico`
  - Combina contenido base + específico
  - Genera `.zip` empaquetado
  - Lanza trigger al repositorio de versiones

### 3. `isa-versiones`
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
├── .gitlab-ci-isa-generico.yml       # CI de isa-generico
├── .gitlab-ci-isa-proyecto.yml      # CI de isa-proyecto
├── .gitlab-ci-isa-versiones.yml      # CI de isa-versiones
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
[Push a main en isa-generico]
      ↓
[Pipeline combina genérico + específico]
      ↓
[Genera .zip] → [Trigger → isa-versiones]
                            ↓
                [Recoge artefactos y guarda]
```

O de forma alternativa:

```
[Push a main en isa-proyecto]
      ↓
[Pipeline combina específico + genérico]
      ↓
[Genera .zip] → [Trigger → isa-versiones]
                            ↓
                [Recoge artefactos y guarda]
```

---

## 🔍 Estado actual

- ✅ Pipelines funcionales en `isa-proyecto`,  `isa-generico` e  `isa-versiones`
- 🚧 En pruebas para despliegue en flujo completo con la herramienta en cuestión.

---

## 👩‍💻 Autora

**Celia Rico Gutiérrez**  
Ingeniera DevOps & Fullstack — CI/CD, automatización, empaquetado modular  
🔗 [LinkedIn](https://www.linkedin.com/in/celiaricogutierrez)  
🔗 [Perfil en Malt](https://www.malt.es/profile/celiaricogutierrez)

---

📅 _Última actualización: Junio 2025_
