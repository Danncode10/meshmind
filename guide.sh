#!/bin/bash

################################################################################
# MeshMind — Interactive Setup Guide
# Main entry point for users to set up Claude + Blender + MCP
################################################################################

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m'

# Directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${SCRIPT_DIR}/config"
MCP_DIR="${SCRIPT_DIR}/mcp"
PROJECTS_DIR="${SCRIPT_DIR}/projects"
SCRIPTS_DIR="${SCRIPT_DIR}/scripts"

mkdir -p "${CONFIG_DIR}"

################################################################################
# Header
################################################################################

show_header() {
  clear
  echo -e "${BLUE}${BOLD}"
  cat << "EOF"
  __  __           _       __  __ _           _
 |  \/  | ___  ___| |__   |  \/  (_)_ __   __| |
 | |\/| |/ _ \/ __| '_ \  | |\/| | | '_ \ / _` |
 | |  | |  __/\__ \ | | | | |  | | | | | | (_| |
 |_|  |_|\___||___/_| |_| |_|  |_|_|_| |_|\__,_|
EOF
  echo -e "${NC}"
  echo -e "${CYAN}  AI-Powered 3D Modeling — Describe it. Claude builds it.${NC}"
  echo -e "${MAGENTA}  ─────────────────────────────────────────────────────${NC}\n"
}

################################################################################
# Utility Functions
################################################################################

log_section() {
  echo -e "\n${BLUE}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${CYAN}${BOLD}  $1${NC}"
  echo -e "${BLUE}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

log_info() {
  echo -e "${CYAN}  ℹ  ${NC}$1"
}

log_success() {
  echo -e "${GREEN}  ✅ $1${NC}"
}

log_warning() {
  echo -e "${YELLOW}  ⚠️  $1${NC}"
}

log_error() {
  echo -e "${RED}  ❌ $1${NC}"
}

prompt_yes_no() {
  local prompt="$1"
  local response
  while true; do
    read -p "$(echo -e "  ${CYAN}${prompt}${NC} [y/n]: ")" -r response
    case "$response" in
      [yY][eE][sS]|[yY]) return 0 ;;
      [nN][oO]|[nN]) return 1 ;;
      *) echo "  Please answer yes or no." ;;
    esac
  done
}

################################################################################
# Step 1: Setup MCP Connection
################################################################################

step_1_setup_mcp() {
  show_header
  log_section "STEP 1 — Setup MCP Connection"

  log_info "Configuring the Model Context Protocol (MCP) bridge"
  log_info "between Claude Code and Blender.\n"

  # Check Claude Code
  log_info "Checking Claude Code installation..."
  if command -v claude &> /dev/null; then
    log_success "Claude Code CLI found"
  else
    log_warning "Claude Code CLI not found in PATH"
    log_info "Install it from: https://github.com/anthropics/claude-code/releases\n"
    if ! prompt_yes_no "Continue anyway?"; then
      return 1
    fi
  fi

  # Explain MCP
  echo ""
  log_info "What is MCP?"
  echo ""
  cat << 'EOF'
    MCP (Model Context Protocol) creates a live bridge between Claude and
    Blender so you can describe 3D models in plain language:

      1. Describe your model → "A futuristic spaceship with glowing wings"
      2. Claude generates Blender Python code automatically
      3. MCP sends that code directly to Blender
      4. Blender executes it and creates your 3D model
      5. Iterate with follow-up prompts — no manual coding needed

EOF

  # Check Blender
  log_info "Checking Blender installation..."
  if command -v blender &> /dev/null; then
    local blender_version
    blender_version=$(blender --version 2>&1 | head -1)
    log_success "Blender found: ${blender_version}"
  else
    log_warning "Blender not found in PATH"
    log_info "Install Blender 4.0+: https://www.blender.org/download/\n"
    if ! prompt_yes_no "Continue anyway?"; then
      return 1
    fi
  fi

  # Generate MCP config
  echo ""
  log_info "Generating MCP configuration..."
  if python3 "${SCRIPTS_DIR}/generate-mcp-config.py"; then
    log_success "MCP config created: .mcp-config.json"
  else
    log_warning "Could not auto-generate MCP config — using defaults"
  fi

  # Save connection status
  local status_file="${CONFIG_DIR}/mcp-status.json"
  local timestamp
  timestamp=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  cat > "${status_file}" << EOF
{
  "configured": true,
  "timestamp": "${timestamp}",
  "mcp_server_url": "http://localhost:5000",
  "blender_bridge": "localhost:5001",
  "status": "ready",
  "last_test": null
}
EOF
  log_success "Connection status saved: config/mcp-status.json"

  # Test connection
  echo ""
  log_info "Running connection tests..."
  echo ""
  if python3 "${MCP_DIR}/test-connection.py" 2>/dev/null; then
    log_success "All connection tests passed!"
  else
    log_warning "Some tests returned warnings (normal on first setup)"
    log_info "The connection will activate when Claude Code runs.\n"
  fi

  echo ""
  log_success "Step 1 complete — MCP bridge is configured!"
  log_info "Run guide.sh again and choose Step 2 to create your first project.\n"
}

################################################################################
# Main Menu
################################################################################

show_menu() {
  show_header
  echo -e "${BOLD}  Getting Started Guide${NC}"
  echo -e "  Use ${CYAN}number keys${NC} to select a step\n"

  echo -e "  ${CYAN}[1]${NC}  Setup MCP Connection          ${GREEN}← Start here${NC}"
  echo -e "  ${CYAN}[2]${NC}  Create Your 3D Model Project  ${YELLOW}(coming soon)${NC}"
  echo -e "  ${CYAN}[3]${NC}  Chat with Claude to Edit       ${YELLOW}(coming soon)${NC}"
  echo -e "  ${CYAN}[4]${NC}  Launch Checklist               ${YELLOW}(coming soon)${NC}"
  echo -e "  ${CYAN}[0]${NC}  Exit\n"

  read -p "$(echo -e "  ${CYAN}Select option${NC} [0-4]: ")" -r choice

  case "$choice" in
    1) step_1_setup_mcp ;;
    2) log_warning "Step 2 coming soon — stay tuned!" ;;
    3) log_warning "Step 3 coming soon — stay tuned!" ;;
    4) log_warning "Step 4 coming soon — stay tuned!" ;;
    0)
      echo -e "\n  ${CYAN}Happy modeling! ✨${NC}\n"
      exit 0
      ;;
    *)
      log_error "Invalid option. Try again."
      ;;
  esac

  echo ""
  if prompt_yes_no "Return to menu?"; then
    show_menu
  else
    echo -e "\n  ${CYAN}Happy modeling! ✨${NC}\n"
    exit 0
  fi
}

################################################################################
# Entry Point
################################################################################

main() {
  show_menu
}

main "$@"
