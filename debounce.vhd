library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity debounce is
   generic(
	   fclk : integer := 1;   -- frequancia do clock
      twindow : integer := 10   -- tamamnho da janela de clock que o sinal devera permanecer o mesmo para ser valido
	);
   port (
	   x : in std_logic;
      clk : in  std_logic; 
      y : buffer  std_logic
	);
end debounce;

architecture debouncer of debounce is
   constant max : integer := fclk * twindow;
begin
   process (clk)
	   variable count : integer range 0 to max;
   begin
      if rising_edge(clk) then
         if x /= y then
            count := count + 1;
				if count = max then
				   y <= x;
					count := 0;
				end if;
			else
			   count := 0;
         end if;    
      end if;
   end process;
end debouncer;