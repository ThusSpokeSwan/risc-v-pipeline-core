`timescale 1ns / 1ps

module Data_Memory(
    input clk, rst, WE,
    input [31:0] A, WD,
    output [31:0] RD
    );
    
    reg [31:0] mem [1023:0];
    
    always @(posedge clk)
    begin
        if (WE)
            mem[A[31:2]] <= WD;
    end
    
    assign RD = (rst) ? 32'h00000000 : mem[A[31:2]];
    
endmodule
