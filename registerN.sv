// This module instantiates N enabled dffs which makes up the word length

`timescale 1ns/1ps

module registerN #(parameter N = 64) (input  logic clk, reset, en, 
						               input  logic  [N-1:0] d,
						               output logic [N-1:0] q);

	
	genvar i;
	
	generate
		for (i = 0; i < N; i++) begin : regs
			dff_en d_ff (.d(d[i]),.q(q[i]), .*);
		end
	endgenerate

	


endmodule
