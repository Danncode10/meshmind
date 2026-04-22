#!/usr/bin/env python3
"""
Blender Bridge — MCP to Blender Communication
Runs inside Blender or as a separate process to handle code execution.

This bridge:
- Listens for code from the MCP server
- Executes code in Blender's Python environment
- Returns results and error handling
- Manages scene state and cleanup
"""

import json
import logging
import subprocess
import sys
from pathlib import Path
from typing import Any, Optional

# ============================================
# Configuration
# ============================================

CONFIG_DIR = Path(__file__).parent.parent / "config"
LOG_DIR = CONFIG_DIR / "logs"
LOG_DIR.mkdir(parents=True, exist_ok=True)

# Setup logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    handlers=[
        logging.FileHandler(LOG_DIR / "blender-bridge.log"),
        logging.StreamHandler(),
    ],
)
logger = logging.getLogger(__name__)

# ============================================
# Blender Code Executor
# ============================================


class BlenderCodeExecutor:
    """Executes Python code in Blender."""

    def __init__(self, blender_path: Optional[str] = None):
        """
        Initialize executor.

        Args:
            blender_path: Path to Blender executable (auto-detected if not provided)
        """
        self.blender_path = blender_path or self._find_blender()
        if self.blender_path:
            logger.info(f"Blender found at: {self.blender_path}")
        else:
            logger.warning("Blender not found. Code execution may fail.")

    @staticmethod
    def _find_blender() -> Optional[str]:
        """Locate Blender executable in common paths."""
        common_paths = [
            "/Applications/Blender.app/Contents/MacOS/Blender",  # macOS
            "/usr/bin/blender",  # Linux
            "C:\\Program Files\\Blender Foundation\\Blender 4.0\\blender.exe",  # Windows
        ]

        for path in common_paths:
            if Path(path).exists():
                return path

        # Try to find in PATH
        try:
            result = subprocess.run(
                ["which", "blender"], capture_output=True, text=True
            )
            if result.returncode == 0:
                return result.stdout.strip()
        except Exception:
            pass

        return None

    def execute_code(self, code: str, headless: bool = True) -> dict:
        """
        Execute Python code in Blender.

        Args:
            code: Python code to execute (uses bpy module)
            headless: Run Blender in headless mode (no UI)

        Returns:
            Dictionary with execution result or error info
        """
        if not self.blender_path:
            return {"success": False, "error": "Blender not found"}

        try:
            # Write code to temporary file for execution
            code_file = LOG_DIR / "temp_script.py"
            code_file.write_text(code)
            logger.info(f"Executing Blender code ({len(code)} chars)")

            # Build Blender command
            cmd = [self.blender_path]
            if headless:
                cmd.extend(["--background", "--python", str(code_file)])
            else:
                cmd.extend(["--python", str(code_file)])

            # Execute
            result = subprocess.run(
                cmd,
                capture_output=True,
                text=True,
                timeout=60,
            )

            if result.returncode == 0:
                logger.info("Code executed successfully in Blender")
                return {
                    "success": True,
                    "output": result.stdout,
                    "stderr": result.stderr if result.stderr else None,
                }
            else:
                logger.error(f"Blender execution failed: {result.stderr}")
                return {
                    "success": False,
                    "error": result.stderr,
                    "output": result.stdout,
                }

        except subprocess.TimeoutExpired:
            logger.error("Blender code execution timeout")
            return {"success": False, "error": "Execution timeout (60s)"}
        except Exception as e:
            logger.error(f"Blender execution error: {e}")
            return {"success": False, "error": str(e)}

    def validate_code(self, code: str) -> tuple[bool, Optional[str]]:
        """
        Validate Python code before execution.

        Args:
            code: Python code to validate

        Returns:
            Tuple of (is_valid, error_message)
        """
        try:
            compile(code, "<string>", "exec")
            return True, None
        except SyntaxError as e:
            return False, f"Syntax error: {e}"
        except Exception as e:
            return False, f"Validation error: {e}"


# ============================================
# Bridge Service
# ============================================


class BlenderBridgeService:
    """Main bridge service that handles requests."""

    def __init__(self):
        """Initialize the bridge service."""
        self.executor = BlenderCodeExecutor()
        self.execution_count = 0
        logger.info("Blender Bridge Service initialized")

    def handle_request(self, request: dict) -> dict:
        """
        Handle a request from the MCP server.

        Args:
            request: Request dictionary with 'action' and 'payload'

        Returns:
            Response dictionary with results or errors
        """
        action = request.get("action")
        payload = request.get("payload", {})

        logger.info(f"Handling request: {action}")

        if action == "execute_code":
            return self.execute_code_request(payload)
        elif action == "validate_code":
            return self.validate_code_request(payload)
        elif action == "ping":
            return self.ping_request()
        elif action == "status":
            return self.status_request()
        else:
            return {"success": False, "error": f"Unknown action: {action}"}

    def execute_code_request(self, payload: dict) -> dict:
        """Execute a code request."""
        code = payload.get("code", "")
        if not code:
            return {"success": False, "error": "No code provided"}

        # Validate first
        is_valid, error = self.executor.validate_code(code)
        if not is_valid:
            return {"success": False, "error": error}

        # Execute
        result = self.executor.execute_code(code, headless=True)
        self.execution_count += 1

        return {
            **result,
            "execution_id": self.execution_count,
        }

    def validate_code_request(self, payload: dict) -> dict:
        """Validate code without executing."""
        code = payload.get("code", "")
        is_valid, error = self.executor.validate_code(code)

        return {
            "success": is_valid,
            "error": error,
            "valid": is_valid,
        }

    def ping_request(self) -> dict:
        """Handle ping/status check."""
        blender_available = self.executor.blender_path is not None
        return {
            "success": True,
            "blender_available": blender_available,
            "blender_path": self.executor.blender_path,
        }

    def status_request(self) -> dict:
        """Return service status."""
        return {
            "success": True,
            "service": "blender-bridge",
            "blender_available": self.executor.blender_path is not None,
            "executions": self.execution_count,
        }


# ============================================
# Main Entry Point
# ============================================


def main():
    """Start the Blender Bridge service."""
    logger.info("Starting Blender Bridge...")
    service = BlenderBridgeService()

    # Example: respond to stdin requests (would be HTTP/socket in production)
    try:
        while True:
            line = sys.stdin.readline()
            if not line:
                break

            try:
                request = json.loads(line)
                response = service.handle_request(request)
                print(json.dumps(response))
            except json.JSONDecodeError as e:
                logger.error(f"Invalid JSON: {e}")
                print(json.dumps({"success": False, "error": "Invalid JSON"}))
            except Exception as e:
                logger.error(f"Request error: {e}")
                print(json.dumps({"success": False, "error": str(e)}))

    except KeyboardInterrupt:
        logger.info("Bridge shutdown requested")


if __name__ == "__main__":
    main()
