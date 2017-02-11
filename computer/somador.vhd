-- Somador de N bits
--
-- Resumo:
--   Somador de N bits com carry out. O tamanho dos bits deve ser definido no generic DATA_WIDTH.
-- Data: 12/2016

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity somador is
   generic ( DATA_WIDTH : natural );
   port (
	   data_A : in std_logic_vector (DATA_WIDTH-1 downto 0);  -- 1a parcela
		data_B : in std_logic_vector (DATA_WIDTH-1 downto 0);  -- 2a parcela
	   sum : out std_logic_vector (DATA_WIDTH-1 downto 0);    -- soma
		carry : out std_logic                                 -- carry out
	);
end somador;

architecture hardware of somador is
   
	component full_adder
		port (
			carry_in : in std_logic;
			data_A : in std_logic;
			data_B : in std_logic;
			sum : out std_logic;
			carry_out : out std_logic
		);
	end component;
	
   signal carry_temp : std_logic_vector (DATA_WIDTH downto 0);
begin
   
	gen_adder : for i in data_A'range generate
	   FA : full_adder port map (
		   carry_in => carry_temp(i),
			data_A   => data_A(i),
			data_B   => data_B(i),
			sum      => sum(i),
			carry_out => carry_temp(i+1)
		);
	end generate;
	
	carry <= carry_temp(DATA_WIDTH);
end hardware;