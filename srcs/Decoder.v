`timescale 1ns / 1ps

module Decoder(
    input Z,
    input [6:0] op,
    output PCSrc, branch,
    output ResultSrc,
    output MemWrite,
    output ALUSrc,
    output [1:0] ImmSrc,
    output RegWrite,
    output [1:0] ALUOp
    );
    
    assign branch = (op == 7'b1100011) ? 1'b1 : 1'b0;
    assign PCSrc = branch & Z;
    assign ResultSrc = (op == 7'b0000011) ? 1'b1 : 1'b0;
    assign MemWrite = (op == 7'b0100011) ? 1'b1 : 1'b0;
    assign ALUSrc = ((op == 7'b0000011) || (op == 7'b0100011)) ? 1'b1 : 1'b0;
    assign ImmSrc = (op == 7'b0100011) ? 2'b01 : (op == 7'b1100011) ? 2'b10 : 2'b00;
    assign RegWrite = (op == 7'b0000011) || (op == 7'b0110011) ? 1'b1 : 1'b0;
    assign ALUOp = (op == 7'b0110011) ? 2'b10 : (op == 7'b1100011) ? 2'b01 : 2'b00; 
    
endmodule
