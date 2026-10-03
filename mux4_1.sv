// This module utilizes 2x1 muxes to make a singular 32x1 mux

`timescale 1ns/1ps

module mux4_1 (input logic  [3:0] in,
					 input logic  [1:0]  sel,
					 output logic out);
					 
	// wires of outputs of each mux stage
	logic [1:0]  lvl1;
	
	
	genvar i;
	
	generate 
		
		for (i = 0; i < 2; i++) begin : sel0
			mux2_1 m (.a(in[2*i+1]), .b(in[2*i]), .sel(sel[0]), .out(lvl1[i]));
		end
		
	endgenerate
	
	mux2_1 m (.a(lvl1[1]), .b(lvl1[0]), .sel(sel[1]), .out(out));

endmodule
