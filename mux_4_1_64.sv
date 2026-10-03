`timescale 1ns/1ps

module mux4_1_64 (input  logic [3:0][63:0] in,
				  input  logic [1:0] sel,
				  output logic [63:0] out);






	genvar i, j;
	generate
	
		// outer loop instantiates the 4x1 muxes while the inner loop hooks up 
		// the mux inputs
		for (i = 0; i < 64; i++) begin : muxes
		
			logic [3:0] col;
		
			for (j = 0; j < 4; j++) begin : wiring
				assign col[j] = in[j][i];
			
			end
			
			
		
			mux4_1 m (.in(col), .sel(sel), .out(out[i]));
		
			
		end
	
	
	endgenerate



endmodule
