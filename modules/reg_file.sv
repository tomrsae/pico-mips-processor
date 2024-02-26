// File: reg_file.sv
// Author: Tommy Sætre
// Description: Describes a register file consisting of M N-bit registers, including a virtual 0-register
// Last revision: 26/02/24

module reg_file #(
    parameter M = 32,
    parameter N = 8,
    localparam addrSz = $clog2(M);
) (
    input logic [addrSz-1:0] Rd, Rs,
    input logic [M-1:0] Wdata,
    input logic w_enable, clk
    output logic [M-1:0] Rd_data, Rs_data
);

    logic [N-1:0] registers [1:M-1];

    always_ff @(posedge clk) begin
        if (w_enable && Rd > 0) registers[Rd] <= Wdata;
    end
    
    always_comb begin
        Rd_data = (Rd == 0) ? 0 : register[Rd];
        Rs_data = (Rs == 0) ? 0 : register[Rs];
    end

endmodule