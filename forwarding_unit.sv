`timescale 1ns/1ps


module forwarding_unit (input  logic [4:0] Rn_ID_EX, 
                        input  logic [4:0] Rm_ID_EX,
                        input  logic [4:0] Rd_EX_MEM, Rd_MEM_WB,
                        input  logic RegWrite_EX_MEM, RegWrite_MEM_WB,                   
                        output logic [1:0] aluMux1_sel, aluMux2_sel);

    always_comb begin

        aluMux1_sel = 2'b00;
        aluMux2_sel = 2'b00;


        // case 1 EX_MEM
        if (RegWrite_EX_MEM && (Rd_EX_MEM != 5'd31) && (Rd_EX_MEM == Rn_ID_EX))
            aluMux1_sel = 2'b01;
        else if (RegWrite_EX_MEM && (Rd_EX_MEM != 5'd31) && (Rd_EX_MEM == Rm_ID_EX))
            aluMux2_sel = 2'b01;




        // case 2 MEM_WB
        if (RegWrite_MEM_WB && (Rd_MEM_WB != 5'd31) && (Rd_MEM_WB == Rn_ID_EX)
            && !(RegWrite_EX_MEM && (Rd_EX_MEM != 5'd31) && (Rd_EX_MEM == Rn_ID_EX)))
            aluMux1_sel = 2'b10;
        else if (RegWrite_MEM_WB && (Rd_MEM_WB != 5'd31) && (Rd_MEM_WB == Rm_ID_EX)
            && !(RegWrite_EX_MEM && (Rd_EX_MEM != 5'd31) && (Rd_EX_MEM == Rm_ID_EX)))
            aluMux2_sel = 2'b10;    


    end







    
    
    



endmodule