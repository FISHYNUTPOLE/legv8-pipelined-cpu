`timescale 1ns/1ps

module ID_dp (input  logic clk, reset,
              input  logic uncondBr, linkReg, reg2loc, RegWrite,
              input  logic [63:0] pc_curr, pc4, regWriteData,
              input  logic [31:0] instruction_in,
              input  logic [4:0]  regWriteAddr,
              input  logic [4:0]  Rd_EX, Rd_MEM,
              input  logic [63:0] aluResult_EX, aluResult_MEM,
              input  logic        RegWrite_EX, RegWrite_MEM,
              output logic readData2_zero,
              output logic [4:0]  Rm, Rn, Rd,
              output logic [10:0] opcode,
              output logic [63:0] DAddr9_se, condSkip, uncondSkip, extended_ALUimm, readData1, readData2, br_pc);


    // instruction connection wires
    logic [4:0] Rd_raw;
    logic [8:0] DAddr9;
    logic [18:0] condAddr;
    logic [25:0] uncondAddr;
    logic [11:0] ALU_immediate;
    logic [63:0] pcPlus4;

    assign Rn            = instruction_in[9:5];
    assign Rm            = instruction_in[20:16];
    assign Rd_raw        = instruction_in[4:0];
    assign condAddr      = instruction_in[23:5];
    assign uncondAddr    = instruction_in[25:0];
    assign DAddr9        = instruction_in[20:12];
    assign ALU_immediate = instruction_in[21:10];
    assign opcode        = instruction_in[31:21];

    // linkReg selector mux
    mux2_5 linkRegSel (.A(5'd30), .B(Rd_raw), .sel(linkReg), .out(Rd)); // RegBrAddr is used as an address once it reaches WB


    // Bus extension
    sign_extender #(.N(19)) conditional   (.in(condAddr),   .out(condSkip));    // conditional branch
    sign_extender #(.N(26)) unconditional (.in(uncondAddr), .out(uncondSkip));  // unconditional branch
    sign_extender #(.N(9))  DAddr9_ext    (.in(DAddr9),     .out(DAddr9_se));   // DAddr9 (used for data memory addressing)
    assign extended_ALUimm = {52'd0, ALU_immediate};                            // immediate arithmetic operations


    // branch type selection mux
    logic [63:0] brSelOut;

    mux2_1_N branch_type (.A(uncondSkip), .B(condSkip), .sel(uncondBr), .out(brSelOut));
    

    // branch value shifter (br*4) because shift value in instruction is per instruction
    logic [63:0] br_shiftOut;

    assign br_shiftOut = {brSelOut[61:0], 2'd0};


    // branch addr adder
    adder_n add2 (.a(pc_curr), .b(br_shiftOut), .cin(1'b0), .sum(br_pc));   // adds the current pc value with the shifted branch value


    // register file
    logic [4:0]  readAddr2; // mux select between Rm and Rd (which is sometimes Rt hence the mux)
    logic [63:0] regIn;
    logic [63:0] readData1_raw, readData2_raw;

    mux2_5 Rd_Rm_sel  (.A(Rd_raw), .B(Rm), .sel(reg2loc), .out(readAddr2));

    regfile rf (.clk, .reset, .RegWrite,
                .ReadRegister1(Rn), .ReadRegister2(readAddr2), .WriteRegister(regWriteAddr), .WriteData(regWriteData),
				.ReadData1(readData1_raw), .ReadData2(readData2_raw));


    // write read bypass - readData1 (Rn) is always used as an ALU operand downstream,
    // so it's already covered by forwarding_unit's EX-stage forwarding for the EX/MEM
    // and MEM/WB gaps; it only needs the WB-tier bypass here, for the gap-3 case where
    // the writer has already left the pipeline by the time EX-stage forwarding could help.
    logic match1_WB, bypass1;
    comparator5 cmp1_WB (.in1(regWriteAddr), .in2(Rn), .out(match1_WB));
    and #(0.05) (bypass1, RegWrite, match1_WB);

    mux2_1_N bypass_mux1 (.A(regWriteData), .B(readData1_raw), .sel(bypass1), .out(readData1));


    // write read bypass - readData2 needs all three tiers, since CBZ/STUR/BR consume it
    // directly in ID (CBZ's zero-check, STUR's store data, BR's target address) without
    // ever passing through EX-stage forwarding the way a normal ALU operand would.
    // Priority: EX (gap 1) > MEM (gap 2) > WB (gap 3), since EX is the most recent write.
    logic match2_EX, match2_MEM, match2_WB;
    comparator5 cmp2_EX  (.in1(Rd_EX),        .in2(readAddr2), .out(match2_EX));
    comparator5 cmp2_MEM (.in1(Rd_MEM),       .in2(readAddr2), .out(match2_MEM));
    comparator5 cmp2_WB  (.in1(regWriteAddr), .in2(readAddr2), .out(match2_WB));

    logic bypass2_EX, bypass2_MEM, bypass2_WB;
    and #(0.05) (bypass2_EX,  RegWrite_EX,  match2_EX);
    and #(0.05) (bypass2_MEM, RegWrite_MEM, match2_MEM);
    and #(0.05) (bypass2_WB,  RegWrite,     match2_WB);

    // cascade low-to-high priority: WB first, MEM overrides it, EX overrides that
    logic [63:0] readData2_step1, readData2_step2;
    mux2_1_N pri2_WB  (.A(regWriteData),  .B(readData2_raw),   .sel(bypass2_WB),  .out(readData2_step1));
    mux2_1_N pri2_MEM (.A(aluResult_MEM), .B(readData2_step1), .sel(bypass2_MEM), .out(readData2_step2));
    mux2_1_N pri2_EX  (.A(aluResult_EX),  .B(readData2_step2), .sel(bypass2_EX),  .out(readData2));


    // check readData2 zero for branching
    zero_detect z (.in(readData2), .out(readData2_zero));

endmodule