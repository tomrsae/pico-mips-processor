`include "../modules/pico_mips.sv"

module pico_mips_test;

parameter N = 8;
parameter MaxProgramSz = 32;

logic [N-1:0] in_bus, out_bus;
logic clk, n_reset, io_handshake;

pico_mips #(.N(N), .MaxProgramSz(MaxProgramSz)) pico_mips (.*);

initial begin
    io_handshake = 0;
    in_bus = 0;

    n_reset = 0;
    #100ms
    n_reset = 1;

    clk = 1;
    forever #50ms clk = ~clk; // 10 Hz, as it will run on FPGA
end

initial begin
    #100ms

    in_bus = 8'hCE;
    #250ms
    io_handshake = 1;
    
    #333ms
    io_handshake = 0;
    #120ms
    in_bus = 8'h8B;
    #833ms
    io_handshake = 1;

    #200ms
    io_handshake = 0;

    #2000ms
    io_handshake = 1;

    #2000ms
    io_handshake = 0;
    
    // 2nd go
    #100ms

    in_bus = 8'h22;
    #250ms
    io_handshake = 1;
    
    #333ms
    io_handshake = 0;
    #120ms
    in_bus = 8'h55;
    #833ms
    io_handshake = 1;

    #200ms
    io_handshake = 0;

    #2000ms
    io_handshake = 1;

    #2000ms
    io_handshake = 0;
end

endmodule