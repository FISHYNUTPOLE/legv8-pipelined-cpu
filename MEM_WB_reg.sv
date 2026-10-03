

module MEM_WB_reg (input  logic clk, reset,  
                   input  logic RegWrite_in, linkReg_in,
                   input  logic [1:0] mem2reg_in,                   
                   input  logic [63:0] dmemOut_in, aluOut_in, pc4_in, readData2_in,
                   input  logic [4:0] Rd_in, 
                   output logic [4:0] Rd_out,                  
                   output logic [63:0] dmemOut_out, aluOut_out, pc4_out, readData2_out,
                   output logic RegWrite_out, linkReg_out,
                   output logic [1:0] mem2reg_out);



    logic [3:0] ctrl_in, ctrl_out;

    assign ctrl_in  = {mem2reg_in, RegWrite_in, linkReg_in};
    assign {mem2reg_out, RegWrite_out, linkReg_out} = ctrl_out;

    registerN #(.N(4)) control_signals (.clk, .reset, .en(1'b1), .d(ctrl_in), .q(ctrl_out));


    registerN #(.N(5)) Rd (.clk, .reset, .en(1'b1), .d(Rd_in), .q(Rd_out));
    registerN #(.N(64)) dmemOut (.clk, .reset, .en(1'b1), .d(dmemOut_in), .q(dmemOut_out));
    registerN #(.N(64)) aluOut (.clk, .reset, .en(1'b1), .d(aluOut_in), .q(aluOut_out));
    registerN #(.N(64)) pc_plus_4  (.clk, .reset, .en(1'b1), .d(pc4_in),  .q(pc4_out));







endmodule