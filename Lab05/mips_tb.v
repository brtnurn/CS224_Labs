`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.04.2024 22:02:40
// Design Name: 
// Module Name: mips_tb
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


module mips_tb();

    reg clk, reset;
    wire [31:0] instrF, instrD;
    wire [31:0] pcF, aluout, resultW, wdm, rdw;
    wire memwrite, regwrite, pcsrc, jump, stallF, stallD;
    
    mips uut(clk, reset, pcF, instrF, instrD, memwrite, regwrite, pcsrc, jump, aluout, resultW, wdm, rdw, stallF, stallD);
    
    initial begin
        clk= 0;
        forever #5 clk= ~clk;
    end

    initial begin
        reset = 1;
        #10;
        reset = 0;
        #300;
        $stop;
    end
    
endmodule
