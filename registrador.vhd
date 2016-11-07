-- Registrador clockado com set e reset assincronos
-- Micael Pimentel
-- github.com/altron42/vhdl-codes

library ieee;
use ieee.std_logic_1164.all;

entity registrador is
   generic ( word_size : natural := 1 );
   port (
	  clk       : in std_logic;  -- clock pulse
    rd        : in std_logic;  -- synchronous read from registered_data
		wr        : in std_logic;  -- synchronous write to registered_data
		load      : in std_logic;  -- asynchronous set registered_data
		clr       : in std_logic;  -- asynchronous clear registered_data
		bus_data  : inout std_logic_vector (word_size-1 downto 0);  -- tri-state bus interface
		in_data   : in std_logic_vector (word_size-1 downto 0);  -- input data for asynchronous load
		out_data  : out std_logic_vector (word_size-1 downto 0)  -- data from registered_data
	);
end registrador;

architecture hardware of registrador is
   signal registered_data : std_logic_vector (word_size-1 downto 0);
begin
   
	process(clk, clr, load)
	begin
	   if clr='1' then
		   registered_data <= (others => '0');
		elsif load='1' then
		   registered_data <= in_data;
	   elsif rising_edge(clk) then 
		   if wr='1' then
		      registered_data <= bus_data;
			end if;
			out_data <= registered_data;
		end if;
	end process;
	
	bus_data <= registered_data when rd='1' else (others => 'Z');
   
end hardware;
