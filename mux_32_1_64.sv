`timescale 1ns/1ps

module mux32_1_64 (input  logic [31:0][63:0] in,
						 input  logic [4:0] sel,
						 output logic [63:0] out);






	genvar i, j;
	generate
	
		// outer loop instantiates the 32x1 muxes while the inner loop hooks up 
		// the mux inputs
		for (i = 0; i < 64; i++) begin : muxes
		
			logic [31:0] col;
		
			for (j = 0; j < 32; j++) begin : wiring
				assign col[j] = in[j][i];
			
			end
			
			
		
			mux32_1 m (.in(col), .sel(sel), .out(out[i]));
		
			
		end
	
	
	endgenerate



endmodule
