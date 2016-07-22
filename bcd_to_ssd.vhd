library ieee;
use ieee.std_logic_1164.all;

entity bcd_to_ssd is
   port (
	   input : in std_logic_vector (3 downto 0);
		output : out std_logic_vector (6 downto 0)
	);
end bcd_to_ssd;

architecture converter of bcd_to_ssd is
begin

   with input select
	   output <= "1111110" when x"0",
		          "0110000" when x"1",
					 "1101101" when x"2",
					 "1111001" when x"3",
					 "0110011" when x"4",
					 "1011011" when x"5",
					 "1011111" when x"6",
					 "1110000" when x"7",
					 "1111111" when x"8",
					 "1111011" when x"9",
					 "1001111" when others;   -- 'E'rror se entrada maior que 1001
   
end converter;