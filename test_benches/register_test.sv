`include "../modules/register.sv"

module register_test;

parameter N = 8;
logic [N-1:0] D, Q;
logic clk, n_reset;

register #(.N(N)) register (.*);

initial begin
    n_reset = 0;
    #5ns
    n_reset = 1;
    clk = 0;
    forever #5ns clk = ~clk;
end

// Properties broken??
// assert property (
//     @(posedge clk) (Q == D)
// ) else $error("Transparency test failed");

// assert property (
//     @(negedge clk) (Q == $past(Q))
// ) else $error("Latching test failed");

initial begin
    D = 133;

    #20ns
    D = 222;

    #10ns
    D = 54;

    #5ns
    D = 99;
end

endmodule