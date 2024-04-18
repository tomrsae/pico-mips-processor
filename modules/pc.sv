// File: pc.sv
// Author: Tommy Sætre
// Description: Program counter, facilitating relative branching and incrementing
// Last revision: 18/04/24

module pc #(parameter AddrSz = 6) (
    input logic rel_branch, clk, n_reset, halt
    input logic [AddrSz-1:0] offset,
    output logic [AddrSz-1:0] addr
);

    always_ff @(posedge clk, negedge n_reset) begin
        if (!n_reset)
            addr <= 0;
        else
            if (!halt) addr <= addr + (rel_branch ? offset : 1);
    end

endmodule