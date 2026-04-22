# Blender MCP Repository — Master Plan

A comprehensive checklist to build a Claude-powered Blender MCP server with an interactive setup guide.

---

## Phase 0: Repository Foundation ✅
Prepare the codebase structure and core files.

**Status**: COMPLETE

- [x] Initialize git repository
- [x] Create `.gitignore` (exclude .blend, .env.local, __pycache__, node_modules, etc.)
- [x] Create folder structure:
  - [x] `scripts/` — guide.sh and helper scripts
  - [x] `mcp/` — MCP server implementation
  - [x] `blender/` — Blender Python scripts
  - [x] `templates/` — Model templates and examples
  - [x] `docs/` — Extended documentation
- [x] Create `README.md` with DannFlow-style formatting
- [x] Create `CLAUDE.md` with AI agent guidelines
- [x] Create this `MASTERPLAN.md` with [ ] checkboxes

---

## Phase 1: MCP & Claude Connection (guide.sh Step 1)

Build the bridge between Claude Code and Blender.

- [ ] Create `guide.sh` main script with menu system
- [ ] Implement Step 1: "Setup MCP Connection"
  - [ ] Verify Claude Code is installed
  - [ ] Explain what MCP is (simple, user-friendly)
  - [ ] Check if Blender is installed and accessible
  - [ ] Create `.mcp-config.json` template
  - [ ] Prompt user to authenticate Claude ↔ Blender connection
  - [ ] Test MCP connection with simple validation
  - [ ] Save connection status to `config/mcp-status.json`
- [ ] Create `mcp/server.py` — Basic MCP server scaffold
- [ ] Create `mcp/blender-bridge.py` — Handles Claude → Blender communication
- [ ] Create `.mcp-config.json.example` template

---

## Phase 2: 3D Model Project Initialization (guide.sh Step 2)

Enable users to describe and auto-generate their 3D project.

- [ ] Implement Step 2: "Create Your 3D Model Project"
  - [ ] Prompt for project name & description
  - [ ] Ask user to describe the 3D model in natural language
  - [ ] Create project directory: `projects/{project_name}/`
  - [ ] Auto-generate files in project:
    - [ ] `model-spec.md` — 3D model description (Claude reference)
    - [ ] `blender-script.py` — Skeleton Python script
    - [ ] `claude-context.json` — Project metadata
    - [ ] `.env.local` — Project-specific env vars
  - [ ] Display summary of generated files
- [ ] Create `templates/model-spec-template.md`
- [ ] Create `templates/blender-script-template.py`
- [ ] Create `templates/model-examples/` with 3-5 pre-made descriptions:
  - [ ] Cube example
  - [ ] Sphere example
  - [ ] Character model example
  - [ ] Spaceship example
  - [ ] Landscape example

---

## Phase 3: Claude Integration & Editing Guide (guide.sh Step 3)

Teach users how to interact with Claude for model edits.

- [ ] Implement Step 3: "Chat with Claude to Edit"
  - [ ] Explain the workflow: describe → Claude generates → Blender executes
  - [ ] Show prompt template examples (e.g., "Add wings to the spaceship")
  - [ ] Create `EXAMPLES.md` with 5 sample edit prompts
  - [ ] Guide user on skill invocation (e.g., `/blender-edit`)
  - [ ] Show sample Claude conversation flow
  - [ ] Document limitations and best practices
- [ ] Create `docs/WORKFLOW.md` — Step-by-step editing workflow
- [ ] Create `docs/EXAMPLES.md` — Real prompt examples
- [ ] Create `docs/PROMPTS.md` — Prompt templates and tips
- [ ] Create optional `cli-shortcuts.md` for alias setup

---

## Phase 4: Testing & Launch (guide.sh Step 4)

Validate everything works and launch the project.

- [ ] Implement Step 4: "Launch Checklist"
  - [ ] Verify all files exist (guide.sh checks)
  - [ ] Verify Blender is accessible
  - [ ] Verify MCP connection works
  - [ ] Run a test: Generate simple 3D object (small cube)
  - [ ] Show success message with next steps
- [ ] Create error handling & helpful error messages
- [ ] Create `mcp/error-handler.py` for graceful failures
- [ ] Create rollback mechanism (version tracking for .blend files)
- [ ] Create `docs/TROUBLESHOOTING.md` with common issues
- [ ] Create backup system (auto-backup before Claude edits)

---

## Phase 5: Polish & Documentation

Final touches before launch.

- [ ] Add comprehensive docstrings to all Python files
- [ ] Create `docs/ARCHITECTURE.md` — How MCP + Claude + Blender connect
- [ ] Create `docs/API.md` — MCP server endpoints
- [ ] Add inline comments to guide.sh for clarity
- [ ] Test guide.sh on fresh machine (simulated)
- [ ] Write `CONTRIBUTING.md` for future developers
- [ ] Create `LICENSE` (MIT or similar)
- [ ] Final README review and polish
- [ ] Create release notes / CHANGELOG.md

---

## Summary of Deliverables

| Phase | Deliverable | Status |
|-------|-------------|--------|
| 0 | Repository structure, README, CLAUDE.md, MASTERPLAN | ✅ Complete |
| 1 | MCP bridge, guide.sh Step 1 | ⏳ Pending |
| 2 | Model initialization, templates, guide.sh Step 2 | ⏳ Pending |
| 3 | Editing workflow, examples, guide.sh Step 3 | ⏳ Pending |
| 4 | Validation, error handling, guide.sh Step 4 | ⏳ Pending |
| 5 | Documentation, polish, launch | ⏳ Pending |

---

## Key Files to Create

```
claude-blender/
├── README.md ✅
├── CLAUDE.md ✅
├── MASTERPLAN.md ✅
├── .gitignore
├── guide.sh (main interactive script)
├── scripts/
│   ├── helpers.sh
│   └── setup-env.sh
├── mcp/
│   ├── server.py
│   ├── blender-bridge.py
│   └── error-handler.py
├── blender/
│   └── blender-script.py
├── templates/
│   ├── model-spec-template.md
│   ├── blender-script-template.py
│   ├── model-examples/
│   │   ├── cube.md
│   │   ├── sphere.md
│   │   ├── character.md
│   │   ├── spaceship.md
│   │   └── landscape.md
├── docs/
│   ├── WORKFLOW.md
│   ├── EXAMPLES.md
│   ├── PROMPTS.md
│   ├── ARCHITECTURE.md
│   ├── API.md
│   ├── TROUBLESHOOTING.md
│   └── CONTRIBUTING.md
└── projects/ (user-generated projects go here)
```

---

**Status**: Ready to start Phase 0 setup. Once Phase 0 is complete, we move into guide.sh development.
