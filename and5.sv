module and5 (input  logic [4:0] in1, in2,
             output logic out);


    logic [4:0] match_out;

    genvar i;
    generate
        
        for (i = 0; i < 5; i++) begin : AND
            and #(0.05) (match_out[i], in1[i], in2[i]);
        end

    endgenerate


    // AND together match_out to one bit
    logic check;

    and #(0.05) (check, match_out[0], match_out[1], match_out[2], match_out[3]);
    and #(0.05) (out, check, match_out[4]);






endmodule