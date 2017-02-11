-- ULA
--
-- Resumo:
--   Unidade logica e aritimetica. Composta por registrador temporario, somador e registrador acumulador
-- Data: 12/2016

library ieee;
use ieee.std_logic_1164.all;

entity componente_ula is
   generic ( DATA_WIDTH : natural );
   port (
	   clk : in std_logic;
		t_gpr : in std_logic;
		c_acc : in std_logic;
		i_acc  : in std_logic;
		z_acc : in std_logic;
		ror_f, rol_f : in std_logic;
		compl_f : in std_logic;
		rst_f : in std_logic;
		flipflop_F : out std_logic;
		din_gpr  : in std_logic_vector (DATA_WIDTH-1 downto 0);
		dout_gpr : buffer std_logic_vector (DATA_WIDTH-1 downto 0)
	);
end componente_ula;

architecture hardware of componente_ula is
	
	component somador
		generic ( DATA_WIDTH : natural );
		port (
			data_A : in std_logic_vector (DATA_WIDTH-1 downto 0);
			data_B : in std_logic_vector (DATA_WIDTH-1 downto 0);
			sum : out std_logic_vector (DATA_WIDTH-1 downto 0);
			carry : out std_logic
		);
	end component;
	
	signal dt_somador : std_logic_vector (DATA_WIDTH-1 downto 0);

	component registrador_acc
		generic ( DATA_WIDTH : natural );
		port (
			clk       : in std_logic;  -- clock pulse
			rst       : in std_logic;  -- asynchronous reset
			wr        : in std_logic;  -- synchronous write to registered_data
			cpl       : in std_logic;   -- 1, complementa dado; 0, dado normal
			inc       : in std_logic;   -- 0, operacao normal; 1, soma + 1
			ror_f, rol_f : in std_logic;
			din       : in std_logic_vector (DATA_WIDTH-1 downto 0); -- input data
			dout      : out std_logic_vector (DATA_WIDTH-1 downto 0);  -- tri-state bus interface
			dout_msb, dout_lsb  : out std_logic
		);
	end component;
	
	signal f_lsb, f_msb : std_logic;
	
	signal reg_F : std_logic;
	
begin
	
	somador_N : somador
	generic map ( DATA_WIDTH => DATA_WIDTH )
	port map (
		data_A => din_gpr,
		data_B => dout_gpr,
		sum => dt_somador,
		carry => open
	);
	
	ACC : registrador_acc
	generic map ( DATA_WIDTH => DATA_WIDTH )
	port map (
	   clk => clk,
		rst => z_acc,
		wr => t_gpr,
		cpl => c_acc,
		inc => i_acc,
		ror_f => ror_f,
		rol_f => rol_f,
		din => dt_somador,
		dout => dout_gpr,
		dout_lsb => f_lsb,
		dout_msb => f_msb
	);
	
	process (clk)
	begin
	   if rising_edge(clk) then
		   if rst_f = '1' then
			   reg_F <= '0';
			end if;
			
			if compl_f = '1' then
			   reg_F <= not reg_F;
			end if;
			
			if ror_f = '1' then
			   reg_F <= f_lsb;
			end if;
			
			if rol_f = '1' then
			   reg_F <= f_msb;
			end if;
		end if;
	end process;

end hardware;