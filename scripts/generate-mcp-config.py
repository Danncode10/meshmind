#!/usr/bin/env python3
"""
Generate MCP Configuration
Creates .mcp-config.json from the example template, auto-detecting paths.
"""

import json
import sys
from pathlib import Path
import subprocess


def find_blender():
    """Auto-detect Blender installation path."""
    common_paths = [
        "/Applications/Blender.app/Contents/MacOS/Blender",  # macOS
        "/usr/bin/blender",  # Linux
        "/opt/blender/blender",  # Linux alt
        "C:\\Program Files\\Blender Foundation\\Blender 4.0\\blender.exe",  # Windows
    ]

    for path in common_paths:
        if Path(path).exists():
            return path

    # Try which command
    try:
        result = subprocess.run(["which", "blender"], capture_output=True, text=True)
        if result.returncode == 0:
            return result.stdout.strip()
    except Exception:
        pass

    return None


def find_project_root():
    """Find the project root directory."""
    current = Path(__file__).parent.parent
    return current


def generate_config():
    """Generate MCP configuration file."""
    project_root = find_project_root()
    blender_path = find_blender()

    config = {
        "version": "1.0",
        "mcpServers": {
            "claude-3d": {
                "command": "python3",
                "args": [
                    str(project_root / "mcp" / "server.py")
                ],
                "env": {
                    "BLENDER_PATH": blender_path or "/Applications/Blender.app/Contents/MacOS/Blender",
                    "MCP_HOST": "localhost",
                    "MCP_PORT": "5000",
                    "BLENDER_BRIDGE_HOST": "localhost",
                    "BLENDER_BRIDGE_PORT": "5001",
                    "PROJECT_ROOT": str(project_root),
                },
                "disabled": False,
            }
        },
        "settings": {
            "autoStartServers": True,
            "serverTimeout": 30,
            "logLevel": "info",
        },
        "claude3d": {
            "projectsDirectory": str(project_root / "projects"),
            "templatesDirectory": str(project_root / "templates"),
            "configDirectory": str(project_root / "config"),
            "blenderVersionRequired": "4.0",
        },
    }

    config_file = project_root / ".mcp-config.json"
    with open(config_file, "w") as f:
        json.dump(config, f, indent=2)

    print(f"✅ MCP config generated: {config_file}")

    if blender_path:
        print(f"✅ Blender found: {blender_path}")
    else:
        print("⚠️  Blender not found in common paths")
        print("   Install Blender or update BLENDER_PATH in .mcp-config.json")

    return config_file


if __name__ == "__main__":
    try:
        generate_config()
    except Exception as e:
        print(f"❌ Error: {e}", file=sys.stderr)
        sys.exit(1)
