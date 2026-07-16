`timescale 1ns / 1ps

module Hazard_Unit(
    input rst,
    input RegWriteM,RegWriteW,
    input [4:0] RdW, RdM,
    input [4:0] Rs1E, Rs2E,
    output [1:0] ForwardAE, ForwardBE
    );
    
    assign ForwardAE = (rst == 1'b1) ? 2'b00 : (RegWriteM && (RdM != 0) && (RdM == Rs1E)) ? 2'b10 : (RegWriteW && (RdW != 0) && (RdW == Rs1E)) ? 2'b01 : 2'b00;
    assign ForwardBE = (rst == 1'b1) ? 2'b00 : (RegWriteM && (RdM != 0) && (RdM == Rs2E)) ? 2'b10 : (RegWriteW && (RdW != 0) && (RdW == Rs2E)) ? 2'b01 : 2'b00;
    
endmodule
