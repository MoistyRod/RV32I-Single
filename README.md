# Single-Cycle RISC-V RV32I CPU
For this project, I implement a simple single-cycle CPU based on the [RISC-V RV32I ISA](https://riscv.org/wp-content/uploads/2017/05/riscv-spec-v2.2.pdf).
The CPU is designed with reference to the book "Digital Design and Computer Architecture".
It supports all unpriviledged instructions excluding FENCE.

## CPU Architecture
![rv32i_architecture](diagrams/rv32i_singlecycle.drawio.png)
The architecture is comprised of the 5 fundamental stages of Fetching, Decoding, Executing, Memory, and WriteBack.
As it is a single-cycle processor, all stages must be completed within the same cycle for each instruction.
As such, the stages are connected directly without any non-architectural registers to separate them.
Diagrams of other modules can be found in the [diagrams pdf](diagrams/rv32i_singlecycle.drawio.pdf).

### Controller Encoding


## Simulation and Testing


## Tools used and Credits
- Intel Quartus Prime Lite Edition
- Questa Intel FPGA Starter Edition
- [Digital Design and Computer Architecture: RISC-V Edition by Harris & Harris](https://www.goodreads.com/book/show/57086525-digital-design-and-computer-architecture-risc-v-edition)
