`include "../modules/sync_ram.sv"

module sync_ram_test;

parameter N = 8;
parameter M = 32;

logic [AddrSz-1:0] addr,
logic [N-1:0] w_data,
logic w_en, clk,
logic [N-1:0] r_data

sync_ram #(.N(N), .M(M)) ram (.*);

initial begin
    clk = 0;
    forever #5ns clk = ~clk;
end

initial begin
    addr = 12;
    w_data = 136;
    w_en = 1;
    #10ns
    w_en = 0;
    #10ns

    addr = 2;
    w_data = 32;
    w_en = 1;
    #10ns
    w_en = 0;
    #10ns

    addr = 12;
    #10ns
    assert(r_data == 136)
    else $("Value at addr 12 changed");
end

default clocking clock
    @(posedge clk);
endclocking

assert property(
    (w_en ## !w_en |-> r_data == w_data);
) else $error("Written value could not be read")

endmodule