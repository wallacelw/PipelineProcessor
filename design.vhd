--- Processador Pipeline, modulo principal

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity CPU is
	port (
  		clock : in std_logic;
		reset : in std_logic
 	);
end entity;

architecture structural of CPU is
    
	---------------------------- IF --------------------------

component MUX_PC is
	port (
  		PCMux_Src: in std_logic_vector(1 downto 0);
  		PCMux_Adder_in : in std_logic_vector(31 downto 0);
        PCMux_PC_Imm_in : in std_logic_vector(31 downto 0);
		PCMux_Reg_Imm_in : in std_logic_vector(31 downto 0);
        PCMux_out : out std_logic_vector(31 downto 0)
 	);
end component;
signal PCMux_out_bus : std_logic_vector(31 downto 0);

component PC is
	port (
  		PCReg_clk : in std_logic;
		PCReg_rst : in std_logic;
  		PCReg_in : in std_logic_vector(31 downto 0);
        PCReg_out : out std_logic_vector(31 downto 0);
        PCReg_address_out : out std_logic_vector(7 downto 0)
 	);
end component;
signal PCReg_out_bus : std_logic_vector(31 downto 0);
signal PCReg_address_out_bus : std_logic_vector(7 downto 0);

component ADDER_4 is
	port (
  		PCAdder_in : in std_logic_vector(31 downto 0);
        PCAdder_out : out std_logic_vector(31 downto 0)
 	);
end component;
signal PCAdder_out_bus : std_logic_vector(31 downto 0);

component MEM_INSTR is
    port (
        MI_address : in std_logic_vector(7 downto 0);
        MI_Instr_out : out std_logic_vector(31 downto 0)
    );
end component;
signal MI_Instr_out_bus : std_logic_vector(31 downto 0);

component IF_ID_PIPE is
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
signal IF_ID_PC_out_bus : std_logic_vector(31 downto 0);
signal IF_ID_Instr_out_bus : std_logic_vector(31 downto 0);
signal IF_ID_rs1_out_bus : std_logic_vector(4 downto 0);
signal IF_ID_rs2_out_bus : std_logic_vector(4 downto 0);
signal IF_ID_rd_out_bus : std_logic_vector(4 downto 0);
signal IF_ID_PC_PLUS_4_out_bus : std_logic_vector(31 downto 0);

	---------------------------- ID --------------------------

component CONTROL_MODULE is
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
signal CONTROL_ALUSrc_bus : std_logic;
signal CONTROL_ALUOp_bus : std_logic_vector(1 downto 0);
signal CONTROL_Branch_bus : std_logic;
signal CONTROL_Jal_bus : std_logic_vector(1 downto 0);
signal CONTROL_MemWrite_bus : std_logic;
signal CONTROL_RegWrite_bus : std_logic;
signal CONTROL_ResultSrc_bus : std_logic_vector(2 downto 0);

component XREGS is
    port (
        XRegs_clk, XRegs_wren, XRegs_rst : in std_logic;
        XRegs_rs1, Xregs_rs2, XRegs_rd : in std_logic_vector(4 downto 0);
        XRegs_data : in std_logic_vector(31 downto 0);
        XRegs_ro1, XRegs_ro2 : out std_logic_vector(31 downto 0)
	);
end component;
signal XRegs_ro1_bus, XRegs_ro2_bus : std_logic_vector(31 downto 0);

component GenImm is
    port (
        GEN_IMM_instr : in std_logic_vector(31 downto 0);
        GEN_IMM_imm32 : out std_logic_vector(31 downto 0)
    );
end component;
signal GEN_IMM_imm32_bus : std_logic_vector(31 downto 0);

