`timescale 1ns/1ps

module zero_detect (input logic [63:0] in,
                    output logic out);

    // zero detect (or every single bit together to make sure there are no 1s)
    logic [15:0] z1;
    logic [3:0]  z2;

    genvar i;
    generate
        
        for (i = 0; i < 16; i++) begin : lvl1
            nor #(0.05) (z1[i], in[4*i], in[4*i+1], in[4*i+2], in[4*i+3]);
        end

        for (i = 0; i < 4; i++) begin : lvl2
            and #(0.05) (z2[i], z1[4*i], z1[4*i+1], z1[4*i+2], z1[4*i+3]);
        end

    endgenerate

    and  #(0.05) (out, z2[0], z2[1], z2[2], z2[3]);


endmodule