module alu_core (input logic [63:0] a, b,
                 input logic [2:0] op,
                 output logic [63:0] out,
                 output logic cout1, cout2);

    logic [63:0] c;


    genvar i;

    alu_bitslice s0 (.a(a[0]), .b(b[0]), .cin(op[0]), .op, .cout(c[0]), .out(out[0]));

    generate

        for (i = 1; i < 64; i++) begin : gen_slices
            alu_bitslice s (.a(a[i]), .b(b[i]), .cin(c[i-1]), .op, .cout(c[i]), .out(out[i]));
        end

    endgenerate
    
    // msb and 2nd msb
    assign cout1 = c[63];
    assign cout2 = c[62];

endmodule