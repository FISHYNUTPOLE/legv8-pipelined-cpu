// This modules is a 2x1 mux created using gate level syntax

`timescale 1ns/1ps

module mux2_1 (input logic a, b, sel,
					output logic out);
					
	logic a1, b1, nsel;
					
	not #(0.05) (nsel, sel);				
	and #(0.05) (a1, a, sel); 				
	and #(0.05) (b1, b, nsel); 				
	or  #(0.05) (out, a1, b1);

	

endmodule 