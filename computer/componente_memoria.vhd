-- Quartus Prime VHDL Template
-- Single port RAM with single read/write address 



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity componente_memoria is

	generic 
	(
	   --DT_SEL     : std_logic;
		DATA_WIDTH : natural;
		ADDR_WIDTH : natural
	);

	port 
	(
		clk		: in std_logic;
		addr	: in natural range 0 to 2**ADDR_WIDTH - 1;
		data	: inout std_logic_vector((DATA_WIDTH-1) downto 0);
		rd    : in std_logic := '0';
		wr    : in std_logic := '0'
	);

end entity;

architecture rtl of componente_memoria is

	-- Build a 2-D array type for the RAM
	subtype word_t is std_logic_vector((DATA_WIDTH-1) downto 0);
	type memory_t is array(2**ADDR_WIDTH-1 downto 0) of word_t;
	
	function init_ram(dt_sel : std_logic)
		return memory_t is 
		variable tmp : memory_t := (others => (others => '0'));
	begin 
	   case dt_sel is
		
		when '0' =>
		for addr_pos in 0 to 2**ADDR_WIDTH - 1 loop 
			-- Initialize the data on memory
			if addr_pos = 0 then
			   tmp(addr_pos) := x"1"&x"00";
			elsif addr_pos = 1 then
			   tmp(addr_pos) := x"9"&x"32";
			elsif addr_pos = 2 then
			   tmp(addr_pos) := x"F"&x"33";
			elsif addr_pos = 3 then
			   tmp(addr_pos) := x"C"&x"01";
			elsif addr_pos = 4 then
			   tmp(addr_pos) := x"B"&x"34";
			elsif addr_pos = 5 then
			   tmp(addr_pos) := x"0"&x"00";
			elsif addr_pos = 50 then
			   tmp(addr_pos) := x"006";
			elsif addr_pos = 51 then
			   tmp(addr_pos) := x"FFD";
			elsif addr_pos = 52 then
			   tmp(addr_pos) := "0001"&"00000110";
			elsif addr_pos = 53 then
			   tmp(addr_pos) := "1001"&"00000110";
			elsif addr_pos = 54 then
			   tmp(addr_pos) := "1001"&"01100000";
			elsif addr_pos = 55 then
			   tmp(addr_pos) := "1001"&"01100000";
			elsif addr_pos = 56 then
			   tmp(addr_pos) := "1100"&"01100000";
			else
			--elsif addr_pos = 52 then
			   tmp(addr_pos) := (others => '0');
			--else
			   -- Initialize each address with the address itself
			   --tmp(addr_pos) := std_logic_vector(to_unsigned(addr_pos, DATA_WIDTH));
			end if;
		end loop;
		
		
		
		-- Initialize the programm on memory
		when '1' =>
		for addr_pos in 0 to 2**ADDR_WIDTH - 1 loop 
			-- Initialize the data on memory
			if addr_pos = 0 then
			   tmp(addr_pos) := x"1"&"00000000";
			elsif addr_pos = 1 then
			   tmp(addr_pos) := x"9"&x"32";
			elsif addr_pos = 2 then
			   tmp(addr_pos) := x"F"&x"33";
			elsif addr_pos = 3 then
			   tmp(addr_pos) := x"C"&x"01";
			elsif addr_pos = 4 then
			   tmp(addr_pos) := x"B"&x"34";
			elsif addr_pos = 5 then
			   tmp(addr_pos) := x"0"&x"00";
			elsif addr_pos = 50 then
			   tmp(addr_pos) := x"006";
			elsif addr_pos = 51 then
			   tmp(addr_pos) := x"FFD";
			elsif addr_pos = 52 then
			   tmp(addr_pos) := "0001"&"01100100";
			elsif addr_pos = 53 then
			   tmp(addr_pos) := "1001"&"01100101";
			elsif addr_pos = 54 then
			   tmp(addr_pos) := "1001"&"01100110";
			elsif addr_pos = 55 then
			   tmp(addr_pos) := "1001"&"01100111";
			elsif addr_pos = 56 then
			   tmp(addr_pos) := "1100"&"01101000";
			else
			--elsif addr_pos = 52 then
			   tmp(addr_pos) := (others => '0');
			--else
			   -- Initialize each address with the address itself
			   --tmp(addr_pos) := std_logic_vector(to_unsigned(addr_pos, DATA_WIDTH));
			end if;
		end loop;
		
		end case;
		
		return tmp;
	end init_ram;

	-- Declare the RAM signal.	
	signal ram : memory_t := init_ram('0');

	-- Register to hold the address 
	signal addr_reg : natural range 0 to 2**ADDR_WIDTH-1;

begin

	process(clk)
	begin
		if(rising_edge(clk)) then
			if wr = '1' and rd = '0' then
				ram(addr) <= data;
			end if;

			-- Register the address for reading
			addr_reg <= addr;
		end if;
	end process;

	data <= ram(addr_reg) when rd = '1' and wr = '0' else (others => 'Z');

end rtl;
