`timescale 1ns/1ps

module mux2_1_N #(parameter N = 64) (input logic [N-1:0] A, B, 
                                     input logic sel,
                                     output logic [N-1:0] out);

    genvar i;

    generate
        
        for (i = 0; i < N; i++) begin : mux
            mux2_1 m (.a(A[i]), .b(B[i]), .sel, .out(out[i]));

        end

    endgenerate 


endmodule