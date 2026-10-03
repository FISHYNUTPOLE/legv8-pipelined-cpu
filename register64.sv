// This module instantiates 64 enabled dffs which makes up the word length

`timescale 1ns/1ps

module register64 (input  logic clk, reset, en, 
						 input  logic  [63:0] d,
						 output logic [63:0] q);

	
	genvar i;
	
	generate
		for (i = 0; i < 64; i++) begin : regs
			dff_en d_ff (.d(d[i]),.q(q[i]), .*);
		end
	endgenerate

	


endmodule
