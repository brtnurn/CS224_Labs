`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.03.2024 11:53:15
// Design Name: 
// Module Name: maindec
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


module maindec(input logic[5:0] op, 
	           output logic memtoreg, memwrite, branch,
	           output logic alusrc, regdst, regwrite, jump,
	           output logic[1:0] aluop );
               logic [8:0] controls;

   assign {regwrite, regdst, alusrc, branch, memwrite, memtoreg,  aluop, jump} = controls;

  always_comb
    case(op)
      6'b000000: controls <= 9'b110000100; // R-type
      6'b100011: controls <= 9'b101001000; // LW
      6'b101011: controls <= 9'b001010000; // SW
      6'b000100: controls <= 9'b000100010; // BEQ
      6'b001000: controls <= 9'b101000000; // ADDI
      6'b000010: controls <= 9'b000000001; // J
      6'b001010: controls <= 9'b101000110; // SLTI
      6'b000110: controls <= 9'b001000001; // JRI
      default:   controls <= 9'bxxxxxxxxx; // illegal op
    endcase
endmodule
