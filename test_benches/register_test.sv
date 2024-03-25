`include "../modules/register.sv"

module register_test;

parameter N = 8;
logic [N-1:0] D, Q;
logic clk, n_reset;

register #(.N(N)) register (.*);

initial begin
    n_reset = 0;
    n_reset = 1;
end

initial begin
    D = 133;
    assert (D != Q)
    else $error("register was transparent without clk");

    clk = 1;
    assert (D == Q)
    else $error("register was not transparent with clk");

    D = 222;
    assert (D == Q)
    else $error("register was not transparent with clk");

    clk = 0;
    D = 54;
    assert (D != Q)
    else $error("register was transparent without clk");
end

endmodule