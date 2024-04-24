`include "../modules/pc.sv"

module pc_test;

parameter AddrSz = 6;

logic rel_branch, clk, n_reset, halt;
logic [AddrSz-1:0] offset;
logic [AddrSz-1:0] addr;

pc #(.AddrSz(AddrSz)) pc (.*);

initial begin
    n_reset = 1;
    #10ns
    n_reset = 0;
	#10ns
	n_reset = 1;

    halt = 0;
	rel_branch = 0;
	offset = 0;
    clk = 0;
    forever #5ns clk = ~clk;
end

default clocking clock
    @(posedge clk);
endclocking

assert property (
    !rel_branch && !halt |=> addr == $past(addr) + 1
) else $error("PC did not increment despite relative branching being disabled");

assert property (
    rel_branch && !halt |=> addr == $past(addr) + offset
) else $error("PC did not add relative branch offset");

assert property (
    halt |=> addr == $past(addr)
) else $error("PC did not halt");

initial begin

    #50ns

    offset = 10;
    rel_branch = 1;
    #10ns
    rel_branch = 0;
    #10ns
    halt = 1;
    #50ns
    halt = 0;

    #50ns
    $display("complete");
end

endmodule

