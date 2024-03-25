module register #(parameter N = 8) (
    input logic [N-1:0] D,
    input logic clk, n_reset
    output logic [N-1] Q
);

always_ff @(posedge clk, negedge n_reset) begin
    if (!n_reset)
        Q <= 0;
    else
        Q <= D;
end

endmodule