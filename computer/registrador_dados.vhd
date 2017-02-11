-- Registrador Generico
--
-- Resumo:
--   Registrador generico de uso geral com entradas e saidas paralelas. Com set sincrono
--   e reset assincrono. Interface de barramento tri-state paralela com leitura e escrita.
-- Data: 12/2016

library ieee;
use ieee.std_logic_1164.all;

entity registrador_dados is
   generic ( DATA_WIDTH : natural );
   port (
	   clk       : in std_logic;  -- pulso de clock
      rd        : in std_logic;  -- ler do registrador para o barramento
		wr        : in std_logic;  -- escreve do barramento no registrador
		load      : in std_logic;  -- carrega da entrada no registrador
		clr       : in std_logic;  -- apaga dados do registrador
		bus_data  : inout std_logic_vector (DATA_WIDTH-1 downto 0);  -- interface tri-state do barramento
		in_data   : in std_logic_vector (DATA_WIDTH-1 downto 0);  -- entrada paralela
		out_data  : out std_logic_vector (DATA_WIDTH-1 downto 0)  -- saida paralela
	);
end registrador_dados;

architecture hardware of registrador_dados is
   signal registered_data : std_logic_vector (DATA_WIDTH-1 downto 0);
begin
   
	process(clk, clr, load)
	   variable temp : std_logic_vector (DATA_WIDTH-1 downto 0) := (others => '0');
	begin
		if clr='0' then
			temp := (others => '0');
	   elsif rising_edge(clk) then
		   if load='0' then
		      temp := in_data;
			elsif wr='1' then
		      temp := bus_data;
			end if;
		end if;
		registered_data <= temp;
	end process;
	
	out_data <= registered_data;
	
	bus_data <= registered_data when rd='1' else (others => 'Z');
   
end hardware;