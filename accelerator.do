#accelerator do file

vsim -gui work.accelerator

add wave -position insertpoint sim:/accelerator/*

force -freeze sim:/accelerator/clk 1 0, 0 {50 ps} -r 100

#mul 11h * 33h


force -freeze sim:/accelerator/filter_row1 x\"0500000000\" 0
force -freeze sim:/accelerator/filter_row2 x\"0600000000\" 0
force -freeze sim:/accelerator/filter_row3 x\"0700000000\" 0
force -freeze sim:/accelerator/filter_row4 x\"0000000015\" 0
force -freeze sim:/accelerator/filter_row5 x\"1500000000\" 0

force -freeze sim:/accelerator/window_row1 x\"3300000000\" 0
force -freeze sim:/accelerator/window_row2 x\"4400000000\" 0
force -freeze sim:/accelerator/window_row3 x\"5500000000\" 0
force -freeze sim:/accelerator/window_row4 x\"0000000066\" 0
force -freeze sim:/accelerator/window_row5 x\"7700000000\" 0
 

force -freeze sim:/accelerator/inst 0 0
force -freeze sim:/accelerator/size 0 0
force -freeze sim:/accelerator/size 1 0

force -freeze sim:/accelerator/filter_ack 0 0
force -freeze sim:/accelerator/data_ack 0 0
force -freeze sim:/accelerator/start 0 0

run  
force -freeze sim:/accelerator/start 1 0
run
force -freeze sim:/accelerator/filter_ack 1 0
run
force -freeze sim:/accelerator/data_ack 1 0
run 1400
