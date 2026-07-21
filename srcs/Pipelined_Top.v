`timescale 1ns / 1ps

module Pipelined_Top(
    input clk, rst
    );
    
    wire PCSrcE, RegWriteW, RegWriteE, MemWriteE, BranchE, JumpE, RegWriteM, MemWriteM, ALUSrcE;
    wire [4:0] RDW, RdE, Rs1E, Rs2E, RdM;
    wire [1:0] ResultSrcE, ResultSrcM, ResultSrcW, ForwardAE, ForwardBE;
    wire [2:0] ALUControlE;
    wire [31:0] PCTargetE, InstrD, PCD, PCPlus4D, ResultW, RD1E, RD2E, PCE, ImmExtE, PCPlus4E, ALUResultM, WriteDataM, PCPlus4M,  ReadDataW, PCPlus4W, ALUResultW;

    Fetch_Cycle Fetch(
        .clk(clk),
        .rst(rst),
        .PCSrcE(PCSrcE),
        .PCTargetE(PCTargetE),
        .InstrD(InstrD),
        .PCD(PCD),
        .PCPlus4D(PCPlus4D)
    );
    
    Decode_Cycle Decode(
        .clk(clk),
        .rst(rst),
        .RegWriteW(RegWriteW),
        .RDW(RDW),
        .ResultW(ResultW),
        .InstrD(InstrD),
        .PCD(PCD),
        .PCPlus4D(PCPlus4D),
        .RegWriteE(RegWriteE),
        .MemWriteE(MemWriteE),
        .BranchE(BranchE),
        .JumpE(JumpE),
        .ALUSrcE(ALUSrcE),
        .ResultSrcE(ResultSrcE),
        .ALUControlE(ALUControlE),
        .RD1E(RD1E),
        .RD2E(RD2E),
        .PCE(PCE),
        .ImmExtE(ImmExtE),
        .PCPlus4E(PCPlus4E),
        .RdE(RdE),
        .Rs1E(Rs1E),
        .Rs2E(Rs2E)
    );
    
    Execute_Cycle Execute(
        .clk(clk),
        .rst(rst),
        .RegWriteE(RegWriteE),
        .MemWriteE(MemWriteE),
        .BranchE(BranchE),
        .JumpE(JumpE),
        .ALUSrcE(ALUSrcE),
        .ResultSrcE(ResultSrcE),
        .ALUControlE(ALUControlE),
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE),
        .RD1E(RD1E),
        .RD2E(RD2E),
        .PCE(PCE), 
        .ImmExtE(ImmExtE),
        .PCPlus4E(PCPlus4E),
        .ResultW(ResultW),
        .RdE(RdE),
        .RegWriteM(RegWriteM),
        .MemWriteM(MemWriteM),
        .PCSrcE(PCSrcE),
        .ResultSrcM(ResultSrcM),
        .ALUResultM(ALUResultM),
        .WriteDataM(WriteDataM),
        .PCPlus4M(PCPlus4M),
        .PCTargetE(PCTargetE),
        .RdM(RdM)
    );

    Memory_Cycle Memory(
        .clk(clk),
        .rst(rst),
        .RegWriteM(RegWriteM),
        .MemWriteM(MemWriteM),
        .PCSrcE(PCSrcE),
        .ResultSrcM(ResultSrcM),
        .ALUResultM(ALUResultM),
        .WriteDataM(WriteDataM), 
        .PCPlus4M(PCPlus4M),
        .PCTargetE(PCTargetE),
        .RdM(RdM),
        .RegWriteW(RegWriteW),
        .ResultSrcW(ResultSrcW),
        .ReadDataW(ReadDataW),
        .PCPlus4W(PCPlus4W),
        .ALUResultW(ALUResultW),
        .RdW(RDW)
    );

    Writeback_Cycle Writeback(
        .clk(clk),
        .rst(rst),
        .ResultSrcW(ResultSrcW),
        .ReadDataW(ReadDataW),
        .ALUResultW(ALUResultW),
        .PCPlus4W(PCPlus4W),
        .ResultW(ResultW)
    );
    
    Hazard_Unit Hazard_Unit(
        .rst(rst),
        .RegWriteM(RegWriteM),
        .RegWriteW(RegWriteW),
        .RdW(RDW),
        .RdM(RdM),
        .Rs1E(Rs1E),
        .Rs2E(Rs2E),
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE)
    );
    
endmodule
