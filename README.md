# 🚀 GitLab Project Version Packager

**GitLab Project Version Packager** is a modular CI/CD system designed to automatically package software by combining multiple reusable modules. It generates delivery `.zip` files on every `merge` to `main`, organizing common and client- or feature-specific code in a structured way.

> This project is aimed at multi-client product environments, where it is necessary to combine generic parts and customizations, maintaining traceability, version control, and process automation.

---

## 🧩 Modular Architecture

The system is based on three key elements:

### 1. Module repositories (`modulo-generic`, `client-a`, `addon-X`)
- Each contains part of the product.
- On push to `main`, they generate their individual `.zip` using the `module-packager.yml` template.

### 2. Assembler repository (`repositorio-versionador`)
- Clones the required modules.
- Uses the `version-assembler.yml` template and the `assemble.sh` script.
- Combines the modules, creates a complete `.zip`, and publishes it as a versioned artifact.

### 3. This repository (`gitlab-project-version-packager`)
- Contains reusable CI/CD templates (`.yml`)
- Assembly scripts (`assemble.sh`)
- Usage documentation and examples

---

## 📁 Repository Structure

```
.
├── templates/
│   ├── module-packager.yml        # CI to package a single module
│   └── version-assembler.yml      # CI to assemble multiple modules
├── scripts/
│   └── assemble.sh                # Script to package and version
├── examples/
│   └── usage-client.yml           # Full usage example
├── docs/
│   └── multi-module.md            # Technical usage details
├── README.md
└── CHANGELOG.md
```

---

## ⚙️ Usage from External Repositories

### 🔹 To package a single module (generic, client, addon):

```yaml
include:
  - project: 'celiaricogz/gitlab-project-version-packager'
    ref: main
    file: '/templates/module-packager.yml'

variables:
  MODULE_FOLDER: 'client-a'
  PACKAGE_VERSION: "v1.0.${CI_PIPELINE_IID}"
```

### 🔹 To assemble multiple modules:

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

## 🔐 Requirements

- GitLab CI/CD enabled
- Access via `CI_JOB_TOKEN` or deploy keys to the module repos
- Runner with `bash`, `git`, `zip` support
- Protected variables if using private repos

---

## 🧪 Workflow

```
[modulo-generic.git] → individual .zip
[client-a.git]       → individual .zip
[merge to main in assembler]
          ↓
[CI clones all specified modules]
          ↓
[./scripts/assemble.sh combines and packages]
          ↓
[Delivery → client-a-release-v1.2.34.zip]
```

---

## 📦 Result

- Versioned `.zip` as pipeline artifact
- `manifest.txt` listing included modules
- Traceable history by hash, date, or tag

---

## 👩‍💻 Author

**Celia Rico Gutiérrez**  
DevOps Engineer — CI/CD automation, modularization, reproducible packaging  
🔗 [LinkedIn](https://www.linkedin.com/in/celiaricogutierrez)  
🔗 [Malt](https://www.malt.es/profile/celiaricogutierrez)
🔗 [UpWork](https://www.upwork.com/freelancers/~01898dfb872ff48b7a?mp_source=share)

---

📅 _Last updated: July 2025_