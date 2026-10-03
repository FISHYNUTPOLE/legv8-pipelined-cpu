`timescale 1ns/1ps

module alu (input logic [63:0] A, B,
            input logic [2:0] cntrl,
            output logic [63:0] result,
            output logic negative, overflow, carry_out, zero);

    
    // msb and 2nd msb 
    logic cout1, cout2;

    alu_core core (.a(A), .b(B), .op(cntrl), .out(result), .cout1, .cout2);


    // overflow detect
    xor #(0.05) (overflow, cout1, cout2);

    zero_detect z (.in(result), .out(zero));

    // negative
    assign negative = result[63];

    // carry out
    assign carry_out = cout1;



endmodule