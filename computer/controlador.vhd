library ieee;
use ieee.std_logic_1164.all;


entity controlador is
   port (
	   clk, rst : in std_logic;
		oper_code : in std_logic_vector (3 downto 0);  -- operation code
		pc_rst, pc_i, pc_t_gpr : buffer std_logic;
		mar_t_pc, mar_t_gpr : buffer std_logic;
		ir_rst, ir_t_gpr : buffer std_logic;
		mem_t_gpr : buffer std_logic;
		gpr_rst, gpr_t_mem, gpr_t_acc, gpr_t_pc : buffer std_logic;
		gpr_inc: buffer std_logic;
		gpr_Z : in std_logic;
		flipflop_F : in std_logic;
		ula_t_gpr, ula_i_acc, ula_c_acc, ula_z_acc : buffer std_logic;
		ula_ror_f, ula_rol_f, ula_rst_f, ula_comp_f : buffer std_logic
	);
end entity;

architecture comportamento of controlador is
   type estados is (START, FETCH_1, FETCH_2, FETCH_3, RUNSTART,
	                     SUM_1, SUM_2, SUM_3,
								SUMI_1, SUMI_2, SUMI_3, SUMI_4, SUMI_5,
								STA_1, STA_2, STA_3,
								JMP,
								JMPI_1, JMPI_2, JMPI_3,
								CSR_1, CSR_2, CSR_3, CSR_4,
								ISZ_1, ISZ_2, ISZ_3, ISZ_4, ISZ_5,
								CRA, CTA, ITA, CRF, CTF, SFZ_1, SFZ_2, ROR_F, ROL_F,
								STOP);
	signal sto_atual, sto_prox : estados := START;
