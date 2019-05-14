onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_spi_top/i_spi_top/shift/Tp
add wave -noupdate /tb_spi_top/i_spi_top/shift/clk
add wave -noupdate /tb_spi_top/i_spi_top/shift/rst
add wave -noupdate /tb_spi_top/i_spi_top/shift/latch
add wave -noupdate /tb_spi_top/i_spi_top/shift/byte_sel
add wave -noupdate /tb_spi_top/i_spi_top/shift/len
add wave -noupdate /tb_spi_top/i_spi_top/shift/lsb
add wave -noupdate /tb_spi_top/i_spi_top/shift/go
add wave -noupdate /tb_spi_top/i_spi_top/shift/pos_edge
add wave -noupdate /tb_spi_top/i_spi_top/shift/neg_edge
add wave -noupdate /tb_spi_top/i_spi_top/shift/rx_negedge
add wave -noupdate /tb_spi_top/i_spi_top/shift/tx_negedge
add wave -noupdate /tb_spi_top/i_spi_top/shift/tip
add wave -noupdate /tb_spi_top/i_spi_top/shift/last
add wave -noupdate /tb_spi_top/i_spi_top/shift/p_in
add wave -noupdate /tb_spi_top/i_spi_top/shift/p_out
add wave -noupdate /tb_spi_top/i_spi_top/shift/s_clk
add wave -noupdate /tb_spi_top/i_spi_top/shift/s_in
add wave -noupdate /tb_spi_top/i_spi_top/shift/s_out
add wave -noupdate /tb_spi_top/i_spi_top/shift/cnt
add wave -noupdate /tb_spi_top/i_spi_top/shift/data
add wave -noupdate /tb_spi_top/i_spi_top/shift/tx_bit_pos
add wave -noupdate /tb_spi_top/i_spi_top/shift/rx_bit_pos
add wave -noupdate /tb_spi_top/i_spi_top/shift/rx_clk
add wave -noupdate /tb_spi_top/i_spi_top/shift/tx_clk
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {157 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 387
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {854 ns}
