`timescale 1ns/1ps

module IF_dp (input  logic clk, reset,
              input  logic brTaken, regBranch, stall, // stall = stall pipeline
              input  logic [63:0] br_pc, Rt_br,
              output logic [63:0] pc_curr, pc4,
              output logic [31:0] instr_IF);



    // needed since rtl is not allowed
    logic not_stall;

    not #(0.05) (not_stall, stall);

    // brTaken mux
    logic [63:0] pc_selConn;

    mux2_1_N branch_sel (.A(br_pc), .B(pc4), .sel(brTaken), .out(pc_selConn));


    // regBranch mux (decides whether or not to take Rt as pc, used for BR instruction, assumes Rd already
    // represents absolute byte address)
    logic [63:0] pc_next;
    mux2_1_N regBrach_sel (.A(Rt_br), .B(pc_selConn), .sel(regBranch), .out(pc_next));


    // pc register
    registerN pc_reg (.clk, .reset, .en(not_stall), .d(pc_next), .q(pc_curr)); 


    // normal pc advance adder
    adder_n add1 (.a(pc_curr), .b(64'd4), .cin(1'b0), .sum(pc4));

    // instruction memory
    instructmem imem (.address(pc_curr), .instruction(instr_IF), .clk);

endmodule