`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.03.2024 12:13:05
// Design Name: 
// Module Name: top
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


module top(input   logic 	 clk, reset,            
	       output  logic[31:0] writedata, dataadr, //data in rt register, alu result
	       output  logic[31:0] readdata,           //data in alu result addr
	       output  logic       memwrite,           //write enable
	       output logic[31:0] instr, pc);    

   // instantiate processor and memories  
   mips mips (clk, reset, pc, instr, memwrite, dataadr, writedata, readdata);  
   imem imem (pc[7:0], instr);  
   dmem dmem (clk, memwrite, dataadr, writedata, readdata);
endmodule
