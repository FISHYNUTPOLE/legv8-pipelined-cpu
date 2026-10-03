`timescale 1ns/1ps

module regfile (input logic clk, reset, RegWrite,
					 input logic [4:0] ReadRegister1, ReadRegister2, WriteRegister,
					 input logic [63:0] WriteData,
					 output logic [63:0] ReadData1, ReadData2);

	// 32 enable bits, one connected to each word
	logic [31:0] 		 en;
	
	// 32, 64 bit outputs 
	logic [31:0][63:0] regOut;
	
	
	
	// enable decoder used outputing 
	decoder5_32 decoder (.addr(WriteRegister), .en(RegWrite), .out(en));
	
	
	// generate 32, 64 bit registers for storage
	genvar i;
	generate
	
		for (i = 0; i < 31; i++) begin : regs
			registerN r (.clk, .reset, .en(en[i]), .d(WriteData), .q(regOut[i]));
			
			
		end
	
	endgenerate
	
	// Output of addr 31 should always be 0 and cannot be modified
	assign regOut[31] = 64'd0;
	
	
	// muxes for read ports
	mux32_1_64 m1 (.in(regOut), .sel(ReadRegister1), .out(ReadData1));
	mux32_1_64 m2 (.in(regOut), .sel(ReadRegister2), .out(ReadData2));


endmodule
