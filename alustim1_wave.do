onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix decimal /alustim1/A
add wave -noupdate -radix decimal /alustim1/B
add wave -noupdate /alustim1/ALU_PASS_B
add wave -noupdate /alustim1/ALU_ADD
add wave -noupdate /alustim1/ALU_SUBTRACT
add wave -noupdate /alustim1/ALU_AND
add wave -noupdate /alustim1/ALU_OR
add wave -noupdate /alustim1/ALU_XOR
add wave -noupdate /alustim1/ZERO
add wave -noupdate /alustim1/cntrl
add wave -noupdate -radix decimal /alustim1/result
add wave -noupdate /alustim1/negative
add wave -noupdate /alustim1/zero
add wave -noupdate /alustim1/overflow
add wave -noupdate /alustim1/carry_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
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
WaveRestoreZoom {0 ps} {1 ns}
