// This module utilizes 2x1 muxes to make a singular 32x1 mux

`timescale 1ns/1ps

module mux32_1 (input logic  [31:0] in,
					 input logic  [4:0]  sel,
					 output logic out);
					 
	// wires of outputs of each mux stage

	logic [15:0] lvl1;
	logic [7:0]  lvl2;
	logic [3:0]  lvl3;
	logic [1:0]  lvl4;
	
	
	genvar i;
	
	generate 
		
		// generates a 2x1 mux for all inputs
		for (i = 0; i < 16; i++) begin : sel0
			mux2_1 m (.a(in[2*i+1]), .b(in[2*i]), .sel(sel[0]), .out(lvl1[i]));
		end
		
		for (i = 0; i < 8; i++) begin : sel1
			mux2_1 m (.a(lvl1[2*i+1]), .b(lvl1[2*i]), .sel(sel[1]), .out(lvl2[i]));
		end
		
		for (i = 0; i < 4; i++) begin : sel2
			mux2_1 m (.a(lvl2[2*i+1]), .b(lvl2[2*i]), .sel(sel[2]), .out(lvl3[i]));
		end
		
		for (i = 0; i < 2; i++) begin : sel3
			mux2_1 m (.a(lvl3[2*i+1]), .b(lvl3[2*i]), .sel(sel[3]), .out(lvl4[i]));
		end
		
	endgenerate
	
	mux2_1 m (.a(lvl4[1]), .b(lvl4[0]), .sel(sel[4]), .out(out));

endmodule
