-- Entidade principal da arquitetura do projeto (top-level entity)
--
-- Titulo: Computador Aprimorado
-- Resumo:
--   Implementacao da arquitetura de um computador aprimorado
--   com modelo de abstracao baseado em RTL.
--   Projeto implementado em VHDL para a disciplina Arquitetura de Sistemas Digitas
--   do curso de Engenharia da Computacao da Universidade Federal do Amazonas.
-- Data: 02/2017
-- Membros da equipe:
--   Antonio Cesar Vieira da Cruz Junior
--   Helton Soares Nogueira
--   Luiz Henrique Coelho Sena
--   Marcelo Ferreira
--   Micael de Sousa Pimentel
--   Osmar Kazuo Kabashima Junior
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity computador_aprimorado is
   generic (
	   word_size : natural := 12;
		addr_size : natural := 8;
		oper_size : natural := 4
	);
   port (
	   CLOCK : in std_logic;
		RST_ALL : in std_logic;
		snl_pc_rst, snl_pc_i, snl_pc_t_gpr : buffer std_logic;
		snl_mar_t_pc, snl_mar_t_gpr : buffer std_logic;
		snl_ir_rst, snl_ir_t_gpr : buffer std_logic;
		snl_mem_t_gpr : buffer std_logic;
		snl_gpr_rst, snl_gpr_t_mem_dt, snl_gpr_t_acc, snl_gpr_t_pc : buffer std_logic;
		snl_gpr_inc, snl_gpr_Z : buffer std_logic;
		snl_ula_t_gpr, snl_ula_i_acc, snl_ula_c_acc, snl_ula_z_acc : buffer std_logic;
		snl_ula_ror_f, snl_ula_rol_f, snl_ula_rst_f, snl_ula_comp_f : buffer std_logic;
		snl_flipflop_F : buffer std_logic;
		saida_barramento : out std_logic_vector (word_size-1 downto 0);
		saida_gpr : out std_logic_vector (word_size-1 downto 0);
		saida_ula : out std_logic_vector (word_size-1 downto 0)
	);
end computador_aprimorado;

