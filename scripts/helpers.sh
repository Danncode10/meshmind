#!/bin/bash

################################################################################
# Helper Functions for Claude 3D Scripts
################################################################################

# Get the script directory (works even when sourced)
get_script_dir() {
  local source="${BASH_SOURCE[0]}"
  while [[ -L "$source" ]]; do
    DIR="$(cd -P "$(dirname "$source")" && pwd)"
    source="$(readlink "$source")"
    [[ $source != /* ]] && source="$DIR/$source"
  done
  cd -P "$(dirname "$source")" && pwd
}

# Colors (duplicate of main script for standalone use)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

################################################################################
# System Detection
################################################################################

# Detect OS
detect_os() {
  case "$(uname -s)" in
    Linux*)   echo "Linux";;
    Darwin*)  echo "macOS";;
    CYGWIN*)  echo "Cygwin";;
    MINGW*)   echo "MinGw";;
    *)        echo "UNKNOWN";;
  esac
}

# Check if command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Get Python 3 path
get_python3_path() {
  if command_exists python3; then
    which python3
  elif command_exists python; then
    which python
  else
    return 1
  fi
}

# Get Blender path
get_blender_path() {
  local os=$(detect_os)

  case "$os" in
    macOS)
      if [[ -d "/Applications/Blender.app" ]]; then
        echo "/Applications/Blender.app/Contents/MacOS/Blender"
      fi
      ;;
    Linux)
      if command_exists blender; then
        which blender
      fi
      ;;
  esac
}

################################################################################
# File Operations
################################################################################

# Create directory structure safely
create_dirs() {
  local dirs=("$@")
  for dir in "${dirs[@]}"; do
    if [[ ! -d "$dir" ]]; then
      mkdir -p "$dir"
    fi
  done
}

# Copy with backup
copy_with_backup() {
  local source="$1"
  local dest="$2"

  if [[ -f "$dest" ]]; then
    cp "$dest" "$dest.backup.$(date +%s)"
  fi

  cp "$source" "$dest"
}

# Safe delete (with confirmation)
safe_delete() {
  local file="$1"
  if [[ -f "$file" ]] || [[ -d "$file" ]]; then
    read -p "Delete $file? [y/N] " -r
    [[ $REPLY =~ ^[Yy]$ ]] && rm -rf "$file"
  fi
}

################################################################################
# JSON Utilities
################################################################################

# Check if valid JSON
is_valid_json() {
  local json_file="$1"
  if command_exists python3; then
    python3 -m json.tool "$json_file" >/dev/null 2>&1
    return $?
  fi
  return 1
}

# Extract JSON value (simple, doesn't require jq)
get_json_value() {
  local json_file="$1"
  local key="$2"

  if command_exists python3; then
    python3 -c "
import json
try:
  with open('$json_file') as f:
    data = json.load(f)
  print(data.get('$key', ''))
except:
  print('')
"
  fi
}

################################################################################
# Process Management
################################################################################

# Check if port is in use
is_port_in_use() {
  local port="$1"
  if command_exists lsof; then
    lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1
    return $?
  fi
  return 1
}

# Wait for port to be available
wait_for_port() {
  local port="$1"
  local timeout="${2:-30}"
  local elapsed=0

  while is_port_in_use "$port" && [[ $elapsed -lt $timeout ]]; do
    sleep 1
    ((elapsed++))
  done

  return $(is_port_in_use "$port")
}

################################################################################
# Logging Utilities
################################################################################

# Log with timestamp
log_timestamped() {
  local level="$1"
  local message="$2"
  local timestamp=$(date '+%Y-%m-%d %H:%M:%S')

  case "$level" in
    INFO)  echo -e "${CYAN}[$timestamp] ℹ ${message}${NC}" ;;
    OK)    echo -e "${GREEN}[$timestamp] ✅ ${message}${NC}" ;;
    WARN)  echo -e "${YELLOW}[$timestamp] ⚠️  ${message}${NC}" ;;
    ERROR) echo -e "${RED}[$timestamp] ❌ ${message}${NC}" ;;
  esac
}

# Write to log file
log_to_file() {
  local log_file="$1"
  local message="$2"
  local timestamp=$(date '+%Y-%m-%d %H:%M:%S')

  mkdir -p "$(dirname "$log_file")"
  echo "[$timestamp] $message" >> "$log_file"
}
