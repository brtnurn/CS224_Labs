`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.03.2024 11:18:59
// Design Name: 
// Module Name: alu_test
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


module alu_test(

    );
    reg [31:0] a;
    reg [31:0] b;
    reg [2:0] alucont;
    wire [31:0] result;
    wire zero;

    alu alu1(.a(a), .b(b), .alucont(alucont), .result(result), .zero(zero));

    initial begin
        a = 32'd15;
        b = 32'd10;
        #10;
        alucont = 3'b010; #10; //add
        alucont = 3'b110; #10; //sub
        alucont = 3'b000; #10; //and
        alucont = 3'b001; #10; //or
        alucont = 3'b111; #10; //slt
        #10;
        $stop;
    end
endmodule
