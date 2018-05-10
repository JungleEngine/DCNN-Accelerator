
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE ieee.std_logic_signed.all;

entity multiplier is 

port (
		-- The counter is the clock driven by the outer clock.
		clk  : in std_logic;
		start : in std_logic;
		enable : in std_logic;
		op1, op2 : in std_logic_vector(7 downto 0);
		result : out std_logic_vector(15 downto 0)

	);
end entity multiplier;


architecture arch of multiplier is 

-- A = op1 + 9 zeros, S = 2's complement of op1 + 9 zeros.
-- P = 8 zeros + op2 + 1 zero. 
-- All are 17 bit signals.
signal sig_a, sig_s, sig_p : std_logic_vector(16 downto 0);

signal  sig_adder_a, sig_adder_b, sig_addition_out: std_logic_vector(16 downto 0);
signal sig_carry_in : std_logic;

begin
  N_ADDER: entity work.NAdder generic map(n=>17)  port map 
  (sig_adder_a, sig_adder_b, sig_carry_in,sig_addition_out);

  	result <= sig_p(16 downto 1	);
	process(clk, start, sig_addition_out, sig_adder_a, sig_adder_b, enable )

	variable var_temp : std_logic_vector(16 downto 0):=(others=>'0');
	begin
		if(enable ='1') then
		--sig_addition_out<=var_addition_result;
		if (start = '1' ) then
			sig_adder_a <= ("000000000" & not op1);
			sig_adder_b <= (others=>'0');
			sig_carry_in <= '1';
			sig_a <= (op1 & "000000000");
			sig_s <= (sig_addition_out(7 downto 0) & "000000000");
			sig_p <= ("00000000" & op2 & '0');
		else 
			if(rising_edge(clk)) then
				if(sig_p(1 downto 0 )= "01") then 
					sig_adder_a <= sig_p;
					sig_adder_b <= sig_a;
					sig_carry_in <= '0';
				elsif (sig_p(1 downto 0 )= "10") then
					sig_adder_a <= sig_p;
					sig_adder_b <= sig_s;
					sig_carry_in <= '0';
				else 
					sig_adder_a <= sig_p;
					sig_adder_b <= (others=>'0');
					sig_carry_in <= '0';
				end if;
			elsif (falling_edge(clk)) then
		   		sig_p <=( sig_addition_out(16) & sig_addition_out(16 downto 1));

			end if;

		end if;
	end if;

	end process;
end;
