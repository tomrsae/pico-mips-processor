// File: decoder.sv
// Author: Tommy Sætre
// Description: Instruction decoder, facilitating relative branching,
//              register- and immediate-based arithmetic and multiplication,
//              as well as I/O.
// Last revision: 22/04/24

`include "opcodes.sv"
`include "alucodes.sv"

module decoder (
    input logic ZF,
    input logic [5:0] opcode,
    output logic [2:0] alu_func,
    output logic pc_rel_branch, reg_write, immediate, read_in, write_out
);
    assign alu_func = opcode[2:0];

    always_comb begin
        pc_rel_branch = 0;
        reg_write = 0;
        immediate = 0;
        read_in = 0;
        write_out = 0;

        unique case (opcode)
            `NOP : ;
            `ADD, `SUB, `MLT : reg_write = 1;
            `ADDI, `SUBI, `MLTI : begin
                reg_write = 1;
                immediate = 1;
            end
            `JMP : pc_rel_branch = 1;
            `LD: begin
                reg_write = 1;
                read_in = 1;
            end
            `ST: write_out = 1;
            default: $error("Opcode not implemented");
        endcase
    end

endmodule