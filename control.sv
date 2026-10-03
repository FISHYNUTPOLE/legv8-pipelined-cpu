module control (input  logic [3:0] flags,
                input  logic [10:0] control_opc, // instruction opcode
                input  logic readData2_zero,
                output logic RegWrite, ALUsrc, memWrite, reg2loc, uncondBr, 
                             brTaken, regBranch, immSel, linkReg, flagWrite,
                output logic [1:0] mem2reg,
                output logic [2:0] ALU_op);




    // flag bits
    logic zero, neg, ovrflw;

    assign neg    = flags[3];
    assign ovrflw = flags[2];
    assign zero   = flags[0];



    always_comb begin

        reg2loc   = 1'b0;      // 0 = Rm[20:16], 1 = Rd[4:0]
        ALUsrc    = 1'b0;      // 0 = readData2, 1 = immediate
        immSel    = 1'b0;      // 0 = SE(Imm9), 1 = ZE(Imm12)
        ALU_op    = 3'b010;    // add (harmless default)
        memWrite  = 1'b0;
        mem2reg   = 2'b00;     // 00 = ALU, 01 = Mem, 10 = PC+4
        RegWrite  = 1'b0;
        linkReg   = 1'b0;      // 1 = write X30 instead of Rd
        flagWrite = 1'b0;      // 1 = latch ALU flags
        uncondBr  = 1'b0;
        brTaken   = 1'b0;
        regBranch = 1'b0;

        casez (control_opc)

            11'b1001000100?: begin  // ADDI
                RegWrite = 1'b1; ALUsrc = 1'b1; immSel = 1'b1; ALU_op = 3'b010;
            end

            11'b10101011000: begin  // ADDS
                RegWrite = 1'b1; ALU_op = 3'b010; flagWrite = 1'b1;
            end

            11'b11101011000: begin  // SUBS
                RegWrite = 1'b1; ALU_op = 3'b011; flagWrite = 1'b1;
            end

            11'b11111000010: begin  // LDUR
                RegWrite = 1'b1; ALUsrc = 1'b1; immSel = 1'b0;
                ALU_op = 3'b010; mem2reg = 2'b01;
            end

            11'b11111000000: begin  // STUR  (store data = Reg[Rd], so reg2loc=1)
                ALUsrc = 1'b1; immSel = 1'b0; ALU_op = 3'b010;
                memWrite = 1'b1; reg2loc = 1'b1;
            end

            11'b000101?????: begin  // B
                brTaken = 1'b1; uncondBr = 1'b1;
            end

            11'b100101?????: begin  // BL  (X30 = PC+4, then branch)
                brTaken = 1'b1; uncondBr = 1'b1;
                RegWrite = 1'b1; linkReg = 1'b1; mem2reg = 2'b10;
            end

            11'b10110100???: begin  // CBZ (decides on ALUzero, not flags)
                reg2loc = 1'b1; ALUsrc = 1'b0; ALU_op = 3'b000;
                brTaken = readData2_zero; uncondBr = 1'b0;
            end

            11'b01010100???: begin  // B.LT
                brTaken = (neg ^ ovrflw); uncondBr = 1'b0;
            end
            
            11'b11010110000: begin  // BR
                regBranch = 1'b1; reg2loc = 1'b1;   // route Reg[Rd] to the PC mux
            end

        endcase
    end


endmodule