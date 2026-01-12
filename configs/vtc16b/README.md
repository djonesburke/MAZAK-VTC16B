# VTC16B LinuxCNC Configuration

This directory contains the complete LinuxCNC configuration for the Mazak VTC16B retrofitted with NYX hardware controller.

## Layout

```
vtc16b/
├── vtc16b.ini              # Main configuration file
├── HAL/                    # Hardware abstraction layer
│   ├── core.vtc16b.hal     # Motion control core
│   ├── io.vtc16b.hal       # I/O and safety
│   ├── nyx.vtc16b.hal      # NYX servo drives
│   ├── spindle.vtc16b.hal  # Spindle motor control
│   ├── atc.vtc16b.hal      # Tool changer interface
│   ├── xhc.vtc16b.hal      # Pendant controller
│   └── postgui.vtc16b.hal  # Post-GUI initialization
├── macros/                 # G-code macros organized by function
│   ├── probe/              # Probing and edge-finding routines
│   ├── atc/                # Tool changer and carousel control
│   └── tooling/            # Spindle and tool management
├── subroutines/            # Reusable G-code subroutines
├── python/                 # Python integration scripts
├── ui/                     # UI resources and config
├── user_buttons/           # Custom button definitions
├── user_atc_buttons/       # ATC-specific custom buttons
├── user_tabs/              # Custom UI tabs
├── custom_config.yml       # Probe Basic display config
├── tool.tbl                # Tool table
├── vmc.var                 # Variable storage
├── qtdragon.var            # Qt display variables
├── nyx-mds.var             # NYX MDS variables
├── m_codes.txt             # M-code reference
└── vtc-16b-mds.par         # NYX parameter file
```

## INI File Organization

The main `vtc16b.ini` file includes:

- **[EMC]** – Machine identity
- **[DISPLAY]** – UI settings (Probe Basic)
- **[HAL]** – Hardware files to load (in order):
  1. `HAL/core.vtc16b.hal` – Motion setup
  2. `HAL/io.vtc16b.hal` – I/O configuration
  3. `HAL/nyx.vtc16b.hal` – Servo configuration
  4. `HAL/spindle.vtc16b.hal` – Spindle setup
  5. `HAL/atc.vtc16b.hal` – ATC configuration
  6. `HAL/xhc.vtc16b.hal` – Pendant setup
  7. `HAL/postgui.vtc16b.hal` – Post-GUI setup

- **[RS274NGC]** – G-code interpreter
  - `SUBROUTINE_PATH = macros:subroutines` (search order)
  - Remapped M-codes for toolchange and ATC control

- **[TRAJ]** – Trajectory settings
- **[EMCIO]** – I/O settings  
- **[KINS]** – Kinematics (trivkins XYZ)
- **[NYX]** – NYX controller parameters

- **[AXIS_*] / [JOINT_*]** – Axis and joint definitions (X, Y, Z)

## Macro Paths

LinuxCNC searches for G-code macros in this order:

1. `macros/probe/` – Edge finding and calibration
2. `macros/atc/` – Tool changing and carousel
3. `macros/tooling/` – Spindle and tool management
4. `subroutines/` – Utility and reusable subroutines

When a macro is called, LinuxCNC searches these paths in order until the file is found.

## Python Integration

The config includes Python-based remapping for tool changes:

- `python/toplevel.py` – Startup script
- `python/remap.py` – Remap handlers for M6 and other M-codes
- `python/stdglue.py` – Standard LinuxCNC Python glue

## Running the Config

```bash
# From the repo root
linuxcnc configs/vtc16b/vtc16b.ini

# Or use the convenience script
./scripts/run-vtc16b.sh
```

## Modifying Configuration

- **Servo tuning** → Edit `HAL/nyx.vtc16b.hal`
- **I/O assignments** → Edit `HAL/io.vtc16b.hal`
- **Spindle control** → Edit `HAL/spindle.vtc16b.hal`
- **Tool changer** → Edit `HAL/atc.vtc16b.hal`
- **Macros** → Add/edit files in `macros/` subdirectories
- **Display settings** → Edit `custom_config.yml`

## Notes

- All paths in INI/HAL files use relative paths (from the config directory)
- The config expects to run with the **NYX LinuxCNC fork** (linuxcnc-nyx submodule)
- Tool table is in `tool.tbl` (referenced in INI as `tools.tbl`)
- Variables are stored in `vmc.var` and `nyx-mds.var`
