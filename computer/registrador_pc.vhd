-- Contador de Programa
--
-- Resumo:
--   Contador sequencial crescente
-- Data: 12/2016

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity registrador_pc is
   generic (
	   ADDR_WIDTH : natural
	);
   port (
	   clk, rst : in std_logic;
	   i_pc  : in std_logic;       -- se '1', incrementa contador na borda positiva de clock
		t_gpr : in std_logic;
		din_gpr  : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
		dout_gpr : out std_logic_vector(ADDR_WIDTH-1 downto 0);
		dout     : out std_logic_vector(ADDR_WIDTH-1 downto 0)   -- saida do contador
	);
end registrador_pc;

architecture comportamento of registrador_pc is
begin

   process (clk, rst)
	   variable data_reg : std_logic_vector (ADDR_WIDTH-1 downto 0) := (others => '0');
	begin
	   if rst = '1' then
		   data_reg := (others => '0');
	   elsif rising_edge(clk) then
			if i_pc = '1' then
				data_reg := data_reg + 1;
			end if;
			if t_gpr = '1' then
			   data_reg := din_gpr;
			end if;
		   dout <= data_reg;
			dout_gpr <= data_reg;
		end if;
	end process;

end comportamento;