architecture hardware of computador_aprimorado is
   
	component registrador_pc
	   generic ( ADDR_WIDTH : natural );
		port (
			clk, rst : in std_logic;
			i_pc  : in std_logic;       -- se '1', incrementa contador na borda positiva de clock
			t_gpr : in std_logic;
			din_gpr  : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
			dout_gpr : out std_logic_vector(ADDR_WIDTH-1 downto 0);
			dout     : out std_logic_vector(ADDR_WIDTH-1 downto 0)   -- saida do contador
		);
	end component;
	
	signal dt_pc_mar, dt_pc_gpr : std_logic_vector (addr_size-1 downto 0);
	
	component registrador_mar
	   generic ( ADDR_WIDTH : natural );
		port (
			clk : in std_logic;
			t_pc, t_gpr : in std_logic;         -- sinaliza origem do endereco
			data_pc, data_gpr : in std_logic_vector (ADDR_WIDTH-1 downto 0);   -- origem do endereco
			dout : out std_logic_vector (ADDR_WIDTH-1 downto 0)       -- saida do endereco selcionado
		);
	end component;
	
	signal dt_mar_mem : std_logic_vector (addr_size-1 downto 0);
	
	component registrador_ir
	   generic (
		   CODE_WIDTH : natural
		);
		port (
			clk, rst : in std_logic;
			t_gpr : in std_logic;                           -- se '1' armazena no registrador dados que estao no barramento
			din_opcode  : in std_logic_vector (CODE_WIDTH-1 downto 0);     -- conecta ao barremento
			dout_opcode : out std_logic_vector (CODE_WIDTH-1 downto 0)  -- codigo de maquina da operacao
		);
	end component;
	
	signal dt_opcode_ir_ctrl : std_logic_vector (oper_size-1 downto 0);
	
	component registrador_gpr
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
	end component;
	
	signal dt_gpr_mar : std_logic_vector (addr_size-1 downto 0);
	signal dt_gpr_pc : std_logic_vector (addr_size-1 downto 0);
	signal dt_opcode_gpr_ir : std_logic_vector (oper_size-1 downto 0);
	signal dt_gpr_ula : std_logic_vector (word_size-1 downto 0);
	
	component componente_ula
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
			dout_gpr : out std_logic_vector (DATA_WIDTH-1 downto 0)
		);
	end component;
	
	signal dt_ula_gpr : std_logic_vector (word_size-1 downto 0);
	
	component componente_memoria
		generic (
			DATA_WIDTH : natural;
			ADDR_WIDTH : natural
		);
		port (
			clk	: in std_logic;
			addr	: in natural range 0 to 2**ADDR_WIDTH - 1;
			data	: inout std_logic_vector((DATA_WIDTH-1) downto 0);
			rd    : in std_logic := '0';
			wr    : in std_logic := '0'
		);
	end component;
	
	component controlador is
		port (
			clk, rst : in std_logic;
			oper_code : in std_logic_vector (3 downto 0);  -- operation code
			pc_rst, pc_i, pc_t_gpr : buffer std_logic;
			mar_t_pc, mar_t_gpr : buffer std_logic;
			ir_rst, ir_t_gpr : buffer std_logic;
			mem_t_gpr : buffer std_logic;
			gpr_rst, gpr_t_mem, gpr_t_acc, gpr_t_pc : buffer std_logic;
			gpr_inc : buffer std_logic;
			gpr_Z : in std_logic;
			flipflop_F : in std_logic;
			ula_t_gpr, ula_i_acc, ula_c_acc, ula_z_acc : buffer std_logic;
			ula_ror_f, ula_rol_f, ula_rst_f, ula_comp_f : buffer std_logic
		);
	end component;
	
	component registrador_dados is
		generic ( DATA_WIDTH : natural );
		port (
			clk       : in std_logic;  -- clock pulse
			rd        : in std_logic;  -- read from registered_data
			wr        : in std_logic;  -- synchronous write to registered_data
			load      : in std_logic;  -- synchronous load registered_data
			clr       : in std_logic;  -- asynchronous clear registered_data
			bus_data  : inout std_logic_vector (DATA_WIDTH-1 downto 0);  -- tri-state bus interface
			in_data   : in std_logic_vector (DATA_WIDTH-1 downto 0);  -- input data for load
			out_data  : out std_logic_vector (DATA_WIDTH-1 downto 0)  -- data from registered_data
		);
	end component;
	
	signal bus_mem_gpr : std_logic_vector (word_size-1 downto 0);
   
	
	--signal snl_pc_rst, snl_pc_i : std_logic;
	--signal snl_mar_t_pc :  std_logic;
	--signal snl_ir_rst, snl_ir_t_gpr : std_logic;
	--signal snl_ram_rd : std_logic;
	-- signal sinal_regA_rd, sinal_regA_wr, sinal_regA_load, sinal_regA_z : std_logic;
   
