`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.03.2024 11:14:13
// Design Name: 
// Module Name: alu
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


module alu(input logic [31:0] a, b, 
           input logic [2:0] alucont, 
           output logic [31:0] result, 
           output logic zero
           );
    always_comb begin
        case (alucont)
            3'b000: result = a & b;
            3'b001: result = a | b;
            3'b010: result = a + b;
            3'b011: result = 32'bx;
            3'b100: result = a & ~b;
            3'b101: result = a | ~b;
            3'b110: result = a - b;
            3'b111: result = (a < b) ? 32'b1 : 32'b0;
            default: result = 32'b0;
        endcase
        zero = (result == 32'b0) ? 1'b1 : 1'b0;
    end  
endmodule
