vlib work
vmap work work
vlog -f filelist
vsim -novopt work.top_tb

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top_tb/clk_in
add wave -noupdate /top_tb/rst
add wave -noupdate /top_tb/enable
add wave -noupdate /top_tb/go
add wave -noupdate /top_tb/last_clk
add wave -noupdate /top_tb/divider
add wave -noupdate /top_tb/clk_out
add wave -noupdate /top_tb/pos_edge
add wave -noupdate /top_tb/neg_edge
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {109832050 ps} 0} {{Cursor 2} {109850410 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {109797260 ps} {110021200 ps}

run 30000ns