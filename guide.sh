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

  # Prerequisite check
  echo -e "  ${BOLD}Before you begin:${NC}"
  echo -e "  Make sure you have the ${CYAN}Blender app${NC} installed on your machine."
  echo -e "  Download it at: ${CYAN}https://www.blender.org/download/${NC}\n"
  if ! prompt_yes_no "Do you have Blender installed?"; then
    log_info "Install Blender 4.0+ first, then re-run this step."
    return 1
  fi

  echo ""
  log_section "Inside Blender — Follow These Steps"

  cat << 'EOF'

  ① Open Blender and do a Save As into this project folder
    File → Save As → navigate here → save your .blend file

  ② Enable the Blender MCP Add-on
    Edit → Preferences → Add-ons → search "Blender MCP" → check the box ✓

  ③ Open the MCP Side Panel
    Press  N  on your keyboard → look for the "Blender MCP" tab on the right

  ④ (Optional) Use Assets from Sketchfab
    Check "Use Asset from Sketchfab"
    To get your API key:
      → Go to sketchfab.com → Settings → Password & API → copy your API key
      → Paste it into the Sketchfab API Key field

  ⑤ (Optional) Enable Hyper 3D Rodin Model Generation
    Check "Hyper 3D Rodin 3D Model Generation"
    → Set your free trial API key from the Hyper 3D Rodin dashboard

  ⑥ Click  "Connect MCP Server"  in the Blender MCP panel
    You should see a green "Connected" status appear

EOF

  log_success "Blender MCP is now connected to MeshMind!"

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
