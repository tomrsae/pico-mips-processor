// File: decoder.sv
// Author: Tommy Sætre
// Description: Constants defining opcodes for readability in decoder source code
// Last revision: 27/02/24
// **AI NOTICE: Inspiration to combine opcode w/ alu codes taken from code supplied by T. Kazmierski.

`define NOP     6'b000000
`define ADD     6'b000010
`define SUB     6'b000011
`define ADDI    6'b001010
`define SUBI    6'b001011
`define BEQ     6'b010011
`define JMP     6'b001000
`define MLT     6'b010111
`define MLTI    6'b011111
`define STIN    6'b100000
`define LOUT    6'b011000