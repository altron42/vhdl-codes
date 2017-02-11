-- Registrador Acumulador
--
-- Resumo:
--   Registrador acumulador com reset assincrono e duas saidas
-- Data: 12/2016

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity registrador_acc is
   generic ( DATA_WIDTH : natural );
   port (
	   clk       : in std_logic;  -- clock pulse
		rst       : in std_logic;  -- asynchronous reset
		wr        : in std_logic;  -- synchronous write to registered_data
		cpl       : in std_logic;   -- 1, complementa dado; 0, dado normal
		inc       : in std_logic;   -- 0, operacao normal; 1, soma + 1
		ror_f, rol_f : in std_logic;
		din       : in std_logic_vector(DATA_WIDTH-1 downto 0); -- input data
		dout      : out std_logic_vector(DATA_WIDTH-1 downto 0);  -- tri-state bus interface
		dout_msb, dout_lsb  : out std_logic
	);
end registrador_acc;

architecture hardware of registrador_acc is
   signal registered_data : std_logic_vector (DATA_WIDTH-1 downto 0);
begin
   
	process(clk, rst)
	   variable temp, temp2 : std_logic_vector (DATA_WIDTH-1 downto 0) := (others => '0');
	begin
		if rst='1' then
			temp := (others => '0');
	   elsif rising_edge(clk) then
			if wr='1' then
		      temp := din;
			end if;
			
			if cpl = '1' then
			   temp := not temp;
			end if;
			
			if inc = '1' then
			   temp := temp + 1;
			end if;
			
			if ror_f = '1' then
			   temp2(DATA_WIDTH-2 downto 0) := temp(DATA_WIDTH-1 downto 1);
				temp2(DATA_WIDTH-1) := temp(0);
				temp := temp2;
				dout_lsb <= temp(0);
			end if;
			
			if rol_f = '1' then
			   temp2(DATA_WIDTH-1 downto 1) := temp(DATA_WIDTH-2 downto 0);
				temp2(0) := temp(DATA_WIDTH-1);
				temp := temp2;
				dout_msb <= temp(DATA_WIDTH-1);
			end if;
			
		end if;
		registered_data <= temp;
	end process;
	
	dout <= registered_data;
   
end hardware;