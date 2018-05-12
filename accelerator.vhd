
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE ieee.std_logic_signed.all;

entity accelerator is 
  


-- inst = 1 => pooling
-- size = 1 => 5*5 filter

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
  		inst : in std_logic;
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
  		cache_write : out std_logic;
  		save_result : out std_logic;
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
  signal sig_adder_first_carry : std_logic :='0';
  -- Adder signals.	
  signal sig_adder_output_r1: std_logic_vector(33 downto 0);
  signal sig_adder_output_r2: std_logic_vector(33 downto 0);
  signal sig_adder_output_r3: std_logic_vector(33 downto 0);
  signal sig_adder_output_r4: std_logic_vector(33 downto 0);
  signal sig_adder_output_r5: std_logic_vector(33 downto 0);

  signal sig_adder_output_c5 : std_logic_vector(33 downto 0);

  signal sig_multiplier_output : std_logic_vector(399 downto 0);

  signal sig_adder_stage1_output : std_logic_vector(203 downto 0);-- 12 * 17 
  signal sig_adder_stage2_output : std_logic_vector(107 downto  0); -- 6 * 18 
  signal sig_adder_stage3_output : std_logic_vector(56 downto  0); -- 3 * 19 

  signal sig_adder_stage4_output : std_logic_vector(39 downto  0); -- 2 * 20 
  signal sig_adder_stage5_output : std_logic_vector(20 downto  0); -- 1 * 21

  signal sig_adder_stage_4_input : std_logic_vector(75 downto 0);

   signal testing_adders : std_logic_vector(15 downto 0);

  signal sig_vcc : std_logic:='1';
  signal sig_ground : std_logic:='0';

  signal sig_buffer_output : std_logic_vector( 107 downto 0);

 
  -- all output
  begin 
  -- Cascaded adders. 3*3
  -- adders.
  --r1

sig_adder_stage_4_input <= sig_adder_stage3_output & "000" & sig_multiplier_output(15 downto 0);


sig_multiplier_output <= 	(x"00")&window_row1(7 downto 0)&
							(x"00")&window_row1(15 downto 8)&
							(x"00")&window_row1(23 downto 16)&
							(x"00")&window_row1(31 downto 24)&
							(x"00")&window_row1(39 downto 32)&
							
							(x"00")&window_row2(7 downto 0)&
							(x"00")&window_row2(15 downto 8)&
							(x"00")&window_row2(23 downto 16)&
							(x"00")&window_row2(31 downto 24)&
							(x"00")&window_row2(39 downto 32)&

							(x"00")&window_row3(7 downto 0)&
							(x"00")&window_row3(15 downto 8)&
							(x"00")&window_row3(23 downto 16)&
							(x"00")&window_row3(31 downto 24)&
							(x"00")&window_row3(39 downto 32)&

							(x"00")&window_row4(7 downto 0)&
							(x"00")&window_row4(15 downto 8)&
							(x"00")&window_row4(23 downto 16)&
							(x"00")&window_row4(31 downto 24)&
							(x"00")&window_row4(39 downto 32)&

							(x"00")&window_row5(7 downto 0)&
							(x"00")&window_row5(15 downto 8)&
							(x"00")&window_row5(23 downto 16)&
							(x"00")&window_row5(31 downto 24)&
							(x"00")&window_row5(39 downto 32)
						 when inst ='1'	
						else (sig_mul_output_r1 & 
						sig_mul_output_r2 & 
						sig_mul_output_r3 &
						sig_mul_output_r4
						& sig_mul_output_r5);


  	BUFF : ENTITY work.REG generic map(n=>108) PORT MAP (clk=>clk, 
  		EN => sig_vcc,
  		Q => sig_buffer_output,
  		RST => sig_ground,
  		D => sig_adder_stage2_output);

