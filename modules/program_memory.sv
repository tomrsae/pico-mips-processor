// File: reg_file.sv
// Author: Tommy Sætre
// Description: Simple program memory implementation, program is read from a static file
// Last revision: 24/03/24

module program_memory #(
    parameter N = 8,
    parameter AddrSz = 6,
    parameter InstructionSz = 24
) (
    input logic [AddrSz-1:0] address,
    output logic [InstructionSz-1:0] instruction
);

    logic [InstructionSz-1:0] rom [0:(1 << AddrSz) - 1];

    initial
        $readmemh("../program.hex", rom);

    always_comb
        instruction = rom[address];

endmodule