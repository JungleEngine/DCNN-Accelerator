vsim -gui work.dma
add wave -position end  sim:/dma/CLK
add wave -position end  sim:/dma/RST
add wave -position end  sim:/dma/SIZE
add wave -position end  sim:/dma/STRIDE
add wave -position end  sim:/dma/READ_FILTER
add wave -position end  sim:/dma/READ_WINDOW
add wave -position end  sim:/dma/FILTER_ACK
add wave -position end  sim:/dma/DATA_ACK
add wave -position end  sim:/dma/NEW_RAM_ADDRESS
add wave -position end  sim:/dma/RAM_ADDRESS_VALUE
add wave -position 10  sim:/dma/COUNTERS_VALUE
add wave -position end  sim:/dma/ROWS_COUNTER
add wave -position end  sim:/dma/COLS_COUNTER
add wave -position end  sim:/dma/BUFFERED_READ_FILTER
add wave -position end  sim:/dma/BUFFERED_READ_WINDOW
add wave -position end  sim:/dma/SIG_READ_FILTER
add wave -position end  sim:/dma/SIG_READ_WINDOW
add wave -position end  sim:/dma/DATA_READ_ENABLE
force -freeze sim:/dma/CLK 1 0, 0 {50 ps} -r 100
force -freeze sim:/dma/RST 1 0
force -freeze sim:/dma/SIZE 1 0
force -freeze sim:/dma/STRIDE 1 0
run
force -freeze sim:/dma/RST 0 0
force -freeze sim:/dma/READ_FILTER 1 0
force -freeze sim:/dma/READ_WINDOW 0 0
run
force -freeze sim:/dma/READ_FILTER 0 0
run
run
run
run
force -freeze sim:/dma/READ_WINDOW 1 0
run
force -freeze sim:/dma/READ_WINDOW 0 0
run
run
run
run
run
run
run
run
force -freeze sim:/dma/READ_WINDOW 1 0
run
force -freeze sim:/dma/READ_WINDOW 0 0
run
run