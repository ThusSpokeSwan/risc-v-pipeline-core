`timescale 1ns / 1ps

module Instruction_Memory(
    input rst, clk,
    input [31:0] A,
    output [31:0] RD
    );
    
    reg [31:0] mem [0:1023];
    
    assign RD = (rst) ? 32'h00000000 : mem[A[31:2]];
    
    initial begin 
        $readmemh("program.hex", mem);
    end
endmodule
