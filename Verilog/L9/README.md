## ✅ How to Run the Testbenches

### Running the Commands

All commands should be run from the root directory of this project (`Lab9_Digital_Design_TakeHome`).

#### Q1: Player Control

```bash
iverilog -o q1.out -I modules tb/tb_Q1_player_control.v
vvp q1.out
```

#### Q2: Collision Detector

```bash
iverilog -o q2.out -I modules tb/tb_Q2_collision_detector.v
vvp q2.out
```

#### Q3: Score Counter

```bash
iverilog -o q3.out -I modules tb/tb_Q3_score_counter.v
vvp q3.out
```

#### Q4: Universal Shift Register

```bash
iverilog -o q4.out -I modules tb/tb_Q4_universal_shift_register.v
vvp q4.out
```

#### Q5: Obstacle Spawner

```bash
iverilog -o q5.out -I modules tb/tb_Q5_obstacle_spawner.v
vvp q5.out
```

-----

## 📂 Project Structure

```
.
├── modules/                # Contains all synthesizable Verilog design files
│   ├── Q1_player_control.v
│   ├── Q2_collision_detector.v
│   ├── Q3_score_counter.v
│   ├── Q4_universal_shift_register.v
│   └── Q5_obstacle_spawner.v
│
├── tb/                     # Contains all testbench files
│   ├── tb_Q1_player_control.v
│   ├── tb_Q2_collision_detector.v
│   ├── tb_Q3_score_counter.v
│   ├── tb_Q4_universal_shift_register.v
│   └── tb_Q5_obstacle_spawner.v
│
└── *.py                    # Python scripts for a higher-level game interface
```

```
```