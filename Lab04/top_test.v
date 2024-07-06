`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.03.2024 12:16:06
// Design Name: 
// Module Name: top_test
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_test();
    reg clk, reset;
    wire[31:0] instr, pc;
    wire[31:0] writedata, dataadr, readdata;
    wire memwrite;
    
    top top1(.clk(clk), .reset(reset), .writedata(writedata), 
             .dataadr(dataadr), .readdata(readdata), 
             .memwrite(memwrite), .instr(instr), .pc(pc));
                
    always #5 clk = ~clk;

    initial begin
        clk = 0; reset = 1;
        #10;
        reset = 0;
        #100;
    end       
endmodule
