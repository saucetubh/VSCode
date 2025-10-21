"""
config.py - Game configuration and constants
"""

# File paths
INPUT_FILE = "input.txt"
OUTPUT_FILE = "output.txt"

# Updated for modular Verilog design
VERILOG_MODULES = [
    # "universal_shift_register.v",
    # "player_control.v",
    # "collision_detector.v",
    # "score_counter.v",
    # "runner_game_top.v",
    # "runner_game_driver.v"
    # "modules/game_logic.v"
    "modules/runner_game_driver.v"
]
COMPILED_SIM = "game_sim"

# Game settings
FRAME_RATE = 6  # Frames per second
WORLD_WIDTH = 16  # Must match Verilog parameter
DISPLAY_HEIGHT = 5  # Display height in characters

# Display characters
CHAR_PLAYER = "🦖"  # Dinosaur
CHAR_OBSTACLE = "🌵"  # Cactus
CHAR_GROUND = "▔"
CHAR_SKY = " "

# Alternative ASCII characters (if emojis don't work)
USE_ASCII = False  # Set to True for pure ASCII
ASCII_PLAYER = "D"
ASCII_OBSTACLE = "#"
ASCII_GROUND = "="
ASCII_SKY = "."

# Colors (ANSI escape codes)
COLOR_RESET = "\033[0m"
COLOR_GREEN = "\033[92m"
COLOR_RED = "\033[91m"
COLOR_YELLOW = "\033[93m"
COLOR_CYAN = "\033[96m"