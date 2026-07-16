`timescale 1ns / 1ps

module Writeback_Cycle(
    input clk, rst,
    input ResultSrcW,
    input [31:0] ReadDataW, ALUResultW, PCPlus4W,
    output [31:0] ResultW
    );
    
    MUX WB_MUX (
        .a(ALUResultW),
        .b(ReadDataW),
        .s(ResultSrcW),
        .c(ResultW)
    );
    
endmodule
