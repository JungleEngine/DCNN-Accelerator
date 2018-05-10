
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE IEEE.std_logic_signed.all;

ENTITY DMA_COUNTER IS
	PORT(
	CLK: IN std_logic;
	RST: IN std_logic;
	EN: IN std_logic;
	STRIDE: IN std_logic;
	Q: OUT std_logic_vector(15 downto 0)
	);
END DMA_COUNTER;

ARCHITECTURE behavioural OF DMA_COUNTER IS

SIGNAL COUNTER_VALUE: std_logic_vector(15 downto 0);

BEGIN
	PROCESS (CLK, RST, EN)
	BEGIN
		IF (RST = '1') THEN
			COUNTER_VALUE <= "0000000000000000";
		ELSIF (rising_edge(CLK) and EN = '1') THEN
			IF (STRIDE = '1' and COUNTER_VALUE(7 DOWNTO 0) = "11111111") THEN
				COUNTER_VALUE <= COUNTER_VALUE + "0000000100000001";
			ELSE 
				COUNTER_VALUE <= COUNTER_VALUE + 1;
			END IF;
		END IF;
	END PROCESS;

	Q <= COUNTER_VALUE;
	
END behavioural;
