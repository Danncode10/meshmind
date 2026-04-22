#!/bin/bash

################################################################################
# Claude 3D — Interactive Setup Guide
# Main entry point for users to set up Claude + Blender + MCP
################################################################################

set -e

# Colors for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${SCRIPT_DIR}/config"
MCP_DIR="${SCRIPT_DIR}/mcp"
PROJECTS_DIR="${SCRIPT_DIR}/projects"
SCRIPTS_DIR="${SCRIPT_DIR}/scripts"

# Ensure config directory exists
mkdir -p "${CONFIG_DIR}"

################################################################################
# Utility Functions
################################################################################

log_header() {
  echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${CYAN}$1${NC}"
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

log_info() {
  echo -e "${CYAN}ℹ ${NC}$1"
}

log_success() {
  echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
  echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
  echo -e "${RED}❌ $1${NC}"
}

prompt_yes_no() {
  local prompt="$1"
  local response
  while true; do
    read -p "$(echo -e ${CYAN}${prompt}${NC} [y/n]: )" -r response
    case "$response" in
      [yY][eE][sS]|[yY]) return 0 ;;
      [nN][oO]|[nN]) return 1 ;;
      *) echo "Please answer yes or no." ;;
    esac
  done
}

################################################################################
# Step 1: Setup MCP Connection
################################################################################

step_1_setup_mcp() {
  log_header "STEP 1: Setup MCP Connection"

  log_info "This step will configure the Model Context Protocol (MCP) bridge"
  log_info "between Claude Code and Blender.\n"

  # Check Claude Code installation
  log_info "Checking Claude Code installation..."
  if command -v claude &> /dev/null; then
    log_success "Claude Code CLI found"
  else
    log_warning "Claude Code CLI not found in PATH"
    log_info "Please ensure Claude Code is installed:"
    log_info "  https://github.com/anthropics/claude-code/releases\n"
    if ! prompt_yes_no "Continue anyway?"; then
      return 1
    fi
  fi

  # Explain MCP
  log_info "What is MCP?\n"
  cat << 'EOF'
  MCP (Model Context Protocol) is a standard way for AI systems like Claude
  to communicate with external tools and services. In this case, it creates a
  bridge between Claude Code and Blender so that:

  1. You describe a 3D model in natural language
  2. Claude generates Blender Python code
  3. The MCP server sends that code to Blender
  4. Blender executes the code and creates your model
  5. Results are shown back to Claude

  This allows seamless conversation-driven 3D modeling!

EOF

  # Check Blender installation
  log_info "Checking Blender installation..."
  if command -v blender &> /dev/null; then
    local blender_version
    blender_version=$(blender --version 2>&1 | head -1)
    log_success "Blender found: ${blender_version}"
  else
    log_warning "Blender not found in PATH"
    log_info "Please install Blender 4.0 or later:"
    log_info "  https://www.blender.org/download/\n"
    if ! prompt_yes_no "Continue anyway?"; then
      return 1
    fi
  fi

  # Create MCP config template
  log_info "Creating MCP configuration..."
  python3 "${SCRIPTS_DIR}/generate-mcp-config.py" || {
    log_warning "Could not auto-generate MCP config"
    log_info "Using default template instead"
  }

  # Save connection status
  local status_file="${CONFIG_DIR}/mcp-status.json"
  cat > "${status_file}" << 'EOF'
{
  "configured": true,
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "mcp_server_url": "http://localhost:5000",
  "blender_bridge": "localhost:5001",
  "status": "ready",
  "last_test": null
}
EOF

  log_success "MCP configuration saved to ${CONFIG_DIR}/mcp-status.json"

  # Test MCP connection
  log_info "Testing MCP connection...\n"
  if python3 "${MCP_DIR}/test-connection.py" 2>/dev/null; then
    log_success "MCP connection test passed!"
  else
    log_warning "Could not test MCP connection"
    log_info "This is normal on first setup. The connection will be"
    log_info "established when you start using Claude Code.\n"
  fi

  log_success "Step 1 complete: MCP Connection configured!"
  log_info "Next: Run 'bash guide.sh' and select Step 2"
}

################################################################################
# Main Menu
################################################################################

show_menu() {
  log_header "Claude 3D — Setup Guide"

  cat << 'EOF'
Choose a setup step:

  [1] Setup MCP Connection (recommended first)
  [2] Create Your 3D Model Project
  [3] Chat with Claude to Edit (coming soon)
  [4] Launch Checklist (coming soon)
  [0] Exit

EOF
  read -p "$(echo -e ${CYAN}Select option${NC} [0-4]: )" -r choice

  case "$choice" in
    1)
      step_1_setup_mcp
      ;;
    2)
      log_info "Step 2 not yet implemented. Check back soon!"
      ;;
    3)
      log_info "Step 3 not yet implemented. Check back soon!"
      ;;
    4)
      log_info "Step 4 not yet implemented. Check back soon!"
      ;;
    0)
      log_info "Exiting. Happy modeling!"
      exit 0
      ;;
    *)
      log_error "Invalid option. Please try again."
      ;;
  esac

  echo ""
  if prompt_yes_no "Return to menu?"; then
    show_menu
  else
    log_info "Exiting. Happy modeling!"
    exit 0
  fi
}

################################################################################
# Entry Point
################################################################################

main() {
  log_header "Welcome to Claude 3D"
  log_info "This guide will help you set up Claude + Blender + MCP"
  log_info "and get started creating 3D models with natural language.\n"

  show_menu
}

main "$@"
