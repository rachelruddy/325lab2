library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY g10_sine_oscillator_tb is
END g10_sine_oscillator_tb;

ARCHITECTURE behavior of g10_sine_oscillator_tb is
	component g10_sine_oscillator is
		port(
			clk, reset : in std_logic;
			f: in signed(23 downto 0);
			cosine, sine : out signed(23 downto 0)
		);
	end component;
	
	--input signals and intial values
	signal clk: std_logic := '0';
	signal reset: std_logic := '0';
	signal s_f : signed(23 downto 0) := (others => '0');
	signal s_cosine, s_sine : signed(23 downto 0) := (others => '0');
	
	signal Nclocks : integer := 0;
	
	constant clk_period : time := 10 ns;
	
	begin
	dut: g10_sine_oscillator
	port map(clk, reset, s_f, s_cosine, s_sine);
	
	-- set s_f to decimal 7
	s_f <= to_signed(7, 24);
	
	--clock process
	clk_process : PROCESS
	BEGIN
		clk <= '0';
		WAIT FOR clk_period/2;
		clk <= '1';
		WAIT FOR clk_period/2;
	END PROCESS;
	
	
	-- reset process - goes high at 15 ns
	reset_process : PROCESS
	BEGIN
		reset <= '0';
		wait for 15 ns;
		reset <= '1';
		wait for 17 ns;
		reset <= '0';
		wait;
	END PROCESS;
	
	
	-- clock counter process- count clock on every rising edge
	nclocks_process : PROCESS(clk, reset)
	BEGIN
		if reset = '1' then
			Nclocks <= 0;
		elsif rising_edge(clk) then
			if reset = '0' then
				Nclocks <= Nclocks + 1;
			end if;
		end if;
	END PROCESS;
	
	
	--stimulus and assertion process
	stim_process : PROCESS
	BEGIN
		------------------------------------------------------------------------------------------------------------
		----Test 1: sine and cosine are correct values when reset is high (cos = 0111...1, sine = 0000...0) --------
		------------------------------------------------------------------------------------------------------------
		
		-- wait until in window where reset is high
		wait for 20 ns;
		
		assert s_sine = to_signed(0,24) report "Test 1 failed- sine should be 00...0 during reset" severity error;
		assert s_cosine = signed'("011111111111111111111111") report "Test 1 failed- cosine should be 011...1 during reset" severity error;
		
		------------------------------------------------------------------------------------------------------------
		----Test 2: sine and cosine are correct values when Nclocks = 10 -------------------------------------------
		------------------------------------------------------------------------------------------------------------
		
		-- wait until Nclocks =10
		wait until Nclocks = 10;
		wait for 1 ns;
		
		assert s_sine = signed'("000000000000000000011110") report "Test 2 failed- sine is incorrect value" severity error;
		assert s_cosine = signed'("011111111111111111111111") report "Test 2 failed- cosine is incorrect value" severity error;
		
		
		wait;
		
	END PROCESS stim_process;
END behavior;
	
	