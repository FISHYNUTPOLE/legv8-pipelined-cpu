`timescale 1ns/1ps

module IF_ID_reg (input  logic clk, reset,
                  input  logic stall, flush,
                  input  logic [31:0] instr_in,
                  input  logic [63:0] pc_in, pc4_in,
                  output logic [31:0] instr_out,
                  output logic [63:0] pc_out, pc4_out,
                  output logic [10:0] control_opc);


    // needed since rtl is not allowed
    logic not_stall;

    not #(0.05) (not_stall, stall);

    // flush replaces a wrongly predicted fetch with a nop instruction before it is latched
    logic [31:0] instr_in_effective;

    mux2_1_N #(.N(32)) flush_mux (.A(32'd0), .B(instr_in), .sel(flush), .out(instr_in_effective));

    registerN #(.N(32)) instr (.clk, .reset, .en(not_stall), .d(instr_in_effective), .q(instr_out));

    registerN #(.N(64)) pc (.clk, .reset, .en(not_stall), .d(pc_in), .q(pc_out));

    registerN #(.N(64)) pc_plus_4 (.clk, .reset, .en(not_stall), .d(pc4_in), .q(pc4_out));


    mux2_1_N #(.N(11)) control_opcode (.A(11'd0), .B(instr_out[31:21]), .sel(stall), .out(control_opc));




endmodule