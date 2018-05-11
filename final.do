vsim -gui -t fs work.dcnn
set StdArithNoWarnings 1
set NumericStdNoWarnings 1
mem load -i ramFilling/ram.mem /dcnn/ram/RAM
add wave -position end  sim:/dcnn/clk
add wave -position end  sim:/dcnn/rst
add wave -position end  sim:/dcnn/start
add wave -position end  sim:/dcnn/inst
add wave -position end  sim:/dcnn/size
add wave -position end  sim:/dcnn/stride
add wave -position end  sim:/dcnn/done
force -freeze sim:/dcnn/clk 1 0, 0 {50 fs} -r 100
force -freeze sim:/dcnn/rst 1 0
force -freeze sim:/dcnn/start 0 0
run
force -freeze sim:/dcnn/rst 0 0
force -freeze sim:/dcnn/start 1 0
force -freeze sim:/dcnn/inst 0 0
force -freeze sim:/dcnn/size 1 0
force -freeze sim:/dcnn/stride 0 0
add wave -position end  sim:/dcnn/accelerator/filter_ack
add wave -position end  sim:/dcnn/accelerator/data_ack
add wave -position end  sim:/dcnn/accelerator/result_ack
add wave -position end  sim:/dcnn/accelerator/read_filter
add wave -position end  sim:/dcnn/accelerator/read_window
add wave -position end  sim:/dcnn/accelerator/cache_write
add wave -position end  sim:/dcnn/accelerator/save_result
add wave -position end  sim:/dcnn/accelerator/result
add wave -position end  sim:/dcnn/accelerator/counter_output
add wave -position end  sim:/dcnn/DMA/FILTER_ACK
add wave -position end  sim:/dcnn/DMA/ram_address
add wave -position 17  sim:/dcnn/DMA/ROWS_COUNTER
add wave -position 18  sim:/dcnn/DMA/COLS_COUNTER
add wave -position end  sim:/dcnn/CACHE/filter_out_r0
add wave -position end  sim:/dcnn/CACHE/filter_out_r1
add wave -position end  sim:/dcnn/CACHE/filter_out_r2
add wave -position end  sim:/dcnn/CACHE/filter_out_r3
add wave -position end  sim:/dcnn/CACHE/filter_out_r4
add wave -position end  sim:/dcnn/CACHE/window_out_r0
add wave -position end  sim:/dcnn/CACHE/window_out_r1
add wave -position end  sim:/dcnn/CACHE/window_out_r2
add wave -position end  sim:/dcnn/CACHE/window_out_r3
add wave -position end  sim:/dcnn/CACHE/window_out_r4
add wave -position end  sim:/dcnn/CACHE/result_in
add wave -position end  sim:/dcnn/CACHE/result_out
run 2100
run 76908500
mem save -o result.mem -f mti -data unsigned -addr dec -startaddress 65562 -endaddress 129065 -wordsperline 1 /dcnn/ram/RAM