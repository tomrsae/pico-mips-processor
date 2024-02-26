`include "../modules/reg_file.sv"

module reg_file_test;

parameter N = 8;
parameter M = 32;
parameter addrSz = $clog(M);

logic [addrSz-1:0] Rd, Rs;
logic [M-1:0] Wdata;
logic w_enable, clk;
logic [M-1:0] Rd_data, Rs_data;

reg_file #(.*) regs (.*);

initial begin
    clk = 0;
    forever #5ns clk = ~clk;
end

initial begin
    // Doesn't write to 0-register
    Wdata = 133;
    Rd = 0;
    w_enable = 1'b1;
    #5ns w_enable = 1'b0;
    assert (Rd_data == 0)
    else $error("Wrote to 0-register");
    
    // Writes to "any" other register
    #5ns
    Rd = 22;
    w_enable = 1'b1;
    #5ns w_enable = 1'b0;
    assert (Rd_data == Wdata)
    else $error("Failed to write (1)");

    #5ns
    Wdata = 233;
    Rd = 31;
    w_enable = 1'b1;
    #5ns w_enable = 1'b0;
    assert (Rd_data == Wdata)
    else $error("Failed to write (2)");

    #5ns
    Wdata = 33;
    Rd = 1;
    w_enable = 1'b1;
    #5ns w_enable = 1'b0;
    assert (Rd_data == Wdata)
    else $error("Failed to write (3)");
end

endmodule