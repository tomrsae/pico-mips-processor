`include "../modules/alu.sv"
`include "../modules/alucodes.sv"

module alu_test;

parameter N = 8;

logic [N-1:0] a, b, result;
logic [2:0] func;
logic ZF, clk;

alu #(.N(N)) alu1 (.*);

initial begin
    a = 5;
    b = 17;
    func = 0;

    clk = 0;
    forever #5ns clk = ~clk;
end

initial begin
    func = `RA;  
    #10ns func = `RB;  
    #10ns func = `RADD;
    #10ns func = `RSUB;
    #10ns func = `RAND;
    #10ns func = `ROR; 
    #10ns func = `RXOR;
    #10ns func = `RMUL;
    #10ns
    a = b;
    func = `RSUB;
end

default clocking clock
    @(posedge clk);
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
    func == `RADD |-> result == (a + b);
endproperty

property RSUBsubtracts;
    func == `RSUB |-> result == (a - b);
endproperty

property RANDands;
    func == `RAND |-> result == (a & b);
endproperty

property RORors;
    func == `ROR |-> result == (a | b);
endproperty

property RXORxors;
    func == `RXOR |-> result == (a ^ b);
endproperty

property RMULmults;
    func == `RMUL |-> result == (a * b);
endproperty

assert property (ZFisSetOnZero)
else $error("Property ZFisSetOnZero not satisfied");

assert property (RAreflectsA)
else $error("Property RAreflectsA not satisfied");

assert property (RBreflectsB)
else $error("Property RBreflectsB not satisfied");

assert property (RADDadds)
else $error("Property RADDadds not satisfied");

assert property (RSUBsubtracts)
else $error("Property RSUBsubtracts not satisfied");

assert property (RANDands)
else $error("Property RANDands not satisfied");

assert property (RORors)
else $error("Property RORors not satisfied");

assert property (RXORxors)
else $error("Property RXORxors not satisfied");

assert property (RMULmults)
else $error("Property RMULmults not satisfied");

endmodule