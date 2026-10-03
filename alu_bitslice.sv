`timescale 1ns/1ps

module alu_bitslice (input logic a, b, cin,
                     input logic [2:0] op,
                     output logic out, cout);


    logic sum, and_out, or_out, xor_out;

    logic bm, bn;

    logic [7:0] mux_in;


    full_adder fa (.a, .b(bm), .cin, .sum, .cout);

    // b inversion for mux before adder
    not #(0.05) (bn, b);

    // b inversion mux
    mux2_1 m1 (bn, b, op[0], bm);    

    // and logic
    and #(0.05) (and_out, a, b);

    // or logic
    or  #(0.05) (or_out, a, b);

    // xor logic
    xor #(0.05) (xor_out, a, b);

    // output selection mux
    mux8_1 m2 (.in(mux_in), .sel(op), .out);


    // assigning mux inputs (unused inputs are arbitrarily assigned 'sum')
    assign mux_in[0] = b;
    assign mux_in[1] = sum;
    assign mux_in[2] = sum;
    assign mux_in[3] = sum;
    assign mux_in[4] = and_out;
    assign mux_in[5] = or_out;
    assign mux_in[6] = xor_out;
    assign mux_in[7] = sum;







endmodule