`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.03.2024 12:03:18
// Design Name: 
// Module Name: imem
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


module imem(input logic [7:0] addr, 
            output logic [31:0] instr);

// imem is modeled as a lookup table, a stored-program byte-addressable ROM
	always_comb
	   case (addr)		   	// word-aligned fetch
            //		address		instruction
            //		-------		-----------
            8'h00: instr = 32'h20040020;    //ADDI $a0 $zero 0x0020
            8'h04: instr = 32'hac040050;    
            8'h08: instr = 32'h1880fff0;
            8'h0c: instr = 32'hac000000;
            8'h10: instr = 32'h8c050050;
            8'h14: instr = 32'h28b00030;    //slti $s0 $a1 0x0030
            8'h18: instr = 32'h22110001;    //addi $s1, $s0, 0x0001

//            8'h00: instr = 32'h20020005;  	// disassemble, by hand 
//            8'h04: instr = 32'h2003000c;  	// or with a program,
//            8'h08: instr = 32'h2067fff7;  	// to find out what
//            8'h0c: instr = 32'h00e22025;  	// this program does!
//            8'h10: instr = 32'h00642824;
//            8'h14: instr = 32'h00a42820;
//            8'h18: instr = 32'h10a7000a;
//            8'h1c: instr = 32'h0064202a;
//            8'h20: instr = 32'h10800001;
//            8'h24: instr = 32'h20050000;
//            8'h28: instr = 32'h00e2202a;
//            8'h2c: instr = 32'h00853820;
//            8'h30: instr = 32'h00e23822;
//            8'h34: instr = 32'hac670044;
//            8'h38: instr = 32'h8c020050;
//            8'h3c: instr = 32'h08000011;
//            8'h40: instr = 32'h20020001;
//            8'h44: instr = 32'hac020054;
//            8'h48: instr = 32'h08000012;	// j 48, so it will loop here
            
            default:  instr = {32{1'bx}};	// unknown address
	   endcase

endmodule