begin
   
	process (clk, rst)
	begin
	   if rst = '1' then
		   sto_atual <= START;
	   elsif falling_edge(clk) then
		   sto_atual <= sto_prox;
		end if;
	end process;
	
	process (sto_atual)
	begin
	   case sto_atual is
		
		when START =>
		   sto_prox <= FETCH_1;
			
		
		when FETCH_1 =>	
		   sto_prox <= FETCH_2;
		when FETCH_2 =>
		   sto_prox <= FETCH_3;
		when FETCH_3 =>
			sto_prox <= RUNSTART;
			
			
		when RUNSTART =>
		   case oper_code is
				when x"0" => sto_prox <= STOP;
				when x"1" => sto_prox <= CRA;
				when x"2" => sto_prox <= CTA;
				when x"3" => sto_prox <= ITA;
				when x"4" => sto_prox <= CRF;
				when x"5" => sto_prox <= CTF;
				when x"6" => sto_prox <= SFZ_1;
				when x"7" => sto_prox <= ROR_F;
				when x"8" => sto_prox <= ROL_F;
				when x"9" => sto_prox <= SUM_1;
				when x"A" => sto_prox <= SUMI_1;
				when x"B" => sto_prox <= STA_1;
				when x"C" => sto_prox <= JMP;
				when x"D" => sto_prox <= JMPI_1;
				when x"E" => sto_prox <= CSR_1;
				when x"F" => sto_prox <= ISZ_1;
				when others => sto_prox <= FETCH_1;
			end case;
			
		
		when CRA =>
		   sto_prox <= FETCH_1;
			
		when CTA =>
		   sto_prox <= FETCH_1;
		
		when ITA =>
		   sto_prox <= FETCH_1;
		
		when CRF =>
		   sto_prox <= FETCH_1;
		
		when CTF =>
		   sto_prox <= FETCH_1;
			
		when SFZ_1 =>
		   if gpr_Z = '1' then
		      sto_prox <= SFZ_2;
			else
			   sto_prox <= FETCH_1;
			end if;
		when SFZ_2 =>
		   sto_prox <= FETCH_1;
		
		when ROR_F =>
		   sto_prox <= FETCH_1;
		
		when ROL_F =>
		   sto_prox <= FETCH_1;
		
		
		when SUM_1 =>
			sto_prox <= SUM_2;
		when SUM_2 =>
			sto_prox <= SUM_3;
		when SUM_3 =>
			sto_prox <= FETCH_1;
		
		
		when SUMI_1 =>
			sto_prox <= SUMI_2;
		when SUMI_2 =>
			sto_prox <= SUMI_3;
		when SUMI_3 =>
			sto_prox <= SUMI_4;
		when SUMI_4 =>
		   sto_prox <= SUMI_5;
		when SUMI_5 =>
			sto_prox <= FETCH_1;
			
			
		
		when STA_1 =>
		   sto_prox <= STA_2;
		when STA_2 =>
		   sto_prox <= STA_3;
		when STA_3 =>
		   sto_prox <= FETCH_1;
			
		
		when JMP =>
		   sto_prox <= FETCH_1;
		
		
		when JMPI_1 =>
		   sto_prox <= JMPI_2;
		when JMPI_2 =>
		   sto_prox <= JMPI_3;
		when JMPI_3 =>
		   sto_prox <= FETCH_1;
		
		
		when CSR_1 =>
		   sto_prox <= CSR_2;
		when CSR_2 =>
		   sto_prox <= CSR_3;
		when CSR_3 =>
		   sto_prox <= CSR_4;
		when CSR_4 =>
		   sto_prox <= FETCH_1;
		
		
		when ISZ_1 =>
		   sto_prox <= ISZ_2;
		when ISZ_2 =>
		   sto_prox <= ISZ_3;
		when ISZ_3 =>
		   sto_prox <= ISZ_4;
		when ISZ_4 =>
		   if gpr_Z = '1' then
			   sto_prox <= ISZ_5;
			else
			   sto_prox <= FETCH_1;
			end if;
		when ISZ_5 =>
		   sto_prox <= FETCH_1;
			
			
		when STOP =>
		   sto_prox <= STOP;
			
		
		when others =>
		   sto_prox <= FETCH_1;
			
		end case;
	end process;
	
	
	mar_t_pc <= '1' when (sto_atual = FETCH_1) else '0';
	
	gpr_t_pc <= '1' when (sto_atual = CSR_2) else '0';
	
	gpr_t_mem <= '1' when (sto_atual = FETCH_2) or
	                      (sto_atual = SUM_2) or
								 (sto_atual = SUMI_2) or
								 (sto_atual = SUMI_2) or
								 (sto_atual = JMPI_2) or
								 (sto_atual = ISZ_2) else '0';
								 
	pc_i <= '1' when (sto_atual = FETCH_2) or
	                 (sto_atual = CSR_4) or
						  (sto_atual = ISZ_5) or
						  (sto_atual = SFZ_2) else '0';
	
	ir_t_gpr <= '1' when sto_atual = FETCH_3 else '0';
	
	mar_t_gpr <= '1' when (sto_atual = SUM_1) or
	                      (sto_atual = SUMI_1) or
								 (sto_atual = SUMI_3) or
								 (sto_atual = STA_1) or
								 (sto_atual = JMPI_1) or
								 (sto_atual = CSR_1) or
								 (sto_atual = ISZ_1) else '0';
								 
	ula_t_gpr <= '1' when (sto_atual = SUM_3) or
	                      (sto_atual = SUMI_5) else '0';
	
	gpr_t_acc <= '1' when (sto_atual = STA_2) else '0';
	
	mem_t_gpr <= '1' when (sto_atual = STA_3) or
                           (sto_atual = CSR_3) or
									(sto_atual = ISZ_4) else '0';
	
	pc_t_gpr <= '1' when (sto_atual = JMP) or
	                     (sto_atual = JMPI_3) or
								(sto_atual = CSR_2) else '0';
	
	gpr_inc <= '1' when (sto_atual = ISZ_3) else '0';
	
	
	ula_z_acc <= '1' when (sto_atual = CRA) else '0';
	
	ula_c_acc <= '1' when (sto_atual = CTA) else '0';
	
	ula_i_acc <= '1' when (sto_atual = ITA) else '0';
	
	ula_rst_f <= '1' when (sto_atual = CRF) else '0';
	
	ula_comp_f <= '1' when (sto_atual = CTF) else '0';
	
	ula_ror_f <= '1' when (sto_atual = ROR_F) else '0';
	
	ula_rol_f <= '1' when (sto_atual = ROL_F) else '0';
	
	
end comportamento;