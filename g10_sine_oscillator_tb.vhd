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
	signal clk, reset: std_logic := '0';
	signal s_f : signed(23 downto 0) := (others <= '0');
	signal s_cosine, s_sine : signed(23 downto 0) := (others <= '0');
	-- add Nclocks signal
	
	constant clk_period : time := 1 ns;
	
	begin
	dut: g10_sine_oscillator
	port map(clk, reset, s_f, s_cosine, s_sine);
	
	--clock process
	clk_process : PROCESS
	BEGIN
		clk <= '0';
		WAIT FOR clk_period/2;
		clk <= '1';
		WAIT FOR clk_period/2;
	END PROCESS;
	
	stim_process : PROCESS
	BEGIN
		------------------------------------------------------------------------------------------------------------
		----Test 1: XXXXXXXXXXXXXXXXXXXX ---------------------------------------------------------------------------
		------------------------------------------------------------------------------------------------------------
		-- syntax for assertions: assert s_cosine = expected_value report "Test 1 incorrect cosine value" severity error;
		
		------------------------------------------------------------------------------------------------------------
		----Test 2: XXXXXXXXXXXXXXXXXXXX ---------------------------------------------------------------------------
		------------------------------------------------------------------------------------------------------------
	
	
		wait;
		
	END PROCESS stim_process;
END;
	
	