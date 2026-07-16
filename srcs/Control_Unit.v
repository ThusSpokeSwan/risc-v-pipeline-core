`timescale 1ns / 1ps

module Control_Unit(
    input [6:0] op, funct7,
    input [2:0] funct3,
    input z,
    output PCSrc,branch,
    output ResultSrc,
    output MemWrite,
    output ALUSrc,
    output [1:0] ImmSrc,
    output RegWrite,
    output [2:0] ALUControl
    );
    
    wire [1:0] ALUOp;
      
    Decoder Decoder(
        .op(op),
        .Z(z),
        .PCSrc(PCSrc),
        .branch(branch),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite),
        .ALUOp(ALUOp)
    );

    Alu_Decoder Alu_Decoder(
        .ALUOp(ALUOp),
        .funct3(funct3),
        .op(op),
        .funct7(funct7),
        .ALUControl(ALUControl)
    );
    
endmodule
