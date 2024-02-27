`include "../modules/pc.sv"

module pc_test;

parameter AddrSz = 6;

logic rel_branch, clk, n_reset;
logic [AddrSz-1:0] offset;
logic [AddrSz-1:0] addr;

pc #(.AddrSz(AddrSz)) pc1 (.*);

initial begin
    n_reset = 1;
    #10ns
    n_reset = 0;

    clk = 0;
    forever #5ns clk = ~clk;
end

assert property (
    @(posedge clk) (!rel_branch |=> addr == $past(addr) + 1)
) else $error("PC did not increment despite relative branching being disabled");

assert property (
    @(posedge clk) (rel_branch |=> addr == $past(addr) + offset)
) else $error("PC did not add relative branch offset");

initial begin

    #50ns

    offset = 10;
    rel_branch = 1;
    #10ns
    rel_branch = 0;

    #50ns
end

endmodule

