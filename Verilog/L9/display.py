"""
display.py - Display and rendering module
"""

import os
import sys
from config import (
    WORLD_WIDTH, DISPLAY_HEIGHT, USE_ASCII,
    CHAR_PLAYER, CHAR_OBSTACLE, CHAR_GROUND, CHAR_SKY,
    ASCII_PLAYER, ASCII_OBSTACLE, ASCII_GROUND, ASCII_SKY,
    COLOR_RESET, COLOR_GREEN, COLOR_RED, COLOR_YELLOW, COLOR_CYAN
)


class Display:
    """Handles game display and rendering"""
    
    def __init__(self):
        self.use_ascii = USE_ASCII
        
        # Choose character set
        if self.use_ascii:
            self.player_char = ASCII_PLAYER
            self.obstacle_char = ASCII_OBSTACLE
            self.ground_char = ASCII_GROUND
            self.sky_char = ASCII_SKY
        else:
            self.player_char = CHAR_PLAYER
            self.obstacle_char = CHAR_OBSTACLE
            self.ground_char = CHAR_GROUND
            self.sky_char = CHAR_SKY
    
    def clear_screen(self):
        """Clear the terminal screen"""
        os.system('cls' if os.name == 'nt' else 'clear')
    
    def render_frame(self, game_state):
        """Render a single frame of the game"""
        obstacles = game_state['obstacles']
        player_height = game_state['player_height']
        score = game_state['score']
        game_over = game_state['game_over']
        
        # Clear screen
        self.clear_screen()
        
        # Print title and score
        print(f"{COLOR_CYAN}{'=' * (WORLD_WIDTH * 2)}{COLOR_RESET}")
        print(f"{COLOR_YELLOW}🎮  DINO JUMP - Hardware Simulation{COLOR_RESET}")
        print(f"{COLOR_GREEN}Score: {score:04d}{COLOR_RESET}")
        print(f"{COLOR_CYAN}{'=' * (WORLD_WIDTH * 2)}{COLOR_RESET}")
        print()
        
        # Build game world grid
        world = self._build_world(obstacles, player_height)
        
        # Print world
        for row in world:
            print("".join(row))
        
        # Print ground
        print(f"{COLOR_GREEN}{self.ground_char * (WORLD_WIDTH * 2)}{COLOR_RESET}")
        
        # Print controls
        print()
        print(f"{COLOR_CYAN}Controls: [↑ UP] to Jump | [Q] to Quit{COLOR_RESET}")
        
        # Game over message
        if game_over:
            print()
            print(f"{COLOR_RED}{'*' * (WORLD_WIDTH * 2)}{COLOR_RESET}")
            print(f"{COLOR_RED}GAME OVER! Final Score: {score}{COLOR_RESET}")
            print(f"{COLOR_RED}{'*' * (WORLD_WIDTH * 2)}{COLOR_RESET}")
    
    def _build_world(self, obstacles, player_height):
        """Build the 2D world grid"""
        # Create empty world
        world = [[self.sky_char for _ in range(WORLD_WIDTH * 2)] 
                 for _ in range(DISPLAY_HEIGHT)]
        
        # Add obstacles (convert integer to binary positions)
        # Obstacles move from right (index 15) to left (index 0)
        for x in range(WORLD_WIDTH):
            if obstacles & (1 << x):  # Check if bit is set
                # Map Verilog position to display position (right to left)
                display_x = (WORLD_WIDTH - 1 - x) * 2
                # Obstacle at ground level
                world[DISPLAY_HEIGHT - 1][display_x] = self.obstacle_char
        
        # Add player at position 2 from the left (fixed horizontal position)
        player_x = WORLD_WIDTH-3
        player_y = DISPLAY_HEIGHT - 1 - player_height
        
        if 0 <= player_y < DISPLAY_HEIGHT:
            world[player_y][player_x * 2] = self.player_char
        
        return world
    
    def show_start_screen(self):
        """Display start screen"""
        self.clear_screen()
        print(f"{COLOR_CYAN}{'=' * 40}{COLOR_RESET}")
        print(f"{COLOR_YELLOW}   🦖  DINO JUMP GAME  🌵{COLOR_RESET}")
        print(f"{COLOR_CYAN}{'=' * 40}{COLOR_RESET}")
        print()
        print(f"{COLOR_GREEN}Hardware-Accelerated Game Engine{COLOR_RESET}")
        print(f"Powered by: Python + Verilog (Icarus)")
        print()
        print("How to Play:")
        print("  • Press UP arrow to make dino jump")
        print("  • Avoid the cacti!")
        print("  • Score points by surviving")
        print()
        print(f"{COLOR_CYAN}Press ENTER to start...{COLOR_RESET}")
        input()
    
    def show_compilation_screen(self):
        """Show compilation in progress"""
        self.clear_screen()
        print(f"{COLOR_YELLOW}⚙️  Compiling Verilog Hardware...{COLOR_RESET}")
        print("Please wait...")