LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE ieee.std_logic_signed.all;


entity dcnn is
	port (
		clk 		: in 	std_logic;
		rst 		: in	std_logic;
		start 		: in 	std_logic;
		inst 		: in 	std_logic;
		size 		: in 	std_logic;
		stride 		: in 	std_logic;
		done 		: in 	std_logic;
		ram_data_bus: INOUT std_logic_vector(39 downto 0)

	);
end dcnn;



architecture dcnn_arch of dcnn is
signal READ_FILTER:std_logic;
signal READ_WINDOW:std_logic;
signal FILTER_ACK:std_logic;
signal DATA_ACK:std_logic;
signal save_result:std_logic;
signal ram_address:std_logic_vector(17 downto 0);
signal cache_write_filter:std_logic;
signal cache_write_window:std_logic;
signal cache_write_result:std_logic;
signal save_out_img_ram:std_logic;
signal result_ack:std_logic;
signal cache_result_value_in:std_logic_vector(7 downto 0);
signal cache_result_value_out:std_logic_vector(7 downto 0);
signal filter_out_r0 : std_logic_vector(39 downto 0);
signal filter_out_r1 : std_logic_vector(39 downto 0);
signal filter_out_r2 : std_logic_vector(39 downto 0);
signal filter_out_r3 : std_logic_vector(39 downto 0);
signal filter_out_r4 : std_logic_vector(39 downto 0);
signal window_out_r0 : std_logic_vector(39 downto 0);
signal window_out_r1 : std_logic_vector(39 downto 0);
signal window_out_r2 : std_logic_vector(39 downto 0);
signal window_out_r3 : std_logic_vector(39 downto 0);
signal window_out_r4 : std_logic_vector(39 downto 0);
begin
	DMA: ENTITY work.DMA PORT MAP(
		CLK 				=>	clk,
		RST 				=>	rst,
		size 				=>	size,
		STRIDE 				=> 	stride,
		result_write		=> save_out_img_ram,

		READ_FILTER			=>	READ_FILTER,
		READ_WINDOW			=>	READ_WINDOW,
		FILTER_ACK 			=> 	FILTER_ACK,
		DATA_ACK 			=> DATA_ACK,
		save_out_img_ram	=> save_out_img_ram,
		result_ack 			=> result_ack,
		ram_address 		=> ram_address,
		cache_write_filter	=> cache_write_filter,
		cache_write_window	=> cache_write_window
		);
	CACHE: ENTITY work.cache port map (
			clk				=>	clk,
			rst				=>	rst,
			filter_shift	=>	cache_write_filter,
			window_shift	=>	cache_write_window,
			result_write 	=>	cache_write_result, --from accelerator
			result_in		=>	cache_result_value_in,
			result_out		=>	cache_result_value_out,
			serial_in		=>	ram_data_bus,
			filter_out_r0	=>	filter_out_r0,
			filter_out_r1	=>	filter_out_r1,
			filter_out_r2	=>	filter_out_r2,
			filter_out_r3	=>	filter_out_r3,
			filter_out_r4	=>	filter_out_r4,
			window_out_r0	=>	window_out_r0,
			window_out_r1	=>	window_out_r1,
			window_out_r2	=>	window_out_r2,
			window_out_r3	=>	window_out_r3,
			window_out_r4	=>	window_out_r4
	);
	accelerator: ENTITY work.accelerator port map (
	
		clk 			 	=>	clk,
		start  				=>	start,
		size  				=>	size,
		stride  			=>	stride,
		inst 				=> 	inst,
		filter_ack  		=>	filter_ack,
		data_ack  			=>	data_ack,
		result_ack  		=>	result_ack,
		filter_row1 		=>	filter_out_r0,
		filter_row2 		=>	filter_out_r1,	
		filter_row3 		=>	filter_out_r2,	
		filter_row4 		=>	filter_out_r3,	
		filter_row5  		=>	filter_out_r4,	
		window_row1			=>	window_out_r0,
		window_row2			=>	window_out_r1,
		window_row3			=>	window_out_r2,
		window_row4			=>	window_out_r3,
		window_row5			=>	window_out_r4,
		read_filter			=>	read_filter,
		read_window			=>	read_window,
		result				=>	cache_result_value_in,
		cache_write 		=> 	cache_write_result,
		save_result  		=> 	save_out_img_ram
	);

	ram: ENTITY work.ram port map(
		CLK 				=> clk,
		WRITE_ENABLE 		=> save_out_img_ram,
		ADDRESS 			=>ram_address,
		DATA_IN 			=>cache_result_value_out,
		DATA_OUT 			=>ram_data_bus
	);
end dcnn_arch;