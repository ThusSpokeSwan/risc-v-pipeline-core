# 32-bit 5-Stage Pipelined RISC-V Core in Verilog

A complete, 32-bit pipelined processor core implementing a foundational subset of the RISC-V (RV32I) instruction set architecture. Designed in Verilog, this project features a 5-stage pipeline (Fetch, Decode, Execute, Memory, Writeback), a centralized control unit, a forwarding unit for hazard resolution, and an exhaustive verification environment. 

## Features

* **Architecture**: 32-bit 5-Stage Pipelined Data Path.
* **R-Type Instructions**: `add`, `sub`, `and`, `or`, `slt`.
* **I-Type Instructions**: `lw` (Load Word).
* **S-Type Instructions**: `sw` (Store Word).
* **B-Type Instructions**: `beq` (Branch if Equal).
* **J-Type Instructions**: `jal` (Jump and Link).
* **Hazard Handling**: Implements a dedicated Hazard Unit for ALU-to-ALU data forwarding, alongside software-level mitigation for load-use and control hazards.
* **Memory Integration**: Word-aligned byte-addressable Data Memory and Instruction Memory.
* **Verification**: Includes a self-checking testbench (`tb_Pipeline.v`) with integrated execution reporting and branch-target verification.

## Project Structure

* `src/Pipelined_Top.v`: The top-level wrapper connecting all pipeline stages and the hazard unit.
* `src/*_Cycle.v`: Individual pipeline stage modules (`Fetch`, `Decode`, `Execute`, `Memory`, `Writeback`).
* `src/Hazard_Unit.v`: Resolves data hazards via forwarding paths.
* `src/ALU.v` & `src/Alu_Decoder.v`: Handles arithmetic and logical operations.
* `src/Control_Unit.v` & `src/Decoder.v`: Generates multiplexer selections and write-enable signals based on instruction opcodes.
* `src/Register_File.v`: 32x32-bit register file with hardwired `x0`.
* `src/Data_Memory.v` & `src/Instruction_Memory.v`: Synthesizable memory models.
* `src/Sign_Extend.v`: Handles I, S, B, and J-type immediate generation.
* `src/tb_Pipeline.v`: The main simulation testbench.
* `src/program.hex`: Compiled machine code used to initialize the instruction memory.

## Hazards Encountered and Resolved

Transitioning from a single-cycle to a pipelined architecture introduced several timing and structural challenges. The following hazards were identified and resolved during development:

* **Register File Read/Write Hazard (Structural/Data):** An issue occurred where instructions in the Decode stage read stale data (`X`) because a simultaneous Writeback operation had not yet completed on the positive clock edge. This was resolved by modifying `Register_File.v` to perform write operations on the negative edge of the clock (`negedge clk`), ensuring data availability for second-half cycle reads.
* **Load-Use Data Hazard:** The `add` instruction failed when attempting to use a register immediately following a `lw` operation before the loaded data reached the Writeback stage. This was mitigated at the software level by padding the assembly code with `NOP` instructions (`addi x0, x0, 0`) to stall the pipeline manually.
* **Control Hazards (Branch/Jump Delay Slots):** Instructions immediately following a `beq` or `jal` were being fetched and executed erroneously due to the lack of hardware branch-flushing logic. This was resolved by inserting software `NOP` flushes immediately after control flow instructions.

## Included Verification Program

The included `src/program.hex` executes the following RV32I assembly program to verify arithmetic, logical, memory, branching, and jump functionality, including NOPs for hazard mitigation:

```assembly
lw x1, 0(x0)      // mem[0]=15 -> x1 = 15
lw x2, 4(x0)      // mem[1]=25 -> x2 = 25
lw x3, 8(x0)      // mem[2]=10 -> x3 = 10

addi x0, x0, 0    // NOP - Software stall for Load-Use Hazard
addi x0, x0, 0    // NOP - Software stall for Load-Use Hazard

add x4, x1, x2    // x4 = 15 + 25 = 40
sub x5, x2, x1    // x5 = 25 - 15 = 10
and x6, x1, x3    // x6 = 15 & 10 = 10
or  x7, x1, x2    // x7 = 15 | 25 = 31
slt x8, x2, x1    // x8 = (25 < 15) ? 1 : 0 = 0
slt x9, x1, x2    // x9 = (15 < 25) ? 1 : 0 = 1

sw x4, 12(x0)     // Store 40 into mem[3]
sw x6, 16(x0)     // Store 10 into mem[4]

beq x3, x5, 8     // x3 == x5, branch forward
addi x0, x0, 0    // NOP - Branch delay slot flush
addi x0, x0, 0    // NOP - Branch delay slot flush
sw x9, 20(x0)     // Skipped

jal x10, 12       // Jump forward and save return address (PC+4 = 72)
addi x0, x0, 0    // NOP - Jump delay slot flush
addi x0, x0, 0    // NOP - Jump delay slot flush
sw x10, 28(x0)    // Skipped
sw x10, 32(x0)    // Skipped
sw x10, 36(x0)    // Store JAL return address (72) into mem[9]

beq x0, x0, 0     // Infinite loop to halt execution
```
## Expected Results

### Registers

| Register | Expected Value |
|----------|---------------:|
| `x1` | 15 |
| `x2` | 25 |
| `x3` | 10 |
| `x4` | 40 |
| `x5` | 10 |
| `x6` | 10 |
| `x7` | 31 |
| `x8` | 0 |
| `x9` | 1 |
| `x10` | 72 |

### Data Memory

| Address | Word | Expected Value |
|---------:|:----:|---------------|
| 12 | `mem[3]` | 40 |
| 16 | `mem[4]` | 10 |
| 20 | `mem[5]` | Unchanged (store skipped by `beq`) |
| 24 | `mem[6]` | 31 |
| 28 | `mem[7]` | Unchanged (store skipped by `jal`) |
| 32 | `mem[8]` | Unchanged (store skipped by `jal`) |
| 36 | `mem[9]` | 72 |

## Getting Started

### Prerequisites

- Xilinx Vivado (or any standard Verilog simulator such as ModelSim or Icarus Verilog)

### Simulation & Testing

1. Clone the repository to your local machine.
2. Open the project in Vivado and set `src/tb_Pipeline.v` as the top simulation module.
3. Ensure `src/program.hex` is loaded into your active simulation sources directory.
4. Run the behavioral simulation for at least **400 ns** to allow instructions to propagate through all five pipeline stages.
5. The testbench will output a detailed pass/fail report in the TCL console verifying register states and memory contents.

## Future Work

- **Hardware Hazard Resolution:** Upgrade `Hazard_Unit.v` to dynamically stall the pipeline for load-use hazards and automatically flush incorrectly fetched instructions after taken branches or jumps, eliminating the need for software `NOP` padding.
- **Extended RV32I Support:** Implement additional branch instructions (`bne`, `blt`, `bge`), shift operations (`sll`, `srl`), and immediate arithmetic/logic instructions (`addi`, `andi`, etc.).

## License

This project is licensed under the MIT License.
