// File: reg_file.sv
// Author: Tommy Sætre
// Description: Describes a register file consisting of M N-bit registers, including a virtual 0-register.
//              Has 3 address inputs
//              - Rd for write address
//              - Rs for read address, with result appearing on Rs_data
//              - Rt for read address, with result appearing on Rt_data
// Last revision: 22/04/24

module reg_file #(
    parameter M = 32,
    parameter N = 8
) (
    input logic [$clog2(M)-1:0] Rd, Rs, Rt,
    input logic [N-1:0] Wdata,
    input logic w_enable, clk, n_reset,
    output logic [N-1:0] Rs_data, Rt_data
);

    logic [N-1:0] registers [1:M-1];

    always_ff @(posedge clk, negedge n_reset) begin
        if (!n_reset)
            registers <= '{(M-1){0}};
        else
            if (w_enable && Rd > 0) registers[Rd] <= Wdata;
    end
    
    always_comb begin
        Rt_data = (Rt == 0) ? 0 : registers[Rt];
        Rs_data = (Rs == 0) ? 0 : registers[Rs];
    end

endmodule