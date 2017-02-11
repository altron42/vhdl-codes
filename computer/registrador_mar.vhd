-- Registrador de Endereco de Memoria
--
-- Resumo:
--   Registrador multiplexado de endereco. As entradas t_pc e t_gpr selecionam qual entrada vai pro registrador
--   Saida dout eh o endereco selecionado
-- Data: 12/2016

library ieee;
use ieee.std_logic_1164.all;

entity registrador_mar is
   generic ( ADDR_WIDTH : natural );
   port (
	   clk : in std_logic;
	   t_pc, t_gpr : in std_logic;         -- sinaliza origem do endereco
		data_pc, data_gpr : in std_logic_vector (ADDR_WIDTH-1 downto 0);   -- origem do endereco
		dout : out std_logic_vector (ADDR_WIDTH-1 downto 0)       -- saida do endereco selcionado
	);
end registrador_mar;

architecture comportamento of registrador_mar is
begin

   process (clk)
	   variable reg_data : std_logic_vector (ADDR_WIDTH-1 downto 0) := (others => '0');
	begin
	   if rising_edge(clk) then
		   
			if t_pc = '1' and t_gpr = '0' then
			   reg_data := data_pc;
			elsif t_gpr = '1' and t_pc = '0' then
			   reg_data := data_gpr;
			end if;
			
		end if;
		dout <= reg_data;
	end process;

end comportamento;