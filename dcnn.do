vsim work.dcnn
add wave -position end  sim:/dcnn/clk
add wave -position end  sim:/dcnn/rst
add wave -position end  sim:/dcnn/READ_FILTER
add wave -position end  sim:/dcnn/READ_WINDOW
add wave -position end  sim:/dcnn/FILTER_ACK
add wave -position insertpoint  \
sim:/dcnn/DATA_ACK \
sim:/dcnn/save_result \
sim:/dcnn/ram_address \
sim:/dcnn/cache_write_filter \
sim:/dcnn/cache_write_window \
sim:/dcnn/cache_write_result \
sim:/dcnn/save_out_img_ram \
sim:/dcnn/result_ack \
sim:/dcnn/cache_result_value_in \
sim:/dcnn/cache_result_value_out \
sim:/dcnn/filter_out_r0 \
sim:/dcnn/filter_out_r1 \
sim:/dcnn/filter_out_r2 \
sim:/dcnn/filter_out_r3 \
sim:/dcnn/filter_out_r4 \
sim:/dcnn/window_out_r0 \
sim:/dcnn/window_out_r1 \
sim:/dcnn/window_out_r2 \
sim:/dcnn/window_out_r3 \
sim:/dcnn/window_out_r4

add wave -position insertpoint  \
sim:/dcnn/accelerator/read_filter
add wave -position insertpoint  \
sim:/dcnn/accelerator/read_window
add wave -position insertpoint  \
sim:/dcnn/accelerator/save_result
add wave -position insertpoint  \
sim:/dcnn/accelerator/save_out_img_ram


force -freeze sim:/dcnn/size 0 0
force -freeze sim:/dcnn/stride 0 0
force -freeze sim:/dcnn/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/dcnn/rst 1 0
force -freeze sim:/dcnn/accelerator/read_filter 0 0
force -freeze sim:/dcnn/accelerator/read_window 0 0
force -freeze sim:/dcnn/accelerator/save_result 0 0
force -freeze sim:/dcnn/accelerator/save_out_img_ram 0 0
run
force -freeze sim:/dcnn/rst 0 0
force -freeze sim:/dcnn/accelerator/read_filter 1 0
run
force -freeze sim:/dcnn/accelerator/read_filter 0 0
run