component ID_EX_PIPE is
	port (
  		ID_EX_clk : in std_logic;

  		ID_EX_PC_in : in std_logic_vector(31 downto 0);
        ID_EX_PC_out : out std_logic_vector(31 downto 0);
        
        ID_EX_ro1_in : in std_logic_vector(31 downto 0);
        ID_EX_ro1_out : out std_logic_vector(31 downto 0);
        
        ID_EX_ro2_in : in std_logic_vector(31 downto 0);
        ID_EX_ro2_out : out std_logic_vector(31 downto 0);
        
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
        ID_EX_CONTROL_Jal_in : in std_logic_vector(1 downto 0);
        ID_EX_CONTROL_MemWrite_in : in std_logic;
        ID_EX_CONTROL_RegWrite_in : in std_logic;
        ID_EX_CONTROL_ResultSrc_in : in std_logic_vector(2 downto 0);

        ID_EX_CONTROL_ALUSrc_out : out std_logic;
        ID_EX_CONTROL_ALUOp_out : out std_logic_vector(1 downto 0);
        ID_EX_CONTROL_Branch_out : out std_logic;
        ID_EX_CONTROL_Jal_out : out std_logic_vector(1 downto 0);
        ID_EX_CONTROL_MemWrite_out : out std_logic;
        ID_EX_CONTROL_RegWrite_out : out std_logic;
        ID_EX_CONTROL_ResultSrc_out : out std_logic_vector(2 downto 0)
 	);
end component;
signal ID_EX_PC_out_bus : std_logic_vector(31 downto 0);
signal ID_EX_ro1_out_bus : std_logic_vector(31 downto 0);
signal ID_EX_ro2_out_bus : std_logic_vector(31 downto 0);
signal ID_EX_rd_out_bus : std_logic_vector(4 downto 0);
signal ID_EX_imm_out_bus : std_logic_vector(31 downto 0);
signal ID_EX_instr_out_bus : std_logic_vector(31 downto 0);
signal ID_EX_PC_PLUS_4_out_bus : std_logic_vector(31 downto 0);
signal ID_EX_CONTROL_ALUSrc_out_bus : std_logic;
signal ID_EX_CONTROL_ALUOp_out_bus : std_logic_vector(1 downto 0);
signal ID_EX_CONTROL_Branch_out_bus : std_logic;
signal ID_EX_CONTROL_Jal_out_bus : std_logic_vector(1 downto 0);
signal ID_EX_CONTROL_MemWrite_out_bus : std_logic;
signal ID_EX_CONTROL_RegWrite_out_bus : std_logic;
signal ID_EX_CONTROL_ResultSrc_out_bus : std_logic_vector(2 downto 0);

	---------------------------- EX --------------------------

component ADDER_PC_IMM is
	port (
  		PC_IMM_Adder_PC : in std_logic_vector(31 downto 0);
        PC_IMM_Adder_Imm : in std_logic_vector(31 downto 0);
        PC_IMM_Adder_out : out std_logic_vector(31 downto 0)
 	);
end component;
signal PC_IMM_Adder_out_bus : std_logic_vector(31 downto 0);

component MUX_ALU is
	port (
  		ALUMUX_ALUSrc : in std_logic;
  		ALUMUX_ro2 : in std_logic_vector(31 downto 0);
        ALUMUX_imm : in std_logic_vector(31 downto 0);
        ALUMUX_out : out std_logic_vector(31 downto 0)
 	);
end component;
signal ALUMUX_out_bus : std_logic_vector(31 downto 0);

component ALU is
    port (
        ALU_opcode : in std_logic_vector(3 downto 0);
        ALU_A, ALU_B : in std_logic_vector(31 downto 0);
        ALU_Z : out std_logic_vector(31 downto 0);
        ALU_zero : out std_logic
    );
end component ALU;
signal ALU_Z_bus : std_logic_vector(31 downto 0);
signal ALU_zero_bus : std_logic;

component ALU_Control is
	port (
  		ALU_Control_instr : in std_logic_vector(31 downto 0);
        ALU_Control_alu_op : in std_logic_vector(1 downto 0);
        ALU_Control_out : out std_logic_vector(3 downto 0)
 	);
end component;
signal ALU_Control_out_bus : std_logic_vector(3 downto 0);

