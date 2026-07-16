`timescale 1ns / 1ps

module ALU(
    input [31:0] A,B,
    input [2:0] ALUControl,
    output[31:0] Result,slt,
    output Z,N,C,V //Zero, Negative, Carry, Overflow
    );
    wire [31:0] sum;
    wire cout;
    wire [31:0] mux1;
    wire [31:0] A_and_B;
    wire [31:0] A_or_B;
    wire notALUControl;
    assign A_and_B = A & B;
    assign A_or_B = A | B;
    assign notALUControl = (~ALUControl[1]);
    assign mux1 = (ALUControl[0] == 1'b0) ? B : (~B);
    assign {cout,sum} = A + mux1 + ALUControl[0];
    assign slt = {31'b0000000000000000000000000000000, sum[31]};
    assign C = cout & notALUControl;
    assign V = (sum[31] ^ A[31]) & (~(ALUControl[0] ^ A[31] ^ B[31])) & ALUControl[1];
    assign Result = (ALUControl == 3'b000) ? sum : (ALUControl == 3'b001) ? sum : (ALUControl == 3'b010) ? A_and_B : (ALUControl == 3'b011) ? A_or_B : (ALUControl == 3'b101) ? slt : 32'h00000000;
    assign Z = ~(|Result);
    assign N = Result[31];
endmodule
