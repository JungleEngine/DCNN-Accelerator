vsim work.cache
add wave -position end  sim:/cache/clk
add wave -position end  sim:/cache/rst
add wave -position end  sim:/cache/shift
add wave -position end  sim:/cache/reading_filter
add wave -position end  sim:/cache/serial_in
add wave -position end  sim:/cache/filter_out_r0
add wave -position end  sim:/cache/filter_out_r1
add wave -position end  sim:/cache/filter_out_r2
add wave -position end  sim:/cache/filter_out_r3
add wave -position end  sim:/cache/filter_out_r4

force -freeze sim:/cache/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/cache/rst 1 0
force -freeze sim:/cache/shift 0 0
force -freeze sim:/cache/serial_in x\"00000000F\" 0
run
force -freeze sim:/cache/rst 0 0
force -freeze sim:/cache/reading_filter 1 0
force -freeze sim:/cache/shift 1 0
force -freeze sim:/cache/rst 0 0
run
force -freeze sim:/cache/shift 1 0
force -freeze sim:/cache/serial_in x\"0000000F0\" 0
run
force -freeze sim:/cache/shift 1 0
force -freeze sim:/cache/serial_in x\"000000F00\" 0
run
force -freeze sim:/cache/shift 1 0
force -freeze sim:/cache/serial_in x\"00000F000\" 0
run
force -freeze sim:/cache/shift 1 0
force -freeze sim:/cache/serial_in x\"0000F0000\" 0
run
force -freeze sim:/cache/shift 0 0
run