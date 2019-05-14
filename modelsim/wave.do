onerror {resume}
quietly virtual signal -install /tb_spi_top/i_spi_top { /tb_spi_top/i_spi_top/wb_adr_i[4:2]} SPI_OFS_BITS
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_spi_top/i_spi_top/Tp
add wave -noupdate /tb_spi_top/i_spi_top/wb_clk_i
add wave -noupdate /tb_spi_top/i_spi_top/wb_rst_i
add wave -noupdate -expand /tb_spi_top/i_spi_top/SPI_OFS_BITS
add wave -noupdate -color Gold -subitemconfig {{/tb_spi_top/i_spi_top/wb_adr_i[4]} {-color Gold} {/tb_spi_top/i_spi_top/wb_adr_i[3]} {-color Gold} {/tb_spi_top/i_spi_top/wb_adr_i[2]} {-color Gold} {/tb_spi_top/i_spi_top/wb_adr_i[1]} {-color Gold} {/tb_spi_top/i_spi_top/wb_adr_i[0]} {-color Gold}} /tb_spi_top/i_spi_top/wb_adr_i
add wave -noupdate -color Magenta /tb_spi_top/i_spi_top/wb_dat_i
add wave -noupdate /tb_spi_top/i_spi_top/wb_dat_o
add wave -noupdate /tb_spi_top/i_spi_top/wb_sel_i
add wave -noupdate /tb_spi_top/i_spi_top/wb_we_i
add wave -noupdate /tb_spi_top/i_spi_top/wb_stb_i
add wave -noupdate /tb_spi_top/i_spi_top/wb_cyc_i
add wave -noupdate /tb_spi_top/i_spi_top/wb_ack_o
add wave -noupdate /tb_spi_top/i_spi_top/wb_err_o
add wave -noupdate /tb_spi_top/i_spi_top/wb_int_o
add wave -noupdate /tb_spi_top/i_spi_top/ss_pad_o
add wave -noupdate -color {Orange Red} -itemcolor {Orange Red} /tb_spi_top/i_spi_top/sclk_pad_o
add wave -noupdate -color {Medium Violet Red} /tb_spi_top/i_spi_top/mosi_pad_o
add wave -noupdate /tb_spi_top/i_spi_top/miso_pad_i
add wave -noupdate /tb_spi_top/i_spi_top/divider
add wave -noupdate /tb_spi_top/i_spi_top/ctrl
add wave -noupdate /tb_spi_top/i_spi_top/ss
add wave -noupdate /tb_spi_top/i_spi_top/wb_dat
add wave -noupdate /tb_spi_top/i_spi_top/rx
add wave -noupdate /tb_spi_top/i_spi_top/rx_negedge
add wave -noupdate /tb_spi_top/i_spi_top/tx_negedge
add wave -noupdate /tb_spi_top/i_spi_top/char_len
add wave -noupdate -color Gold /tb_spi_top/i_spi_top/go
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
WaveRestoreCursors {{Cursor 1} {253 ns} 0} {{Cursor 2} {552 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 366
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
WaveRestoreZoom {162 ns} {448 ns}
