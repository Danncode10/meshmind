#!/bin/bash

################################################################################
# Setup Environment for Claude 3D
# Initializes environment variables and creates necessary directories
################################################################################

set -e

# Get project root
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Create necessary directories
mkdir -p "${PROJECT_ROOT}/config"
mkdir -p "${PROJECT_ROOT}/config/logs"
mkdir -p "${PROJECT_ROOT}/projects"
mkdir -p "${PROJECT_ROOT}/blender"

# Export environment variables
export PROJECT_ROOT="${PROJECT_ROOT}"
export CLAUDE_3D_HOME="${PROJECT_ROOT}"
export MCP_CONFIG="${PROJECT_ROOT}/.mcp-config.json"
export CONFIG_DIR="${PROJECT_ROOT}/config"
export PROJECTS_DIR="${PROJECT_ROOT}/projects"

# Python path
export PYTHONPATH="${PROJECT_ROOT}:${PYTHONPATH}"

# Log setup
echo "✅ Claude 3D environment initialized"
echo "   Project root: ${PROJECT_ROOT}"
echo "   Config dir: ${CONFIG_DIR}"
echo "   Projects dir: ${PROJECTS_DIR}"

# Check for required tools
missing_tools=()

if ! command -v python3 &> /dev/null; then
  missing_tools+=("python3")
fi

if ! command -v blender &> /dev/null; then
  echo "⚠️  Blender not found in PATH (optional, but recommended)"
fi

if [[ ${#missing_tools[@]} -gt 0 ]]; then
  echo "❌ Missing required tools: ${missing_tools[*]}"
  exit 1
fi

echo "✅ All required tools available"
