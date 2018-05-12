LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE ieee.std_logic_signed.all;


entity shift_registers is
	GENERIC(N : integer := 40);
	port (
			clk 		: in 	std_logic;
			rst 		: in 	std_logic;
			shift 		: in 	std_logic; --to shift all the registers
			data_in 	: in 	std_logic_vector(N-1 downto 0);
			row0_out	: out 	std_logic_vector(N-1 downto 0); 
			row1_out	: out 	std_logic_vector(N-1 downto 0); 
			row2_out	: out 	std_logic_vector(N-1 downto 0); 
			row3_out	: out 	std_logic_vector(N-1 downto 0); 
			row4_out	: out 	std_logic_vector(N-1 downto 0)
			);
end entity shift_registers;

architecture shift_registers_arch of shift_registers is

signal sig_row0_out	: std_logic_vector(N-1 downto 0); 
signal sig_row1_out	: std_logic_vector(N-1 downto 0); 
signal sig_row2_out	: std_logic_vector(N-1 downto 0); 
signal sig_row3_out	: std_logic_vector(N-1 downto 0); 
signal sig_row4_out	: std_logic_vector(N-1 downto 0); 
signal inv_clk : std_logic;

begin
	row0_out<=sig_row0_out;
	row1_out<=sig_row1_out;
	row2_out<=sig_row2_out;
	row3_out<=sig_row3_out;
	row4_out<=sig_row4_out;
	
	inv_clk <= not clk;
	
	Row0_Register: ENTITY work.Reg PORT MAP(
		D 		=>data_in, 
		EN 		=>shift,
		CLK 	=>inv_clk,
		RST 	=>rst,
		Q 		=>sig_row0_out
		); 
	Row1_Register: ENTITY work.Reg PORT MAP(
		D 		=>sig_row0_out, 
		EN 		=>shift,
		CLK 	=>inv_clk,
		RST 	=>rst,
		Q 		=>sig_row1_out
		); 
	Row2_Register: ENTITY work.Reg PORT MAP(
		D 		=>sig_row1_out, 
		EN 		=>shift,
		CLK 	=>inv_clk,
		RST 	=>rst,
		Q 		=>sig_row2_out
		); 
	Row3_Register: ENTITY work.Reg PORT MAP(
		D 		=>sig_row2_out, 
		EN 		=>shift,
		CLK 	=>inv_clk,
		RST 	=>rst,
		Q 		=>sig_row3_out
		); 
	Row4_Register: ENTITY work.Reg PORT MAP(
		D 		=>sig_row3_out, 
		EN 		=>shift,
		CLK 	=>inv_clk,
		RST 	=>rst,
		Q 		=>sig_row4_out
		); 

end shift_registers_arch ;
