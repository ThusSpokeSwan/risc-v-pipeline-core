`timescale 1ns / 1ps

module Single_Cycle_Top(
    input clk, rst
    );
    
    wire [31:0] PC_Op, Instr, SrcA, SrcB, WriteData, ImmExt, Result, ALUResult, ReadData, PCNext, PC4, PC_Target;
    wire RegWrite, ALUSrc, Zero, MemWrite, ResultSrc, PCSrc, branch;
    wire [2:0] ALUControl;
    wire [1:0] ImmSrc;
    
    Control_Unit Control_Unit(
        .op(Instr[6:0]),
        .funct7(Instr[31:25]),
        .funct3(Instr[14:12]),
        .z(Zero),
        .PCSrc(PCSrc),
        .branch(branch),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite),
        .ALUControl(ALUControl)
    );
    
    PC PC(
        .clk(clk),
        .rst(rst),
        .PCNext(PCNext),
        .PC(PC_Op)
    );
    
    PCPlus4 PCPlus4(
        .A(PC_Op),
        .B(PC4)
    );
    
    PCTarget PCTarget(
        .PC(PC_Op),
        .ImmExt(ImmExt),
        .PCTarget(PC_Target)
    );
    
    MUX MUX_PCPlus4_and_PCTarget(
        .a(PC4),
        .b(PC_Target),
        .c(PCNext),
        .s(PCSrc)
    );
    
    Instruction_Memory Instruction_Memory(
        .rst(rst),
        .clk(clk),
        .A(PC_Op),
        .RD(Instr)
    ); 
    
    Register_File Register_File(
        .rst(rst),
        .clk(clk),
        .WE(RegWrite),
        .A1(Instr[19:15]),
        .A2(Instr[24:20]),
        .A3(Instr[11:7]),
        .WD(Result),
        .RD1(SrcA),
        .RD2(WriteData)
    );
    
    Sign_Extend Sign_Extend(
        .Inst(Instr),
        .ImmSrc(ImmSrc),
        .ImmExt(ImmExt)
    );
    
    MUX MUX_Register_to_ALU(
        .a(WriteData),
        .b(ImmExt),
        .c(SrcB),
        .s(ALUSrc)
    );
    
    ALU ALU(
        .A(SrcA),
        .B(SrcB),
        .ALUControl(ALUControl),
        .Result(ALUResult),
        .slt(),
        .Z(Zero),
        .N(),
        .C(),
        .V()
    );
    
    Data_Memory Data_Memory(
        .clk(clk),
        .rst(rst),
        .WE(MemWrite),
        .A(ALUResult),
        .WD(WriteData),
        .RD(ReadData)
    );
    
    MUX MUX_DataMemory_to_Register(
        .a(ALUResult),
        .b(ReadData),
        .c(Result),
        .s(ResultSrc)
    );
    
endmodule
