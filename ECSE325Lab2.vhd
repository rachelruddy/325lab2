library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity g10_sine_oscillator is
	port(
		clk: in std_logic;
		reset: in std_logic;
		f: in signed(23 downto 0);
		cosine: out signed(23 downto 0);
		sine: out signed(23 downto 0)
	);
end entity;

architecture rtl of g10_sine_oscillator is 
	-- declare all signals --
	-- initialize curr values to be reset state values
	signal cos_cur: signed(23 downto 0) := (23 => '0', others => '1');
	signal sin_cur: signed(23 downto 0) := (others => '0');
	signal cos_next: signed(23 downto 0);
	signal sin_next: signed(23 downto 0);
	signal mult_cos: signed(47 downto 0);
	signal mult_sin: signed(47 downto 0);
	
	begin
		------------------LOGIC IDEA--------------------------
		-- combinatorial and sequantial logic goes here
		-- angle at step n:
			-- angle: n = 2pi * F * (n/Fs)
		-- angle at n+1
			-- angle: n + 1 = [2pi * F * ((n+1)/Fs) ] 
			-- 				 = [2pi * F * (n/Fs)] + [2pi * F/Fs ]
		-- cos[n+1] = cos[n] - f * sin[n] 
		-- sin[n+1] = sin[n] + f * cos[n+1]
		
		
		---------------COMBINATORIAL LOGIC---------------------
		--mult_cos = f * sin_cur
		mult_cos <= f * sin_cur;
		
		--mult_sin = f * cos_next
		mult_sin <= f * cos_next;
		
		cos_next <= cos_cur - mult_cos(47 downto 24);
		sin_next <= sin_cur + mult_sin(47 downto 24);
		
		-------------SEQUENTIAL LOGIC-------------------------
		process(clk, reset)
		begin
			--sequential logic here
			if reset = '1' then
				-- reset cosine and sine
				cos_cur <= (23 => '0', others => '1');
				sin_cur <= (others => '0');
				
			elsif rising_edge(clk) then
				-- logic for rising edge latch onto next values for cosine and sine
				cos_cur <= cos_next;
				sin_cur <= sin_next;
				
			end if;
		end process;
		
		
		-------------OUTPUT LOGIC-------------------------
		cosine <= cos_cur;
		sine <= sin_cur;
		
		
end architecture;
		