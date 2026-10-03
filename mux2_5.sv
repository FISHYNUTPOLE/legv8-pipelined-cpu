module mux2_5 (input logic [4:0] A, B, 
               input logic sel,
               output logic [4:0] out);

    genvar i;

    generate
        
        for (i = 0; i < 5; i++) begin : mux
            mux2_1 m (.a(A[i]), .b(B[i]), .sel, .out(out[i]));

        end

    endgenerate 


endmodule