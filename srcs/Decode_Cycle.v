`timescale 1ns / 1ps

module Decode_Cycle(
    input clk, rst, RegWriteW,
    input [4:0] RDW,
    input [31:0] ResultW, InstrD, PCD, PCPlus4D,
    output RegWriteE, MemWriteE, BranchE, JumpE, ALUSrcE,
    output [1:0] ResultSrcE,
    output [2:0] ALUControlE,
    output [31:0] RD1E, RD2E, PCE, ImmExtE, PCPlus4E,
    output [4:0] RdE, Rs1E, Rs2E
    );
    
    wire BranchD, JumpD, MemWriteD, ALUSrcD, RegWriteD;
    wire [1:0] ImmSrcD, ResultSrcD;
    wire [2:0] ALUControlD;
    wire [31:0] RD1D, RD2D, ImmExtD;
    
    reg RegWriteD_reg, MemWriteD_reg, BranchD_reg, JumpD_reg, ALUSrcD_reg;
    reg [1:0] ResultSrcD_reg;
    reg [2:0] ALUControlD_reg;
    reg [31:0] RD1D_reg, RD2D_reg, PCD_reg, ImmExtD_reg, PCPlus4D_reg;
    reg [4:0] RdD, Rs1D, Rs2D;
    
    Control_Unit Control_Unit(
        .op(InstrD[6:0]),
        .funct7(InstrD[31:25]),
        .funct3(InstrD[14:12]),
        .z(),
        .PCSrc(),
        .branch(BranchD),
        .jump(JumpD),
        .ResultSrc(ResultSrcD),
        .MemWrite(MemWriteD),
        .ALUSrc(ALUSrcD),
        .ImmSrc(ImmSrcD),
        .RegWrite(RegWriteD),
        .ALUControl(ALUControlD)    
    );

    Register_File Register_File(
        .clk(clk),
        .rst(rst),
        .WE(RegWriteW),
        .A1(InstrD[19:15]),
        .A2(InstrD[24:20]),
        .A3(RDW),
        .WD(ResultW),
        .RD1(RD1D),
        .RD2(RD2D)
    );
    
    Sign_Extend Sign_Extend(
        .Inst(InstrD),
        .ImmSrc(ImmSrcD),
        .ImmExt(ImmExtD)
    );
    
    always @(posedge clk) begin
        if (rst) begin
            RegWriteD_reg <= 1'd0;
            ResultSrcD_reg <= 2'd00;
            MemWriteD_reg <= 1'd0;
            BranchD_reg <= 1'd0;
            JumpD_reg <= 1'd0;
            ALUSrcD_reg <= 1'd0;
            ALUControlD_reg <= 3'd0;
            RD1D_reg <= 32'd0;
            RD2D_reg <= 32'd0;
            PCD_reg <= 32'd0;
            ImmExtD_reg <= 32'd0;
            PCPlus4D_reg <= 32'd0;
            RdD <= 5'd0;
            Rs1D <= 5'd0;
            Rs2D <= 5'd0;
        end
        else begin
            RegWriteD_reg <= RegWriteD;
            ResultSrcD_reg <= ResultSrcD;
            MemWriteD_reg <= MemWriteD;
            BranchD_reg <= BranchD;
            JumpD_reg <= JumpD;
            ALUSrcD_reg <= ALUSrcD;
            ALUControlD_reg <= ALUControlD;
            RD1D_reg <= RD1D;
            RD2D_reg <= RD2D;
            PCD_reg <= PCD;
            ImmExtD_reg <= ImmExtD;
            PCPlus4D_reg <= PCPlus4D;
            RdD <= InstrD[11:7];
            Rs1D <= InstrD[19:15];
            Rs2D <= InstrD[24:20];
        end
    end
    
    assign RegWriteE = RegWriteD_reg;
    assign ResultSrcE = ResultSrcD_reg;
    assign MemWriteE = MemWriteD_reg;
    assign BranchE = BranchD_reg;
    assign JumpE = JumpD_reg;
    assign ALUSrcE = ALUSrcD_reg;
    assign ALUControlE = ALUControlD_reg;
    assign RD1E = RD1D_reg;
    assign RD2E = RD2D_reg;
    assign PCE = PCD_reg;
    assign ImmExtE = ImmExtD_reg;
    assign PCPlus4E = PCPlus4D_reg;
    assign RdE = RdD;
    assign Rs1E = Rs1D;
    assign Rs2E = Rs2D;
    
endmodule
