// Top-level testbench for the ARM single-cycle CPU.
//
//   PC          dut.dp.instruction_fetch.pc_curr
//   instruction dut.dp.instr_IF
//   flags       dut.dp.flags        (bit3=neg, bit2=ovrflw, bit1=carry, bit0=zero)
//   registers   dut.dp.Instruction_Decode.rf.regOut[0-31]
//   data mem    dut.dp.memory.dmem.mem[byte address]

`timescale 1ns/10ps

module cpu_tb ();

    parameter ClockDelay = 100;
    parameter NUM_CYCLES = 1000;   // arbitrary number of cycles, enough to reach end of simulation

    logic clk, reset;

    cpu dut (.clk, .reset);



    initial begin // clock setup
        clk <= 0;
        forever #(ClockDelay/2) clk <= ~clk;
    end

    // compares a register against an expected value and prints PASS/FAIL
    task automatic chk_reg(input int regnum, input logic [63:0] expected);
        logic [63:0] actual;
        begin
            actual = dut.dp.Instruction_Decode.rf.regOut[regnum];
            $display("t=%0t  X%0d = %0d (expected %0d)  %s",
                      $time, regnum, $signed(actual), $signed(expected),
                      (actual === expected) ? "PASS" : "FAIL");
        end
    endtask

    integer i;
    initial begin
        reset <= 1'b1;                                              @(posedge clk);

        reset <= 1'b0;

        // Run and trace simulation (commented out because it became unreadable for the longer testbenches)
        // for (i = 0; i < NUM_CYCLES; i++) begin
        //     @(posedge clk);
        //     #(1); // let combinational logic settle after the edge before sampling
        //     $display("t=%0t  cycle=%0d  PC=%0d  instr=%b  flags=%b",
        //               $time, i, dut.dp.f.pc, dut.dp.instruction, dut.dp.flags);
        // end

        repeat (NUM_CYCLES) @(posedge clk);

        // register dump
        $display("\nfinal register file");
        for (i = 0; i < 32; i++)
            $display("X%0d = %0d", i, $signed(dut.dp.Instruction_Decode.rf.regOut[i]));

        // First few doublewords of data memory
        $display("\ndata memory [0:63]");
        for (i = 0; i < 64; i = i + 8)
            $display("mem[%0d] = %h %h %h %h %h %h %h %h",
                      i, dut.dp.memory.dmem.mem[i],   dut.dp.memory.dmem.mem[i+1], dut.dp.memory.dmem.mem[i+2], dut.dp.memory.dmem.mem[i+3],
                         dut.dp.memory.dmem.mem[i+4], dut.dp.memory.dmem.mem[i+5], dut.dp.memory.dmem.mem[i+6], dut.dp.memory.dmem.mem[i+7]);

        // pass/fail check
        $display("\nbenchmark checks");


        // test01_AddiB.arm
        // chk_reg(0, 64'd0);
        // chk_reg(1, 64'd1);
        // chk_reg(2, 64'd2);
        // chk_reg(3, 64'd3);
        // chk_reg(4, 64'd4);	

        // test02_AddsSubs.arm
        // chk_reg(0, 64'd1);
        // chk_reg(1, -64'd1);
        // chk_reg(2, 64'd2);
        // chk_reg(3, -64'd3);
        // chk_reg(4, -64'd2);
        // chk_reg(5, -64'd5);
        // chk_reg(6, 64'd0);
        // chk_reg(7, -64'd6);
        // $display("flags = %b (expected 4'b1010)  %s", dut.dp.flags, (dut.dp.flags === 4'b1010) ? "PASS" : "FAIL");
		  

        // test03_CbzB.arm
        chk_reg(0, 64'd1);
        chk_reg(1, 64'd0);
        chk_reg(2, 64'd0);
        chk_reg(3, 64'd1);
        chk_reg(4, 64'd31);
        chk_reg(5, 64'd0);		  

        // test04_LdurStur.arm
        // chk_reg(0, 64'd1);
        // chk_reg(1, 64'd2);
        // chk_reg(2, 64'd3);
        // chk_reg(3, 64'd8);
        // chk_reg(4, 64'd11);
        // chk_reg(5, 64'd1);
        // chk_reg(6, 64'd2);
        // chk_reg(7, 64'd3);

        // test05_Blt.arm
        // chk_reg(0, 64'd1);
        // chk_reg(1, 64'd1);

        // test06_BlBr.arm *************
        // chk_reg(0,  64'd1);
        // chk_reg(1,  64'd0);
        // chk_reg(2,  64'd0);
        // chk_reg(3,  64'd1);
        // chk_reg(4,  64'd52);
        // chk_reg(5,  64'd64);
        // chk_reg(29, 64'd20);
        // chk_reg(30, 64'd68);


        // test10_forwarding.arm
        // chk_reg(0,  64'd0);
        // chk_reg(1,  64'd8);
        // chk_reg(2,  64'd4);
        // chk_reg(3,  64'd5);
        // chk_reg(4,  64'd7);
        // chk_reg(5,  64'd2);
        // chk_reg(6,  -64'd2);
        // chk_reg(7,  -64'd2);
        // chk_reg(8,  64'd0);
        // chk_reg(9,  64'd1);
        // chk_reg(10, -64'd4);
        // chk_reg(14, 64'd5);
        // chk_reg(15, 64'd8);
        // chk_reg(16, 64'd9);
        // chk_reg(17, 64'd1);
        // chk_reg(18, 64'd99);
        // Mem[0]=8, Mem[8]=5


        // test11_Sort.arm
        // chk_reg(11, 64'd1);
        // chk_reg(12, 64'd2);
        // chk_reg(13, 64'd3);
        // chk_reg(14, 64'd4);
        // chk_reg(15, 64'd5);
        // chk_reg(16, 64'd6);
        // chk_reg(17, 64'd7);
        // chk_reg(18, 64'd8);
        // chk_reg(19, 64'd9);
        // chk_reg(20, 64'd10);


        // test12_Fibonacci.arm
        // chk_reg(0,  64'd6);
        // chk_reg(1,  64'd8);
        // chk_reg(28, 64'd8);
        // chk_reg(30, 64'd196);



        $stop;
    end
endmodule
