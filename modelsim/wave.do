onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_spi_top/i_spi_top/Tp
add wave -noupdate /tb_spi_top/i_spi_top/i_clk
add wave -noupdate /tb_spi_top/i_spi_top/i_rst
add wave -noupdate /tb_spi_top/i_spi_top/i_adr
add wave -noupdate /tb_spi_top/i_spi_top/i_dat
add wave -noupdate /tb_spi_top/i_spi_top/o_dat
add wave -noupdate /tb_spi_top/i_spi_top/i_sel
add wave -noupdate /tb_spi_top/i_spi_top/i_we
add wave -noupdate /tb_spi_top/i_spi_top/i_stb
add wave -noupdate /tb_spi_top/i_spi_top/i_cyc
add wave -noupdate /tb_spi_top/i_spi_top/o_ack
add wave -noupdate /tb_spi_top/i_spi_top/o_err
add wave -noupdate /tb_spi_top/i_spi_top/o_intrup
add wave -noupdate /tb_spi_top/i_spi_top/o_pad_ss
add wave -noupdate /tb_spi_top/i_spi_top/o_pad_sclk
add wave -noupdate /tb_spi_top/i_spi_top/o_pad_mosi
add wave -noupdate /tb_spi_top/i_spi_top/i_pad_miso
add wave -noupdate /tb_spi_top/i_spi_top/ctrl
add wave -noupdate /tb_spi_top/i_spi_top/divider
add wave -noupdate /tb_spi_top/i_spi_top/ss
add wave -noupdate /tb_spi_top/i_spi_top/r_rx_dat
add wave -noupdate /tb_spi_top/i_spi_top/rx
add wave -noupdate /tb_spi_top/i_spi_top/rx_negedge
add wave -noupdate /tb_spi_top/i_spi_top/tx_negedge
add wave -noupdate /tb_spi_top/i_spi_top/char_len
add wave -noupdate /tb_spi_top/i_spi_top/go
add wave -noupdate /tb_spi_top/i_spi_top/lsb
add wave -noupdate /tb_spi_top/i_spi_top/ie
add wave -noupdate /tb_spi_top/i_spi_top/ass
add wave -noupdate /tb_spi_top/i_spi_top/spi_divider_sel
add wave -noupdate /tb_spi_top/i_spi_top/spi_ctrl_sel
add wave -noupdate /tb_spi_top/i_spi_top/spi_tx_sel
add wave -noupdate /tb_spi_top/i_spi_top/spi_ss_sel
add wave -noupdate /tb_spi_top/i_spi_top/tip
add wave -noupdate /tb_spi_top/i_spi_top/pos_edge
add wave -noupdate /tb_spi_top/i_spi_top/neg_edge
add wave -noupdate /tb_spi_top/i_spi_top/last_bit
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {141 ns} 0}
quietly wave cursor active 1
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {1 us}
