#!/usr/bin/env python3
"""
game_controller.py - Main game controller and entry point
Orchestrates the hardware/software co-simulation game
"""

import time
import sys
import select
import termios
import tty
from config import FRAME_RATE                   #Python File
from verilog_interface import VerilogInterface  #Python File
from display import Display                     #Python File


class GameController:
    """Main game controller"""
    
    def __init__(self):
        self.verilog = VerilogInterface()
        self.display = Display()
        self.running = False
        self.jump_pressed = False
        
        # Terminal settings for non-blocking input
        self.old_settings = None
    
    def setup_terminal(self):
        """Setup terminal for non-blocking input"""
        self.old_settings = termios.tcgetattr(sys.stdin)
        tty.setcbreak(sys.stdin.fileno())
    
    def restore_terminal(self):
        """Restore terminal settings"""
        if self.old_settings:
            termios.tcsetattr(sys.stdin, termios.TCSADRAIN, self.old_settings)
    
    def get_key_press(self):
        """Check for key press without blocking"""
        if select.select([sys.stdin], [], [], 0)[0]:
            key = sys.stdin.read(1)
            
            # Check for arrow keys (they send escape sequences)
            if key == '\x1b':  # ESC
                next1 = sys.stdin.read(1)
                next2 = sys.stdin.read(1)
                if next1 == '[' and next2 == 'A':  # UP arrow
                    return 'UP'
            
            # Check for q to quit
            if key.lower() == 'q':
                return 'QUIT'
            
            # Spacebar alternative for jump
            if key == ' ':
                return 'UP'
        
        return None
    
    def initialize(self):
        """Initialize the game"""
        # Show start screen
        self.display.show_start_screen()
        
        # Compile Verilog
        self.display.show_compilation_screen()
        if not self.verilog.compile_verilog():
            print("\nFailed to compile Verilog. Exiting.")
            return False
        
        time.sleep(1)  # Brief pause to show compilation success
        
        # Setup terminal
        self.setup_terminal()
        
        return True
    
    def run_frame(self):
        """Execute one game frame"""
        # 1. Get input
        key = self.get_key_press()
        
        if key == 'QUIT':
            return False
        
        self.jump_pressed = (key == 'UP')
        
        # 2. Write input to Verilog
        self.verilog.write_input(self.jump_pressed)
        
        # 3. Run Verilog simulation
        if not self.verilog.run_simulation():
            print("Simulation error!")
            return False
        
        # 4. Read output from Verilog
        if not self.verilog.read_output():
            print("Failed to read output!")
            return False
        
        # 5. Get game state
        game_state = self.verilog.get_game_state()
        
        # 6. Render frame
        self.display.render_frame(game_state)
        
        # 7. Check game over
        if game_state['game_over']:
            time.sleep(2)  # Show game over screen
            return False
        
        return True
    
    def run(self):
        """Main game loop"""
        if not self.initialize():
            return
        
        self.running = True
        frame_delay = 1.0 / FRAME_RATE
        
        try:
            while self.running:
                frame_start = time.time()
                
                # Run one frame
                if not self.run_frame():
                    self.running = False
                    break
                
                # Maintain frame rate
                frame_time = time.time() - frame_start
                sleep_time = max(0, frame_delay - frame_time)
                time.sleep(sleep_time)
        
        except KeyboardInterrupt:
            print("\n\nGame interrupted by user.")
        
        finally:
            self.cleanup()
    
    def cleanup(self):
        """Clean up resources"""
        self.restore_terminal()
        self.verilog.cleanup()
        print("\nThanks for playing! 🦖")


def main():
    """Entry point"""
    game = GameController()
    game.run()


if __name__ == "__main__":
    main()