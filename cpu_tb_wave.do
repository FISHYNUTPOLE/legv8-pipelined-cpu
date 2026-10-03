onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cpu_tb/dut/clk
add wave -noupdate /cpu_tb/dut/reset
add wave -noupdate -radix hexadecimal /cpu_tb/dut/dp/instruction_fetch/imem/instruction
add wave -noupdate /cpu_tb/dut/flags
add wave -noupdate /cpu_tb/dut/RegWrite
add wave -noupdate /cpu_tb/dut/ALUsrc
add wave -noupdate /cpu_tb/dut/memWrite
add wave -noupdate /cpu_tb/dut/reg2loc
add wave -noupdate /cpu_tb/dut/uncondBr
add wave -noupdate /cpu_tb/dut/brTaken
add wave -noupdate /cpu_tb/dut/regBranch
add wave -noupdate /cpu_tb/dut/immSel
add wave -noupdate /cpu_tb/dut/linkReg
add wave -noupdate /cpu_tb/dut/flagWrite
add wave -noupdate /cpu_tb/dut/mem2reg
add wave -noupdate /cpu_tb/dut/ALU_op
add wave -noupdate /cpu_tb/dut/dp/Instruction_Decode/rf/regOut
add wave -noupdate /cpu_tb/dut/dp/Instruction_Decode/regWriteData
add wave -noupdate /cpu_tb/dut/dp/Instruction_Decode/regWriteAddr
add wave -noupdate /cpu_tb/dut/dp/clk
add wave -noupdate /cpu_tb/dut/dp/reset
add wave -noupdate /cpu_tb/dut/dp/RegWrite
add wave -noupdate /cpu_tb/dut/dp/ALUsrc
add wave -noupdate /cpu_tb/dut/dp/memWrite
add wave -noupdate /cpu_tb/dut/dp/reg2loc
add wave -noupdate /cpu_tb/dut/dp/uncondBr
add wave -noupdate /cpu_tb/dut/dp/brTaken
add wave -noupdate /cpu_tb/dut/dp/regBranch
add wave -noupdate /cpu_tb/dut/dp/immSel
add wave -noupdate /cpu_tb/dut/dp/linkReg
add wave -noupdate /cpu_tb/dut/dp/flagWrite
add wave -noupdate /cpu_tb/dut/dp/ALU_op
add wave -noupdate /cpu_tb/dut/dp/mem2reg
add wave -noupdate /cpu_tb/dut/dp/readData2_zero
add wave -noupdate /cpu_tb/dut/dp/flags
add wave -noupdate /cpu_tb/dut/dp/control_opc
add wave -noupdate -radix unsigned /cpu_tb/dut/dp/pc_curr
add wave -noupdate /cpu_tb/dut/dp/pc4_IF
add wave -noupdate /cpu_tb/dut/dp/br_pc
add wave -noupdate /cpu_tb/dut/dp/instr_IF
add wave -noupdate /cpu_tb/dut/dp/instr_ID
add wave -noupdate /cpu_tb/dut/dp/pc_ID
add wave -noupdate /cpu_tb/dut/dp/pc4_ID
add wave -noupdate /cpu_tb/dut/dp/readData1_ID
add wave -noupdate /cpu_tb/dut/dp/readData2_ID
add wave -noupdate -radix unsigned /cpu_tb/dut/dp/imm_ID
add wave -noupdate /cpu_tb/dut/dp/DAddr9_se_ID
add wave -noupdate -radix unsigned /cpu_tb/dut/dp/Rn_ID
add wave -noupdate -radix unsigned /cpu_tb/dut/dp/Rm_ID
add wave -noupdate -radix unsigned /cpu_tb/dut/dp/Rd_ID
add wave -noupdate /cpu_tb/dut/dp/regWriteAddr
add wave -noupdate /cpu_tb/dut/dp/stall
add wave -noupdate /cpu_tb/dut/dp/readData1_EX
add wave -noupdate /cpu_tb/dut/dp/readData2_EX
add wave -noupdate /cpu_tb/dut/dp/imm_EX
add wave -noupdate -radix decimal /cpu_tb/dut/dp/execute/fwdMuxOut1
add wave -noupdate -radix decimal /cpu_tb/dut/dp/aluIn2
add wave -noupdate -radix decimal /cpu_tb/dut/dp/aluResult_EX
add wave -noupdate /cpu_tb/dut/dp/DAddr9_se_EX
add wave -noupdate /cpu_tb/dut/dp/pc4_EX
add wave -noupdate -radix unsigned /cpu_tb/dut/dp/Rn_EX
add wave -noupdate -radix unsigned /cpu_tb/dut/dp/Rm_EX
add wave -noupdate -radix unsigned /cpu_tb/dut/dp/Rd_EX
add wave -noupdate /cpu_tb/dut/dp/fwdA
add wave -noupdate /cpu_tb/dut/dp/fwdB
add wave -noupdate /cpu_tb/dut/dp/mem2reg_EX
add wave -noupdate /cpu_tb/dut/dp/flags_live
add wave -noupdate /cpu_tb/dut/dp/flags_stored
add wave -noupdate /cpu_tb/dut/dp/ALUsrc_EX
add wave -noupdate /cpu_tb/dut/dp/memWrite_EX
add wave -noupdate /cpu_tb/dut/dp/flagWrite_EX
add wave -noupdate /cpu_tb/dut/dp/RegWrite_EX
add wave -noupdate /cpu_tb/dut/dp/linkReg_EX
add wave -noupdate /cpu_tb/dut/dp/immSel_EX
add wave -noupdate /cpu_tb/dut/dp/ALU_op_EX
add wave -noupdate /cpu_tb/dut/dp/aluResult_MEM
add wave -noupdate /cpu_tb/dut/dp/memData_MEM
add wave -noupdate /cpu_tb/dut/dp/pc4_MEM
add wave -noupdate /cpu_tb/dut/dp/readData2_MEM
add wave -noupdate /cpu_tb/dut/dp/Rd_MEM
add wave -noupdate /cpu_tb/dut/dp/memWrite_MEM
add wave -noupdate /cpu_tb/dut/dp/RegWrite_MEM
add wave -noupdate /cpu_tb/dut/dp/linkReg_MEM
add wave -noupdate /cpu_tb/dut/dp/mem2reg_MEM
add wave -noupdate /cpu_tb/dut/dp/aluResult_WB
add wave -noupdate /cpu_tb/dut/dp/memData_WB
add wave -noupdate /cpu_tb/dut/dp/writeBackData
add wave -noupdate /cpu_tb/dut/dp/pc4_WB
add wave -noupdate /cpu_tb/dut/dp/Rd_WB
add wave -noupdate /cpu_tb/dut/dp/RegWrite_WB
add wave -noupdate /cpu_tb/dut/dp/linkReg_WB
add wave -noupdate /cpu_tb/dut/dp/mem2reg_WB
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {98859251 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1641446 ps}
