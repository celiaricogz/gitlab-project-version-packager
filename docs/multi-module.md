# 📦 Advanced Usage: Multi-Module Assembly

This document describes how to use the packaging system to combine multiple modules (generic, specific, addons, etc.) into a single versioned final delivery, using the `version-assembler.yml` and `assemble.sh` files.

---

## 🧩 What is a module?

A module is any Git repository that contains a functional part of the system:

- `modulo-generic`: common base for all clients.
- `client-x`: client-specific implementation.
- `addon-analytics`, `addon-persistence`: additional features.

---

## ⚙️ What does the assembler do?

- Clones all modules defined in `MODULE_REPOS`
- Mounts them in a temporary directory (`modules/`)
- Uses `scripts/assemble.sh` to:
    - Copy all modules under a single structure
    - Generate a `.zip` named with the version
    - Add a `manifest.txt` listing the included modules

---

## 📄 CI: version-assembler.yml

This pipeline is designed to run after a merge to `main` and automatically generate the delivery `.zip`.

### Expected variables:

```yaml
MODULE_REPOS: >
    git@gitlab.com/org/modulo-generic.git
    git@gitlab.com/org/client-x.git
    git@gitlab.com/org/addon-x.git

MODULE_NAMES: "generic client-x addon-x"
PACKAGE_NAME: "client-x-release"
PACKAGE_VERSION: "v1.0.${CI_PIPELINE_IID}"
```

### Output:

```
client-x-release-v1.0.23.zip
├── generic/
├── client-x/
├── addon-x/
└── manifest.txt
```

---

## 📜 Complete usage example (in .gitlab-ci.yml)

```yaml
include:
    - project: 'celiaricogz/gitlab-project-version-packager'
        ref: main
        file: '/templates/version-assembler.yml'

variables:
    MODULE_REPOS: >
        git@gitlab.com/org/modulo-generic.git
        git@gitlab.com/org/client-x.git
    MODULE_NAMES: "generic client-x"
    PACKAGE_NAME: "client-x-release"
    PACKAGE_VERSION: "v1.2.${CI_PIPELINE_IID}"
```

---

## 🛠️ Customization

You can modify `assemble.sh` to:

- Change the `.zip` structure
- Add validations or checksums
- Generate logs, hashes, or changelogs
- Upload the `.zip` to a bucket or GitLab Releases

---

## ✅ Recommendations

- Always use protected branches and `merge request pipelines`
- Tag important versions (`v1.0.0`, etc.)
- Document which modules compose each version in the `manifest.txt`
- Maintain a clear naming convention for modules and deliveries

---

Questions or suggestions? Open an issue in the repository or contact me on LinkedIn.