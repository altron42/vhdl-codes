library ieee;
use ieee.std_logic_1164.all;

entity buffered_mux is
   port (
	   a, b, c, d : in std_logic_vector (7 downto 0);
		sel : in natural range 0 to 3;
		enable : in std_logic;
		y : out std_logic_vector (7 downto 0)
	);
end buffered_mux;

architecture arquitetura of buffered_mux is
   signal x : std_logic_vector (7 downto 0);
begin
   -- Mux
   x <= a when sel = 0 else
	     b when sel = 1 else
		  c when sel = 2 else
		  d;
	
	-- Buffer tristate
	y <= x when enable = '1' else
	     (others => 'Z');
end arquitetura;