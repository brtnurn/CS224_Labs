`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.03.2024 17:22:29
// Design Name: 
// Module Name: my_mips
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


module my_mips(input clk, reset,
	           output  logic       memwrite, 
               input   btnD, btnL, btnR,
               output [6:0]seg, logic dp,
               output [3:0] an
               );

    logic btnDdeb, btnLdeb, btnRdeb;
    logic [3:0] in3, in2, in1, in0;
    logic[31:0] instr, pc;
    logic[31:0] writedata, dataadr; //data in rt register, alu result
	logic[31:0] readdata;           //data in alu result addr
	logic next;
    
    pulse_controller clkButton(clk, btnD, reset, btnDdeb);
    pulse_controller wdButton(clk, btnL, reset, btnLdeb);
    pulse_controller daButton(clk, btnR, reset, btnRdeb);
    
    display_controller display(clk, in3, in2, in1, in0, seg, dp, an);
    
    always@(posedge clk) begin
        next <= 0;
        if(reset) begin
            {in3, in2, in1, in0} <= 4'b0000;
            next <= 0;
        end
        if(btnDdeb) begin
            next <= 1;
        end
        else if(btnLdeb) begin
            in3 <= writedata[15:12];
            in2 <= writedata[11:8];
            in1 <= writedata[7:4];
            in0 <= writedata[3:0];
        end
        else if(btnRdeb) begin
            in3 <= dataadr[15:12];
            in2 <= dataadr[11:8];
            in1 <= dataadr[7:4];
            in0 <= dataadr[3:0];
        end
    end

    top my_top(.clk(next), .reset(reset), .writedata(writedata), .dataadr(dataadr), 
               .readdata(readdata), .memwrite(memwrite), .instr(instr), .pc(pc));

endmodule
