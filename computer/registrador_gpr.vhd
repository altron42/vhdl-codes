library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity registrador_gpr is
   generic (
	   DATA_WIDTH : natural;
		ADDR_WIDTH : natural;
		CODE_WIDTH : natural
	);
   port (
	   clk, rst : in std_logic;
		t_mem, t_acc, t_pc : in std_logic;
		inc_gpr : in std_logic;
		gpr_Z : out std_logic;
		rd_data : in std_logic;
	   dout_mar : out std_logic_vector(ADDR_WIDTH-1 downto 0);
		dout_pc  : out std_logic_vector(ADDR_WIDTH-1 downto 0);
		dout_opcode : out std_logic_vector(CODE_WIDTH-1 downto 0);
		dout_ula : out std_logic_vector(DATA_WIDTH-1 downto 0);
		din_pc   : in std_logic_vector(ADDR_WIDTH-1 downto 0);
		din_acc  : in std_logic_vector(DATA_WIDTH-1 downto 0);
		bus_mem  : inout std_logic_vector(DATA_WIDTH-1 downto 0)
	);
end entity;

architecture hardware of registrador_gpr is
   signal data_reg : std_logic_vector(DATA_WIDTH-1 downto 0);
begin
   
	process(clk, rst)
	begin
	   if rst = '1' then
		   data_reg <= (others => '0');
		elsif rising_edge(clk) then
		   
		   if t_mem = '1' then
			   data_reg <= bus_mem;
			elsif t_acc = '1' then
			   data_reg <= din_acc;
			elsif t_pc = '1' then
			   data_reg(DATA_WIDTH-1 downto ADDR_WIDTH) <= (others => '0');
				data_reg(ADDR_WIDTH-1 downto 0) <= din_pc;
			end if;
			
			if inc_gpr = '1' then
			   data_reg <= data_reg + 1;
			end if;
			
		end if;
	end process;
	
	gpr_Z <= '1' when (data_reg = (data_reg'range => '0')) else '0';
	
	dout_mar <= data_reg(ADDR_WIDTH-1 downto 0);
	dout_pc <= data_reg(ADDR_WIDTH-1 downto 0);
	
	dout_opcode <= data_reg(DATA_WIDTH-1 downto ADDR_WIDTH);
	
	dout_ula <= data_reg;
	
	bus_mem <= data_reg when rd_data = '1' else (others => 'Z');
	
end architecture;