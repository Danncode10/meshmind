"""
Claude 3D — MCP (Model Context Protocol) Module
Handles communication between Claude Code and Blender.
"""

__version__ = "1.0.0"
__author__ = "Claude"

from . import server
from . import blender_bridge

__all__ = ["server", "blender_bridge"]
