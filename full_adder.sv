`timescale 1ns/1ps

module full_adder (input logic a, b, cin,
                   output logic sum, cout);

    logic xor1, and1, and2;

    xor #(0.05) (xor1, a, b);
    xor #(0.05) (sum, xor1, cin);
    and #(0.05) (and1, cin, xor1);
    and #(0.05) (and2, a, b);
    or  #(0.05) (cout, and1, and2);



endmodule
