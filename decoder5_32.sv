



`timescale 1ns/1ps

module decoder5_32 (input  logic [4:0] addr,
					input  logic en, 
					output logic [31:0] out);

						  
	// inverted address bits used for decoder wiring					  
						  
	logic na0, na1, na2, na3, na4;
	
	not #(0.05) (na0, addr[0]);
	not #(0.05) (na1, addr[1]);
	not #(0.05) (na2, addr[2]);
	not #(0.05) (na3, addr[3]);
	not #(0.05) (na4, addr[4]);
	
	
	
	
	// each block represents a possible output of the decoder. each block utilizes three AND gates
	// that are daisy chained together because of the limit of four input per gate in labs
	
   logic l0a, l0b;
   and #(0.05) (l0a, na4, na3, na2, na1);
   and #(0.05) (l0b, na0, en);
   and #(0.05) (out[0], l0a, l0b);

   logic l1a, l1b;
   and #(0.05) (l1a, na4, na3, na2, na1);
   and #(0.05) (l1b, addr[0], en);
   and #(0.05) (out[1], l1a, l1b);

   logic l2a, l2b;
   and #(0.05) (l2a, na4, na3, na2, addr[1]);
   and #(0.05) (l2b, na0, en);
   and #(0.05) (out[2], l2a, l2b);

	logic l3a, l3b;
   and #(0.05) (l3a, na4, na3, na2, addr[1]);
   and #(0.05) (l3b, addr[0], en);
   and #(0.05) (out[3], l3a, l3b);
	
	logic l4a, l4b;
	and #(0.05) (l4a, na4, na3, addr[2], na1);
	and #(0.05) (l4b, na0, en);
	and #(0.05) (out[4], l4a, l4b);
	
	logic l5a, l5b;
	and #(0.05) (l5a, na4, na3, addr[2], na1);
	and #(0.05) (l5b, addr[0], en);
	and #(0.05) (out[5], l5a, l5b);
	
	logic l6a, l6b;
	and #(0.05) (l6a, na4, na3, addr[2], addr[1]);
	and #(0.05) (l6b, na0, en);
	and #(0.05) (out[6], l6a, l6b);
	
	logic l7a, l7b;
	and #(0.05) (l7a, na4, na3, addr[2], addr[1]);
	and #(0.05) (l7b, addr[0], en);
	and #(0.05) (out[7], l7a, l7b);
	
	logic l8a, l8b;
	and #(0.05) (l8a, na4, addr[3], na2, na1);
	and #(0.05) (l8b, na0, en);
	and #(0.05) (out[8], l8a, l8b);
	
	logic l9a, l9b;
	and #(0.05) (l9a, na4, addr[3], na2, na1);
	and #(0.05) (l9b, addr[0], en);
	and #(0.05) (out[9], l9a, l9b);
	
	logic l10a, l10b;
	and #(0.05) (l10a, na4, addr[3], na2, addr[1]);
	and #(0.05) (l10b, na0, en);
	and #(0.05) (out[10], l10a, l10b);
	
	logic l11a, l11b;
	and #(0.05) (l11a, na4, addr[3], na2, addr[1]);
	and #(0.05) (l11b, addr[0], en);
	and #(0.05) (out[11], l11a, l11b);
	
	logic l12a, l12b;
	and #(0.05) (l12a, na4, addr[3], addr[2], na1);
	and #(0.05) (l12b, na0, en);
	and #(0.05) (out[12], l12a, l12b);
	
	logic l13a, l13b;
	and #(0.05) (l13a, na4, addr[3], addr[2], na1);
	and #(0.05) (l13b, addr[0], en);
	and #(0.05) (out[13], l13a, l13b);
	
	logic l14a, l14b;
	and #(0.05) (l14a, na4, addr[3], addr[2], addr[1]);
	and #(0.05) (l14b, na0, en);
	and #(0.05) (out[14], l14a, l14b);
	
	logic l15a, l15b;
	and #(0.05) (l15a, na4, addr[3], addr[2], addr[1]);
	and #(0.05) (l15b, addr[0], en);
	and #(0.05) (out[15], l15a, l15b);
	
	logic l16a, l16b;
	and #(0.05) (l16a, addr[4], na3, na2, na1);
	and #(0.05) (l16b, na0, en);
	and #(0.05) (out[16], l16a, l16b);
	
	logic l17a, l17b;
	and #(0.05) (l17a, addr[4], na3, na2, na1);
	and #(0.05) (l17b, addr[0], en);
	and #(0.05) (out[17], l17a, l17b);
	
	logic l18a, l18b;
	and #(0.05) (l18a, addr[4], na3, na2, addr[1]);
	and #(0.05) (l18b, na0, en);
	and #(0.05) (out[18], l18a, l18b);
	
	logic l19a, l19b;
	and #(0.05) (l19a, addr[4], na3, na2, addr[1]);
	and #(0.05) (l19b, addr[0], en);
	and #(0.05) (out[19], l19a, l19b);
	
	logic l20a, l20b;
	and #(0.05) (l20a, addr[4], na3, addr[2], na1);
	and #(0.05) (l20b, na0, en);
	and #(0.05) (out[20], l20a, l20b);
	
	logic l21a, l21b;
	and #(0.05) (l21a, addr[4], na3, addr[2], na1);
	and #(0.05) (l21b, addr[0], en);
	and #(0.05) (out[21], l21a, l21b);
	
	logic l22a, l22b;
	and #(0.05) (l22a, addr[4], na3, addr[2], addr[1]);
	and #(0.05) (l22b, na0, en);
	and #(0.05) (out[22], l22a, l22b);
	
	logic l23a, l23b;
	and #(0.05) (l23a, addr[4], na3, addr[2], addr[1]);
	and #(0.05) (l23b, addr[0], en);
	and #(0.05) (out[23], l23a, l23b);
	
	logic l24a, l24b;
	and #(0.05) (l24a, addr[4], addr[3], na2, na1);
	and #(0.05) (l24b, na0, en);
	and #(0.05) (out[24], l24a, l24b);
	
	logic l25a, l25b;
	and #(0.05) (l25a, addr[4], addr[3], na2, na1);
	and #(0.05) (l25b, addr[0], en);
	and #(0.05) (out[25], l25a, l25b);
	
	logic l26a, l26b;
	and #(0.05) (l26a, addr[4], addr[3], na2, addr[1]);
	and #(0.05) (l26b, na0, en);
	
	and #(0.05) (out[26], l26a, l26b);
	logic l27a, l27b;
	and #(0.05) (l27a, addr[4], addr[3], na2, addr[1]);
	and #(0.05) (l27b, addr[0], en);
	and #(0.05) (out[27], l27a, l27b);
	
	logic l28a, l28b;
	and #(0.05) (l28a, addr[4], addr[3], addr[2], na1);
	and #(0.05) (l28b, na0, en);
	and #(0.05) (out[28], l28a, l28b);
	
	logic l29a, l29b;
	and #(0.05) (l29a, addr[4], addr[3], addr[2], na1);
	and #(0.05) (l29b, addr[0], en);
	and #(0.05) (out[29], l29a, l29b);
	
	logic l30a, l30b;
	and #(0.05) (l30a, addr[4], addr[3], addr[2], addr[1]);
	and #(0.05) (l30b, na0, en);
	and #(0.05) (out[30], l30a, l30b);
	
	logic l31a, l31b;
	and #(0.05) (l31a, addr[4], addr[3], addr[2], addr[1]);
	and #(0.05) (l31b, addr[0], en);
	and #(0.05) (out[31], l31a, l31b);	
	


endmodule
