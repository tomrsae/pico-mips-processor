// File: pico_mips_test.sv
// Author: (Presumably) T. Kazmierski, adapted by Tommy Sætre
// Description: Top-level module for picoMIPS processor for synthesizing.
// Last revision: 22/04/24
// AI notice: Taken directly from coursework specs and lightly adapted/changed.

// synthesise to run on Altera DE0 for testing and demo

module pico_mips_test (
    input logic fastclk, // 50MHz Altera DE0 clock
    input logic [9:0] SW, // Switches SW0..SW9
    output logic [7:0] LED // LED
);

    logic clk; // slow clock, about 10Hz

    counter c (.fastclk(fastclk),.clk(clk)); // slow clk from counter

    pico_mips myDesign (
        .clk(clk),
        .n_reset(SW[9]),
        .io_handshake(SW[8]),
        .in_bus(SW[7:0]),
        .out_bus(LED)
    );
    
endmodule