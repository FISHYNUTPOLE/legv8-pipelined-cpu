module EX_MEM_reg (input  logic clk, reset, 
                   input  logic memWrite_in, RegWrite_in, linkReg_in,
                   input  logic [1:0] mem2reg_in,
                   input  logic [63:0] pc4_in, aluOut_in, STURdata_in, // STURdata is ReadData2 from regfile
                   input  logic [4:0] Rd_in,
                   output logic [4:0] Rd_out,
                   output logic [63:0] pc4_out, aluOut_out, STURdata_out,
                   output logic [1:0] mem2reg_out,
                   output logic memWrite_out, RegWrite_out, linkReg_out);

    logic [4:0] ctrl_in, ctrl_out;

    assign ctrl_in  = {memWrite_in, mem2reg_in, RegWrite_in, linkReg_in};
    assign {memWrite_out, mem2reg_out, RegWrite_out, linkReg_out} = ctrl_out;

    registerN #(.N(5)) control_signals (.clk, .reset, .en(1'b1), .d(ctrl_in), .q(ctrl_out));


    registerN #(.N(64)) alu (.clk, .reset, .en(1'b1), .d(aluOut_in),  .q(aluOut_out));
    registerN #(.N(64)) pc_plus_4  (.clk, .reset, .en(1'b1), .d(pc4_in),  .q(pc4_out));
    registerN #(.N(64)) STURdata  (.clk, .reset, .en(1'b1), .d(STURdata_in),  .q(STURdata_out));
    registerN #(.N(5)) destination_reg (.clk, .reset, .en(1'b1), .d(Rd_in), .q(Rd_out));    


endmodule