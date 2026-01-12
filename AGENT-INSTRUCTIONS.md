# MAZAK-VTC16B – Codespaces Agent Instruction Set

Repo: `github.com/djonesburke/MAZAK-VTC16B`  
Working branch: **FILE-CLEANUP** (do NOT modify `main`)

Goal:

1. Restructure the configs so they match how LinuxCNC & Probe Basic expect configs to be organized.  
2. Add a **NYX LinuxCNC** git submodule (`yur7aev/linuxcnc`, branch `nyx2.9`).  
3. Keep functional behavior as close as possible to the current working `VTC16B-PROBE-BASIC` config; changes are structural only.  
4. Perform all refactoring inside `FILE-CLEANUP` so the user can test on the machine before merging to `main`.

You are running in a Codespace and **cannot execute LinuxCNC**, so treat INI/HAL/G-code as static text.

---

## 1. Step-by-step restructuring tasks

### 1.1. Ensure correct branch

```bash
git fetch origin
git checkout FILE-CLEANUP
```

### 1.2. Identify current working config

Locate the currently working config directory:  
`VTC16B-PROBE-BASIC/`

Identify:
- Main INI file (`*.ini`)
- HAL files (`*.hal`)
- G-code macros/subs (`*.ngc`)
- UI files for Probe Basic

### 1.3. Create canonical LinuxCNC config root

```bash
mkdir -p configs/vtc16b
git mv VTC16B-PROBE-BASIC/* configs/vtc16b/
git rm -r VTC16B-PROBE-BASIC || true
```

Rename the INI:

```bash
git mv configs/vtc16b/*.ini configs/vtc16b/vtc16b.ini
```

All config restructuring happens inside `configs/vtc16b`.

---

## 2. NYX submodule setup

### 2.1. Add submodule

```bash
git submodule add -b nyx2.9 https://github.com/yur7aev/linuxcnc.git linuxcnc-nyx
```

### 2.2. Commit

```bash
git add .gitmodules linuxcnc-nyx
git commit -m "Add linuxcnc-nyx submodule tracking nyx2.9"
```

### 2.3. Add documentation

```bash
mkdir -p docs
cat << 'EOF' > docs/NYX-VERSION.md
# NYX LinuxCNC Version
Submodule: linuxcnc-nyx  
Repo: https://github.com/yur7aev/linuxcnc.git  
Branch: nyx2.9  
Pinned commit: (fill this in later)
EOF

git add docs/NYX-VERSION.md
git commit -m "Add NYX version documentation"
```

---

## 3. HAL file reorganization

Target split:
- `HAL/core.vtc16b.hal` – motion, joints, kinematics  
- `HAL/nyx.vtc16b.hal` – NYX/MDS servo integration  
- `HAL/io.vtc16b.hal` – estop, limits, lubrication, switches  
- `HAL/atc.vtc16b.hal` – carousel, toolchanger, ATC logic  

### 3.1. Create HAL directory

```bash
mkdir -p configs/vtc16b/HAL
```

### 3.2. Move HAL files

```bash
git mv configs/vtc16b/*.hal configs/vtc16b/HAL/core.vtc16b.hal
```

If multiple HAL files exist, move them all first.

### 3.3. Split HAL blocks into new files

```bash
touch configs/vtc16b/HAL/nyx.vtc16b.hal
touch configs/vtc16b/HAL/io.vtc16b.hal
touch configs/vtc16b/HAL/atc.vtc16b.hal
```

Move code blocks by function.

### 3.4. Update INI

```ini
[HAL]
HALFILE = HAL/core.vtc16b.hal
HALFILE = HAL/nyx.vtc16b.hal
HALFILE = HAL/io.vtc16b.hal
HALFILE = HAL/atc.vtc16b.hal
```

---

## 4. Macro/subroutine organization

### 4.1. Create directories

```bash
mkdir -p configs/vtc16b/macros/probe
mkdir -p configs/vtc16b/macros/atc
mkdir -p configs/vtc16b/macros/tooling
mkdir -p configs/vtc16b/subroutines
```

### 4.2. Categorize `.ngc` files

Probe → `macros/probe/`  
ATC → `macros/atc/`  
General tooling → `macros/tooling/`  
Reusable cycles → `subroutines/`

Move using `git mv`.

### 4.3. Update INI

```ini
[RS274NGC]
PROGRAM_PREFIX = ~/linuxcnc/nc_files
SUBROUTINE_PATH = macros:subroutines
```

---

## 5. INI/HAL path updates

### 5.1. Update INI references

Replace old paths with:

- `HAL/<file>.hal`
- `macros/...`
- `subroutines/...`
- `ui/...`

### 5.2. Update HAL includes

Search for:

- `source`
- `loadusr`
- `loadrt`

Ensure paths reference the new structure.

---

## 6. Scripts and documentation

### 6.1. Run script

```bash
mkdir -p scripts
cat << 'EOF' > scripts/run-vtc16b.sh
#!/bin/bash
linuxcnc "$(dirname "$0")/../configs/vtc16b/vtc16b.ini"
EOF

chmod +x scripts/run-vtc16b.sh
git add scripts/run-vtc16b.sh
git commit -m "Add run script"
```

### 6.2. Repo-level docs

```bash
mkdir -p docs
cat << 'EOF' > docs/README.md
# Mazak VTC16B – LinuxCNC + NYX Configuration

- configs/vtc16b: machine configuration  
- linuxcnc-nyx: NYX LinuxCNC source (submodule)  
- scripts/: launch scripts  
- docs/: documentation  

Usage:
git clone <repo>
git submodule update --init --recursive
./scripts/run-vtc16b.sh
EOF

git add docs/README.md
git commit -m "Add top-level documentation"
```

### 6.3. Config-local README

```bash
cat << 'EOF' > configs/vtc16b/README.md
# VTC16B LinuxCNC Config Layout

- vtc16b.ini  
- HAL/  
- macros/  
- subroutines/  
- ui/  
EOF

git add configs/vtc16b/README.md
git commit -m "Add config-local documentation"
```

---

## 7. .gitignore

```bash
cat << 'EOF' >> .gitignore
.vscode/
.idea/
*~
*.log
*.tmp
linuxcnc-nyx/debian/
linuxcnc-nyx/bin/
linuxcnc-nyx/lib/
linuxcnc-nyx/src/objects/
EOF

git add .gitignore
git commit -m "Add .gitignore entries"
```

---

## 8. Final push

```bash
git status
git push origin FILE-CLEANUP
```

---

# 9. Devcontainer Usage Instructions for the Agent

A `.devcontainer/devcontainer.json` file is included to standardize the Codespaces environment.

### 9.1. Behavior inside the devcontainer

Inside the container, you have:

- Ubuntu base image  
- Git + GitHub CLI  
- Submodules auto-initialized  
- Editor extensions for INI/HAL/G-code  
- Predictable POSIX filesystem structure  

Perform **all restructuring tasks inside the container**.

### 9.2. Post-create actions for the agent

After the container loads:

```bash
git submodule update --init --recursive || true
git checkout FILE-CLEANUP
```

Proceed with restructuring tasks.

### 9.3. Path expectations

Inside the devcontainer:

- Use POSIX paths only  
- No absolute paths  
- Ensure INI/HAL path references use:
  - `HAL/...`
  - `macros/...`
  - `subroutines/...`
  - `ui/...`

### 9.4. Before pushing changes

Run:

```bash
git add .
git commit -m "Apply structural config cleanup using devcontainer environment"
git push origin FILE-CLEANUP
```

The user will test on the machine before merging to `main`.

---

## End of AGENT-INSTRUCTIONS.md
