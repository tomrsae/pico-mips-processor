// File: counter.sv
// Author: (Presumably) T. Kazmierski.
// Description: Counter for slowing down FPGA clock.
// Last revision: 22/04/24
// AI notice: Taken directly from coursework specs

// counter for slow clock

module counter #(parameter n = 24) //clock divides by 2^n, adjust n if necessary
    (input logic fastclk, output logic clk);

    logic [n-1:0] count;
    always_ff @(posedge fastclk)
        count <= count + 1;

    assign clk = count[n-1]; // slow clock

endmodule