-- Micael Pimentel
-- github.com/altron42/vhdl-codes

library ieee;
use ieee.std_logic_1164.all;

entity full_adder is
   port (
	   carry_in : in std_logic;
	   data_A : in std_logic;
	   data_B : in std_logic;
	   sum : out std_logic;
	   carry_out : out std_logic
	);
end full_adder;

architecture hardware of full_adder is
begin
   sum <= data_A xor data_B xor carry_in;
   carry_out <= (data_A and data_B) or (data_A and carry_in) or (data_B and carry_in);
	
end hardware;