testing_adders <= sig_mul_output_r1(79 downto 64) + sig_mul_output_r2(79 downto 64);
-- STAGE 1 ---------------------------------------------------------------------
  loop_adder_stage_1: for i in 0 to 11 generate
	N_ADDER1: entity work.Adder generic map(n=>16)  port map 
			(sig_multiplier_output(399 -  i * 2 * 16 downto 399 - i * 2 * 16 - 15),
			sig_multiplier_output(399 - (i* 2 +1) * 16   downto 399 - (i* 2+1) * 16 - 15), 
			sig_adder_first_carry,
			sig_adder_stage1_output(203 - i * 17-1 downto 203 - i * 17 - 15-1),
			sig_adder_stage1_output(203 - i*17));
	end generate;
	-----------------------------------------------------------------------------
	------------------------------------------------------------------------------
	----------------------------------------------------------------------------
-- STAGE 2 
  	loop_adder_stage_2: for i in 0 to 5 generate
	N_ADDER2: entity work.Adder generic map(n=>17)  port map 
			(sig_adder_stage1_output(203 -  i * 2 * 17 downto 203 - i * 2 * 17 - 16),
			sig_adder_stage1_output(203 - (i* 2+1) * 17   downto 203 - (i* 2+1) * 17 - 16), 
			sig_adder_first_carry,
			sig_adder_stage2_output(107 - i * 18-1 downto 107 - i * 18 - 16-1),
			sig_adder_stage2_output(107 - i*18));
	end generate;
--------------------------------------------------------------------------------
---------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- STAGE 3
  	loop_adder_stage_3: for i in 0 to 2 generate
	N_ADDER4: entity work.Adder generic map(n=>18)  port map 
			(sig_buffer_output(107 -  i * 2 * 18 downto 107 - i * 2 * 18 - 17),
			sig_buffer_output(107 - (i*2+1) * 18   downto 107 - (i*2+1) * 18 - 17), 
			sig_adder_first_carry,
			sig_adder_stage3_output(56 - i * 19-1 downto 56 - i * 19 - 17-1),
			sig_adder_stage3_output(56 - i*19));
	end generate;
-----------------------------------------------------------------------------
----------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- STAGE 4

  	loop_adder_stage_4: for i in 0 to 1 generate
	N_ADDER3: entity work.Adder generic map(n=>19)  port map 
			(sig_adder_stage_4_input(75 -  i * 2 * 19 downto 75 - i * 2 * 19 - 18),
			sig_adder_stage_4_input(75 - (i*2+1) * 19   downto 75 - (i*2+1) * 19 - 18), 
			sig_adder_first_carry,
			sig_adder_stage4_output(39 - i * 20-1 downto 39 - i *20 - 18-1),
			sig_adder_stage4_output(39 - i*20));
	end generate;

-- STAGE 5 

	N_ADDER3: entity work.Adder generic map(n=>20)  port map 
			(sig_adder_stage4_output(39   downto 20),
			sig_adder_stage4_output(19 downto 0), 
			sig_adder_first_carry,
			sig_adder_stage5_output(19 downto 0),
			sig_adder_stage5_output(20));


---------------------------------------------------------------------------------
--------------------------------------------------------------------------------
 -- result 

 result <= sig_adder_stage5_output(10 downto 3) when size ='0'
 		else sig_adder_stage5_output(12 downto 5);
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

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

	if (falling_edge(clk)) then
	if (sig_multipliers_start = '1') then
		sig_multipliers_start <= '0';
		counter_clear <= '0';
	end if;
	end if;

	if(filter_ack = '1') then
		read_filter <= '0';
		sig_read_window <= '1';
	end if;

	if(result_ack = '1') then
		read_filter <= '0';
		sig_read_window <= '1';
	end if;

	if(start = '1') then
		read_filter <= '1';		
	end if;

	if(data_ack = '1') then
		sig_read_window <='0';
		counter_clear <= '1';
		sig_multipliers_start <='1';
		sig_multipliers_enable <= '1';
	end if;


	if((counter_output = "1001" and inst = '0') or (counter_output = "0001" and inst = '1')) then
	sig_multipliers_enable <='0';
	end if;

	if((counter_output = "1001" and inst = '0') or (counter_output = "0001" and inst = '1')) then
	cache_write<='1';
	else 
	cache_write <='0';
	end if;

	if((counter_output = "1010" and inst = '0') or (counter_output = "0010" and inst = '1')) then
	save_result<='1';
	else 
	save_result <='0';
	end if;
	

end process;
  end arch;

