`timescale 1ns / 1ps

module PCPlus4(
    input [31:0] A,
    output [31:0] B
    );
    
    assign B = A + 32'd4; 
    
endmodule
