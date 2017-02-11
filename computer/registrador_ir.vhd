-- Registrador de Instrucao
--
-- Resumo:
--   Armazena dados do barramento quando sinal t_bus='1' na borda positiva de clock
--   Descrimina o operador do operando nas saidas dout_opcode e addrs_mem, respectivamente
-- Data: 12/2016

library ieee;
use ieee.std_logic_1164.all;

entity registrador_ir is
   generic (
		CODE_WIDTH : natural
	);
   port (
	   clk, rst : in std_logic;
	   t_gpr : in std_logic;                           -- se '1' armazena no registrador dados que estao no barramento
		din_opcode  : in std_logic_vector (CODE_WIDTH-1 downto 0);     -- conecta ao barremento
		dout_opcode : out std_logic_vector (CODE_WIDTH-1 downto 0)  -- codigo de maquina da operacao
	);
end registrador_ir;

architecture comportamento of registrador_ir is
begin

   process (clk, rst)
	   variable data : std_logic_vector (CODE_WIDTH-1 downto 0);
	begin
	   if rst = '1' then
		   data := (others => '0');
	   elsif rising_edge(clk) and t_gpr = '1' then
		  data := din_opcode;
		end if;
		dout_opcode <= data;
	end process;

end comportamento;