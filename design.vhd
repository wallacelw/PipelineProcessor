--- Processador Pipeline, modulo principal

-- NOT COMPLETE

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity CPU is
	port (
  		clock : in std_logic
 	);
end entity;

architecture structural of CPU is
    
	-- IF

    component MUX_PC is
		port (
			PCMux_Src: in std_logic_vector(1 downto 0);
			PCMux_Adder_in : in std_logic_vector(31 downto 0);
			PCMux_PC_Imm_in : in std_logic_vector(31 downto 0);
			PCMux_Reg_Imm_in : in std_logic_vector(31 downto 0);
			PCMux_out : out std_logic_vector(31 downto 0)
		);
	end component;

	component PC is
		port (
			PCReg_clk : in std_logic;
			PCReg_in : in std_logic_vector(31 downto 0);
			PCReg_out : out std_logic_vector(31 downto 0);
		);
	end component;

	component ADDER_4 is
		port (
			PCAdder_in : in std_logic_vector(31 downto 0);
			PCAdder_out : out std_logic_vector(31 downto 0)
		);
	end component;

	component MEM_INSTR is
		port (
			MI_address : in std_logic_vector(7 downto 0);
			MI_Instr_out : out std_logic_vector(31 downto 0)
		);
	end component;

	component IF_ID is
		port (
			IF_ID_clk : in std_logic;

			IF_ID_PC_in : in std_logic_vector(31 downto 0);
			IF_ID_PC_out : out std_logic_vector(31 downto 0);

			IF_ID_Instr_in : in std_logic_vector(31 downto 0);
			IF_ID_Instr_out : out std_logic_vector(31 downto 0);

			IF_ID_rs1_out : out std_logic_vector(4 downto 0);
			IF_ID_rs2_out : out std_logic_vector(4 downto 0);
			IF_ID_rd_out : out std_logic_vector(4 downto 0);

			IF_ID_PC_PLUS_4_in : in std_logic_vector(31 downto 0);
			IF_ID_PC_PLUS_4_out : out std_logic_vector(31 downto 0)
		);
	end component;

	-- ID

	component CONTROL is
		port (
			CONTROL_instr : in std_logic_vector(31 downto 0);

			--EX
			CONTROL_ALUSrc : out std_logic;
			CONTROL_ALUOp : out std_logic_vector(1 downto 0);

			--MEM
			CONTROL_Branch : out std_logic;
			CONTROL_Jal : out std_logic_vector(1 downto 0); -- indica se a instrução é do tipo Jal (== 01) or Jalr (== 10)
			CONTROL_MemWrite : out std_logic; -- memWrite = 1; memRead = 0

			--WB
			CONTROL_RegWrite : out std_logic;
			CONTROL_ResultSrc : out std_logic_vector(2 downto 0) -- Mem2Reg extendido
		);
	end component;

	component XREGS is
		port (
			XRegs_clk, XRegs_wren, XRegs_rst : in std_logic;
			XRegs_rs1, Xregs_rs2, XRegs_rd : in std_logic_vector(4 downto 0);
			XRegs_data : in std_logic_vector(31 downto 0);
			XRegs_ro1, XRegs_ro2 : out std_logic_vector(31 downto 0)
		);
	end component;

	component GenImm is
		port (
			GEN_IMM_instr : in std_logic_vector(31 downto 0);
			GEN_IMM_imm32 : out signed(31 downto 0)
		);
	end component;

	component ID_EX is
		port (
			IF_EX_clk : in std_logic;

			ID_EX_PC_in : in std_logic_vector(31 downto 0);
			ID_EX_PC_out : out std_logic_vector(31 downto 0);
			
			ID_EX_rs1_in : in std_logic_vector(4 downto 0);
			ID_EX_rs1_out : out std_logic_vector(4 downto 0);
			
			ID_EX_rs2_in : in std_logic_vector(4 downto 0);
			ID_EX_rs2_out : out std_logic_vector(4 downto 0);
			
			ID_EX_rd_in : in std_logic_vector(4 downto 0);
			ID_EX_rd_out : out std_logic_vector(4 downto 0);
			
			ID_EX_imm_in : in std_logic_vector(31 downto 0);
			ID_EX_imm_out : out std_logic_vector(31 downto 0);
			
			ID_EX_instr_in : in std_logic_vector(31 downto 0);
			ID_EX_instr_out : out std_logic_vector(31 downto 0);
			
			ID_EX_PC_PLUS_4_in : in std_logic_vector(31 downto 0);
			ID_EX_PC_PLUS_4_out : out std_logic_vector(31 downto 0);

			-- control
			ID_EX_CONTROL_ALUSrc_in : in std_logic;
			ID_EX_CONTROL_ALUOp_in : in std_logic_vector(1 downto 0);
			ID_EX_CONTROL_Branch_in : in std_logic;
			ID_EX_CONTROL_Jal_in : in std_logic(1 downto 0);
			ID_EX_CONTROL_MemWrite_in : in std_logic;
			ID_EX_CONTROL_RegWrite_in : in std_logic;
			ID_EX_CONTROL_ResultSrc_in : in std_logic_vector(1 downto 0);

			ID_EX_CONTROL_ALUSrc_out : out std_logic;
			ID_EX_CONTROL_ALUOp_out : out std_logic_vector(1 downto 0);
			ID_EX_CONTROL_Branch_out : out std_logic;
			ID_EX_CONTROL_Jal_out : out std_logic;
			ID_EX_CONTROL_MemWrite_out : out std_logic;
			ID_EX_CONTROL_RegWrite_out : out std_logic;
			ID_EX_CONTROL_ResultSrc_out : out std_logic_vector(1 downto 0)
		);
	end component;

	-- EX

	component ADDER_PC_IMM is
		port (
			PC_IMM_Adder_PC : in std_logic_vector(31 downto 0);
			PC_IMM_Adder_Imm : in std_logic_vector(31 downto 0);
			PC_IMM_Adder_out : out std_logic_vector(31 downto 0)
		);
	end component;

	component MUX_ALU is
		port (
			ALUMUX_ALUSrc : in std_logic;
			ALUMUX_rs2 : in std_logic_vector(31 downto 0);
			ALUMUX_imm : in std_logic_vector(31 downto 0);
			ALUMUX_out : out std_logic_vector(31 downto 0)
		);
	end component;

	component ALU is
		port (
			ALU_opcode : in std_logic_vector(3 downto 0);
			ALU_A, ALU_B : in std_logic_vector(31 downto 0);
			ALU_Z : out std_logic_vector(31 downto 0);
			ALU_zero : out std_logic
		);
	end component ALU;

	component ALU_Control is
		port (
			ALU_Control_instr : in std_logic_vector(31 downto 0);
			ALU_Control_alu_op : in std_logic_vector(1 downto 0);
			ALU_Control_out : out std_logic_vector(31 downto 0)
		);
	end component;

	component EX_MEM is
		port (
			EX_MEM_clk : in std_logic;

			EX_MEM_PC_plus_Imm_in : in std_logic_vector(31 downto 0);
			EX_MEM_Pc_plus_Imm_out : out std_logic_vector(31 downto 0);

			EX_MEM_zero_in : in std_logic;
			EX_MEM_zero_out : out std_logic;

			EX_MEM_rs2_in : in std_logic_vector(4 downto 0);
			EX_MEM_rs2_out : out std_logic_vector(4 downto 0);

			EX_MEM_rd_in : in std_logic_vector(4 downto 0);
			EX_MEM_rd_out : out std_logic_vector(4 downto 0);

			EX_MEM_Alu_in : in std_logic_vector(31 downto 0);
			EX_MEM_Alu_out : out std_logic_vector(31 downto 0);

			EX_MEM_imm_in : in std_logic_vector(31 downto 0);
			EX_MEM_imm_out : out std_logic_vector(31 downto 0);

			EX_MEM_PC_PLUS_4_in : in std_logic_vector(31 downto 0);
			EX_MEM_PC_PLUS_4_out : out std_logic_vector(31 downto 0);

			EX_MEM_address_out : out std_logic_vector(7 downto 0);

			-- control
			EX_MEM_CONTROL_Branch_in : in std_logic;
			EX_MEM_CONTROL_Jal_in : in std_logic(1 downto 0);
			EX_MEM_CONTROL_MemWrite_in : in std_logic;
			EX_MEM_CONTROL_RegWrite_in : in std_logic;
			EX_MEM_CONTROL_ResultSrc_in : in std_logic_vector(1 downto 0);

			EX_MEM_CONTROL_Branch_out : out std_logic;
			EX_MEM_CONTROL_Jal_out : out std_logic;
			EX_MEM_CONTROL_MemWrite_out : out std_logic;
			EX_MEM_CONTROL_RegWrite_out : out std_logic;
			EX_MEM_CONTROL_ResultSrc_out : out std_logic_vector(1 downto 0)
		);
	end component;

	-- MEM

	component PC_Control is
		port (
			PC_Control_Branch : in std_logic;
			PC_Control_Zero : in std_logic;
			PC_Control_Jal : in std_logic_vector(1 downto 0);

			PC_Control_PCSRC : out std_logic(1 downto 0);
		);
	end component;

	component MEM_DADOS is
		port (
			MD_clk : in std_logic;
			MD_we : in std_logic;
			MD_address : in std_logic_vector(7 downto 0);
			MD_datain : in std_logic_vector(31 downto 0);
			MD_dataout : out std_logic_vector(31 downto 0)
		);
	end component;

	component MEM_WB is
		port (
			MEM_WB_clk : in std_logic;

			MEM_WB_mem_data_in : in std_logic_vector(31 downto 0);
			MEM_WB_mem_data_out : out std_logic_vector(31 downto 0);

			MEM_WB_Alu_in : in std_logic_vector(31 downto 0);
			MEM_WB_Alu_out : out std_logic_vector(31 downto 0);

			MEM_WB_rd_in : in std_logic_vector(4 downto 0);
			MEM_WB_rd_out : out std_logic_vector(4 downto 0);

			MEM_WB_PC_plus_Imm_in : in std_logic_vector(31 downto 0);
			MEM_WB_Pc_plus_Imm_out : out std_logic_vector(31 downto 0);

			MEM_WB_imm_in : in std_logic_vector(31 downto 0);
			MEM_WB_imm_out : out std_logic_vector(31 downto 0);

			MEM_WB_PC_PLUS_4_in : in std_logic_vector(31 downto 0);
			MEM_WB_PC_PLUS_4_out : out std_logic_vector(31 downto 0);

			-- control
			MEM_WB_CONTROL_RegWrite_in : in std_logic;
			MEM_WB_CONTROL_ResultSrc_in : in std_logic_vector(1 downto 0);

			MEM_WB_CONTROL_RegWrite_out : out std_logic;
			MEM_WB_CONTROL_ResultSrc_out : out std_logic_vector(1 downto 0)
		);
	end component;

	-- WB

	component MUX_XREG is
		port (
			XREGSMUX_ResultSrc : in std_logic_vector(2 downto 0);

			XREGSMUX_ALU_in : in std_logic_vector(31 downto 0);
			XREGSMUX_mem_data_in : in std_logic_vector(31 downto 0);
			XREGSMUX_pc_plus_4_in : in std_logic_vector(31 downto 0);
			XREGSMUX_pc_plus_Imm_in : in std_logic_vector(31 downto 0);
			XREGSMUX_Imm_in : in std_logic_vector(31 downto 0);

			XREGSMUX_out : out std_logic_vector(31 downto 0)
		);
	end component;

begin

end structural;