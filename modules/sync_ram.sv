// File: sync_ram.sv
// Author: Tommy Sætre
// Description: Synchronous RAM
// Last revision: 22/03/24

module sync_ram #(
    parameter N = 8,
    parameter M = 32,
    localparam AddrSz = $clog2(M)
) (
    input logic [AddrSz-1:0] addr,
    input logic [N-1:0] w_data,
    input logic w_en, clk,
    output logic [N-1:0] r_data
);

    logic [N-1:0] ram [0:AddrSz-1];

    always_ff @(posedge clk) begin
        if (w_en)
            ram[addr] = w_data;
        else
            r_data = ram[addr];
    end

endmodule