component EX_MEM_PIPE is
	port (
  		EX_MEM_clk : in std_logic;

  		EX_MEM_PC_plus_Imm_in : in std_logic_vector(31 downto 0);
        EX_MEM_Pc_plus_Imm_out : out std_logic_vector(31 downto 0);

        EX_MEM_zero_in : in std_logic;
        EX_MEM_zero_out : out std_logic;

        EX_MEM_ro2_in : in std_logic_vector(31 downto 0);
        EX_MEM_ro2_out : out std_logic_vector(31 downto 0);

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
        EX_MEM_CONTROL_Jal_in : in std_logic_vector(1 downto 0);
        EX_MEM_CONTROL_MemWrite_in : in std_logic;
        EX_MEM_CONTROL_RegWrite_in : in std_logic;
        EX_MEM_CONTROL_ResultSrc_in : in std_logic_vector(2 downto 0);

        EX_MEM_CONTROL_Branch_out : out std_logic;
        EX_MEM_CONTROL_Jal_out : out std_logic_vector(1 downto 0);
        EX_MEM_CONTROL_MemWrite_out : out std_logic;
        EX_MEM_CONTROL_RegWrite_out : out std_logic;
        EX_MEM_CONTROL_ResultSrc_out : out std_logic_vector(2 downto 0)
 	);
end component;
signal EX_MEM_Pc_plus_Imm_out_bus : std_logic_vector(31 downto 0);
signal EX_MEM_zero_out_bus : std_logic;
signal EX_MEM_ro2_out_bus : std_logic_vector(31 downto 0);
signal EX_MEM_rd_out_bus : std_logic_vector(4 downto 0);
signal EX_MEM_Alu_out_bus : std_logic_vector(31 downto 0);
signal EX_MEM_imm_out_bus : std_logic_vector(31 downto 0);
signal EX_MEM_PC_PLUS_4_out_bus : std_logic_vector(31 downto 0);
signal EX_MEM_address_out_bus : std_logic_vector(7 downto 0);
signal EX_MEM_CONTROL_Branch_out_bus : std_logic;
signal EX_MEM_CONTROL_Jal_out_bus : std_logic_vector(1 downto 0);
signal EX_MEM_CONTROL_MemWrite_out_bus : std_logic;
signal EX_MEM_CONTROL_RegWrite_out_bus : std_logic;
signal EX_MEM_CONTROL_ResultSrc_out_bus : std_logic_vector(2 downto 0);

	---------------------------- MEM --------------------------

component PC_Control is
	port (
  		PC_Control_Branch : in std_logic;
        PC_Control_Zero : in std_logic;
        PC_Control_Jal : in std_logic_vector(1 downto 0);

        PC_Control_PCSRC : out std_logic_vector(1 downto 0)
 	);
end component;
signal PC_Control_PCSRC_bus : std_logic_vector(1 downto 0) := "00";

component MEM_DADOS is
    port (
        MD_clk : in std_logic;
        MD_we : in std_logic;
        MD_address : in std_logic_vector(7 downto 0);
        MD_datain : in std_logic_vector(31 downto 0);
        MD_dataout : out std_logic_vector(31 downto 0)
    );
end component;
signal MD_dataout_bus : std_logic_vector(31 downto 0);

component MEM_WB_PIPE is
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
        MEM_WB_CONTROL_ResultSrc_in : in std_logic_vector(2 downto 0);

        MEM_WB_CONTROL_RegWrite_out : out std_logic;
        MEM_WB_CONTROL_ResultSrc_out : out std_logic_vector(2 downto 0)
 	);
end component;
signal MEM_WB_mem_data_out_bus : std_logic_vector(31 downto 0);
signal MEM_WB_Alu_out_bus : std_logic_vector(31 downto 0);
signal MEM_WB_rd_out_bus : std_logic_vector(4 downto 0);
signal MEM_WB_Pc_plus_Imm_out_bus : std_logic_vector(31 downto 0);
signal MEM_WB_imm_out_bus : std_logic_vector(31 downto 0);
signal MEM_WB_PC_PLUS_4_out_bus : std_logic_vector(31 downto 0);
signal MEM_WB_CONTROL_RegWrite_out_bus : std_logic;
signal MEM_WB_CONTROL_ResultSrc_out_bus : std_logic_vector(2 downto 0);

	---------------------------- WB --------------------------

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
signal XREGSMUX_out_bus : std_logic_vector(31 downto 0);

