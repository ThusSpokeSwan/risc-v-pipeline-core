`timescale 1ns / 1ps

module PC(
    input clk, rst,
    input [31:0] PCNext,
    output reg [31:0] PC
    );
    
    always @(posedge clk)
    begin
        if(rst)
            PC <= 32'h00000000;
        else
            PC <= PCNext;
    end
    
endmodule
