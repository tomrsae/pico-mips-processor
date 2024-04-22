`include "../modules/io.sv"

module io_test;

parameter N = 8;

logic clk, n_reset, handshake, write_out, halt_program;
logic [N-1:0] in, out, cpu_out, cpu_in;

io #(.N(N)) io (.*);

initial begin
    n_reset = 1;
    #5ns
    n_reset = 0;
    #5ns
    n_reset = 1;

    handshake = 0;
    write_out = 0;
    clk = 1;
    forever #5ns clk = ~clk;
end

initial begin
    in = 8'h2B;
    // reading x1
    #23ns
    handshake = 1;
    #44ns
    handshake = 0;

    #10ns
    in = 8'h04;
    // reading y1
    #12ns
    handshake = 1;
    #53ns
    handshake = 0;
    
    // waiting for result from affine transformation
    #118ns
    cpu_out = 8'hCC; // x2
    write_out = 1;
    #10ns
    write_out = 0;

    // result ready, currently displaying x2
    #78ns
    handshake = 1;

    #12ns
    cpu_out = 8'hEE; // y2
    write_out = 1;
    #10ns
    write_out = 0;

    // currently displaying y2
    #26ns
    handshake = 0;
end

endmodule