vlib work
vmap work work
vlog +incdir+C:/dev/rtl/spi -f top_sim_filelist 
vsim -novopt work.tb_spi_top
do wave.do
run 1500ns