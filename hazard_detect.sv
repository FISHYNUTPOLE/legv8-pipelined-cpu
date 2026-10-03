module hazard_detect (input  logic [1:0] mem2reg_ID_EX,
                      input  logic [4:0] Rn_IF_ID, Rm_IF_ID, Rd_ID_EX,
                      output logic stall);


    always_comb begin
    
        stall   = 1'b0;

        if ((mem2reg_ID_EX == 2'b01) && (Rd_ID_EX != 5'd31) &&    // mem2reg == 2'01 signifies load instruction
           ((Rd_ID_EX == Rn_IF_ID) || (Rd_ID_EX == Rm_IF_ID))) begin
           
            stall = 1'b1;

        end

    end


    


endmodule