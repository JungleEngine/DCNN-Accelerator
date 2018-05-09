
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE ieee.std_logic_signed.all;

entity multiplier is 

port (
		-- The counter is the clock driven by the outer clock.
		clk  : in std_logic;
		start : in std_logic;
		op1, op2 : in std_logic_vector(7 downto 0)

	);
end entity multiplier;


architecture arch of multiplier is 

-- A = op1 + 9 zeros, S = 2's complement of op1 + 9 zeros.
-- P = 8 zeros + op2 + 1 zero. 
-- All are 17 bit signals.
signal sig_a, sig_s, sig_p : std_logic_vector(16 downto 0):=(others=>'0');

begin



	process(clk, start)
	begin
		if(rising_edge(start)) then
			sig_a <= (op1 & "000000000");
			sig_s <= (std_logic_vector(unsigned(not op1 + 1)) & "000000000");
			sig_p <= ("00000000" & op2 & '0');
		else 
			if(rising_edge(clk)) then
				if(sig_p(1 downto 0 )= "01") then 
					sig_p <= (std_logic_vector(unsigned( sig_p + sig_a)));

				elsif (sig_p(1 downto 0 )= "10") then
					sig_p <= (std_logic_vector(unsigned( sig_p + sig_s)));

				else 
					sig_p <= sig_p;

				end if;
				sig_p <= ('0' & sig_p(15 downto 0));
			end if;
		
		end if;

	end process;
end;
