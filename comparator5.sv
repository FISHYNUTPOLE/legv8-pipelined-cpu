`timescale 1ns/10ps

module comparator5 (input  logic [4:0] in1, in2,
                    output logic out);

    logic [4:0] xnor_bits;
    xnor #(0.05) (xnor_bits[0], in1[0], in2[0]);
    xnor #(0.05) (xnor_bits[1], in1[1], in2[1]);
    xnor #(0.05) (xnor_bits[2], in1[2], in2[2]);
    xnor #(0.05) (xnor_bits[3], in1[3], in2[3]);
    xnor #(0.05) (xnor_bits[4], in1[4], in2[4]);

    logic and_lo, match;
    and #(0.05) (and_lo, xnor_bits[0], xnor_bits[1], xnor_bits[2], xnor_bits[3]);
    and #(0.05) (match, and_lo, xnor_bits[4]);

    logic addr1_and_lo, addr1_isX31, notX31;
    and #(0.05) (addr1_and_lo, in1[0], in1[1], in1[2], in1[3]);
    and #(0.05) (addr1_isX31, addr1_and_lo, in1[4]);
    not #(0.05) (notX31, addr1_isX31);

    and #(0.05) (out, match, notX31);

endmodule