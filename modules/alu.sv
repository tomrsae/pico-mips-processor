// File: alu.sv
// Author: Tommy Sætre
// Description: N-bit arithmetic logic unit
// Last revision: 28/02/24

`include "alucodes.sv"

module alu #(parameter N = 8) (
    input logic signed [N-1:0] a, b,
    input logic [2:0] func,
    output logic [N-1:0] result,
    output logic ZF
);
    // Use same adder for addition and subtraction
    logic [N-1:0] arithmetic_result, temp;
    always_comb begin
        temp = (func == `RSUB) ? ~b + 1 : b;

        arithmetic_result = a + temp;
    end

    logic signed [2*N-1:0] smult_result;
    always_comb begin
        smult_result = a * b;
    end

    always_comb begin
        unique case (func)
            `RA:    result = a;
            `RB:    result = b;
            `RADD,
            `RSUB:  result = arithmetic_result;
            `RAND:  result = a & b;
            `ROR:   result = a | b;
            `RXOR:  result = a ^ b;
            `RMUL:  result = smult_result[2*N-1:N];
        endcase
    end

    assign ZF = (result == 0);

endmodule