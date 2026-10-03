module flag_reg (input  logic clk, reset, en,
                 input  logic negative, overflow, carry_out, zero,
                 output logic [3:0] out);

    dff_en neg    	(.d(negative), .q(out[3]), .*);
    dff_en ovrflw 	(.d(overflow), .q(out[2]), .*);    
    dff_en cout   	(.d(carry_out),.q(out[1]), .*);
    dff_en zeroReg   (.d(zero)    ,.q(out[0]), .*);



endmodule