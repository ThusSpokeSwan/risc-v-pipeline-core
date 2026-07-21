`timescale 1ns / 1ps

module Writeback_Cycle(
    input clk, rst,
    input [1:0] ResultSrcW,
    input [31:0] ReadDataW, ALUResultW, PCPlus4W,
    output [31:0] ResultW
    );
    
    MUX_3x1 WB_MUX (
        .a(ALUResultW),
        .b(ReadDataW),
        .c(PCPlus4W),
        .s(ResultSrcW),
        .d(ResultW)
    );
    
endmodule
