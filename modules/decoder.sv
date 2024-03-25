// File: decoder.sv
// Author: Tommy Sætre
// Description: Instruction decoder, facilitating relative branching, register- and immediate-based arithmetic and multiplication, as well as I/O
// Last revision: 23/03/24

`include "opcodes.sv"
`include "alucodes.sv"

module decoder (
    input logic ZF,
    input logic [5:0] opcode,
    output logic [2:0] alu_func,
    output logic pc_rel_branch, reg_write, immediate, mult, read_in, write_out
);
    assign alu_func = opcode[2:0];

    always_comb begin
        pc_rel_branch = 0;
        reg_write = 0;
        immediate = 0;
        mult = 0;
        read_in = 0;
        write_out = 0;

        unique case (opcode)
            `NOP : ;
            `ADD, `SUB : reg_write = 1;
            `ADDI, `SUBI : begin
                reg_write = 1;
                immediate = 1;
            end
            `BEQ : pc_rel_branch = ZF;
            `BNQ : pc_rel_branch = ~ZF;
            `JMP : pc_rel_branch = 1;
            `MULT: begin
                reg_write = 1;
                mult = 1;
            end
            `STIN: begin
                reg_write = 1;
                read_in = 1;
            end
            `LOUT: write_out = 1;
            default: $error("Opcode not implemented");
        endcase
    end

endmodule