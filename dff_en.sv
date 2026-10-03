`timescale 1ns/1ps

module dff_en (input logic clk, reset, d, en, 
					output logic q);
						
	logic out;
	

	D_FF d_ff (.q(q), .d(out), .reset(reset), .clk(clk));
	
	mux2_1 m (.a(d), .b(q), .sel(en), .out(out));
	
	
	

endmodule
