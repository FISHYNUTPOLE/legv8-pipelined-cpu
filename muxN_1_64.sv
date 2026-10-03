`timescale 1ns/1ps

module muxN_1_64 #(parameter N=32) (input  logic [N-1:0][63:0] in,
				   					 input  logic [$clog2(N):0] sel,
				   					 output logic [63:0] out);






	genvar i, j;
	generate
	
		// outer loop instantiates the 32x1 muxes while the inner loop hooks up 
		// the mux inputs
		for (i = 0; i < 64; i++) begin : muxes
		
			logic [N-1:0] col;
		
			for (j = 0; j < N; j++) begin : wiring
				assign col[j] = in[j][i];
			
			end
			
			
		
			muxN_1 m (.in(col), .sel(sel), .out(out[i]));
		
			
		end
	
	
	endgenerate



endmodule
