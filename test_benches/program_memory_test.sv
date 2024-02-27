`include "../modules/program_memory.sv"

module program_memory_test;

parameter N = 8;
parameter AddrSz = 6;

logic [AddrSz-1:0] address;
logic [N+15:0] instruction;

program_memory #(.N(N), .AddrSz(AddrSz)) mem (.*);

initial begin
    address = 0;
    #10ns
    address = 1;
    #10ns
    address = 2;
    # 10ns
    address = 3;
    # 10ns
    address = 4;
end

endmodule