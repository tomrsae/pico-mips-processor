`include "../modules/decoder.sv"
`include "../modules/opcodes.sv"
`include "../modules/alucodes.sv"

module decoder_test;

    logic [5:0] opcode;
    logic [2:0] alu_func;
    logic pc_rel_branch, reg_write, immediate, mult, read_in, write_out, ZF, clk;

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
        opdcode == `SUBI |-> (alu_func == `RSUB && immediate && reg_write);
    endproperty

    property BEQandZFsetsPcRelBranch;
        (opcode == `BEQ && ZF) |-> pc_rel_branch;
    endproperty

    property BEQandNotZFdoesNotSetPcRelBranch;
        (opcode == `BEQ && !ZF) |-> !pc_rel_branch;
    endproperty

    property BNQandZFsetsPcRelBranch;
        (opcode == `BNQ && ZF) |-> !pc_rel_branch;
    endproperty

    property BNQandNotZFdoesNotSetPcRelBranch;
        (opcode == `BNQ && !ZF) |-> pc_rel_branch;
    endproperty

    property JMPsetsPcRelBranch;
        opcode == `JMP |-> pc_rel_branch;
    endproperty

    property MULTsetsMultandRegWrite;
        opcode == `MULT |-> (mult && reg_write);
    endproperty

    property STINsetsReadInandRegWrite;
        opcode == `STIN |-> (read_in && reg_write);
    endproperty

    property LOUTsetsWriteOut;
        opcode == `LOUT |-> write_out;
    endproperty

    initial begin
        clk = 0;
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
        opcode = `BNQ;
        #10ns
        opcode = `BNQ;
        ZF = 0;
        #10ns
        opcode = `JMP;
        #10ns
        opcode = `MULT;
        #10ns
        opcode = `STIN;
        #10ns
        opcode = `LOUT;
    end
 
    assert property (ADDsetsALUandRegWrite)
    else $("ADDsetsALUandRegWrite not satisfied");

    assert property (SUBsetsALUandRegWrite)
    else $("SUBsetsALUandRegWrite not satisfied");

    assert property (ADDIsetsALUandImmediateandRegWrite)
    else $("ADDIsetsALUandImmediateandRegWrite not satisfied");

    assert property (SUBIsetsALUandImmediateandRegWrite)
    else $("SUBIsetsALUandImmediateandRegWrite not satisfied");

    assert property (BEQandZFsetsPcRelBranch)
    else $("BEQandZFsetsPcRelBranch not satisfied");

    assert property (BEQandNotZFdoesNotSetPcRelBranch)
    else $("BEQandNotZFdoesNotSetPcRelBranch not satisfied");

    assert property (BNQandZFsetsPcRelBranch)
    else $("BNQandZFsetsPcRelBranch not satisfied");

    assert property (BNQandNotZFdoesNotSetPcRelBranch)
    else $("BNQandNotZFdoesNotSetPcRelBranch not satisfied");

    assert property (JMPsetsPcRelBranch)
    else $("JMPsetsPcRelBranch not satisfied");

    assert property (MULTsetsMultandRegWrite)
    else $("MULTsetsMultandRegWrite not satisfied");

    assert property (STINsetsReadInandRegWrite)
    else $("STINsetsReadInandRegWrite not satisfied");

    assert property (LOUTsetsWriteOut)
    else $("LOUTsetsWriteOut not satisfied");

endmodule