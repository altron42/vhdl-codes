-- Módulo debounce de chave em VHDL
-- Micael Pimentel
-- github.com/altron42/vhdl-codes

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity debounce is
   generic(
      twindow : integer := 50   -- quantidades de pulso de clock que o sinal deverá permaner o mesmo para ficar estável. Ajustar conforme sua aplicação
	);
   port (
	   x : in std_logic;  -- Sinal de entrada
      clk : in  std_logic;  -- Clock
      y : buffer  std_logic  -- Sinal debounceado
	);
end debounce;

architecture debouncer of debounce is
   constant max : integer := twindow;
begin
   process (clk)
	   variable count : integer range 0 to max;
   begin
      if rising_edge(clk) then
         if x /= y then  -- Sinal de entrada está variando
            count := count + 1;
				if count = max then  -- sinal estabilizou e a contagem atingiu o valor máximo
				   y <= x;
					count := 0;
				end if;
			else
			   count := 0;
         end if;    
      end if;
   end process;
end debouncer;