begin

	---------------------------- IF --------------------------

	PCMUX: MUX_PC port map (
		PCMux_Src => PC_Control_PCSRC_bus,
		PCMux_Adder_in => PCAdder_out_bus,
		PCMux_PC_Imm_in => EX_MEM_Pc_plus_Imm_out_bus,
		PCMux_Reg_Imm_in => EX_MEM_Alu_out_bus,
		PCMux_out => PCMux_out_bus
	);

	PCREG: PC port map (
		PCReg_clk => clock,
		PCReg_rst => reset,
		PCReg_in => PCMux_out_bus,
		PCReg_out => PCReg_out_bus,
		PCReg_address_out => PCReg_address_out_bus
	);

	PCADDER: ADDER_4 port map (
		PCAdder_in => PCReg_out_bus,
		PCAdder_out => PCAdder_out_bus
	);

	MI: MEM_INSTR port map (
		MI_address => PCReg_address_out_bus,
		MI_Instr_out => MI_Instr_out_bus
	);

	IF_ID: IF_ID_PIPE port map (
		IF_ID_clk => clock,
		IF_ID_PC_in => PCReg_out_bus,
		IF_ID_PC_out => IF_ID_PC_out_bus,
		IF_ID_Instr_in => MI_Instr_out_bus,
		IF_ID_Instr_out => IF_ID_Instr_out_bus,
		IF_ID_rs1_out => IF_ID_rs1_out_bus,
		IF_ID_rs2_out => IF_ID_rs2_out_bus,
		IF_ID_rd_out => IF_ID_rd_out_bus,
		IF_ID_PC_PLUS_4_in => PCAdder_out_bus,
		IF_ID_PC_PLUS_4_out => IF_ID_PC_PLUS_4_out_bus
	);

	---------------------------- ID --------------------------

	CONTROL: CONTROL_MODULE port map (
		CONTROL_instr => IF_ID_Instr_out_bus,
		CONTROL_ALUSrc => CONTROL_ALUSrc_bus,
		CONTROL_ALUOp => CONTROL_ALUOp_bus,
		CONTROL_Branch => CONTROL_Branch_bus,
		CONTROL_Jal => CONTROL_Jal_bus,
		CONTROL_MemWrite => CONTROL_MemWrite_bus,
		CONTROL_RegWrite => CONTROL_RegWrite_bus,
		CONTROL_ResultSrc => CONTROL_ResultSrc_bus
	);

	BancoRegs: XREGS port map (
		XRegs_clk => clock,
		XRegs_wren => MEM_WB_CONTROL_RegWrite_out_bus,
		XRegs_rst => reset,
		XRegs_rs1 => IF_ID_rs1_out_bus,
		Xregs_rs2 => IF_ID_rs2_out_bus,
		XRegs_rd => MEM_WB_rd_out_bus,
		XRegs_data => XREGSMUX_out_bus,
		XRegs_ro1 => XRegs_ro1_bus,
		XRegs_ro2 => XRegs_ro2_bus
	);

	GeradorIMM: GenImm port map (
		GEN_IMM_instr => IF_ID_Instr_out_bus,
		GEN_IMM_imm32 => GEN_IMM_imm32_bus
	);
	
	ID_EX: ID_EX_PIPE port map (
		ID_EX_clk => clock,
		ID_EX_PC_in => IF_ID_PC_out_bus,
		ID_EX_PC_out => ID_EX_PC_out_bus,
		ID_EX_ro1_in => XRegs_ro1_bus,
		ID_EX_ro1_out => ID_EX_ro1_out_bus,
		ID_EX_ro2_in => XRegs_ro2_bus,
		ID_EX_ro2_out => ID_EX_ro2_out_bus,
		ID_EX_rd_in => IF_ID_rd_out_bus,
		ID_EX_rd_out => ID_EX_rd_out_bus,
		ID_EX_imm_in => GEN_IMM_imm32_bus,
		ID_EX_imm_out => ID_EX_imm_out_bus,
		ID_EX_instr_in => IF_ID_Instr_out_bus,
		ID_EX_instr_out => ID_EX_instr_out_bus,
		ID_EX_PC_PLUS_4_in => IF_ID_PC_PLUS_4_out_bus,
		ID_EX_PC_PLUS_4_out => ID_EX_PC_PLUS_4_out_bus,
		ID_EX_CONTROL_ALUSrc_in => CONTROL_ALUSrc_bus,
		ID_EX_CONTROL_ALUSrc_out => ID_EX_CONTROL_ALUSrc_out_bus,
		ID_EX_CONTROL_ALUOp_in => CONTROL_ALUOp_bus,
		ID_EX_CONTROL_ALUOp_out => ID_EX_CONTROL_ALUOp_out_bus,
		ID_EX_CONTROL_Branch_in => CONTROL_Branch_bus,
		ID_EX_CONTROL_Branch_out => ID_EX_CONTROL_Branch_out_bus,
		ID_EX_CONTROL_Jal_in => CONTROL_Jal_bus,
		ID_EX_CONTROL_Jal_out => ID_EX_CONTROL_Jal_out_bus,
		ID_EX_CONTROL_MemWrite_in => CONTROL_MemWrite_bus,
		ID_EX_CONTROL_MemWrite_out => ID_EX_CONTROL_MemWrite_out_bus,
		ID_EX_CONTROL_RegWrite_in => CONTROL_RegWrite_bus,
		ID_EX_CONTROL_RegWrite_out => ID_EX_CONTROL_RegWrite_out_bus,
		ID_EX_CONTROL_ResultSrc_in => CONTROL_ResultSrc_bus,
		ID_EX_CONTROL_ResultSrc_out => ID_EX_CONTROL_ResultSrc_out_bus
	);

	---------------------------- EX --------------------------

	PC_IMM_Adder: ADDER_PC_IMM port map (
		PC_IMM_Adder_PC => ID_EX_PC_out_bus,
		PC_IMM_Adder_Imm => ID_EX_imm_out_bus,
		PC_IMM_Adder_out => PC_IMM_Adder_out_bus
	);

	ALUMUX: MUX_ALU port map (
		ALUMUX_ALUSrc => ID_EX_CONTROL_ALUSrc_out_bus,
		ALUMUX_ro2 => ID_EX_ro2_out_bus,
		ALUMUX_imm => ID_EX_imm_out_bus,
		ALUMUX_out => ALUMUX_out_bus
	);

	ULA: ALU port map (
		ALU_opcode => ALU_Control_out_bus,
		ALU_A => ID_EX_ro1_out_bus,
		ALU_B => ALUMUX_out_bus,
		ALU_Z => ALU_Z_bus,
		ALU_zero => ALU_zero_bus
	);

	controleULA: ALU_Control port map (
		ALU_Control_instr => ID_EX_instr_out_bus,
		ALU_Control_alu_op => ID_EX_CONTROL_ALUOp_out_bus,
		ALU_Control_out => ALU_Control_out_bus
	);

	EX_MEM: EX_MEM_PIPE port map (
		EX_MEM_clk => clock,
		EX_MEM_PC_plus_Imm_in => ID_EX_PC_PLUS_4_out_bus,
		EX_MEM_Pc_plus_Imm_out => EX_MEM_Pc_plus_Imm_out_bus,
		EX_MEM_zero_in => ALU_zero_bus,
		EX_MEM_zero_out => EX_MEM_zero_out_bus,
		EX_MEM_ro2_in => ID_EX_ro2_out_bus,
		EX_MEM_ro2_out => EX_MEM_ro2_out_bus,
		EX_MEM_rd_in => ID_EX_rd_out_bus,
		EX_MEM_rd_out => EX_MEM_rd_out_bus,
		EX_MEM_Alu_in => ALU_Z_bus,
		EX_MEM_Alu_out => EX_MEM_Alu_out_bus,
		EX_MEM_imm_in => ID_EX_imm_out_bus,
		EX_MEM_imm_out => EX_MEM_imm_out_bus,
		EX_MEM_PC_PLUS_4_in => ID_EX_PC_PLUS_4_out_bus,
		EX_MEM_PC_PLUS_4_out => EX_MEM_PC_PLUS_4_out_bus,
		EX_MEM_address_out => EX_MEM_address_out_bus,
		EX_MEM_CONTROL_Branch_in => ID_EX_CONTROL_Branch_out_bus,
		EX_MEM_CONTROL_Branch_out => EX_MEM_CONTROL_Branch_out_bus,
		EX_MEM_CONTROL_Jal_in => ID_EX_CONTROL_Jal_out_bus,
		EX_MEM_CONTROL_Jal_out => EX_MEM_CONTROL_Jal_out_bus,
		EX_MEM_CONTROL_MemWrite_in => ID_EX_CONTROL_MemWrite_out_bus,
		EX_MEM_CONTROL_MemWrite_out => EX_MEM_CONTROL_MemWrite_out_bus,
		EX_MEM_CONTROL_RegWrite_in => ID_EX_CONTROL_RegWrite_out_bus,
		EX_MEM_CONTROL_RegWrite_out => EX_MEM_CONTROL_RegWrite_out_bus,
		EX_MEM_CONTROL_ResultSrc_in => ID_EX_CONTROL_ResultSrc_out_bus,
		EX_MEM_CONTROL_ResultSrc_out => EX_MEM_CONTROL_ResultSrc_out_bus
	);

	---------------------------- MEM --------------------------

	Controle_PC: PC_Control port map (
		PC_Control_Branch => EX_MEM_CONTROL_Branch_out_bus,
		PC_Control_Zero => EX_MEM_zero_out_bus,
		PC_Control_Jal => EX_MEM_CONTROL_Jal_out_bus,
		PC_Control_PCSRC => PC_Control_PCSRC_bus
	);

	MD: MEM_DADOS port map (
		MD_clk => clock,
		MD_we => EX_MEM_CONTROL_MemWrite_out_bus,
		MD_address => EX_MEM_address_out_bus,
		MD_datain => EX_MEM_ro2_out_bus,
		MD_dataout => MD_dataout_bus
	);

	MEM_WB: MEM_WB_PIPE port map (
		MEM_WB_clk => clock,
		MEM_WB_mem_data_in => MD_dataout_bus,
		MEM_WB_mem_data_out => MEM_WB_mem_data_out_bus,
		MEM_WB_Alu_in => EX_MEM_Alu_out_bus,
		MEM_WB_Alu_out => MEM_WB_Alu_out_bus,
		MEM_WB_rd_in => EX_MEM_rd_out_bus,
		MEM_WB_rd_out => MEM_WB_rd_out_bus,
		MEM_WB_PC_plus_Imm_in => EX_MEM_Pc_plus_Imm_out_bus,
		MEM_WB_Pc_plus_Imm_out => MEM_WB_Pc_plus_Imm_out_bus,
		MEM_WB_imm_in => EX_MEM_imm_out_bus,
		MEM_WB_imm_out => MEM_WB_imm_out_bus,
		MEM_WB_PC_PLUS_4_in => EX_MEM_PC_PLUS_4_out_bus,
		MEM_WB_PC_PLUS_4_out => MEM_WB_PC_PLUS_4_out_bus,
		MEM_WB_CONTROL_RegWrite_in => EX_MEM_CONTROL_RegWrite_out_bus,
		MEM_WB_CONTROL_RegWrite_out => MEM_WB_CONTROL_RegWrite_out_bus,
		MEM_WB_CONTROL_ResultSrc_in => EX_MEM_CONTROL_ResultSrc_out_bus,
		MEM_WB_CONTROL_ResultSrc_out => MEM_WB_CONTROL_ResultSrc_out_bus
	);

	---------------------------- WB --------------------------

	XREGSMUX: MUX_XREG port map (
		XREGSMUX_ResultSrc => MEM_WB_CONTROL_ResultSrc_out_bus,
		XREGSMUX_ALU_in => MEM_WB_Alu_out_bus,
		XREGSMUX_mem_data_in => MEM_WB_mem_data_out_bus,
		XREGSMUX_pc_plus_4_in => MEM_WB_PC_PLUS_4_out_bus,
		XREGSMUX_pc_plus_Imm_in => MEM_WB_Pc_plus_Imm_out_bus,
		XREGSMUX_Imm_in => MEM_WB_imm_out_bus,
		XREGSMUX_out => XREGSMUX_out_bus
	);

end structural;