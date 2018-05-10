
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE ieee.std_logic_signed.all;

entity accelerator is 
  
  port(

  		clk : in std_logic;
  		start : in std_logic;
  		-- 1 or 2 pixels.
  		size : in std_logic;
  		-- Move by 1 pixel or 2.
  		stride : in std_logic;
  		filter_ack : in std_logic;
  		data_ack : in std_logic;
  		result_ack : in std_logic;

  		filter_row1,
  		filter_row2,
  		filter_row3,
  		filter_row4,
  		filter_row5 : in std_logic_vector(39 downto 0);

  		window_row1,
  		window_row2,
  		window_row3,
  		window_row4,
  		window_row5 : in std_logic_vector(39 downto 0);

  		read_filter : out std_logic;
  		read_window : out std_logic;
  		result : out std_logic_vector(7 downto 0)
	  );
    
 end entity accelerator;
  
  architecture arch of accelerator is 
  
  --signals
  signal sig_mul_output_r1,
		 sig_mul_output_r2,
		 sig_mul_output_r3,
		 sig_mul_output_r4,
		 sig_mul_output_r5 : std_logic_vector(79 downto 0);
  signal sig_start : std_logic :='0';
  signal sig_multipliers_enable : std_logic := '0';
  signal sig_read_window :std_logic :='0';
  signal sig_multipliers_start : std_logic :='0';
  signal counter_clear : std_logic :='0';
  signal counter_clock : std_logic :='0';
  signal counter_output : std_logic_vector(3 downto 0);


  -- multiplication output signals.
  -- Adder signals.	
  signal sig_adder_output_r1: std_logic_vector(79 downto 0);
  signal sig_adder_output_r2: std_logic_vector(79 downto 0);
  signal sig_adder_output_r3: std_logic_vector(79 downto 0);
  signal sig_adder_output_r4: std_logic_vector(79 downto 0);
  signal sig_adder_output_r5: std_logic_vector(79 downto 0);

  begin 
  -- Cascaded adders.
  	 adder_loop1: for i in 0 to 4 generate
    	N_ADDER: entity work.Nadder generic map(n=>16)  port map 
  		(sig_mul_output_r1, sig_mul_output_r1, sig_mul_output_r1,sig_mul_output_r1);
	end generate;
  
  counter : ENTITY work.counter PORT MAP (clock=>counter_clock, clr=>counter_clear, q=>counter_output);

  -- generate 5 rows.
  loop1: for i in 0 to 4 generate

	multiplier : ENTITY work.multiplier PORT MAP (
		clk => clk,
		enable => sig_multipliers_enable,
		start => sig_multipliers_start,
		op1 => filter_row1(39- i *8 downto 39- i*8-7),
		op2 => window_row1(39- i *8 downto 39- i*8-7),
		result => sig_mul_output_r1(79 - i*16 downto 79- i*16 - 15)
				);
    end generate;

  loop2: for i in 0 to 4 generate

	multiplier : ENTITY work.multiplier PORT MAP (
		clk => clk,
		enable => sig_multipliers_enable,
		start => sig_multipliers_start,
		op1 => filter_row2(39- i *8 downto 39- i*8-7),
		op2 => window_row2(39- i *8 downto 39- i*8-7),
		result => sig_mul_output_r2(79 - i*16 downto 79- i*16 - 15)
				);
    end generate;

  loop3: for i in 0 to 4 generate

	multiplier : ENTITY work.multiplier PORT MAP (
		clk => clk,
		enable =>sig_multipliers_enable,
		start => sig_multipliers_start,
		op1 => filter_row3(39- i *8 downto 39- i*8-7),
		op2 => window_row3(39- i *8 downto 39- i*8-7),
		result => sig_mul_output_r3(79 - i*16 downto 79- i*16 - 15)
				);
    end generate;

  
  loop4: for i in 0 to 4 generate

	multiplier : ENTITY work.multiplier PORT MAP (
		clk => clk,
		enable => sig_multipliers_enable,
		start => sig_multipliers_start,
		op1 => filter_row4(39- i *8 downto 39- i*8-7),
		op2 => window_row4(39- i *8 downto 39- i*8-7),
		result => sig_mul_output_r4(79 - i*16 downto 79- i*16 - 15)
				);
    end generate;

 
  loop5: for i in 0 to 4 generate

	multiplier : ENTITY work.multiplier PORT MAP (
		clk => clk,
		enable =>sig_multipliers_enable,
		start => sig_multipliers_start,
		op1 => filter_row5(39- i *8 downto 39- i*8-7),
		op2 => window_row5(39- i *8 downto 39- i*8-7),
		result => sig_mul_output_r5(79 - i*16 downto 79- i*16 - 15)
				);
    end generate;
counter_clock <= clk;
read_window <= sig_read_window;

process(start, clk, filter_ack, result_ack, sig_multipliers_start, data_ack,counter_output)

begin
	if(rising_edge(filter_ack) or rising_edge(result_ack)) then
		read_filter <= '0';
		sig_read_window <='1';
	end if;

	if(rising_edge(start)) then
		read_filter <= '1';		
	end if;

	if(rising_edge(data_ack)) then
		sig_read_window <='0';
		counter_clear <= '1';
		sig_multipliers_start <='1';
		sig_multipliers_enable <= '1';
	end if;

	if(sig_multipliers_start ='1' and falling_edge(clk)) then
		sig_multipliers_start <='0';
		counter_clear <= '0';
	end if;

	if(counter_output = "1001") then
	sig_multipliers_enable <='0';
	end if;


end process;
  end arch;





