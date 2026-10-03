module adder_n #(parameter N = 64) (input  logic [N-1:0] a, b,
                                    input  logic         cin,
                                    output logic [N-1:0] sum,
                                    output logic         cout);

    logic [N:0] c;
    assign c[0] = cin;
  
    genvar i;
    generate
        for (i = 0; i < N; i++) begin : fa
            full_adder a (.a(a[i]), .b(b[i]), .cin(c[i]),
                          .sum(sum[i]), .cout(c[i+1]));
        end
    endgenerate

    assign cout = c[N];
endmodule