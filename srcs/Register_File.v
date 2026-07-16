`timescale 1ns / 1ps

module Register_File(
    input clk, rst, WE,
    input [4:0] A1, A2, A3,
    input [31:0] WD,
    output [31:0] RD1, RD2
    );
    
    reg [31:0] Register [31:0];
    
    always @(posedge clk)
    begin
        if (WE && A3 != 5'd0)
            Register[A3] <= WD;
    end
    
    assign RD1 = (rst) ? 32'h00000000 : ((A1 == 5'd0) ? 32'h00000000 : Register[A1]);
    assign RD2 = (rst) ? 32'h00000000 : ((A2 == 5'd0) ? 32'h00000000 : Register[A2]);
    
endmodule
