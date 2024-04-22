`include "../modules/reg_file.sv"

module reg_file_test;

parameter N = 8;
parameter M = 32;

logic [4:0] Rd, Rs, Rt;
logic [N-1:0] Wdata;
logic w_enable, clk, n_reset;
logic [N-1:0] Rs_data, Rt_data;

reg_file #(.N(N), .M(M)) regs (.*);

initial begin
    n_reset = 0;
    #10ns
    n_reset = 1;

    clk = 1;
    forever #5ns clk = ~clk;
end

initial begin
	Rd = 0;
	Rs = 0;
    assign Rt = Rd; // Immediately read written value
	Wdata = 0;
	w_enable = 0;

    // Doesn't write to 0-register
    Wdata = 133;
    Rd = 0;
    #10ns w_enable = 1'b1;
    #10ns w_enable = 1'b0;
    assert (Rt_data == 0)
    else $error("Wrote to 0-register");
    
    // Writes to "any" other register
    #10ns
    Rd = 22;
    #10ns w_enable = 1'b1;
    #10ns w_enable = 1'b0;
    assert (Rt_data == Wdata)
    else $error("Failed to write (1)");

    #10ns
    Wdata = 233;
    Rd = 31;
    #10ns w_enable = 1'b1;
    #10ns w_enable = 1'b0;
    assert (Rt_data == Wdata)
    else $error("Failed to write (2)");

    #10ns
    Wdata = 33;
    Rd = 1;
    #10ns w_enable = 1'b1;
    #10ns w_enable = 1'b0;
    assert (Rt_data == Wdata)
    else $error("Failed to write (3)");
	
	#10ns
	Rs = 22;
end

endmodule