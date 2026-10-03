module cpu (input logic clk, reset);


    // ctrl inputs / dp outputs
    logic [3:0] flags;
    logic [10:0] control_opc; // instruction opcode
    logic readData2_zero; // specifically for CBZ since it doesn't set flags
   


    // ctrl outputs / dp inputs
    logic RegWrite, ALUsrc, memWrite, reg2loc, uncondBr, 
          brTaken, regBranch, immSel, linkReg, flagWrite;
    logic [1:0] mem2reg;
    logic [2:0] ALU_op;


    // control unit
    control ctrl (.*);


    // datapath unit
    datapath dp (.*);

endmodule