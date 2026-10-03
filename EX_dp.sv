module EX_dp (input  logic clk, reset, 
              input  logic [63:0] readData1, readData2, imm, DAddr9_se, pc4_EX,
                                  aluResult_MEM, aluResult_WB, 
              input  logic        ALUsrc, flagWrite, immSel,
              input  logic [1:0]  fwdA, fwdB, mem2reg_EX,
              input  logic [2:0]  ALU_op,
              output logic [3:0]  flags_live, flags_stored,
              output logic [63:0] aluResult, aluIn2);


    // ALU forwarding muxes
    logic [3:0][63:0] fwdMuxIn1, fwdMuxIn2;
    logic [63:0] fwdMuxOut1, fwdMuxOut2;

    assign fwdMuxIn1[0] = readData1;
    assign fwdMuxIn1[1] = aluResult_MEM;
    assign fwdMuxIn1[2] = aluResult_WB;
    assign fwdMuxIn1[3] = 64'd0;

    assign fwdMuxIn2[0] = readData2;
    assign fwdMuxIn2[1] = aluResult_MEM;
    assign fwdMuxIn2[2] = aluResult_WB;
    assign fwdMuxIn2[3] = 64'd0;

    mux4_1_64 port1 (.in(fwdMuxIn1), .sel(fwdA), .out(fwdMuxOut1));
    mux4_1_64 port2 (.in(fwdMuxIn2), .sel(fwdB), .out(fwdMuxOut2));

    // immediate select mux
    logic [63:0] imm_muxOut;

    mux2_1_N immediate_sel (.A(imm), .B(DAddr9_se), .sel(immSel), .out(imm_muxOut));


    // ALUsrc mux
    mux2_1_N ALU_source (.A(imm_muxOut), .B(fwdMuxOut2), .sel(ALUsrc), .out(aluIn2));


    // ALU
    logic negative, overflow, carry_out, zero;
    logic [63:0] aluResult_raw;

    alu alu (.A(fwdMuxOut1), .B(aluIn2), .cntrl(ALU_op), .result(aluResult_raw),
             .negative, .overflow, .carry_out, .zero);

    mux2_1_N wbSel (.A(pc4_EX), .B(aluResult_raw), .sel(mem2reg_EX[1]), .out(aluResult)); // use to choose between actual alu result or pc4 for linkReg

    assign flags_live[3] = negative;
    assign flags_live[2] = overflow;
    assign flags_live[1] = carry_out;
    assign flags_live[0] = zero;

    // flag register (keeps neg, ovrflw, cout, and zero flags for conditional branches, enabled by flagWrite from control)
    flag_reg flag_reg (.clk, .reset, .en(flagWrite), .negative, .overflow, .carry_out, .zero, .out(flags_stored));






endmodule