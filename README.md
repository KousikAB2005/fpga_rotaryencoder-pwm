# PWM Generator in FPGA (Verilog)

A collection of PWM (Pulse Width Modulation) implementations in Verilog for FPGA, including a static multi-channel PWM generator and a rotary encoder-controlled variable duty cycle PWM.

---
<img src="https://github.com/user-attachments/assets/07228f0d-46da-4016-a772-ba2cc52f3c03"/>

## 🔧 Modules

### 1. `pwm.v` — Static Multi-Channel PWM Generator

Generates 4 simultaneous PWM signals with fixed duty cycles using an 8-bit counter.

| Output  | Duty Cycle | Threshold |
|---------|------------|-----------|
| `pwm[0]` | 20%       | counter < 51  |
| `pwm[1]` | 40%       | counter < 102 |
| `pwm[2]` | 60%       | counter < 153 |
| `pwm[3]` | 80%       | counter < 204 |

**Ports:**

| Port | Direction | Width | Description         |
|------|-----------|-------|---------------------|
| `clk` | Input   | 1-bit | System clock        |
| `pwm` | Output  | 4-bit | PWM output channels |

---

### 2. `pwm_encoder_control.v` — Rotary Encoder Controlled PWM

Uses a magnetic rotary encoder (e.g., from an N20 motor) to dynamically adjust the PWM duty cycle. The encoder's two Hall sensors determine rotation direction.

- **Default duty cycle:** 50% (127/255)
- Rotating **clockwise** → increases duty cycle (up to 100%)
- Rotating **counter-clockwise** → decreases duty cycle (down to 0%)

**Ports:**

| Port        | Direction | Width | Description              |
|-------------|-----------|-------|--------------------------|
| `clk`       | Input     | 1-bit | System clock             |
| `encoder_a` | Input     | 1-bit | Encoder channel A        |
| `encoder_b` | Input     | 1-bit | Encoder channel B        |
| `pwm_out`   | Output    | 1-bit | PWM output signal        |

---

## ⚙️ How It Works

### PWM Principle

An 8-bit counter cycles from 0 to 255. The PWM output is **HIGH** while the counter is below the duty cycle threshold, and **LOW** otherwise. This creates a square wave whose on-time ratio equals the desired duty cycle.

```
Counter:  0 ──────────── threshold ──────────── 255
PWM Out:  ████████████████░░░░░░░░░░░░░░░░░░░░░░
                   HIGH          LOW
```

### Encoder Direction Detection

The rotary encoder outputs two quadrature signals (A and B). Direction is determined by checking the state of channel B at the **rising edge** of channel A:

- `encoder_b == 1` at rising edge of A → **Clockwise** → duty cycle++
- `encoder_b == 0` at rising edge of A → **Counter-clockwise** → duty cycle--

---

## 🚀 Getting Started

### Requirements

- Verilog simulator (ModelSim, Vivado Simulator, Icarus Verilog, etc.)
- FPGA board (tested with output on oscilloscope)
- Rotary encoder (for `pwm_encoder_control.v`)

### Simulation (Icarus Verilog)

```bash
# Simulate static PWM
iverilog -o sim_pwm sim/tb_pwm.v src/pwm.v
vvp sim_pwm

# Simulate encoder-controlled PWM
iverilog -o sim_enc sim/tb_pwm_encoder_control.v src/pwm_encoder_control.v
vvp sim_enc
```

### Synthesis

Import the source files into your FPGA toolchain (Xilinx Vivado / Intel Quartus) and assign the ports to your board's pins via the constraints file.

---

## 📊 Oscilloscope Results

The design was verified on hardware. The oscilloscope measurement showed:
<img src="https://github.com/user-attachments/assets/645f631c-aa1b-450b-95fa-5dd2948f8886"/>
- **Frequency:** ~390.6 kHz
- **Channel 1 (pwm[3]):** 80% duty cycle
- **Channel 2 (pwm[0]):** 20% duty cycle

---

## 📄 License

This project is open-source and free to use for educational and personal projects.

---

## 👤 Author

**Kousik A B**
