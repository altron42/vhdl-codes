library ieee;
use ieee.std_logic_1164.all;

entity Monoestavel is
    port ( trig   : in  std_logic;
           clk    : in  std_logic;
           x      : out std_logic);
end Monoestavel;
            
architecture comportamento of Monoestavel is
    type StateType is (IDLE, EDGE, WAIT0);
    signal sto_atual : StateType := IDLE;
	 
	 signal pulso : std_logic;
	 
	 component Ripple_Clock
	    generic ( fator : integer := 100 );
	    port (
		    clk_in : in std_logic;
			 clk_out : out std_logic
		 );
	 end component;
	 
begin

    compDivisor : Ripple_Clock
	 generic map ( fator => 50e3 )
	 port map (
	    clk_in => clk,
		 clk_out => pulso
	 );
   
    x <= '0' when sto_atual = EDGE else '1';
    process (pulso)
	     variable count : natural range 0 to 1000 := 0;
    begin
        if rising_edge(pulso) then
            if trig = '1' and sto_atual /= EDGE then
                sto_atual <= IDLE;
            elsif sto_atual = IDLE then
                sto_atual <= EDGE;
            elsif sto_atual = EDGE then
				    count := count + 1;
					 if count = 500 then
					     count := 0;
                    sto_atual <= WAIT0;
				    end if;
            end if;
        end if;
    end process;
end comportamento;
