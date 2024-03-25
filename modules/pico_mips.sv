// File: pico_mips.sv
// Author: Tommy Sætre
// Description:
//  Top-level module for N-bit picoMIPS processor, capable of reading
//  from an in_bus to its registers and output to an out_bus from its
//  registers using the STIN and LOUT instructions respectively.
//  Capable of running programs consisting of MaxProgramSz instructions.
// Last revision: 24/03/24

`include "alucodes.sv"
`include "alu.sv"
`include "decoder.sv"
`include "opcodes.sv"
`include "pc.sv"
`include "pico_mips.sv"
`include "program_memory.sv"
`include "reg_file.sv"
`include "sync_ram.sv"
`include "sync_smult.sv"
`include "register.sv"

module pico_mips #(
    parameter N = 8
    parameter InBusSz = 10,
    parameter MaxProgramSz = 64,
    parameter ImmediateSz = 16,
    localparam ProgramAddrSz = $clog2(MaxProgramSz),
    localparam InstructionSz = N + ImmediateSz
) (
    input logic [inBusSz-1:0] in_bus,
    input logic clk, n_reset,
    output logic [N-1:0] out_bus
);

    // Wiring/buses
    logic rel_branch;
    logic alu_ZF;
    logic reg_write;
    logic immediate;
    logic mult;
    logic read_in_bus;
    logic write_out_bus;
    logic [N-1:0] pc_offset;
    logic [N-1:0] addr;
    logic [InstructionSz-1:0] instruction;
    logic [5:0] opcode;
    logic [2:0] alu_func;
    logic [4:0] rd;
    logic [4:0] rs;
    logic [N-1:0] reg_write_data;
    logic [N-1:0] rd_data;
    logic [N-1:0] rs_data;
    logic [N-1:0] alu_a;
    logic [N-1:0] alu_b;
    logic [N-1:0] alu_result;

    assign reg_write_data = (read_in_bus ? in_bus : alu_result);

    // Modules
    pc #(.AddrSz(ProgramAddrSz)) pc (.rel_branch(rel_branch), .clk(clk), .n_reset(n_reset), .offset(pc_offset));
    program_memory #(.N(N), .AddrSz(ProgramAddrSz)) program_memory (.address(addr), .instruction(current_instruction));
    decoder decoder (.ZF(alu_ZF), .opcode(opcode), .alu_func(alu_func), .pc_rel_branch(rel_branch),
        .reg_write(reg_write), .immediate(immediate), .mult(mult), .read_in(read_in_bus), .wirte_out(write_out_bus));
    reg_file #(.N(N), .M(32)) reg_file (.Rd(rd), .Rs(rs), .Wdata(reg_write_data), .w_enable(reg_write), .clk(clk),
        .Rd_data(rd_data), .Rs_data(rs_data));
    alu #(.N(N)) alu (.a(alu_a), .b(alu_b), .func(alu_func), .result(alu_result), .ZF(alu_ZF));
    register #(.N(N)) register (.D(alu_result), .clk(write_out_bus), .n_reset(n_reset), .Q(out_bus));


endmodule
