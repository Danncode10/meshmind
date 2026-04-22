#!/usr/bin/env python3
"""
Test MCP Connection
Validates that the MCP server and Blender bridge are properly configured.
"""

import json
import sys
import socket
from pathlib import Path
import subprocess

# Get project root
PROJECT_ROOT = Path(__file__).parent.parent
CONFIG_DIR = PROJECT_ROOT / "config"


def test_blender_availability():
    """Test if Blender is installed and accessible."""
    print("\n📋 Testing Blender availability...")

    try:
        result = subprocess.run(
            ["blender", "--version"],
            capture_output=True,
            text=True,
            timeout=5,
        )

        if result.returncode == 0:
            print(f"   ✅ Blender found: {result.stdout.strip()}")
            return True
        else:
            print(f"   ⚠️  Blender command returned: {result.stderr}")
            return False

    except FileNotFoundError:
        print("   ⚠️  Blender not found in PATH")
        return False
    except subprocess.TimeoutExpired:
        print("   ⚠️  Blender check timed out")
        return False
    except Exception as e:
        print(f"   ❌ Error: {e}")
        return False


def test_python_modules():
    """Test if required Python modules are available."""
    print("\n📦 Testing Python modules...")

    modules = [
        "json",
        "asyncio",
        "logging",
        "pathlib",
    ]

    all_available = True
    for module in modules:
        try:
            __import__(module)
            print(f"   ✅ {module}")
        except ImportError:
            print(f"   ❌ {module}")
            all_available = False

    return all_available


def test_port_availability():
    """Test if required ports are available."""
    print("\n🔌 Testing port availability...")

    ports = [
        ("MCP Server", 5000),
        ("Blender Bridge", 5001),
    ]

    all_available = True
    for name, port in ports:
        try:
            sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            result = sock.connect_ex(("127.0.0.1", port))
            sock.close()

            if result == 0:
                print(f"   ⚠️  {name} port {port} is in use")
                all_available = False
            else:
                print(f"   ✅ {name} port {port} is available")

        except Exception as e:
            print(f"   ❌ Error checking port {port}: {e}")
            all_available = False

    return all_available


def test_config_files():
    """Test if configuration files exist."""
    print("\n📄 Testing configuration files...")

    files = [
        ("MCP Config", PROJECT_ROOT / ".mcp-config.json"),
        ("Status File", CONFIG_DIR / "mcp-status.json"),
    ]

    all_exist = True
    for name, filepath in files:
        if filepath.exists():
            print(f"   ✅ {name}: {filepath}")
        else:
            print(f"   ⚠️  {name} not found: {filepath}")
            all_exist = False

    return all_exist


def test_config_validity():
    """Test if config files are valid JSON."""
    print("\n🔍 Testing configuration validity...")

    config_file = PROJECT_ROOT / ".mcp-config.json"

    if not config_file.exists():
        print(f"   ⚠️  Config file not found: {config_file}")
        return False

    try:
        with open(config_file) as f:
            config = json.load(f)
        print(f"   ✅ Config is valid JSON")

        # Check required keys
        required_keys = ["mcpServers", "settings", "claude3d"]
        for key in required_keys:
            if key in config:
                print(f"      ✅ {key}")
            else:
                print(f"      ❌ Missing: {key}")
                return False

        return True

    except json.JSONDecodeError as e:
        print(f"   ❌ Invalid JSON: {e}")
        return False
    except Exception as e:
        print(f"   ❌ Error: {e}")
        return False


def main():
    """Run all tests."""
    print("=" * 60)
    print("Claude 3D — MCP Connection Test")
    print("=" * 60)

    results = []

    # Run tests
    results.append(("Blender Availability", test_blender_availability()))
    results.append(("Python Modules", test_python_modules()))
    results.append(("Port Availability", test_port_availability()))
    results.append(("Configuration Files", test_config_files()))
    results.append(("Configuration Validity", test_config_validity()))

    # Summary
    print("\n" + "=" * 60)
    print("📊 Test Summary")
    print("=" * 60)

    passed = sum(1 for _, result in results if result)
    total = len(results)

    for name, result in results:
        status = "✅ PASS" if result else "⚠️  WARN"
        print(f"{status} — {name}")

    print("\n" + "=" * 60)

    if passed == total:
        print(f"✅ All tests passed! ({passed}/{total})")
        print("\nYou can now use Claude 3D to create models.")
        return 0
    else:
        print(f"⚠️  Some tests failed ({passed}/{total})")
        print("\nPlease review the warnings above and fix any issues.")
        return 1


if __name__ == "__main__":
    sys.exit(main())
