# Mazak VTC16B – LinuxCNC + NYX Configuration

This repository contains the complete LinuxCNC configuration for a Mazak VTC16B vertical machining center retrofitted with LinuxCNC and the NYX hardware controller by Yurtaev.

## Repository Structure

```
MAZAK-VTC16B/
├── configs/
│   └── vtc16b/           # Main machine configuration
│       ├── vtc16b.ini    # LinuxCNC INI file
│       ├── HAL/          # Hardware abstraction layer files
│       ├── macros/       # G-code macros
│       │   ├── probe/    # Probe calibration and measurement routines
│       │   ├── atc/      # ATC (automatic tool changer) routines
│       │   └── tooling/  # Tool management and spindle routines
│       ├── subroutines/  # Reusable G-code subroutines
│       ├── python/       # Python integration scripts
│       ├── ui/           # UI files and resources
│       ├── user_buttons/ # User-defined button templates
│       └── README.md     # Config layout documentation
├── linuxcnc-nyx/         # NYX LinuxCNC fork (git submodule)
├── scripts/
│   └── run-vtc16b.sh     # Convenient launch script
├── docs/
│   ├── README.md         # This file
│   └── NYX-VERSION.md    # NYX LinuxCNC version info
└── .gitmodules           # Git submodule configuration
```

## Quick Start

### Clone with Submodules

```bash
git clone https://github.com/djonesburke/MAZAK-VTC16B.git --recursive
cd MAZAK-VTC16B
git submodule update --init --recursive
```

### Launch LinuxCNC

```bash
./scripts/run-vtc16b.sh
```

Or manually:

```bash
linuxcnc configs/vtc16b/vtc16b.ini
```

## Key Components

- **HAL Files** (`configs/vtc16b/HAL/`)
  - `core.vtc16b.hal` – Motion and kinematics setup
  - `nyx.vtc16b.hal` – NYX servo integration
  - `io.vtc16b.hal` – E-stop, limits, and I/O
  - `atc.vtc16b.hal` – Tool changer interface
  - `spindle.vtc16b.hal` – Spindle control
  - `xhc.vtc16b.hal` – Pendant (wireless remote)
  - `postgui.vtc16b.hal` – Post-GUI initialization

- **Macros & Subroutines**
  - Probe routines for edge finding and calibration
  - ATC (carousel) management and tool changing
  - Spindle and coolant control
  - G30 and home position management

- **Display**
  - Probe Basic UI with custom widgets
  - Real-time DRO and tool offset display
  - ATC carousel visualization

## Build & Installation Notes

- This config requires the **NYX LinuxCNC fork** (tracked as a git submodule)
- The submodule is pinned to the `nyx2.9` branch
- See [docs/NYX-VERSION.md](NYX-VERSION.md) for submodule details

## Testing & Deployment

**Current Status:** Configuration under restructuring in the `FILE-CLEANUP` branch

- Test the reorganized config thoroughly on the VTC16B before merging to `main`
- Path references and INI/HAL includes have been updated for the new structure
- All G-code macros, subroutines, and UI components have been reorganized by function

## Support

For issues or questions about this configuration, refer to:
- LinuxCNC docs: https://linuxcnc.org
- Probe Basic UI: https://github.com/joco-nz/probe_basic_vcp
- NYX Project: http://yurtaev.com
