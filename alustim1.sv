// Thorough testbench for the 64-bit ARM ALU
`timescale 1ns/1ps

// Meaning of signals in and out of the ALU:
//
// Flags:
// negative:  whether the result output is negative if interpreted as 2's comp (= result[63]).
// zero:      whether the result output was a 64-bit zero.
// overflow:  on an add or subtract, whether the computation overflowed (2's comp).
// carry_out: on an add or subtract, whether the computation produced a carry-out.
//
// cntrl        Operation                    Notes:
// 000:         result = B                   overflow and carry_out unimportant
// 010:         result = A + B
// 011:         result = A - B
// 100:         result = bitwise A & B       overflow and carry_out unimportant
// 101:         result = bitwise A | B       overflow and carry_out unimportant
// 110:         result = bitwise A XOR B      overflow and carry_out unimportant
//
// NOTE on carry_out during subtract: the hardware computes A + ~B + 1, so carry_out
// is the adder's true carry out of bit 63. That means carry_out = 1 on subtract
// indicates NO borrow (A >= B unsigned), and 0 indicates a borrow (A < B). The
// expected values below mirror the hardware exactly (A + ~B + 1), so they match
// whatever a correct design produces regardless of borrow-convention wording.

module alustim1();

    parameter delay = 100;

    logic [63:0] A, B;
    logic [2:0]  cntrl;
    logic [63:0] result;
    logic        negative, zero, overflow, carry_out;

    parameter ALU_PASS_B  = 3'b000,
              ALU_ADD      = 3'b010,
              ALU_SUBTRACT = 3'b011,
              ALU_AND      = 3'b100,
              ALU_OR       = 3'b101,
              ALU_XOR      = 3'b110;

    // Handy constants
    localparam logic [63:0] ZERO    = 64'h0000_0000_0000_0000;
    localparam logic [63:0] ONE     = 64'h0000_0000_0000_0001;
    localparam logic [63:0] ALLONES = 64'hFFFF_FFFF_FFFF_FFFF; // -1  / max unsigned
    localparam logic [63:0] MAXPOS  = 64'h7FFF_FFFF_FFFF_FFFF; // max positive signed
    localparam logic [63:0] MINNEG  = 64'h8000_0000_0000_0000; // min negative signed
    localparam logic [63:0] AAAA    = 64'hAAAA_AAAA_AAAA_AAAA;
    localparam logic [63:0] FIVES   = 64'h5555_5555_5555_5555;
    localparam logic [63:0] LOWFULL = 64'h0000_0000_FFFF_FFFF; // low 32 bits set
    localparam logic [63:0] BIT32   = 64'h0000_0001_0000_0000; // carry across 32-bit line

    integer errors = 0;
    integer vectors = 0;

    alu dut (.A, .B, .cntrl, .result, .negative, .zero, .overflow, .carry_out);

    initial $timeformat(-9, 2, " ns", 10);

    // 64-bit random ($random is only 32 bits, so concatenate two)
    function [63:0] rand64();
        rand64 = {$random, $random};
    endfunction

    // Apply one vector, compute the expected outputs by mirroring the hardware,
    // and check every field that matters for that operation.
    task automatic run_test(input logic [2:0] c, input logic [63:0] ta, tb);
        logic [63:0] r_exp, Y;
        logic        cin0, cout_exp, ovf_exp, neg_exp, zero_exp, check_arith;
        logic [64:0] ext;
        begin
            cntrl = c; A = ta; B = tb;
            #(delay);

            check_arith = 1'b0;
            cout_exp    = 1'b0;
            ovf_exp     = 1'b0;

            case (c)
                ALU_PASS_B: r_exp = tb;
                ALU_AND:    r_exp = ta & tb;
                ALU_OR:     r_exp = ta | tb;
                ALU_XOR:    r_exp = ta ^ tb;
                ALU_ADD, ALU_SUBTRACT: begin
                    if (c == ALU_ADD) begin Y = tb;  cin0 = 1'b0; end
                    else              begin Y = ~tb; cin0 = 1'b1; end
                    ext      = {1'b0, ta} + {1'b0, Y} + {64'b0, cin0};
                    r_exp    = ext[63:0];
                    cout_exp = ext[64];
                    // signed overflow of an adder computing (ta + Y + cin):
                    ovf_exp  = (ta[63] == Y[63]) && (r_exp[63] != ta[63]);
                    check_arith = 1'b1;
                end
                default: r_exp = 64'bx;
            endcase

            neg_exp  = r_exp[63];
            zero_exp = (r_exp == ZERO);

            vectors++;

            if (result !== r_exp)
                report("result", c, ta, tb, result, r_exp);
            if (negative !== neg_exp)
                report("negative", c, ta, tb, {63'b0, negative}, {63'b0, neg_exp});
            if (zero !== zero_exp)
                report("zero", c, ta, tb, {63'b0, zero}, {63'b0, zero_exp});
            if (check_arith) begin
                if (carry_out !== cout_exp)
                    report("carry_out", c, ta, tb, {63'b0, carry_out}, {63'b0, cout_exp});
                if (overflow !== ovf_exp)
                    report("overflow", c, ta, tb, {63'b0, overflow}, {63'b0, ovf_exp});
            end
        end
    endtask

    task report(input string field, input logic [2:0] c,
                input logic [63:0] ta, tb, got, exp);
        begin
            errors++;
            $display("[FAIL] %t  cntrl=%b  A=%h  B=%h  %s: got=%h expected=%h",
                     $time, c, ta, tb, field, got, exp);
        end
    endtask

    integer i;
    initial begin

        // ---------- PASS_B ----------
        $display("%t  testing PASS_B", $time);
        run_test(ALU_PASS_B, rand64(), ZERO);      // zero flag
        run_test(ALU_PASS_B, rand64(), MINNEG);    // negative flag
        run_test(ALU_PASS_B, rand64(), ALLONES);
        run_test(ALU_PASS_B, ALLONES,  ONE);       // A is ignored
        for (i = 0; i < 500; i++)
            run_test(ALU_PASS_B, rand64(), rand64());

        // ---------- ADD ----------
        $display("%t  testing ADD", $time);
        run_test(ALU_ADD, ONE,     ONE);           // 1+1=2, no flags
        run_test(ALU_ADD, ZERO,    ZERO);          // zero
        run_test(ALU_ADD, ALLONES, ONE);           // -1 + 1 = 0: carry_out=1, zero=1, ovf=0
        run_test(ALU_ADD, MAXPOS,  ONE);           // signed overflow -> negative, ovf=1, cout=0
        run_test(ALU_ADD, MINNEG,  MINNEG);        // ovf=1, carry_out=1, result=0
        run_test(ALU_ADD, MAXPOS,  MAXPOS);        // ovf=1, result negative
        run_test(ALU_ADD, ALLONES, ALLONES);       // carry_out=1
        run_test(ALU_ADD, LOWFULL, ONE);           // carry ripples across bit 32
        for (i = 0; i < 500; i++)
            run_test(ALU_ADD, rand64(), rand64());

        // ---------- SUBTRACT ----------
        // These directed cases specifically catch the invert-select bug (b-invert
        // mux must be driven by op[0], not by cin) -- e.g. 2 - 1 fails if a
        // mid-chain carry of 0 leaves a slice adding b instead of ~b.
        $display("%t  testing SUBTRACT", $time);
        run_test(ALU_SUBTRACT, ONE,     ONE);      // 1-1=0: zero, no borrow (cout=1)
        run_test(ALU_SUBTRACT, 64'd2,   ONE);      // 2-1=1  <-- catches invert-select bug
        run_test(ALU_SUBTRACT, ONE,     64'd2);    // 1-2=-1: negative, borrow (cout=0)
        run_test(ALU_SUBTRACT, ZERO,    ONE);      // 0-1=-1
        run_test(ALU_SUBTRACT, MINNEG,  ONE);      // signed overflow -> MAXPOS, ovf=1
        run_test(ALU_SUBTRACT, MAXPOS,  MINNEG);   // ovf=1
        run_test(ALU_SUBTRACT, BIT32,   ONE);      // borrow ripples across bit 32
        run_test(ALU_SUBTRACT, MINNEG,  MINNEG);   // equal, result 0
        for (i = 0; i < 500; i++)
            run_test(ALU_SUBTRACT, rand64(), rand64());

        // ---------- AND ----------
        $display("%t  testing AND", $time);
        run_test(ALU_AND, AAAA,    FIVES);         // 0 -> zero flag
        run_test(ALU_AND, ALLONES, ALLONES);
        run_test(ALU_AND, ALLONES, ZERO);          // zero
        for (i = 0; i < 500; i++)
            run_test(ALU_AND, rand64(), rand64());

        // ---------- OR ----------
        $display("%t  testing OR", $time);
        run_test(ALU_OR, AAAA,  FIVES);            // all ones
        run_test(ALU_OR, ZERO,  ZERO);             // zero
        run_test(ALU_OR, MINNEG, ZERO);            // negative
        for (i = 0; i < 500; i++)
            run_test(ALU_OR, rand64(), rand64());

        // ---------- XOR ----------
        $display("%t  testing XOR", $time);
        run_test(ALU_XOR, ALLONES, ALLONES);       // 0 -> zero
        run_test(ALU_XOR, AAAA,    FIVES);         // all ones
        run_test(ALU_XOR, rand64(), ZERO);         // A ^ 0 = A
        for (i = 0; i < 500; i++)
            run_test(ALU_XOR, rand64(), rand64());

        // ---------- Summary ----------
        $display("==================================================");
        if (errors == 0)
            $display("ALL CHECKS PASSED  (%0d vectors)", vectors);
        else
            $display("FAILED: %0d error(s) across %0d vectors", errors, vectors);
        $display("==================================================");
        $finish;
    end

endmodule