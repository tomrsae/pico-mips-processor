`include "../modules/alu.sv"
`include "../modules/alucodes.sv"

module alu_test;

parameter N = 8;

logic [N-1:0] a, b, result;
logic [2:0] func;
logic ZF;

alu #(.N(N)) alu1 (.*);

initial begin
    a = 5;
    b = 17;
    func = 0;
end

initial begin
    #10ns func = RA;  
    #10ns func = RB;  
    #10ns func = RADD;
    #10ns func = RSUB;
    #10ns func = RAND;
    #10ns func = ROR; 
    #10ns func = RXOR;
    #10ns func = RNOR; 
end

default clocking clock;
    @(posedge clk)
endclocking

property ZFisSetOnZero;
    result == 0 |-> ZF;
endproperty

property RAreflectsA;
    func == `RA |-> result == a;
endproperty

property RBreflectsB;
    func == `RB |-> result == b;
endproperty

property RADDadds;
    func == `RADD |-> result == a + b;
endproperty

property RSUBsubtracts;
    func == `RSUB |-> result == a - b;
endproperty

property RANDands;
    func == `RAND |-> result == a & b;
endproperty

property RORors;
    func == `ROR |-> result == a | b;
endproperty

property RXORxors;
    func == `RXOR |-> result == a ^ b;
endproperty

property RNORnors;
    func == `RNOR |-> result == ~(a | b);
endproperty

endmodule