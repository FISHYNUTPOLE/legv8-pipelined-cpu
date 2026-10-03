// This module utilizes 2x1 muxes to make a singular 8x1 mux

`timescale 1ns/1ps

module mux8_1 (input logic  [7:0] in,
					 input logic  [2:0]  sel,
					 output logic out);
					 
	// wires of outputs of each mux stage

	logic [3:0]  lvl1;
	logic [1:0]  lvl2;
	
	
	genvar i;
	
	generate 
		
		// generates a 2x1 mux for all inputs
		
		for (i = 0; i < 4; i++) begin : sel2
			mux2_1 m (.a(in[2*i+1]), .b(in[2*i]), .sel(sel[0]), .out(lvl1[i]));
		end
		
		for (i = 0; i < 2; i++) begin : sel3
			mux2_1 m (.a(lvl1[2*i+1]), .b(lvl1[2*i]), .sel(sel[1]), .out(lvl2[i]));
		end
		
	endgenerate
	
	mux2_1 m (.a(lvl2[1]), .b(lvl2[0]), .sel(sel[2]), .out(out));

endmodule
