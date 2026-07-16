`timescale 1ns / 1ps

module Sign_Extend(
    input [31:0] Inst,
    input [1:0] ImmSrc,
    output reg [31:0] ImmExt
    );
    
    always @(*) begin
        case (ImmSrc)
            2'b00: ImmExt = {{20{Inst[31]}}, Inst[31:20]}; // I-type
            2'b01: ImmExt = {{20{Inst[31]}}, Inst[31:25], Inst[11:7]}; // S-Type
            2'b10: ImmExt = {{19{Inst[31]}}, Inst[31], Inst[7], Inst[30:25], Inst[11:8], 1'b0}; // B-Type (BEQ)
            default: ImmExt = 32'b0;
        endcase
    end     
endmodule
