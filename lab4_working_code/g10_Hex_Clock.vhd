library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Assuming that the write_data is the 24 LSBs, write_data[23-16] are hour, write_data[15-8] are minute, write_data[7-0] are seconds
-- seg6 & seg5 -> hour hex displays
-- seg4 & seg3 -> minute hex displays
-- seg2 & seg1 -> seconds hex displays
entity g10_Hex_Clock is
	port ( clk: in std_logic;
		resetn : in std_logic;
		write : in std_logic;
		write_data : in std_logic_vector(31 downto 0);
		seg1, seg2, seg3, seg4, seg5, seg6 : out std_logic_vector(6 downto 0));
end g10_Hex_Clock;

architecture behavioral of g10_Hex_Clock is
	-------------------------------------
	---------COMPONENT DECLARATIONS------
	-------------------------------------
	component g10_7_segment_decoder is
		port (
        hex_value : in std_logic_vector(3 downto 0);
        segments  : out std_logic_vector(6 downto 0)
		);
	end component;
	
	-------------------------------------
	---------SIGNAL DECLARATIONS---------
	-------------------------------------
	-- corresponding to all 6 7-seg diplay components
	signal hour_1 : std_logic_vector(3 downto 0);   -- hour digit 1
	signal hour_0: std_logic_vector(3 downto 0);   -- hour digit 0
	signal min_1  : std_logic_vector(3 downto 0);   -- minute digit 1
	signal min_0 : std_logic_vector(3 downto 0);   -- minute digit 0
	signal sec_1  : std_logic_vector(3 downto 0);   -- seconds digit 1
	signal sec_0 : std_logic_vector(3 downto 0);   -- seconds digit 0
	
	-- time registers  
	signal hours : unsigned(7 downto 0);  -- 0x00 to 0x17 (0-23 hrs)
	signal minutes : unsigned(7 downto 0);  -- 0x00 to 0x3B (0-59 mins)
	signal seconds : unsigned(7 downto 0);  -- 0x00 to 0x3B (0-59 secs)
	
	--need clk counter signals to count passing of 1 sec
	signal clk_counter : integer range 0 to 49999999; 	-- because of 50MHz clock frequency
	--signal sec_counter : integer range 0 to 49999999; --counts seconds
	
	begin
	--unclocked processs goe here
	-----------------------------------
   ---SPLITTING INTO DIGITS   --------
   -----------------------------------
	hour_1 <= std_logic_vector(hours(7 downto 4));
   hour_0 <= std_logic_vector(hours(3 downto 0));
   min_1  <= std_logic_vector(minutes(7 downto 4));
   min_0  <= std_logic_vector(minutes(3 downto 0));
   sec_1  <= std_logic_vector(seconds(7 downto 4));
   sec_0  <= std_logic_vector(seconds(3 downto 0));
	
	-----------------------------------
   ---COMPONENT INSTANTIATIONS--------
   -----------------------------------
   seg6_dec : g10_7_segment_decoder port map(hex_value => hour_1, segments => seg6);
   seg5_dec : g10_7_segment_decoder port map(hex_value => hour_0, segments => seg5);
   seg4_dec : g10_7_segment_decoder port map(hex_value => min_1,  segments => seg4);
   seg3_dec : g10_7_segment_decoder port map(hex_value => min_0,  segments => seg3);
   seg2_dec : g10_7_segment_decoder port map(hex_value => sec_1,  segments => seg2);
   seg1_dec : g10_7_segment_decoder port map(hex_value => sec_0,  segments => seg1);

	
	process(clk, resetn)
	begin
		--handle reset, clk rising, time logic
		if resetn = '0' then
			hours <= (others => '0');
			minutes <= (others => '0');
			seconds <= (others => '0');
			clk_counter <= 0;
			
		elsif rising_edge(clk) then
			if write = '1' then
				hours   <= unsigned(write_data(23 downto 16));
				minutes <= unsigned(write_data(15 downto 8));
				seconds <= unsigned(write_data(7 downto 0));
				clk_counter <= 0;
			else
			
				if clk_counter = 49999999 then
					clk_counter <= 0;
					seconds <= seconds +1;
					if seconds = x"3B" then
						seconds <= (others => '0');
						minutes <= minutes +1;
						if minutes = x"3B" then
							minutes <= (others => '0');
							hours <= hours + 1;
							if hours = x"17" then
								hours <= (others => '0');
							end if;
						end if;
					end if;	
				else
					clk_counter <= clk_counter + 1;
				end if;
				
			end if;
		end if;
	end process;
end architecture;