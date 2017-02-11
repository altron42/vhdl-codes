-- Somador Completo
--
-- Resumo:
--   Somador completo de 1 bit com carry in e carry out.
-- Data: 12/2016

library ieee;
use ieee.std_logic_1164.all;

entity full_adder is
   port (
	   carry_in : in std_logic;   -- carry in
	   data_A : in std_logic;     -- 1a parcela
		data_B : in std_logic;     -- 2a parcela
	   sum : out std_logic;       -- soma
		carry_out : out std_logic  -- carry out
	);
end full_adder;

architecture hardware of full_adder is
begin
   sum <= data_A xor data_B xor carry_in;
	carry_out <= (data_A and data_B) or (data_A and carry_in) or (data_B and carry_in);
	
end hardware;