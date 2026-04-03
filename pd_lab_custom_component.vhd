LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY pd_lab_custom_component IS
PORT (
	clock, resetn : IN STD_LOGIC;
	address : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	writedata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	write : IN STD_LOGIC;
	chipselect : IN STD_LOGIC;
	seg1, seg2, seg3, seg4, seg5, seg6 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
);
END pd_lab_custom_component;

ARCHITECTURE Structure OF pd_lab_custom_component IS

	COMPONENT g10_Hex_Clock
	PORT ( 
		clk: in std_logic;
		resetn : in std_logic;
		write : in std_logic;
		write_data : in std_logic_vector(31 downto 0);
		seg1, seg2, seg3, seg4, seg5, seg6 : out std_logic_vector(6 downto 0)
	);
	END COMPONENT;

	BEGIN
		component_inst : g10_Hex_Clock PORT MAP (clock, resetn, write, writedata, seg1, seg2, seg3, seg4, seg5, seg6);

END Structure;