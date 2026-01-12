# NYX LinuxCNC Version

**Submodule:** `linuxcnc-nyx`  
**Repository:** https://github.com/yur7aev/linuxcnc.git  
**Branch:** `nyx2.9`  

## Pinned Commit

To get the exact commit this configuration was tested with, run:

```bash
git submodule status
```

Output will show the pinned commit hash. To update to the latest nyx2.9 commit, run:

```bash
git submodule update --remote linuxcnc-nyx
```

## Building NYX LinuxCNC

See the linuxcnc-nyx submodule's README for build and installation instructions.

## Configuration

This VTC16B config expects the NYX LinuxCNC fork to be available. The submodule is automatically cloned and initialized when you run:

```bash
git clone <repo> --recursive
git submodule update --init --recursive
```
