module ID_EX_reg (input  logic clk, reset, 
                  input  logic ALUsrc_in, memWrite_in, flagWrite_in, RegWrite_in, linkReg_in, immSel_in,
                  input  logic [1:0] mem2reg_in,
                  input  logic [2:0] ALU_op_in,
                  input  logic [63:0] ReadData1_in, ReadData2_in, immediate_in, DAddr9_se_in, pc4_in,
                  input  logic [4:0]  Rn_ID, Rm_ID, Rd_ID, 
                  output logic [4:0]  Rn_EX, Rm_EX, Rd_EX, 
                  output logic [63:0] ReadData1_out, ReadData2_out, immediate_out, DAddr9_se_out, pc4_out,
                  output logic ALUsrc_out, memWrite_out, flagWrite_out, RegWrite_out, linkReg_out, immSel_out,
                  output logic [1:0] mem2reg_out,
                  output logic [2:0] ALU_op_out);


    // control signals
    logic [10:0] ctrl_in, ctrl_out;

    assign ctrl_in = {ALUsrc_in, memWrite_in, flagWrite_in, mem2reg_in, RegWrite_in, linkReg_in, ALU_op_in, immSel_in};
    assign {ALUsrc_out, memWrite_out, flagWrite_out, mem2reg_out, RegWrite_out, linkReg_out, ALU_op_out, immSel_out} = ctrl_out;

    registerN #(.N(11)) control_signals (.clk, .reset, .en(1'b1), .d(ctrl_in), .q(ctrl_out));


    // registers
    logic [14:0] registers_in, registers_out;

    assign registers_in = {Rn_ID, Rm_ID, Rd_ID};
    assign {Rn_EX, Rm_EX, Rd_EX} = registers_out;  

    registerN #(.N(15))  registers    (.clk, .reset, .en(1'b1), .d(registers_in), .q(registers_out));



    registerN #(.N(64)) readData1_reg (.clk, .reset, .en(1'b1), .d(ReadData1_in), .q(ReadData1_out));
    registerN #(.N(64)) readData2_reg (.clk, .reset, .en(1'b1), .d(ReadData2_in), .q(ReadData2_out));
    registerN #(.N(64)) immediate     (.clk, .reset, .en(1'b1), .d(immediate_in), .q(immediate_out));
    registerN #(.N(64)) DAddr9        (.clk, .reset, .en(1'b1), .d(DAddr9_se_in), .q(DAddr9_se_out));
    registerN #(.N(64)) pc_plus_4  (.clk, .reset, .en(1'b1), .d(pc4_in),  .q(pc4_out));


    



endmodule