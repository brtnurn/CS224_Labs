`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.04.2024 16:40:27
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


module top(input  logic clk, reset,
           input logic btnC, btnD, btnU,
           output logic memwrite, regwrite, 
           output logic [6:0]seg,
           output logic dp,
           output logic [3:0] an
           ); // TOP MODULE YAP
             
    logic[31:0] aluout, wdm, rdw;         
    logic [31:0] pcF, instrF, instrD, ResultW;
    logic pcsrc, jump, stallF, stallD;
    logic [3:0] in3, in2, in1, in0;
    logic clkDeb, data1Deb, data2Deb, next;
    
    pulse_controller clkButton(clk, btnC, reset, clkDeb);
    pulse_controller data1Button(clk, btnD, reset, data1Deb);
    pulse_controller data2Button(clk, btnU, reset, data2Deb);

    display_controller display(clk, in3, in2, in1, in0, seg, dp, an);
                 
    always@(posedge clk) begin
        next <= 0;
        if(reset) begin
            next <= 0;
            in3 <= 4'b0000;
            in2 <= 4'b0000;
            in1 <= 4'b0000;
            in0 <= 4'b0000;
        end
        if(clkDeb) begin
            next <= 1;
        end
        else if(data1Deb) begin
            in3 <= aluout[15:12];
            in2 <= aluout[11:8];
            in1 <= aluout[7:4];
            in0 <= aluout[3:0];
        end
        else if(data2Deb) begin
            in3 <= wdm[15:12];
            in2 <= wdm[11:8];
            in1 <= wdm[7:4];
            in0 <= wdm[3:0];
        end  
    end
  
    mips my_mips(next, reset, pcF, instrF, instrD, memwrite, regwrite,
                 pcsrc, jump, aluout, ResultW, wdm, rdw, stallF, stallD);
                 
endmodule
    // Define pipes that exist in the PipelinedDatapath. 
// The pipe between Writeback (W) and Fetch (F), as well as Fetch (F) and Decode (D) is given to you.
// However, you can change them, if you want.
// Create the rest of the pipes where inputs follow the naming conventions in the book.


module PipeFtoD(input logic[31:0] instr, PcPlus4F,
                input logic EN, clk, reset,	CLR,	// StallD will be connected as this EN
                output logic[31:0] instrD, PcPlus4D);

    always_ff @(posedge clk, posedge reset) begin
        if(reset) begin
            instrD <= 0;
            PcPlus4D <= 0;
        end
        else if(EN) begin
            if(CLR) begin
                instrD <= 0;
                PcPlus4D <= 0;
            end
            else begin
                instrD <= instr;
                PcPlus4D <= PcPlus4F;
            end
        end
     end
                
endmodule

// Similarly, the pipe between Writeback (W) and Fetch (F) is given as follows.

module PipeWtoF(input logic[31:0] PC,
                input logic EN, clk, reset,		// StallF will be connected as this EN
                output logic[31:0] PCF);

    always_ff @(posedge clk, posedge reset) begin
        if(reset) begin
            PCF <= 0;
        end
//        else begin
        else if(EN) begin
            PCF <= PC;
        end
//        end
    end
                
endmodule

// *******************************************************************************
// Below, write the modules for the pipes PipeDtoE, PipeEtoM, PipeMtoW yourselves.
// Don't forget to connect Control signals in these pipes as well.
// *******************************************************************************


module PipeDtoE(input logic clk, CLR, reset,
                input logic RegWriteD, MemToRegD, MemWriteD,
                input logic [2:0] ALUControlD,
                input logic ALUSrcD, RegDstD,
                input logic [31:0] RD1, RD2,
                input logic [4:0] rsD, rtD, rdD,
                input logic [31:0] SignImmD,
                output logic RegWriteE, MemToRegE, MemWriteE,
                output logic [2:0] ALUControlE,
                output logic ALUSrcE, RegDstE,
                output logic [31:0] RD1E, RD2E,
                output logic [4:0] rsE, rtE, rdE,
                output logic [31:0] SignImmE
                );
                // to be filled 
        always_ff @(posedge clk, posedge reset)
            if(CLR | reset) begin
                RegWriteE <= 0;
                MemToRegE <= 0;
                MemWriteE <= 0;
                ALUControlE <= 0;
                ALUSrcE <= 0;
                RegDstE <= 0;
                RD1E <= 0;
                RD2E <= 0;
                rsE <= 0;
                rtE <= 0;
                rdE <= 0;
                SignImmE <= 0;
            end
            else begin
                RegWriteE <= RegWriteD;
                MemToRegE <= MemToRegD;
                MemWriteE <= MemWriteD;
                ALUControlE <= ALUControlD;
                ALUSrcE <= ALUSrcD;
                RegDstE <= RegDstD;
                RD1E <= RD1;
                RD2E <= RD2;
                rsE <= rsD;
                rtE <= rtD;
                rdE <= rdD;
                SignImmE <= SignImmD;
            end
endmodule

module PipeEtoM(input logic clk, reset,
                input logic RegWriteE, MemToRegE, MemWriteE,
                input logic [31:0] ALUOutE, WriteDataE,
                input logic [4:0] WriteRegE,
                output logic RegWriteM, MemToRegM, MemWriteM,
                output logic [31:0] ALUOutM, WriteDataM,
                output logic [4:0] WriteRegM
                );
		// to be filled
    always_ff @(posedge clk, posedge reset) begin
        if(reset) begin
            RegWriteM <= 0;
            MemToRegM <= 0;
            MemWriteM <= 0;
            ALUOutM <= 0;
            WriteDataM <= 0;
            WriteRegM <= 0;
        end
        else begin
            RegWriteM <= RegWriteE;
            MemToRegM <= MemToRegE;
            MemWriteM <= MemWriteE;
            ALUOutM <= ALUOutE;
            WriteDataM <= WriteDataE;
            WriteRegM <= WriteRegE;
        end
    end
endmodule

module PipeMtoW(input logic clk, reset,
                input logic RegWriteM, MemToRegM,
                input logic [31:0] ReadDataM, ALUOutM,
                input logic [4:0] WriteRegM,
                output logic RegWriteW, MemToRegW,
                output logic [31:0] ReadDataW, ALUOutW,
                output logic [4:0] WriteRegW
                );
		// to be filled 
    always_ff @(posedge clk, posedge reset) begin
        if(reset) begin
            RegWriteW <= 0;
            MemToRegW <= 0;
            ReadDataW <= 0;
            ALUOutW <= 0;
            WriteRegW <= 0;
        end
        else begin
            RegWriteW <= RegWriteM;
            MemToRegW <= MemToRegM;
            ReadDataW <= ReadDataM;
            ALUOutW <= ALUOutM;
            WriteRegW <= WriteRegM;
        end
    end               
endmodule



// *******************************************************************************
// End of the individual pipe definitions.
// ******************************************************************************

// *******************************************************************************
// Below is the definition of the datapath.
// The signature of the module is given. The datapath will include (not limited to) the following items:
//  (1) Adder that adds 4 to PC
//  (2) Shifter that shifts SignImmE to left by 2
//  (3) Sign extender and Register file
//  (4) PipeFtoD
//  (5) PipeDtoE and ALU
//  (5) Adder for PCBranchM
//  (6) PipeEtoM and Data Memory
//  (7) PipeMtoW
//  (8) Many muxes
//  (9) Hazard unit
//  ...?
// *******************************************************************************

module datapath (input  logic clk, reset,    
                 input  logic MemToRegD, ALUSrcD, RegDstD, RegWriteD, JumpD, BranchD,
		         input  logic [2:0]  ALUControlD,	         
		         output logic MemWriteD, PcSrcD,
		         output  logic [31:0] instrF, PCF, instrD, 
		         output logic [31:0] ALUOutE, WriteDataM, ReadDataW, ResultW,
		         output logic StallF, StallD
		         ); 

	// ********************************************************************
	// Here, define the wires that are needed inside this pipelined datapath module
	// ********************************************************************

	logic ForwardAD, ForwardBD,  FlushE;		// Wires for connecting Hazard Unit
	logic MemToRegW, RegWriteW;											// Add the rest of the wires whenever necessary.
    logic [31:0] PcPlus4D, JumpDsh, PC, PCmux, PcPlus4F;
    logic [31:0] PcBranchD, ALUOutW;
    logic [4:0] WriteRegW, rsD, rtD, rdD, rsE, rtE, rdE, WriteRegE, WriteRegM;
    logic [31:0] SignImmD, SignImmshD, SignImmE;
    logic [31:0] RD1E, RD2E, WriteDataE, ALUOutM, ReadDataM, SrcAE, SrcBE, RD1, RD2, RD1D, RD2D;
	logic equalD;
	logic RegWriteE, MemToRegE, MemWriteE, ALUSrcE, RegDstE;
	logic [2:0] ALUControlE;
	logic zero;
	logic RegWriteM, MemToRegM, MemWriteM, resD;
	logic [1:0] ForwardAE, ForwardBE;
	
	// ********************************************************************
	// Instantiate the required modules below in the order of the datapath flow.
	// ********************************************************************
	
  // Connections for the writeback stage and the fetch stage is written for you.
  // You can change them if you want.
    HazardUnit haz(JumpD, BranchD, RegWriteW, WriteRegE, WriteRegW, RegWriteM, MemToRegM, WriteRegM, RegWriteE, MemToRegE,
                   rsE, rtE, rsD, rtD, ForwardAE, ForwardBE, ForwardAD, ForwardBD, FlushE, StallD, StallF);

	PipeWtoF pWtoF(PC, ~StallF, clk, reset, PCF);							// Writeback stage pipe

    // Note that normally whole PCF should be driven to
    // instruction memory. However for our instruction 
    // memory this is not necessary
	imem im1(PCF[7:2], instrF);								        // Instantiated instruction memory

	PipeFtoD pFtoD(instrF, PcPlus4F, ~StallD, clk, reset, resD, instrD, PcPlus4D);			    // Fetch stage pipe


    assign rsD = instrD[25:21];
	assign rtD = instrD[20:16];
	assign rdD = instrD[15:11];
	
	regfile rf(clk, RegWriteW, rsD, rtD,
	            WriteRegW, ResultW, RD1, RD2);							            // Add the rest.
	
	
	
	signext se(instrD[15:0], SignImmD);
	sl2 immsh(SignImmD, SignImmshD);
	
	adder pcadder(SignImmshD, PcPlus4D, PcBranchD);
	
	mux2 #(32) rd1_mux(RD1, ALUOutM, ForwardAD, RD1D);
	mux2 #(32) rd2_mux(RD2, ALUOutM, ForwardBD, RD2D);
	
	assign equalD = (RD1D == RD2D) ? 1 : 0;
	assign PcSrcD = BranchD & equalD;
	assign resD = JumpD | PcSrcD;
	assign JumpDsh = {PcPlus4D[31:28], instrD[25:0], 2'b00};
	
	PipeDtoE pDtoE(clk, FlushE, reset,
	               RegWriteD, MemToRegD, MemWriteD, ALUControlD, ALUSrcD, RegDstD, RD1, RD2, rsD, rtD, rdD, SignImmD,
                   RegWriteE, MemToRegE, MemWriteE, ALUControlE, ALUSrcE, RegDstE, RD1E, RD2E, rsE, rtE, rdE, SignImmE);
             
    
    mux2 #(5) wr_mux(rtE, rdE, RegDstE, WriteRegE);
    mux4 #(32) rd1e_mux(RD1E, ResultW, ALUOutM, 32'b0, ForwardAE, SrcAE);
    mux4 #(32) rd2e_mux(RD2E, ResultW, ALUOutM, 32'b0, ForwardBE, WriteDataE);
    mux2 #(32) alu_mux(WriteDataE, SignImmE, ALUSrcE, SrcBE);
    alu alu_e(SrcAE, SrcBE, ALUControlE, ALUOutE, zero);
    
    PipeEtoM pEtoM(clk, reset, RegWriteE, MemToRegE, MemWriteE, ALUOutE, WriteDataE, WriteRegE,
                               RegWriteM, MemToRegM, MemWriteM, ALUOutM, WriteDataM, WriteRegM);
                   
    dmem dmem_m(clk, MemWriteM, ALUOutM, WriteDataM, ReadDataM);
    
    PipeMtoW pMtoW(clk, reset, RegWriteM, MemToRegM, ReadDataM, ALUOutM, WriteRegM,
                               RegWriteW, MemToRegW, ReadDataW, ALUOutW, WriteRegW);
                        
    mux2 #(32) result_mux(ALUOutW, ReadDataW, MemToRegW, ResultW);
    
    assign PcPlus4F = PCF + 4;
//    adder addpc(PCF, 32'b100, PcPlus4F);                                      // Here PCF is from fetch stage
  	mux2 #(32) pc_mux(PcPlus4F, PcBranchD, PcSrcD, PCmux);             // Here PcBranchD is from decode stage
  	mux2 #(32) jump_mux(PCmux, JumpDsh, JumpD, PC);
                        
    
                   

endmodule



// Hazard Unit with inputs and outputs named
// according to the convention that is followed on the book.

module HazardUnit(input logic JumpD, BranchD,
                input logic RegWriteW,
                input logic [4:0] WriteRegE, WriteRegW,
                input logic RegWriteM,MemToRegM,
                input logic [4:0] WriteRegM,
                input logic RegWriteE,MemToRegE,
                input logic [4:0] rsE,rtE,
                input logic [4:0] rsD,rtD,
                output logic [1:0] ForwardAE,ForwardBE,
                output logic ForwardAD, ForwardBD,
                output logic FlushE,StallD,StallF
                );
                
    logic lwstall, branchstall;
    always_comb begin
    
	// ********************************************************************
	// Here, write equations for the Hazard Logic.
	// If you have troubles, please study pages ~420-430 in your book.
	// ********************************************************************
        if ((rsE != 0) & (rsE == WriteRegM) & RegWriteM) begin
            ForwardAE <= 2'b10;
        end
        else if ((rsE != 0) & (rsE == WriteRegW) & RegWriteW) begin
            ForwardAE <= 2'b01;
        end
        else begin
            ForwardAE <= 2'b00;
        end
    // --------------------------------------------------------------------------
        if ((rtE != 0) & (rtE == WriteRegM) & RegWriteM) begin
            ForwardBE <= 2'b10;
        end
        else if ((rtE != 0) & (rtE == WriteRegW) & RegWriteW) begin
            ForwardBE <= 2'b01;
        end
        else begin
            ForwardBE <= 2'b00;
        end
    // --------------------------------------------------------------------------
        lwstall = ((rsD == rtE) | (rtD == rtE)) & MemToRegE;
        branchstall = (BranchD & RegWriteE & (WriteRegE == rsD | WriteRegE == rtD)) | (BranchD & MemToRegM & (WriteRegM == rsD | WriteRegM == rtD));

        StallF <= lwstall | branchstall;
        StallD <= lwstall | branchstall;
        FlushE <= lwstall | branchstall | JumpD;
        
    // --------------------------------------------------------------------------

        ForwardAD <= (rsD != 0) & (rsD == WriteRegM) & RegWriteM;
        ForwardBD <= (rtD != 0) & (rtD == WriteRegM) & RegWriteM;

    end
endmodule

module mips (input  logic        clk, reset,
             output logic[31:0]  pcF,
             output logic[31:0]  instrF, instrD,
             output logic        memwrite, regwrite, pcsrc, jump,
             output logic[31:0]  aluout, ResultW,
             output logic[31:0]  wdm, rdw,
             output logic        stallF, stallD);

    logic        memtoreg, zero, alusrc, regdst, branch;
    logic [2:0]  alucontrol;
    
    //assign instrOut = instr;

	// ********************************************************************
	// Below, instantiate a controller and a datapath with their new (if modified) signatures
	// and corresponding connections.
	// ********************************************************************
	
	controller c(instrD[31:26], instrD[5:0], memtoreg, memwrite, alusrc, regdst, regwrite, jump, alucontrol, branch);
    datapath dp(clk, reset, memtoreg, alusrc, regdst, regwrite, jump, branch, alucontrol, memwrite, pcsrc,
                instrF, pcF, instrD, aluout, wdm, rdw, ResultW, stallF, stallD);
    

endmodule


// External instruction memory used by MIPS single-cycle
// processor. It models instruction memory as a stored-program 
// ROM, with address as input, and instruction as output
// Modify it to test your own programs.

module imem ( input logic [5:0] addr, output logic [31:0] instr);

// imem is modeled as a lookup table, a stored-program byte-addressable ROM
	always_comb
	   case ({addr,2'b00})		   	// word-aligned fetch
//
// 	***************************************************************************
//	Here, you can paste your own test cases that you prepared for the part 1-g.
//	Below is a program from the single-cycle lab.
//	***************************************************************************
//
//		address		instruction
//		-------		-----------
		8'h00: instr = 32'h20020005;  	// disassemble, by hand 
		8'h04: instr = 32'h2003000c;  	// or with a program,
		8'h08: instr = 32'h2067fff7;  	// to find out what
		8'h0c: instr = 32'h00e22025;  	// this program does!
		8'h10: instr = 32'h00642824;
		8'h14: instr = 32'h00a42820;
		8'h18: instr = 32'h10a7000a;
		8'h1c: instr = 32'h0064202a;
		8'h20: instr = 32'h10800001;
		8'h24: instr = 32'h20050000;
		8'h28: instr = 32'h00e2202a;
		8'h2c: instr = 32'h00853820;
		8'h30: instr = 32'h00e23822;
		8'h34: instr = 32'hac670044;
		8'h38: instr = 32'h8c020050;
		8'h3c: instr = 32'h08000011;
		8'h40: instr = 32'h20020001;
		8'h44: instr = 32'hac020054;
		8'h48: instr = 32'h08000012;	// j 48, so it will loop here

//		8'h00: instr = 32'h20080005;  	// Test code for compute-use hazards
//		8'h04: instr = 32'h21090007;
//		8'h08: instr = 32'h210a0002;
//		8'h0c: instr = 32'h012a5025;
//		8'h10: instr = 32'h01498024;
//		8'h14: instr = 32'h01108820;
//		8'h18: instr = 32'h0151902a;
//		8'h1c: instr = 32'h02318820;
//	    8'h20: instr = 32'h02329822;
//		8'h24: instr = 32'had330074;
//		8'h28: instr = 32'h8C020080;
		
//		8'h00: instr = 32'h20080005;  	// Test code for load-use hazard
//		8'h04: instr = 32'haC080060;
//		8'h08: instr = 32'h8C090060;
//		8'h0c: instr = 32'h212a0004;
//		8'h10: instr = 32'h212b0003;
//		8'h14: instr = 32'h8d6b0058;
//		8'h18: instr = 32'h014b5022;
//		8'h1c: instr = 32'hac0a0070;
//		8'h20: instr = 32'h8C080070;
//		8'h24: instr = 32'h8d09006c;
//		8'h28: instr = 32'h01094820;
		
//		8'h00: instr = 32'h20080005;  	// Test code for branch hazards
//		8'h04: instr = 32'h20090003;
//		8'h08: instr = 32'h11090002;
//		8'h0c: instr = 32'h01285020;
//		8'h10: instr = 32'h01094022;
//		8'h14: instr = 32'h2129FFFF;
//		8'h18: instr = 32'h11280002;
//		8'h1c: instr = 32'hAC0A0050;
//	    8'h20: instr = 32'h01284025;
//		8'h24: instr = 32'h0128482A;
//		8'h28: instr = 32'h11200002;
//		8'h2c: instr = 32'h8C0B0050;
//		8'h30: instr = 32'h01284024;
//		8'h34: instr = 32'h1108FFFF;    // So it loops here
	     default:  instr = {32{1'bx}};	// unknown address
	   endcase
endmodule


// 	***************************************************************************
//	Below are the modules that you shouldn't need to modify at all..
//	***************************************************************************

module controller(input  logic[5:0] op, funct,
                  output logic     memtoreg, memwrite,
                  output logic     alusrc,
                  output logic     regdst, regwrite,
                  output logic     jump,
                  output logic[2:0] alucontrol,
                  output logic branch);

   logic [1:0] aluop;

   maindec md (op, memtoreg, memwrite, branch, alusrc, regdst, regwrite, 
         jump, aluop);

   aludec  ad (funct, aluop, alucontrol);

endmodule

// External data memory used by MIPS single-cycle processor

module dmem (input  logic        clk, we,
             input  logic[31:0]  a, wd,
             output logic[31:0]  rd);

   logic  [31:0] RAM[63:0];
  
   assign rd = RAM[a[31:2]];    // word-aligned  read (for lw)

   always_ff @(posedge clk)
     if (we)
       RAM[a[31:2]] <= wd;      // word-aligned write (for sw)

endmodule

module maindec (input logic[5:0] op, 
	              output logic memtoreg, memwrite, branch,
	              output logic alusrc, regdst, regwrite, jump,
	              output logic[1:0] aluop );
   logic [8:0] controls;

   assign {regwrite, regdst, alusrc, branch, memwrite,
                memtoreg,  aluop, jump} = controls;

  always_comb
    case(op)
      6'b000000: controls <= 9'b110000100; // R-type
      6'b100011: controls <= 9'b101001000; // LW
      6'b101011: controls <= 9'b001010000; // SW
      6'b000100: controls <= 9'b000100010; // BEQ
      6'b001000: controls <= 9'b101000000; // ADDI
      6'b000010: controls <= 9'b000000001; // J
      default:   controls <= 9'bxxxxxxxxx; // illegal op
    endcase
endmodule

module aludec (input    logic[5:0] funct,
               input    logic[1:0] aluop,
               output   logic[2:0] alucontrol);
  always_comb
    case(aluop)
      2'b00: alucontrol  = 3'b010;  // add  (for lw/sw/addi)
      2'b01: alucontrol  = 3'b110;  // sub   (for beq)
      default: case(funct)          // R-TYPE instructions
          6'b100000: alucontrol  = 3'b010; // ADD
          6'b100010: alucontrol  = 3'b110; // SUB
          6'b100100: alucontrol  = 3'b000; // AND
          6'b100101: alucontrol  = 3'b001; // OR
          6'b101010: alucontrol  = 3'b111; // SLT
          default:   alucontrol  = 3'bxxx; // ???
        endcase
    endcase
endmodule

module regfile (input    logic clk, we3, 
                input    logic[4:0]  ra1, ra2, wa3, 
                input    logic[31:0] wd3, 
                output   logic[31:0] rd1, rd2);

  logic [31:0] rf [31:0];

  // three ported register file: read two ports combinationally
  // write third port on rising edge of clock. Register0 hardwired to 0.

  always_ff @(negedge clk)
     if (we3) 
         rf [wa3] <= wd3;	

  assign rd1 = (ra1 != 0) ? rf [ra1] : 0;
  assign rd2 = (ra2 != 0) ? rf [ra2] : 0;

endmodule

module alu(input  logic [31:0] a, b, 
           input  logic [2:0]  alucont, 
           output logic [31:0] result,
           output logic zero);
    
    always_comb
        case(alucont)
            3'b010: result = a + b;
            3'b110: result = a - b;
            3'b000: result = a & b;
            3'b001: result = a | b;
            3'b111: result = (a < b) ? 1 : 0;
            default: result = {32{1'bx}};
        endcase
    
    assign zero = (result == 0) ? 1'b1 : 1'b0;
    
endmodule

module adder (input  logic[31:0] a, b,
              output logic[31:0] y);
     
     assign y = a + b;
endmodule

module sl2 (input  logic[31:0] a,
            output logic[31:0] y);
     
     assign y = {a[29:0], 2'b00}; // shifts left by 2
endmodule

module signext (input  logic[15:0] a,
                output logic[31:0] y);
              
  assign y = {{16{a[15]}}, a};    // sign-extends 16-bit a
endmodule

// parameterized register
module flopr #(parameter WIDTH = 8)
              (input logic clk, reset, 
	       input logic[WIDTH-1:0] d, 
               output logic[WIDTH-1:0] q);

  always_ff@(posedge clk, posedge reset)
    if (reset) q <= 0; 
    else       q <= d;
endmodule


// paramaterized 2-to-1 MUX
module mux2 #(parameter WIDTH = 8)
             (input  logic[WIDTH-1:0] d0, d1,  
              input  logic s, 
              output logic[WIDTH-1:0] y);
  
   assign y = s ? d1 : d0; 
endmodule

module mux4 #(parameter WIDTH = 8)
             (input  logic[WIDTH-1:0] d0, d1, d2, d3,
              input  logic [1:0] s, 
              output logic[WIDTH-1:0] y);
  
   assign y = s[1] ? (s[0] ? d3 : d2) : (s[0] ? d1 : d0); 
endmodule

////////////////////////////////////////////////////////
//  
//  This module puts 4 hexadecimal values (from O to F) on the 4-digit 7-segment display unit
//  
//  Inputs/Outputs:  
//  clk: the system clock on the BASYS3 board
//  in3, in2, in1, in0: the input hexadecimal values. in3(left), in2, in1, in0(right)         
//  seg: the signals going to the segments of a digit.
//       seg[6] is CA for the a segment, seg[5] is CB for the b segment, etc
//  an:  anode, 4 bit enable signal, one bit for each digit
//       an[3] is the left-most digit, an[2] is the second-left-most, etc  
//  dp:  digital point
//  
//  Usage for CS224 Lab4-5: 
//  - Give the system clock of BASYS3 and the hexadecimal values you want to display as inputs.
//  - Send outputs to 7-segment display of BASYS3, using the .XDC file
//
//  Note: the an, seg and dp outputs are active-low, for the BASYS3 board
//
//  For correct connections, carefully plan what should be in the .XDC file
//   
////////////////////////////////////////////////////////

module display_controller(
    input clk,
    input [3:0] in3, in2, in1, in0,
    output [6:0]seg, logic dp,
    output [3:0] an
    );
    
    localparam N = 18;
    
    logic [N-1:0] count = {N{1'b0}};
    always@ (posedge clk)
    count <= count + 1;
    
    logic [4:0]digit_val;
    
    logic [3:0]digit_en;
    always@ (*)
    
    begin
    digit_en = 4'b1111;
    digit_val = in0;
    
    case(count[N-1:N-2])
    
    2'b00 :	//select first 7Seg.
    
    begin
    digit_val = {1'b0, in0};
    digit_en = 4'b1110;
    end
    
    2'b01:	//select second 7Seg.
    
    begin
    digit_val = {1'b0, in1};
    digit_en = 4'b1101;
    end
    
    2'b10:	//select third 7Seg.
    
    begin
    digit_val = {1'b0, in2};
    digit_en = 4'b1011;
    end
    
    2'b11:	//select forth 7Seg.
    
    begin
    digit_val = {1'b0, in3};
    digit_en = 4'b0111;
    end
    endcase
    end
    
    //Convert digit number to LED vector. LEDs are active low.
    
    logic [6:0] sseg_LEDs;
    always @(*)
    begin
    sseg_LEDs = 7'b1111111; //default
    case( digit_val)
    5'd0 : sseg_LEDs = 7'b1000000; //to display 0
    5'd1 : sseg_LEDs = 7'b1111001; //to display 1
    5'd2 : sseg_LEDs = 7'b0100100; //to display 2
    5'd3 : sseg_LEDs = 7'b0110000; //to display 3
    5'd4 : sseg_LEDs = 7'b0011001; //to display 4
    5'd5 : sseg_LEDs = 7'b0010010; //to display 5
    5'd6 : sseg_LEDs = 7'b0000010; //to display 6
    5'd7 : sseg_LEDs = 7'b1111000; //to display 7
    5'd8 : sseg_LEDs = 7'b0000000; //to display 8
    5'd9 : sseg_LEDs = 7'b0010000; //to display 9
    5'd10: sseg_LEDs = 7'b0001000; //to display a
    5'd11: sseg_LEDs = 7'b0000011; //to display b
    5'd12: sseg_LEDs = 7'b1000110; //to display c
    5'd13: sseg_LEDs = 7'b0100001; //to display d
    5'd14: sseg_LEDs = 7'b0000110; //to display e
    5'd15: sseg_LEDs = 7'b0001110; //to display f
    5'd16: sseg_LEDs = 7'b0110111; //to display "="
    default : sseg_LEDs = 7'b0111111; //dash 
    endcase
    end
    
    assign an = digit_en;
    
    assign seg = sseg_LEDs;
    assign dp = 1'b1; //turn dp off

endmodule
/////////////////////////////////////////////////////////////////////////////////
// 
//   This module takes a slide switch or pushbutton input and 
//   does the following:
//     --debounces it (ignoring any addtional changes for ~40 milliseconds)
//     --synchronizes it with the clock edges
//     --produces just one pulse, lasting for one clock period
//   
//   Note that the 40 millisecond debounce time = 2000000 cycles of 
//   50MHz clock (which has 20 nsec period)
//   
//   Inputs/Outputs:
//   sw_input: the signal coming from the slide switch or pushbutton
//   CLK: the system clock on the BASYS3 board
//   clear: resets the pulse controller
//   clk_pulse: the synchronized debounced single-pulse output
//
//   Usage for CS224 Lab4-5: 
//   - Give the BASYS3 clock and the push button signal as inputs
//   - You don't need to clear the controller
//   - Send the output pulse to your top module
//   
//   For correct connections, carefully plan what should be in the .XDC file
//
//////////////////////////////////////////////////////////////////////////////////

module pulse_controller(
	input CLK, sw_input, clear,
	output reg clk_pulse );

	 reg [2:0] state, nextstate;
	 reg [27:0] CNT; 
	 wire cnt_zero; 

	always @ (posedge CLK, posedge clear)
	   if(clear)
	    	state <=3'b000;
	   else
	    	state <= nextstate;

	always @ (sw_input, state, cnt_zero)
          case (state)
             3'b000: begin if (sw_input) nextstate = 3'b001; 
                           else nextstate = 3'b000; clk_pulse = 0; end	     
             3'b001: begin nextstate = 3'b010; clk_pulse = 1; end
             3'b010: begin if (cnt_zero) nextstate = 3'b011; 
                           else nextstate = 3'b010; clk_pulse = 1; end
             3'b011: begin if (sw_input) nextstate = 3'b011; 
                           else nextstate = 3'b100; clk_pulse = 0; end
             3'b100: begin if (cnt_zero) nextstate = 3'b000; 
                           else nextstate = 3'b100; clk_pulse = 0; end
            default: begin nextstate = 3'b000; clk_pulse = 0; end
          endcase

	always @(posedge CLK)
	   case(state)
		3'b001: CNT <= 100000000;
		3'b010: CNT <= CNT-1;
		3'b011: CNT <= 100000000;
		3'b100: CNT <= CNT-1;
	   endcase

//  reduction operator |CNT gives the OR of all bits in the CNT register	
	assign cnt_zero = ~|CNT;

endmodule