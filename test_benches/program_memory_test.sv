`include "../modules/program_memory.sv"

module program_memory_test;

parameter N = 8;
parameter AddrSz = 6;
parameter InstructionSz = 24;

logic [AddrSz-1:0] address;
logic [InstructionSz-1:0] instruction;

program_memory #(.N(N), .AddrSz(AddrSz), .InstructionSz(InstructionSz)) mem (.*);

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