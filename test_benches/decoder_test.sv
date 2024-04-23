`include "../modules/decoder.sv"
`include "../modules/opcodes.sv"
`include "../modules/alucodes.sv"

module decoder_test;

    logic [5:0] opcode;
    logic [2:0] alu_func;
    logic pc_rel_branch, reg_write, immediate, read_in, write_out, ZF, clk;

    decoder decoder (.*);

    default clocking clock
        @(posedge clk);
    endclocking

    property ADDsetsALUandRegWrite;
        opcode == `ADD |-> (alu_func == `RADD && reg_write);
    endproperty

    property SUBsetsALUandRegWrite;
        opcode == `SUB |-> (alu_func == `RSUB && reg_write);
    endproperty

    property ADDIsetsALUandImmediateandRegWrite;
        opcode == `ADDI |-> (alu_func == `RADD && immediate && reg_write);
    endproperty

    property SUBIsetsALUandImmediateandRegWrite;
        opcode == `SUBI |-> (alu_func == `RSUB && immediate && reg_write);
    endproperty

    property BEQandZFsetsPcRelBranch;
        (opcode == `BEQ && ZF) |-> pc_rel_branch;
    endproperty

    property BEQandNotZFdoesNotSetPcRelBranch;
        (opcode == `BEQ && !ZF) |-> !pc_rel_branch;
    endproperty

    property JMPsetsPcRelBranch;
        opcode == `JMP |-> pc_rel_branch;
    endproperty

    property MLTsetsALUandRegWrite;
        opcode == `MLT |-> (alu_func == `RMLT && reg_write);
    endproperty

    property MLTIsetsALUandImmediateandRegWrite;
        opcode == `MLTI |-> (alu_func == `RMLT && immediate && reg_write);
    endproperty

    property LDsetsReadInandRegWrite;
        opcode == `LD |-> (read_in && reg_write);
    endproperty

    property STsetsWriteOut;
        opcode == `ST |-> write_out;
    endproperty

    initial begin
        opcode = `NOP;
        clk = 1;
        forever #5ns clk = ~clk;
    end

    initial begin
        opcode = `ADD;
        #10ns
        opcode = `SUB;
        #10ns
        opcode = `ADDI;
        #10ns
        opcode = `SUBI;
        #10ns
        opcode = `BEQ;
        ZF = 0;
        #10ns
        ZF = 1;
        #10ns
        ZF = 0;
        #10ns
        opcode = `JMP;
        #10ns
        opcode = `MLT;
        #10ns
        opcode = `MLTI;
        #10ns
        opcode = `LD;
        #10ns
        opcode = `ST;
    end
 
    assert property (ADDsetsALUandRegWrite)
    else $error("ADDsetsALUandRegWrite not satisfied");

    assert property (SUBsetsALUandRegWrite)
    else $error("SUBsetsALUandRegWrite not satisfied");

    assert property (ADDIsetsALUandImmediateandRegWrite)
    else $error("ADDIsetsALUandImmediateandRegWrite not satisfied");

    assert property (SUBIsetsALUandImmediateandRegWrite)
    else $error("SUBIsetsALUandImmediateandRegWrite not satisfied");

    assert property (BEQandZFsetsPcRelBranch)
    else $error("BEQandZFsetsPcRelBranch not satisfied");

    assert property (BEQandNotZFdoesNotSetPcRelBranch)
    else $error("BEQandNotZFdoesNotSetPcRelBranch not satisfied");

    assert property (JMPsetsPcRelBranch)
    else $error("JMPsetsPcRelBranch not satisfied");

    assert property (MLTsetsALUandRegWrite)
    else $error("MLTsetsALUandRegWrite not satisfied");

    assert property (MLTIsetsALUandImmediateandRegWrite)
    else $error("MLTsetsALUandImmediateandRegWrite not satisfied");

    assert property (LDsetsReadInandRegWrite)
    else $error("LDsetsReadInandRegWrite not satisfied");

    assert property (STsetsWriteOut)
    else $error("STsetsWriteOut not satisfied");

endmodule