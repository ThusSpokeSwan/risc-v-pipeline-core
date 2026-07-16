`timescale 1ns / 1ps

module Execute_Cycle(
    input clk, rst,
    input RegWriteE, ResultSrcE, MemWriteE, BranchE, ALUSrcE,
    input [2:0] ALUControlE, ForwardAE, ForwardBE,
    input [31:0] RD1E, RD2E, PCE, ImmExtE, PCPlus4E, ResultW,
    input [4:0] RdE,
    output RegWriteM, ResultSrcM, MemWriteM, PCSrcE,
    output [31:0] ALUResultM, WriteDataM, PCPlus4M, PCTargetE,
    output [4:0] RdM
    );
    
    wire [31:0] SrcAE, SrcBE, SrcBE_interim ,ALUResultE;
    wire ZeroE;

    reg RegWriteE_reg, ResultSrcE_reg, MemWriteE_reg;
    reg [4:0] RdE_reg;
    reg[31:0] ALUResultE_reg, WriteDataE, PCPlus4E_reg;    
        
    MUX_3x1 MUX_SrcA(
        .a(RD1E),
        .b(ResultW),
        .c(ALUResultM),
        .s(ForwardAE),
        .d(SrcAE)
    );
    
    MUX_3x1 MUX_SrcB(
        .a(RD2E),
        .b(ResultW),
        .c(ALUResultM),
        .s(ForwardBE),
        .d(SrcBE_interim)
    );
        
        
    MUX MUX_ALU(
        .a(RD2E),
        .b(ImmExtE),
        .s(ALUSrcE),
        .c(SrcBE)
    );
    
    ALU ALU(
        .A(SrcAE),
        .B(SrcBE),
        .ALUControl(ALUControlE),
        .Result(ALUResultE),
        .slt(),
        .Z(ZeroE),
        .N(),
        .C(),
        .V()
    );
    
    PCTarget PCTarget(
        .PC(PCE),
        .ImmExt(ImmExtE),
        .PCTarget(PCTargetE)
    );
    
    always @(posedge clk) begin
        if (rst) begin
            RegWriteE_reg <= 1'd0;
            ResultSrcE_reg <= 1'd0;
            MemWriteE_reg <= 1'd0;
            ALUResultE_reg <= 32'd0;
            WriteDataE <= 32'd0;
            RdE_reg <= 5'd0;
            PCPlus4E_reg <= 32'd0;
        end
        else begin
            RegWriteE_reg <= RegWriteE;
            ResultSrcE_reg <= ResultSrcE;
            MemWriteE_reg <= MemWriteE;
            ALUResultE_reg <= ALUResultE;
            WriteDataE <= SrcBE_interim;
            RdE_reg <= RdE;
            PCPlus4E_reg <= PCPlus4E;
        end
    end
    
    assign PCSrcE = ZeroE && BranchE;
    assign RegWriteM = RegWriteE_reg;
    assign ResultSrcM = ResultSrcE_reg;
    assign MemWriteM = MemWriteE_reg;
    assign ALUResultM = ALUResultE_reg;
    assign WriteDataM = WriteDataE;
    assign RdM = RdE_reg;
    assign PCPlus4M = PCPlus4E_reg;
    
endmodule
