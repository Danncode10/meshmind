# Claude 3D — Blender + MCP Integration

> Generate and edit 3D models in Blender using natural language with Claude AI.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude](https://img.shields.io/badge/Powered%20by-Claude%20AI-blue)](https://claude.ai)
[![Blender](https://img.shields.io/badge/Blender-4.0%2B-orange)](https://www.blender.org)

---

## What is Claude 3D?

Claude 3D bridges **Blender** and **Claude AI** through the **Model Context Protocol (MCP)**. Describe your 3D models in natural language, and Claude will:

1. **Understand** your 3D vision
2. **Generate** Blender Python scripts automatically
3. **Execute** in Blender without manual coding
4. **Iterate** by editing via natural language prompts

### Quick Example

```bash
# Start the interactive setup
./guide.sh

# Describe your model
"Create a futuristic spaceship with glowing wings and a circular cockpit"

# Claude generates the Blender script
# You can edit: "Make the wings more angular and add thruster ports"

# Blender renders your vision ✨
```

---

## Features

| Feature | Status |
|---------|--------|
| MCP Server for Blender integration | 🔄 In Progress |
| Interactive setup guide (`guide.sh`) | 🔄 In Progress |
| Natural language model descriptions | 🔄 In Progress |
| Auto-generation of Blender scripts | 🔄 In Progress |
| Claude AI prompt templates | 🔄 In Progress |
| Model templates (cube, sphere, character, etc.) | 🔄 In Progress |
| Backup & rollback system | 🔄 In Progress |
| Error handling & troubleshooting | 🔄 In Progress |

---

## Quick Start

### Prerequisites

- **Claude Code** installed ([download here](https://claude.com/claude-code))
- **Blender 4.0+** installed ([download here](https://www.blender.org/download/))
- **Bash** shell (macOS, Linux, or WSL on Windows)

### Installation

```bash
# 1. Clone or download this repository
git clone https://github.com/yourusername/claude-3d.git
cd claude-3d

# 2. Run the interactive setup guide
./guide.sh

# 3. Follow the prompts:
#    - Connect Claude ↔ Blender (MCP)
#    - Create your first 3D project
#    - Chat with Claude to edit your model
```

---

## The Workflow

```
┌─────────────────────────────────────┐
│  1. Describe Your Model             │
│  "A futuristic space station"       │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  2. Claude Generates Script         │
│  (Blender Python)                   │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  3. Blender Executes                │
│  (Creates 3D Model)                 │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  4. Iterate & Edit                  │
│  "Add glowing windows and antennas" │
└─────────────────────────────────────┘
```

---

## Documentation

| Document | Purpose |
|----------|---------|
| [**MASTERPLAN.md**](./MASTERPLAN.md) | Phase-by-phase development roadmap with checklist |
| [**CLAUDE.md**](./CLAUDE.md) | AI agent instructions & best practices |
| [**guide.sh**](./scripts/guide.sh) | Interactive setup & workflow guide (coming soon) |
| [**docs/WORKFLOW.md**](./docs/WORKFLOW.md) | Step-by-step user guide (coming soon) |
| [**docs/EXAMPLES.md**](./docs/EXAMPLES.md) | Real prompt examples (coming soon) |
| [**docs/ARCHITECTURE.md**](./docs/ARCHITECTURE.md) | How MCP + Claude + Blender work together (coming soon) |

---

## Repository Structure

```
claude-3d/
├── README.md              # This file
├── CLAUDE.md              # AI agent guidelines
├── MASTERPLAN.md          # Development roadmap
├── .gitignore             # Git exclusions
│
├── scripts/               # Setup & helper scripts
│   ├── guide.sh          # Interactive setup guide
│   ├── helpers.sh        # Utility functions
│   └── setup-env.sh      # Environment setup
│
├── mcp/                   # MCP Server implementation
│   ├── server.py         # MCP server core
│   ├── blender-bridge.py # Claude ↔ Blender bridge
│   └── error-handler.py  # Error handling
│
├── blender/              # Blender scripts
│   └── blender-script.py # Template & examples
│
├── templates/            # Project templates
│   ├── model-spec-template.md
│   ├── blender-script-template.py
│   └── model-examples/   # Pre-made examples
│
├── docs/                 # Extended documentation
│   ├── WORKFLOW.md
│   ├── EXAMPLES.md
│   ├── PROMPTS.md
│   ├── ARCHITECTURE.md
│   ├── API.md
│   ├── TROUBLESHOOTING.md
│   └── CONTRIBUTING.md
│
└── projects/             # User-generated projects
    └── (auto-created per project)
```

---

## Development Status

**Current Phase**: Phase 0 — Repository Foundation

- [x] Initialize git repository
- [x] Create README, CLAUDE.md, MASTERPLAN.md
- [x] Create folder structure & .gitignore
- [ ] **Next**: Phase 1 — MCP Connection (guide.sh Step 1)

See [MASTERPLAN.md](./MASTERPLAN.md) for the full roadmap.

---

## Contributing

Contributions welcome! Please see [CONTRIBUTING.md](./docs/CONTRIBUTING.md) (coming soon).

---

## License

MIT License — see [LICENSE](./LICENSE) (coming soon)

---

## Questions?

- Check [docs/TROUBLESHOOTING.md](./docs/TROUBLESHOOTING.md) for common issues
- Read [CLAUDE.md](./CLAUDE.md) for AI agent context
- Run `./guide.sh` to get started interactively

---

**Made with ❤️ for 3D creators and Claude AI enthusiasts**
