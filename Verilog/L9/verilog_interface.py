"""
verilog_interface.py - Module for communicating with Verilog simulation
Updated for modular design
"""

import subprocess
import os
from config import INPUT_FILE, OUTPUT_FILE, VERILOG_MODULES, COMPILED_SIM

STATE_FILE = "state.txt"


class VerilogInterface:
    """Handles compilation and execution of Verilog simulation"""
    
    def __init__(self):
        self.compiled = False
        self.game_state = {
            'obstacles': 0,
            'player_height': 0,
            'collision': False,
            'game_over': False,
            'score': 0
        }
    
    def compile_verilog(self):
        """Compile Verilog source using Icarus Verilog"""
        try:
            print("Compiling Verilog modules...")
            print(f"  Modules: {', '.join(VERILOG_MODULES)}")
            
            # Check if all modules exist
            missing_modules = [m for m in VERILOG_MODULES if not os.path.exists(m)]
            if missing_modules:
                print(f"ERROR: Missing Verilog modules: {', '.join(missing_modules)}")
                return False
            
            # Compile all modules together
            result = subprocess.run(
                ["iverilog", "-o", COMPILED_SIM] + VERILOG_MODULES,
                capture_output=True,
                text=True,
                timeout=10
            )
            
            if result.returncode != 0:
                print(f"Compilation Error:\n{result.stderr}")
                return False
            
            print("✓ Verilog compiled successfully!")
            self.compiled = True
            return True
            
        except FileNotFoundError:
            print("ERROR: Icarus Verilog (iverilog) not found!")
            print("Please install it: sudo apt-get install iverilog")
            return False
        except Exception as e:
            print(f"Compilation failed: {e}")
            return False
    
    def write_input(self, jump_pressed):
        """Write player input to input file"""
        try:
            with open(INPUT_FILE, 'w') as f:
                f.write(f"{1 if jump_pressed else 0}\n")
        except Exception as e:
            print(f"Error writing input: {e}")
    
    def run_simulation(self):
        """Execute one frame of Verilog simulation"""
        if not self.compiled:
            print("ERROR: Verilog not compiled!")
            return False
        
        try:
            # Run the simulation
            result = subprocess.run(
                ["vvp", COMPILED_SIM],
                capture_output=True,
                text=True,
                timeout=2
            )
            
            if result.returncode != 0:
                print(f"Simulation Error:\n{result.stderr}")
                return False
            
            return True
            
        except Exception as e:
            print(f"Simulation failed: {e}")
            return False
    
    def read_output(self):
        """Read game state from output file"""
        if not os.path.exists(OUTPUT_FILE):
            return False
        
        try:
            with open(OUTPUT_FILE, 'r') as f:
                lines = f.readlines()
            
            # Parse output
            for line in lines:
                line = line.strip()
                if line.startswith("obstacles="):
                    obs_str = line.split("=")[1]
                    self.game_state['obstacles'] = int(obs_str, 2)  # Binary to int
                elif line.startswith("player_height="):
                    self.game_state['player_height'] = int(line.split("=")[1])
                elif line.startswith("collision="):
                    self.game_state['collision'] = bool(int(line.split("=")[1]))
                elif line.startswith("game_over="):
                    self.game_state['game_over'] = bool(int(line.split("=")[1]))
                elif line.startswith("score="):
                    self.game_state['score'] = int(line.split("=")[1])
            
            return True
            
        except Exception as e:
            print(f"Error reading output: {e}")
            return False
    
    def get_game_state(self):
        """Return current game state"""
        return self.game_state
    
    def cleanup(self):
        """Clean up temporary files"""
        try:
            if os.path.exists(INPUT_FILE):
                os.remove(INPUT_FILE)
            if os.path.exists(OUTPUT_FILE):
                os.remove(OUTPUT_FILE)
            if os.path.exists(STATE_FILE):
                os.remove(STATE_FILE)
        except:
            pass