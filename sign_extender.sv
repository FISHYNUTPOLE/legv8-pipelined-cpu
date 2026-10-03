module sign_extender #(parameter N = 9) (input  logic [N-1:0] in,
                                         output logic [63:0]  out);

    assign out = {{(64-N){in[N-1]}}, in};


endmodule