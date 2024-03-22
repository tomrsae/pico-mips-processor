// File: sync_smult.sv
// Author: Tommy Sætre
// Description: N-bit synchronized signed multiplier
// Last revision: 21/03/24

module sync_smult #(parameter N=8) (
    input logic [N-1:0] a, b,
    input logic clk
    output logic [2*N-1:0] result
);
    signed logic [N-1:0] ra, rb;
    signed logic [2*N-1:0] rresult;

    assign rresult = ra * rb;

    always_ff @(posedge clk) begin
        ra <= a;
        rb <= b;
        result <= rresult;
    end
endmodule