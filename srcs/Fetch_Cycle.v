`timescale 1ns / 1ps

module Fetch_Cycle(
    input clk, rst, PCSrcE,
    input [31:0] PCTargetE,
    output [31:0] InstrD,
    output [31:0] PCD,
    output [31:0] PCPlus4D
    );
    
    wire [31:0] PC_F, PCF, PCPlus4F, InstrF;
    reg [31:0] InstrF_reg, PCF_reg, PCPlus4F_reg;
    
    MUX PC_Mux (
        .a(PCPlus4F),
        .b(PCTargetE),
        .s(PCSrcE),
        .c(PC_F)
    );
    
    PC PC(
        .clk(clk),
        .rst(rst),
        .PCNext(PC_F),
        .PC(PCF)
    );
    
    PCPlus4 PC_Adder(
        .A(PCF),
        .B(PCPlus4F)
    );
    
    Instruction_Memory Instruction_Memory(
        .rst(rst),
        .A(PCF),
        .RD(InstrF)
    );
    
    always @(posedge clk) begin
        if(rst) begin
            InstrF_reg <= 32'd0;
            PCF_reg <= 32'd0;
            PCPlus4F_reg <= 32'd0;
        end
        else begin
            InstrF_reg <= InstrF;
            PCF_reg <= PCF;
            PCPlus4F_reg <= PCPlus4F;
        end
    end
    
    assign InstrD = InstrF_reg;
    assign PCD = PCF_reg;
    assign PCPlus4D = PCPlus4F_reg;
    
endmodule
