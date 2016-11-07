-- Multivibrador monoestavel
-- Micael Pimentel
-- github.com/altron42/vhdl-codes

library ieee;
use ieee.std_logic_1164.all;

entity monoestavel is
	port (
		trig   : in  std_logic;
		clk    : in  std_logic;
		x      : out std_logic
	);
end monoestavel;

architecture comportamento of monoestavel is
	type StateType is (IDLE, EDGE, WAIT0);
	signal sto_atual : StateType := IDLE;
begin
	x <= '1' when sto_atual = EDGE else '0';
	
	process (clk)
		variable count : natural range 0 to 1000 := 0;
	begin
		if rising_edge(clk) then
			if trig = '0' and sto_atual /= EDGE then
				sto_atual <= IDLE;
			elsif sto_atual = IDLE then
				sto_atual <= EDGE;
			elsif sto_atual = EDGE then
				count := count + 1;
				if count = 3 then
					count := 0;
					sto_atual <= WAIT0;
				end if;
			end if;
		end if;
	end process;

end comportamento;
