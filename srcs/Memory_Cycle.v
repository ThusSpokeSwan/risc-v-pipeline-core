`timescale 1ns / 1ps

module Memory_Cycle(
    input clk, rst,
    input RegWriteM, MemWriteM, PCSrcE,
    input [1:0] ResultSrcM,
    input [31:0] ALUResultM, WriteDataM, PCPlus4M, PCTargetE,
    input [4:0] RdM,
    output RegWriteW,
    output [1:0] ResultSrcW,
    output [31:0] ReadDataW, PCPlus4W, ALUResultW,
    output [4:0] RdW
    );
    
    wire [31:0] ReadDataM;
    
    reg [31:0] ReadDataM_reg, ALUResultM_reg, PCPlus4M_reg;
    reg [4:0] RdM_reg;
    reg RegWriteM_reg; 
    reg [1:0] ResultSrcM_reg;
    
    Data_Memory Data_Memory(
        .clk(clk),
        .rst(rst),
        .WE(MemWriteM),
        .A(ALUResultM),
        .WD(WriteDataM),
        .RD(ReadDataM)
    );
    
    always @(posedge clk) begin
        if (rst) begin
            ReadDataM_reg <= 32'd0;
            ALUResultM_reg <= 32'd0;
            PCPlus4M_reg <= 32'd0;
            RdM_reg <= 5'd0;
            RegWriteM_reg <= 1'd0;
            ResultSrcM_reg <= 2'd00;
        end
        else begin
            ReadDataM_reg <= ReadDataM;
            ALUResultM_reg <= ALUResultM;
            PCPlus4M_reg <= PCPlus4M;
            RdM_reg <= RdM;
            RegWriteM_reg <= RegWriteM;
            ResultSrcM_reg <= ResultSrcM;
        end
    end
    
    assign RegWriteW = RegWriteM_reg;
    assign ResultSrcW = ResultSrcM_reg;
    assign ReadDataW = ReadDataM_reg;
    assign PCPlus4W = PCPlus4M_reg;
    assign ALUResultW = ALUResultM_reg;
    assign RdW = RdM_reg;
    
endmodule
