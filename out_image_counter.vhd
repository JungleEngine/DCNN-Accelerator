LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE ieee.std_logic_signed.all;

entity out_image_counter is
	port (
		enable 	: in	std_logic;
		address : out	std_logic_vector(17 downto 0)
	);
end out_image_counter;


architecture out_image_counter_arch of out_image_counter is
signal sig_address: std_logic_vector(17 downto 0):="010000000000011001";--256*256 + 25
begin
	process(enable)
	begin
	  IF(rising_edge(enable)) THEN
		  sig_address <= sig_address + 1;
		ELSE sig_address <= sig_address; 
		END IF;
	end process;
	address <= sig_address;
end out_image_counter_arch;