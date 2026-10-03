module WB_dp (input  logic [1:0] mem2reg,
              input  logic [63:0] aluOut, dmem_out, pcPlus4,
              input  logic [4:0] Rd_WB_in,
              input  logic linkReg,
              output logic [63:0] regIn,
              output logic [4:0] Rd_WB_out);

    assign regIn = aluOut;
    assign Rd_WB_out = Rd_WB_in;




endmodule