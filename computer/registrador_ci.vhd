-- Registrador de complemento e incremento
--
-- Resumo:
--   Registrador temporario generico de uso geral com entrada e saida paralelas. Com set sincrono
--   e reset assincrono. Realiza as operacoes de complemento e/ou soma + 1 nos dados registrados
-- Data: 12/2016

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity registrador_ci is
   generic ( DATA_WIDTH : natural );
   port (
	   clk       : in std_logic;  -- clock pulse
		cpl       : in std_logic;   -- 1, complementa dado; 0, dado normal
		inc       : in std_logic;   -- 0, operacao normal; 1, soma + 1
      rd        : in std_logic;  -- read from registered_data
		wr        : in std_logic;  -- synchronous write to registered_data
		clr       : in std_logic;  -- asynchronous clear registered_data
		bus_data  : in std_logic_vector (DATA_WIDTH-1 downto 0);  -- tri-state bus interface
		out_data  : out std_logic_vector (DATA_WIDTH-1 downto 0)  -- data from registered_data
	);
end registrador_ci;

architecture hardware of registrador_ci is
   signal registered_data : std_logic_vector (DATA_WIDTH-1 downto 0);
begin
   
	process(clk, clr)
	   variable temp : std_logic_vector (DATA_WIDTH-1 downto 0) := (others => '0');
	begin
		if clr='0' then
			temp := (others => '0');
	   elsif rising_edge(clk) then
			if wr='1' then
		      temp := bus_data;
			end if;
			
			if cpl = '1' then
			   temp := not temp;
			end if;
			
			if inc = '1' then
			   temp := temp + 1;
			end if;
			
		end if;
		registered_data <= temp;
	end process;
	
	-- bus_data <= registered_data when rd='1' else (others => 'Z');
	
	out_data <= registered_data;
   
end hardware;