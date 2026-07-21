`timescale 1ns / 1ps

module tb_Pipeline();

    reg clk;
    reg rst;
    
    Pipelined_Top uut (
        .clk(clk),
        .rst(rst)
    );
    
    always #5 clk = ~clk;
    
    initial begin
    
        clk = 0;
        rst = 1;
        
        uut.Memory.Data_Memory.mem[0] = 32'd15;
        uut.Memory.Data_Memory.mem[1] = 32'd25;
        uut.Memory.Data_Memory.mem[2] = 32'd10;
        uut.Memory.Data_Memory.mem[3] = 32'd0;
        uut.Memory.Data_Memory.mem[4] = 32'd0;
        uut.Memory.Data_Memory.mem[5] = 32'd0;
        uut.Memory.Data_Memory.mem[6] = 32'd0;
        uut.Memory.Data_Memory.mem[7] = 32'd0;
        uut.Memory.Data_Memory.mem[8] = 32'd0;
        uut.Memory.Data_Memory.mem[9] = 32'd0;
        
        #10;
        rst = 0;
        
        #400;
        
        $display("x4 (ADD): %0d \t(Expected: 40)", uut.Decode.Register_File.Register[4]);
        $display("x5 (SUB): %0d \t(Expected: 10)", uut.Decode.Register_File.Register[5]);
        $display("x6 (AND): %0d \t(Expected: 10)", uut.Decode.Register_File.Register[6]);
        $display("x7 (OR): %0d \t(Expected: 31)", uut.Decode.Register_File.Register[7]);
        $display("x8 (SLT): %0d \t(Expected: 0)", uut.Decode.Register_File.Register[8]);
        $display("x9 (SLT): %0d \t(Expected: 1)", uut.Decode.Register_File.Register[9]);
        $display("x10 (JAL): %0d \t(Expected: 72)", uut.Decode.Register_File.Register[10]);
        
        $display("mem[3] (sw ADD): %0d \t(Expected: 40)", uut.Memory.Data_Memory.mem[3]);
        $display("mem[4] (sw AND): %0d \t(Expected: 10)", uut.Memory.Data_Memory.mem[4]);
        $display("mem[5] (BEQ): %0d \t(Expected: 0)", uut.Memory.Data_Memory.mem[5]);
        $display("mem[6] (sw OR): %0d \t(Expected: 31)", uut.Memory.Data_Memory.mem[6]);
        $display("mem[7] (JAL): %0d \t(Expected: 0)", uut.Memory.Data_Memory.mem[7]);
        $display("mem[8] (JAL): %0d \t(Expected: 0)", uut.Memory.Data_Memory.mem[8]);
        $display("mem[9] (sw JAL): %0d \t(Expected: 72)", uut.Memory.Data_Memory.mem[9]);
        
        $finish;
    end

endmodule
