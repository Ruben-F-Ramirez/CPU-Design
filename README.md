# 16-Bit CPU Design

## Overview
This repository contains the design and implementation of a 16-bit Central Processing Unit (CPU) using VHDL. The CPU includes the following components:

- **ALU (Arithmetic Logic Unit):** Supports arithmetic, logical, and shifting operations.
- **Data Memory:** Stores and retrieves data.
- **Instruction Memory:** Holds the instructions for execution.
- **Registers:** Three 16-bit registers (A, B, and C).
- **Control Unit:** Manages the flow of data within the CPU.
- **Program Counter:** Tracks the current instruction being executed.
- **Multiplexer (MUX):** Implements a 4-to-1 multiplexer.

## Features
- **Instruction Set:**
  - Logical operations (AND, OR, XOR, etc.)
  - Arithmetic operations (ADD, SUB, MUL, INC)
  - Shift and Rotate operations
  - Memory read/write operations
- **Inputs:**
  - 16-bit data inputs A and B
  - 24-bit instruction input
  - 4-bit instruction memory address
  - Enable and clock signals
- **Outputs:**
  - 17-bit data output
  - 16-bit computation result
  - Carry-out for arithmetic operations

## File Structure
- `controller.vhdl`: Implements the control logic for the CPU.
- `cpu.vhdl`: The top-level CPU architecture connecting all components.
- `alu.vhdl`: The Arithmetic Logic Unit implementation.
- `instruction_memory.vhdl`: Stores instructions for execution.
- `data_memory.vhdl`: Manages data storage.
- `program_counter.vhdl`: Keeps track of instruction addresses.
- `mux.vhdl`: A 4-to-1 multiplexer used in the CPU.
- `test_bench/`: Contains test benches for each component.

## Instruction Format
### ALU Operations
| Mode | Opcode | Operation        |
|------|--------|------------------|
| 0    | 000    | A NOR B          |
| 0    | 001    | A NAND B         |
| 0    | 010    | A OR B           |
| 1    | 000    | A * B            |
| 1    | 001    | A + B            |
| 1    | 010    | A - B            |
| 1    | 011    | Increment A      |

### CPU Instructions
| Instruction      | Bit 23-21 | Bit 20-18 | Bit 17 | Bit 16 |
|------------------|-----------|-----------|--------|--------|
| Load             | 000       | ---       | -      | 0/1    |
| Store            | 001       | ---       | -      | -      |
| ALU Operation    | 010       | See ALU   | See ALU| -      |
| Read Memory      | 011       | ---       | -      | -      |
| Exit             | 111       | ---       | -      | -      |

## Test Bench
The test benches are designed to validate the functionality of each component and the complete CPU system. Key test scenarios include:

- **Loading Data:** Verifying data loading into registers A and B.
- **ALU Operations:** Testing arithmetic and logical operations.
- **Memory Operations:** Reading and writing data to memory.
- **Program Counter:** Checking instruction sequencing.
- **Instruction Execution:** Ensuring instructions are executed correctly and in sequence.

## Getting Started
### Prerequisites
- **VHDL Simulation Tools:** Use any standard VHDL simulator such as ModelSim, Xilinx Vivado, or GHDL.

### Steps
1. Clone the repository:
   ```bash
   git clone <repository-url>
   ```
2. Open the VHDL files in your preferred simulator.
3. Run the test benches provided in the `test_bench/` directory.
4. Observe waveforms and verify the outputs against expected results.

## Author
Ruben Ramirez (Student ID: 2694)

## License
This project is licensed under the MIT License. See `LICENSE` for details.

---

For further details, refer to the documentation provided in the repository or contact the author.
