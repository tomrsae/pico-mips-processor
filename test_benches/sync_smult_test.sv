`include "../modules/sync_smult.sv"

module sync_smult_test;

    parameter N = 8;

    signed logic [N-1:0] a, b;
    signed logic [2*N-1:0] result;
    logic clk;

    sync_smult #(.N(N)) smult (.*);

    initial begin
        clk = 0:
        forever #5ns clk = ~clk;
    end

    assert property (
        @(posedge clk) (##1 result == a * b);
    ) else $error("Multiplication failed");

    initial begin
        a = 5;
        b = 4;
        #10ns
        b = -3;
        #10ns
        a = -2;
        #10ns
        b = 0;
    end

endmodule