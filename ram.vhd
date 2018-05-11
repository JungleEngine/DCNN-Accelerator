LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY RAM IS
	PORT(
		CLK: IN std_logic;
		WRITE_ENABLE: IN std_logic;
		ADDRESS: IN std_logic_vector(17 DOWNTO 0);
		DATA_IN: IN std_logic_vector(7 DOWNTO 0);
		DATA_OUT: OUT std_logic_vector(39 DOWNTO 0)
	);
END ENTITY RAM;

ARCHITECTURE RAM_ARCH OF RAM IS  

TYPE RAM_TYPE IS ARRAY(0 TO 131097) of std_logic_vector(7 DOWNTO 0);
SIGNAL RAM: RAM_TYPE;

BEGIN

	PROCESS(CLK) IS
		BEGIN
		IF (rising_edge(CLK) and WRITE_ENABLE = '1') THEN
			RAM(to_integer(unsigned(ADDRESS))) <= DATA_IN;
		END IF;
	END PROCESS;

	DATA_OUT(7 DOWNTO 0) <= RAM(to_integer(unsigned(ADDRESS)));
	DATA_OUT(15 DOWNTO 8) <= RAM(to_integer(unsigned(ADDRESS))+1);
	DATA_OUT(23 DOWNTO 16) <= RAM(to_integer(unsigned(ADDRESS))+2);
	DATA_OUT(31 DOWNTO 24) <= RAM(to_integer(unsigned(ADDRESS))+3);
	DATA_OUT(39 DOWNTO 32) <= RAM(to_integer(unsigned(ADDRESS))+4);

END RAM_ARCH;
