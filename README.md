# MeshMind

> **AI-powered 3D modeling.** Describe it. Claude builds it.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Powered by Claude](https://img.shields.io/badge/Powered%20by-Claude%20AI-blue)](https://claude.ai)
[![Blender 4.0+](https://img.shields.io/badge/Blender-4.0%2B-orange)](https://www.blender.org)
[![MCP](https://img.shields.io/badge/Protocol-MCP-purple)](https://modelcontextprotocol.io)

---

## What is MeshMind?

MeshMind connects **Claude AI** to **Blender** through the **Model Context Protocol (MCP)**. You describe what you want in plain English — MeshMind handles the rest.

```
"A futuristic spaceship with glowing wings and a circular cockpit"
                            ↓
              Claude generates Blender Python code
                            ↓
                  Blender creates your 3D model
                            ↓
        "Make the wings more angular, add thruster ports"
                            ↓
                      Model updated ✨
```

No Python. No Blender expertise. Just describe and iterate.

---

## Features

| Feature | Status |
|---------|--------|
| MCP bridge (Claude ↔ Blender) | ✅ Ready |
| Interactive setup guide (`guide.sh`) | ✅ Ready |
| Auto MCP configuration & detection | ✅ Ready |
| Natural language → Blender scripts | 🔄 Phase 2 |
| Model templates (spaceship, character, etc.) | 🔄 Phase 2 |
| Conversational iteration & editing | 🔄 Phase 3 |
| Backup & rollback system | 🔄 Phase 4 |

---

## Quick Start

### Prerequisites

- **Claude Code** — [download](https://claude.ai/code)
- **Blender 4.0+** — [download](https://www.blender.org/download/)
- **Python 3.8+** — [download](https://www.python.org/)
- **Bash** — macOS, Linux, or WSL on Windows

### Setup

```bash
# 1. Clone the repository
git clone https://github.com/yourusername/meshmind.git
cd meshmind

# 2. Run the interactive setup guide
./guide.sh

# 3. Follow Step 1 to configure the MCP bridge
#    MeshMind auto-detects Blender and generates your config
```

---

## How It Works

```
┌─────────────────────────────────┐
│  You describe your model        │
│  "A cute robot with big eyes"   │
└──────────────┬──────────────────┘
               │
               ▼
┌─────────────────────────────────┐
│  Claude AI understands & plans  │
│  Breaks it into 3D components   │
└──────────────┬──────────────────┘
               │
               ▼
┌─────────────────────────────────┐
│  MeshMind generates the script  │
│  Valid Blender Python (bpy)     │
└──────────────┬──────────────────┘
               │
               ▼
┌─────────────────────────────────┐
│  Blender executes & renders     │
│  Your 3D model appears          │
└──────────────┬──────────────────┘
               │
               ▼
┌─────────────────────────────────┐
│  Iterate with conversation      │
│  "Make the arms longer"         │
└─────────────────────────────────┘
```

---

## Project Structure

```
meshmind/
├── guide.sh                    # Interactive setup (start here)
├── .mcp-config.json.example   # MCP config template
│
├── mcp/                        # MCP bridge layer
│   ├── server.py              # MCP server core
│   ├── blender-bridge.py      # Claude ↔ Blender execution
│   └── test-connection.py     # Connection validation
│
├── scripts/                   # Setup helpers
│   ├── helpers.sh             # Shell utilities
│   ├── setup-env.sh           # Environment init
│   └── generate-mcp-config.py # Auto config generation
│
├── blender/                   # Blender scripts (Phase 2)
├── templates/                 # Model templates (Phase 2)
├── docs/                      # Documentation (Phase 3+)
└── projects/                  # Your generated projects
```

---

## Documentation

| Document | Description |
|----------|-------------|
| [MASTERPLAN.md](./MASTERPLAN.md) | Phase-by-phase development roadmap |
| [CLAUDE.md](./CLAUDE.md) | AI agent guidelines & Blender conventions |
| [PHASE1.md](./PHASE1.md) | Phase 1 implementation details |

---

## Development Status

**Current Phase**: Phase 1 — MCP Connection ✅

```
Phase 0 ✅  Repository & Foundation
Phase 1 ✅  MCP Bridge & Claude Connection
Phase 2 🔄  3D Model Project Initialization
Phase 3 ⏳  Claude Editing Workflow
Phase 4 ⏳  Testing, Validation & Launch
Phase 5 ⏳  Polish & Documentation
```

See [MASTERPLAN.md](./MASTERPLAN.md) for the full roadmap.

---

## License

MIT — see [LICENSE](./LICENSE)

---

**Built for 3D creators who think in ideas, not code.**