begin
   
	PC : registrador_pc
	generic map ( ADDR_WIDTH => addr_size )
	port map (
	   clk => CLOCK,
		rst => snl_pc_rst,
		i_pc => snl_pc_i,
		t_gpr => snl_pc_t_gpr,
		din_gpr => dt_gpr_pc,
		dout_gpr => dt_pc_gpr,
		dout => dt_pc_mar
	);
	
	MAR : registrador_mar
	generic map ( ADDR_WIDTH => addr_size )
	port map (
	   clk => CLOCK,
		t_pc => snl_mar_t_pc,
		t_gpr => snl_mar_t_gpr,
		data_pc => dt_pc_mar,
		data_gpr => dt_gpr_mar,
		dout => dt_mar_mem
	);
	
	IR : registrador_ir
	generic map (
	   CODE_WIDTH => oper_size
	)
	port map (
	   clk => CLOCK,
		rst => snl_ir_rst,
		t_gpr => snl_ir_t_gpr,
		din_opcode => dt_opcode_gpr_ir,
		dout_opcode => dt_opcode_ir_ctrl
	);
	
	GPR : registrador_gpr
	generic map (
		DATA_WIDTH => word_size,
		ADDR_WIDTH => addr_size,
		CODE_WIDTH => oper_size
	)
	port map (
		clk => CLOCK,
		rst => snl_gpr_rst,
		t_mem => snl_gpr_t_mem_dt,
		t_acc => snl_gpr_t_acc,
		t_pc => snl_gpr_t_pc,
		inc_gpr => snl_gpr_inc,
		gpr_Z => snl_gpr_Z,
		rd_data => snl_mem_t_gpr,
		dout_mar => dt_gpr_mar,
		dout_pc => dt_gpr_pc,
		dout_opcode => dt_opcode_gpr_ir,
		dout_ula => dt_gpr_ula,
		din_pc => dt_pc_gpr,
		din_acc => dt_ula_gpr,
		bus_mem => bus_mem_gpr
	);

	ULA : componente_ula
	generic map ( DATA_WIDTH => word_size )
	port map (
	   clk => CLOCK,
		t_gpr => snl_ula_t_gpr,
		c_acc => snl_ula_c_acc,
		i_acc => snl_ula_i_acc,
		z_acc => snl_ula_z_acc,
		ror_f => snl_ula_ror_f,
		rol_f => snl_ula_rol_f,
		compl_f => snl_ula_comp_f,
		rst_f => snl_ula_rst_f,
		flipflop_F => snl_flipflop_F,
		din_gpr => dt_gpr_ula,
		dout_gpr => dt_ula_gpr
	);
	
	RAM_DA : componente_memoria
	generic map ( DATA_WIDTH => word_size, ADDR_WIDTH => addr_size )
	port map (
	   clk => not CLOCK,
		addr => to_integer(unsigned(dt_mar_mem)),
		data => bus_mem_gpr,
		rd => snl_gpr_t_mem_dt,
		wr => snl_mem_t_gpr
	);
	
--	REG_A : registrador_dados
--	generic map ( DATA_WIDTH => word_size )
--	port map (
--		clk   => CLOCK,
--		rd    => sinal_regA_rd,
--		wr    => sinal_regA_wr,
--		load  => sinal_regA_load,
--		clr   => sinal_regA_z,
--		bus_data  => barramento_dados,
--		in_data   => x"5A3",
--		out_data  => saida_regA
--	);
	
	MAIN_CONTROL : controlador
	port map (
		clk => CLOCK,
		rst => RST_ALL,
		oper_code => dt_opcode_ir_ctrl,
		pc_rst => snl_pc_rst,
		pc_i => snl_pc_i,
		pc_t_gpr => snl_pc_t_gpr,
		mar_t_pc => snl_mar_t_pc,
		mar_t_gpr => snl_mar_t_gpr,
		ir_rst => snl_ir_rst,
		ir_t_gpr => snl_ir_t_gpr,
		gpr_rst => snl_gpr_rst,
		gpr_t_mem => snl_gpr_t_mem_dt,
		gpr_t_acc => snl_gpr_t_acc,
		gpr_t_pc => snl_gpr_t_pc,
		gpr_inc => snl_gpr_inc,
		gpr_Z => snl_gpr_Z,
		flipflop_F => snl_flipflop_F,
		mem_t_gpr => snl_mem_t_gpr,
		ula_t_gpr => snl_ula_t_gpr,
		ula_i_acc => snl_ula_i_acc,
		ula_c_acc => snl_ula_c_acc,
		ula_z_acc => snl_ula_z_acc,
		ula_ror_f => snl_ula_ror_f,
		ula_rol_f => snl_ula_rol_f,
		ula_rst_f => snl_ula_rst_f,
		ula_comp_f => snl_ula_comp_f
	);
	
	saida_barramento <= bus_mem_gpr;
	saida_gpr <= dt_gpr_ula;
	saida_ula <= dt_ula_gpr;
	
end hardware;
