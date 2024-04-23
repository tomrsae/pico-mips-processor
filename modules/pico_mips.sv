// File: pico_mips.sv
// Author: Tommy Sætre
// Description:
//  Top-level module for N-bit picoMIPS processor, capable of reading
//  from an in_bus to its registers and output to an out_bus from its
//  registers using the LD and ST instructions respectively.
//  Capable of running programs consisting of MaxProgramSz instructions.
//  io_handshake is a signal used to progress the program, with the
//  intenion of it acting as an I/O handshake.
// Last revision: 22/04/24

module pico_mips #(
    parameter N = 8,
    parameter MaxProgramSz = 32
) (
    input logic [N-1:0] in_bus,
    input logic clk, n_reset, io_handshake,
    output logic [N-1:0] out_bus
);

    // Wiring/buses
    logic rel_branch;
    logic alu_ZF;
    logic reg_write;
    logic use_imm;
    logic read_in_bus;
    logic write_out_bus;
    logic halt_program;
    logic [N-1:0] immediate;
    logic [N-1:0] addr;
    logic [17:0] offset;
    logic [N+15:0] instruction;
    logic [5:0] opcode;
    logic [2:0] alu_func;
    logic [4:0] rd;
    logic [4:0] rs;
    logic [4:0] rt;
    logic [N-1:0] reg_write_data;
    logic [N-1:0] rs_data;
    logic [N-1:0] rt_data;
    logic [N-1:0] alu_a;
    logic [N-1:0] alu_b;
    logic [N-1:0] alu_result;
    logic [N-1:0] cpu_out;
    logic [N-1:0] cpu_in;

    assign opcode = instruction[N+15:N+10];
    assign rd = instruction[N+9:N+5];
    assign rs = instruction[N+4:N];
    assign rt = instruction[N-1:N-5];
    assign immediate = instruction[N-1:0];
    assign offset = instruction[N+9:0];
    
    assign alu_a = rs_data;
    assign alu_b = use_imm ? immediate : rt_data;
    assign reg_write_data = (read_in_bus ? cpu_in : alu_result);
    assign cpu_out = alu_result;

    // Modules
    pc #(.AddrSz($clog2(MaxProgramSz))) pc (.rel_branch(rel_branch), .clk(clk), .halt(halt_program), .n_reset(n_reset),
        .offset(offset), .addr(addr));
    program_memory #(.N(N), .AddrSz($clog2(MaxProgramSz))) program_memory (.address(addr), .instruction(instruction));
    decoder decoder (.ZF(alu_ZF), .opcode(opcode), .alu_func(alu_func), .pc_rel_branch(rel_branch),
        .reg_write(reg_write), .immediate(use_imm), .read_in(read_in_bus), .write_out(write_out_bus));
    reg_file #(.N(N), .M(32)) reg_file (.Rd(rd), .Rt(rt), .Rs(rs), .Wdata(reg_write_data), .w_enable(reg_write), .clk(clk),
        .Rs_data(rs_data), .Rt_data(rt_data), .n_reset(n_reset));
    alu #(.N(N)) alu (.a(alu_a), .b(alu_b), .func(alu_func), .result(alu_result), .ZF(alu_ZF));
    io #(.N(N)) io_module (.clk(clk), .n_reset(n_reset), .handshake(io_handshake), .write_out(write_out_bus),
        .in(in_bus), .cpu_out(cpu_out), .cpu_in(cpu_in), .out(out_bus), .halt_program(halt_program));


endmodule
