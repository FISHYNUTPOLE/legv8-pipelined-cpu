`timescale 1ns/1ps

module datapath (input  logic clk, reset,
                 input  logic RegWrite, ALUsrc, memWrite, reg2loc, uncondBr, 
                              brTaken, regBranch, immSel, linkReg, flagWrite,
                 input  logic [2:0] ALU_op,
                 input  logic [1:0] mem2reg,
                 output logic readData2_zero,
                 output logic [3:0] flags,
                 output logic [10:0] control_opc);


    // ---- IF ----
    logic [63:0] pc_curr, pc4_IF, br_pc; // br_pc is pc value after branch addition to pc_curr
    logic [31:0] instr_IF;

    // ---- ID ----
    logic [31:0] instr_ID;
    logic [63:0] pc_ID, pc4_ID, readData1_ID, readData2_ID, imm_ID, DAddr9_se_ID;
    logic [4:0]  Rn_ID, Rm_ID, Rd_ID, regWriteAddr;
    logic        stall, flush;

    // ---- EX ----
    logic [63:0] readData1_EX, readData2_EX, imm_EX, aluIn2, aluResult_EX, DAddr9_se_EX, pc4_EX;
    logic [4:0]  Rn_EX, Rm_EX, Rd_EX;
    logic [1:0]  fwdA, fwdB, mem2reg_EX;
    logic [3:0]  flags_live, flags_stored;
    logic        ALUsrc_EX, memWrite_EX, flagWrite_EX, RegWrite_EX, linkReg_EX, immSel_EX;
    logic [2:0]  ALU_op_EX;



    // ---- MEM ----
    logic [63:0] aluResult_MEM, memData_MEM, pc4_MEM, readData2_MEM, writeBackVal_MEM;
    logic [4:0]  Rd_MEM;
    logic        memWrite_MEM, RegWrite_MEM, linkReg_MEM;
    logic [1:0]  mem2reg_MEM;

    // ---- WB ----
    logic [63:0] aluResult_WB, memData_WB, writeBackData, pc4_WB;
    logic [4:0]  Rd_WB;
    logic        RegWrite_WB, linkReg_WB;
    logic [1:0]  mem2reg_WB;





    // ========= IF =========

    IF_dp instruction_fetch (.clk, .reset,
                             .brTaken, .regBranch, .stall,
                             .br_pc, .Rt_br(readData2_ID),
                             .pc_curr, .pc4(pc4_IF),
                             .instr_IF);




    // ======== IF/ID ========

    // flush, a wrong branching guess needs its just fetched instruction squashed
    or #(0.05) (flush, brTaken, regBranch);

    IF_ID_reg IF_ID (.clk, .reset,
                     .stall, .flush,
                     .instr_in(instr_IF),
                     .pc_in(pc_curr), .pc4_in(pc4_IF),
                     .instr_out(instr_ID),
                     .pc_out(pc_ID), .pc4_out(pc4_ID),
                     .control_opc);



    // ========= ID =========

    hazard_detect hd (.mem2reg_ID_EX(mem2reg_EX),
                      .Rn_IF_ID(Rn_ID), .Rm_IF_ID(Rm_ID), .Rd_ID_EX(Rd_EX),
                      .stall);


    ID_dp Instruction_Decode (.clk, .reset,
                              .uncondBr, .linkReg, .reg2loc, .RegWrite(RegWrite_WB),
                              .pc_curr(pc_ID), .pc4(pc4_ID), .regWriteData(writeBackData),
                              .instruction_in(instr_ID),
                              .regWriteAddr,
                              .Rd_EX, .Rd_MEM, .aluResult_EX, .aluResult_MEM(writeBackVal_MEM),
                              .RegWrite_EX(RegWrite_EX), .RegWrite_MEM(RegWrite_MEM),
                              .readData2_zero,      // read port 2 comparator output
                              .Rm(Rm_ID), .Rn(Rn_ID), .Rd(Rd_ID),
                              .DAddr9_se(DAddr9_se_ID), .extended_ALUimm(imm_ID),
                              .readData1(readData1_ID), .readData2(readData2_ID), .br_pc);



    // ========= ID/EX =========

    ID_EX_reg ID_EX (.clk, .reset, 
                     .ALUsrc_in(ALUsrc), .memWrite_in(memWrite), .flagWrite_in(flagWrite), .RegWrite_in(RegWrite), .linkReg_in(linkReg), .immSel_in(immSel),
                     .mem2reg_in(mem2reg),
                     .ALU_op_in(ALU_op),
                     .ReadData1_in(readData1_ID), .ReadData2_in(readData2_ID), .immediate_in(imm_ID), .DAddr9_se_in(DAddr9_se_ID), .pc4_in(pc4_ID),
                     .Rn_ID, .Rm_ID, .Rd_ID, 
                     .Rn_EX, .Rm_EX, .Rd_EX, 
                     .ReadData1_out(readData1_EX), .ReadData2_out(readData2_EX), .immediate_out(imm_EX), .DAddr9_se_out(DAddr9_se_EX), .pc4_out(pc4_EX),
                     .ALUsrc_out(ALUsrc_EX), .memWrite_out(memWrite_EX), .flagWrite_out(flagWrite_EX), .RegWrite_out(RegWrite_EX), .linkReg_out(linkReg_EX), .immSel_out(immSel_EX),
                     .mem2reg_out(mem2reg_EX),
                     .ALU_op_out(ALU_op_EX));



    // ========= EX =========

    forwarding_unit fu (.Rn_ID_EX(Rn_EX), 
                        .Rm_ID_EX(Rm_EX),
                        .Rd_EX_MEM(Rd_MEM), .Rd_MEM_WB(Rd_WB),
                        .RegWrite_EX_MEM(RegWrite_MEM),
                        .RegWrite_MEM_WB(RegWrite_WB), 
                        .aluMux1_sel(fwdA), .aluMux2_sel(fwdB));

    EX_dp execute (.clk, .reset,
                   .readData1(readData1_EX), .readData2(readData2_EX), .imm(imm_EX), .DAddr9_se(DAddr9_se_EX), .aluResult_MEM(writeBackVal_MEM), .aluResult_WB,
                   .ALUsrc(ALUsrc_EX), .flagWrite(flagWrite_EX), .immSel(immSel_EX), .mem2reg_EX, .pc4_EX,
                   .fwdA, .fwdB,
                   .ALU_op(ALU_op_EX),
                   .flags_live, .flags_stored,
                   .aluResult(aluResult_EX), .aluIn2);




    // ========= EX/MEM =========

    EX_MEM_reg EX_MEM (.clk, .reset, 
                       .memWrite_in(memWrite_EX), .RegWrite_in(RegWrite_EX), .linkReg_in(linkReg_EX),
                       .mem2reg_in(mem2reg_EX),
                       .pc4_in(pc4_EX), .aluOut_in(aluResult_EX), .STURdata_in(readData2_EX), // STURdata is ReadData2 from regfile
                       .Rd_in(Rd_EX),
                       .Rd_out(Rd_MEM),
                       .pc4_out(pc4_MEM), .aluOut_out(aluResult_MEM), .STURdata_out(readData2_MEM),
                       .mem2reg_out(mem2reg_MEM),
                       .memWrite_out(memWrite_MEM), .RegWrite_out(RegWrite_MEM), .linkReg_out(linkReg_MEM));





    // ========= MEM =========

    MEM_dp memory (.clk, .reset,
                   .memWrite(memWrite_MEM),
                   .aluOut(aluResult_MEM), .memWriteData(readData2_MEM),
                   .dmem_out(memData_MEM));

    // resolve LDUR's loaded value into the write-back-ready value here, the same
    // way EX_dp already resolved BL's pc4 - mem2reg_MEM[0] alone is 1 only for
    // 2'b01 (LDUR), since 2'b11 is never a real encoding. Everything downstream
    // (MEM_WB_reg, WB_dp, and the MEM-tier of the ID-stage bypass) now sees the
    // final value instead of the raw ALU-computed address.
    mux2_1_N wbSel_MEM (.A(memData_MEM), .B(aluResult_MEM), .sel(mem2reg_MEM[0]), .out(writeBackVal_MEM));


    // ========= MEM/WB =========
    MEM_WB_reg MEM_WB (.clk, .reset,
                       .RegWrite_in(RegWrite_MEM), .linkReg_in(linkReg_MEM),
                       .mem2reg_in(mem2reg_MEM),
                       .dmemOut_in(memData_MEM), .aluOut_in(writeBackVal_MEM), .pc4_in(pc4_MEM),
                       .Rd_in(Rd_MEM),
                       .Rd_out(Rd_WB),
                       .dmemOut_out(memData_WB), .aluOut_out(aluResult_WB), .pc4_out(pc4_WB),
                       .RegWrite_out(RegWrite_WB), .linkReg_out(linkReg_WB),
                       .mem2reg_out(mem2reg_WB));




    // ========= WB =========

    WB_dp write_back (.mem2reg(mem2reg_WB),
                      .aluOut(aluResult_WB), .dmem_out(memData_WB), .pcPlus4(pc4_WB),
                      .Rd_WB_in(Rd_WB),
                      .linkReg(linkReg_WB),
                      .regIn(writeBackData),
                      .Rd_WB_out(regWriteAddr));



    // select between live flag and stored registered flag values
    mux2_1_N #(.N(4)) flags_bypass (.A(flags_live), .B(flags_stored), .sel(flagWrite_EX), .out(flags));
    

endmodule