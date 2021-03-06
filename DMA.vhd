LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY DMA IS
	PORT(
	CLK: IN std_logic;
	RST: IN std_logic;
	SIZE: IN std_logic;
	STRIDE: IN std_logic;
	result_write: IN std_logic;
	READ_FILTER: IN std_logic;
	READ_WINDOW: IN std_logic;
	FILTER_ACK: OUT std_logic;
	DATA_ACK: OUT std_logic;
	save_out_img_ram: IN std_logic;
	result_ack: out std_logic;
	DONE: out std_logic;
	ram_address: out std_logic_vector(17 downto 0);
	cache_write_filter: out std_logic;
	cache_write_window: out std_logic
		);
END DMA;


ARCHITECTURE DMA_ARCH OF DMA IS

SIGNAL VCC: std_logic := '1';
SIGNAL GND: std_logic := '0';

SIGNAL NEW_RAM_ADDRESS: std_logic_vector(17 DOWNTO 0);
SIGNAL RAM_ADDRESS_VALUE: std_logic_vector(17 DOWNTO 0);

SIGNAL COUNTERS_VALUE: std_logic_vector(15 DOWNTO 0);
SIGNAL ROWS_COUNTER: std_logic_vector(7 DOWNTO 0);
SIGNAL COLS_COUNTER: std_logic_vector(7 DOWNTO 0);

SIGNAL INPUT_SIGNALS: std_logic_vector(2 DOWNTO 0);
SIGNAL BUFFERED_SIGNALS: std_logic_vector(2 DOWNTO 0);
SIGNAL BUFFERED_READ_FILTER: std_logic;
SIGNAL BUFFERED_READ_WINDOW: std_logic;
SIGNAL SIG_READ_FILTER: std_logic := '0'; 
SIGNAL SIG_READ_WINDOW: std_logic := '0'; 
SIGNAL SIG_FILTER_ACK: std_logic;
SIGNAL SIG_DATA_ACK: std_logic;

SIGNAL SIG_DONE: std_logic;

SIGNAL DATA_READ_ENABLE: std_logic;

SIGNAL COUNTERS_RESET: std_logic;
SIGNAL ram_address_result:std_logic_vector(17 downto 0);
SIGNAL OUT_IMAGE_ADDRESS: std_logic_vector(17 downto 0):=(others=>'0');

BEGIN


	ram_address<=ram_address_result when(result_write='1')
	else NEW_RAM_ADDRESS;
	  
	out_address: ENTITY work.out_image_counter PORT MAP(
		enable 	=> 	save_out_img_ram,
		address => 	ram_address_result
		);
	--Address of outImage

	SIGNALS_BUFFER: ENTITY work.REG GENERIC MAP(n => 3) PORT MAP 
	(
		D => INPUT_SIGNALS,
		EN => VCC,
		CLK => CLK,
		RST => RST,
		Q => BUFFERED_SIGNALS
	);

	RAM_ADDRESS_REG: ENTITY work.REG GENERIC MAP(n => 18) PORT MAP 
	(
		D => NEW_RAM_ADDRESS,
		EN => DATA_READ_ENABLE,
		CLK => CLK,
		RST => RST,
		Q => RAM_ADDRESS_VALUE
	);

	COUNTER: ENTITY work.DMA_COUNTER PORT MAP 
	(
		CLK => CLK,
		RST => COUNTERS_RESET,
		EN => DATA_READ_ENABLE,
		STRIDE => STRIDE,
		Q => COUNTERS_VALUE
	);	

	RAR: ENTITY work.RAM_ADDRESS_RESOLVER PORT MAP 
	( 
		SIZE => SIZE,
		READ_FILTER => SIG_READ_FILTER,
		ROWS_COUNTER => ROWS_COUNTER,
		COLS_COUNTER => COLS_COUNTER,
		RAM_ADDRESS_VALUE => RAM_ADDRESS_VALUE,
		Q => NEW_RAM_ADDRESS
	);

	ROWS_COUNTER <= COUNTERS_VALUE(7 DOWNTO 0);
	COLS_COUNTER <= COUNTERS_VALUE(15 DOWNTO 8);

	FILTER_ACK <= SIG_FILTER_ACK;
	DATA_ACK <= SIG_DATA_ACK;

	BUFFERED_READ_FILTER<= BUFFERED_SIGNALS(0);
	BUFFERED_READ_WINDOW<= BUFFERED_SIGNALS(1);
	result_ack 			<= BUFFERED_SIGNALS(2);
	SIG_READ_FILTER <= (READ_FILTER or BUFFERED_READ_FILTER) and (NOT SIG_FILTER_ACK) and (NOT SIG_DONE);
	SIG_READ_WINDOW <= (READ_WINDOW or BUFFERED_READ_WINDOW) and (NOT SIG_DATA_ACK) and (NOT SIG_DONE);

	INPUT_SIGNALS <= ( save_out_img_ram or SIG_DONE )& SIG_READ_WINDOW & SIG_READ_FILTER;

	DATA_READ_ENABLE <= SIG_READ_FILTER or SIG_READ_WINDOW;
  
  	cache_write_window <= SIG_READ_WINDOW;
  	cache_write_filter <= SIG_READ_FILTER;

  COUNTERS_RESET <= '1' WHEN (RST = '1') or 
                             (SIG_FILTER_ACK = '1' and ROWS_COUNTER = "00000101" and SIZE  = '1') or 
                             (SIG_FILTER_ACK = '1' and ROWS_COUNTER = "00000011" and SIZE  = '0')
  ELSE '0';
  
  
  SIG_DONE <= '1' when (BUFFERED_SIGNALS(2) = '1' and ROWS_COUNTER = "00000000" and ((COLS_COUNTER = "11111110" and SIZE = '0') or (COLS_COUNTER = "11111100" and SIZE = '1')))            
  else '0';
    
  DONE <= SIG_DONE;
    
	PROCESS(CLK)
	BEGIN
		IF (rising_edge(CLK)) THEN
		  IF ((SIZE = '1' and ROWS_COUNTER >= "00000100") or (SIZE = '0' and ROWS_COUNTER >= "00000010")) THEN
			  IF (SIG_READ_FILTER = '1') THEN
				  SIG_FILTER_ACK <= '1';
				  SIG_DATA_ACK <= '0';
			  ELSIF (SIG_READ_WINDOW = '1' and (STRIDE = '0' or (STRIDE = '1' and ROWS_COUNTER(0) = '1'))) THEN
				  SIG_DATA_ACK <= '1';
				  SIG_FILTER_ACK <= '0';
				ELSE 
				SIG_DATA_ACK <= '0';
			    SIG_FILTER_ACK <= '0';
			  END IF;
		  ELSE 
				SIG_DATA_ACK <= '0';
				SIG_FILTER_ACK <= '0';
		  END IF;
	  END IF;
	END PROCESS;

END DMA_ARCH;