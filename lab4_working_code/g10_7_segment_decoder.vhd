library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity g10_7_segment_decoder is
	port ( 
		hex_value : in std_logic_vector(3 downto 0);
		segments : out std_logic_vector(6 downto 0)
	);
end g10_7_segment_decoder;

architecture behavioral of g10_7_segment_decoder is
begin
		process(hex_value)
		begin
			case hex_value is
            when "0000" => segments <= "1000000"; -- 0, on is logic low
            when "0001" => segments <= "1111001"; -- 1
            when "0010" => segments <= "0100100"; -- 2
            when "0011" => segments <= "0110000"; -- 3
            when "0100" => segments <= "0011001"; -- 4
            when "0101" => segments <= "0010010"; -- 5
            when "0110" => segments <= "0000010"; -- 6
            when "0111" => segments <= "1111000"; -- 7
            when "1000" => segments <= "0000000"; -- 8
            when "1001" => segments <= "0010000"; -- 9
				when "1010" => segments <= "0001000"; -- a
				when "1011" => segments <= "0000011"; -- b
            when "1100" => segments <= "1000110"; -- c
            when "1101" => segments <= "0100001"; -- d
            when "1110" => segments <= "0000110"; -- e
				when "1111" => segments <= "0001110"; -- f
            when others => segments <= "1111111"; -- all off
        end case;
    end process;
end behavioral;