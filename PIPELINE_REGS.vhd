--- Registradores Auxiliares do Pipeline

---- Registradores IF -> ID
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity IF_ID_PIPE is
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
end entity;

architecture df of IF_ID_PIPE is

begin

    process(IF_ID_clk) begin
        if (rising_edge(IF_ID_clk)) then
            IF_ID_PC_out <= IF_ID_PC_in;

            IF_ID_Instr_out <= IF_ID_Instr_in;
            
            IF_ID_rs1_out <= IF_ID_Instr_in(19 downto 15);
            IF_ID_rs2_out <= IF_ID_Instr_in(24 downto 20);
            IF_ID_rd_out <= IF_ID_Instr_in(11 downto 7);

            IF_ID_PC_PLUS_4_out <= IF_ID_PC_PLUS_4_in;
        end if;
    end process;

end df;

---- Registradores ID -> EX
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ID_EX_PIPE is
	port (
  		ID_EX_clk : in std_logic;

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
        ID_EX_CONTROL_Jal_in : in std_logic_vector(1 downto 0);
        ID_EX_CONTROL_MemWrite_in : in std_logic;
        ID_EX_CONTROL_RegWrite_in : in std_logic;
        ID_EX_CONTROL_ResultSrc_in : in std_logic_vector(1 downto 0);

        ID_EX_CONTROL_ALUSrc_out : out std_logic;
        ID_EX_CONTROL_ALUOp_out : out std_logic_vector(1 downto 0);
        ID_EX_CONTROL_Branch_out : out std_logic;
        ID_EX_CONTROL_Jal_out : out std_logic_vector(1 downto 0);
        ID_EX_CONTROL_MemWrite_out : out std_logic;
        ID_EX_CONTROL_RegWrite_out : out std_logic;
        ID_EX_CONTROL_ResultSrc_out : out std_logic_vector(1 downto 0)
 	);
end entity;

architecture df of ID_EX_PIPE is

begin

    process(IF_EX_clk) begin
        if (rising_edge(IF_EX_clk)) then
            ID_EX_PC_out <= ID_EX_PC_in;

            ID_EX_rs1_out <= ID_EX_rs1_in;

            ID_EX_rs2_out <= ID_EX_rs2_in;

            ID_EX_rd_out <= ID_EX_rd_in;

            ID_EX_imm_out <= ID_EX_imm_in;

            ID_EX_instr_out <= ID_EX_instr_in;

            ID_EX_PC_PLUS_4_out <= ID_EX_PC_PLUS_4_in;

            ID_EX_CONTROL_ALUSrc_out <= ID_EX_CONTROL_ALUSrc_in;
            ID_EX_CONTROL_ALUOp_out <= ID_EX_CONTROL_ALUOp_in;
            ID_EX_CONTROL_Branch_out <= ID_EX_CONTROL_Branch_in;
            ID_EX_CONTROL_Jal_out <= ID_EX_CONTROL_Jal_in;
            ID_EX_CONTROL_MemWrite_out <= ID_EX_CONTROL_MemWrite_in;
            ID_EX_CONTROL_RegWrite_out <= ID_EX_CONTROL_RegWrite_in;
            ID_EX_CONTROL_ResultSrc_out <= ID_EX_CONTROL_ResultSrc_in;
        end if;
    end process;

end df;

---- Registradores EX/MEM
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity EX_MEM_PIPE is
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
        EX_MEM_CONTROL_Jal_in : in std_logic_vector(1 downto 0);
        EX_MEM_CONTROL_MemWrite_in : in std_logic;
        EX_MEM_CONTROL_RegWrite_in : in std_logic;
        EX_MEM_CONTROL_ResultSrc_in : in std_logic_vector(1 downto 0);

        EX_MEM_CONTROL_Branch_out : out std_logic;
        EX_MEM_CONTROL_Jal_out : out std_logic_vector(1 downto 0);
        EX_MEM_CONTROL_MemWrite_out : out std_logic;
        EX_MEM_CONTROL_RegWrite_out : out std_logic;
        EX_MEM_CONTROL_ResultSrc_out : out std_logic_vector(1 downto 0)
 	);
end entity;

architecture df of EX_MEM_PIPE is

begin

    process(EX_MEM_clk) begin
        if (rising_edge(EX_MEM_clk)) then
            EX_MEM_Pc_plus_Imm_out <= EX_MEM_PC_plus_Imm_in;

            EX_MEM_zero_out <= EX_MEM_zero_in;

            EX_MEM_rs2_out <= EX_MEM_rs2_in;

            EX_MEM_rd_out <= EX_MEM_rd_in;

            EX_MEM_Alu_out <= EX_MEM_Alu_in;

            EX_MEM_imm_out <= EX_MEM_imm_in;

            EX_MEM_PC_PLUS_4_out <= EX_MEM_PC_PLUS_4_in;

            EX_MEM_address_out <= EX_MEM_Alu_in(7 downto 0);

            EX_MEM_CONTROL_Branch_out <= EX_MEM_CONTROL_Branch_in;
            EX_MEM_CONTROL_Jal_out <= EX_MEM_CONTROL_Jal_in;
            EX_MEM_CONTROL_MemWrite_out <= EX_MEM_CONTROL_MemWrite_in;
            EX_MEM_CONTROL_RegWrite_out <= EX_MEM_CONTROL_RegWrite_in;
            EX_MEM_CONTROL_ResultSrc_out <= EX_MEM_CONTROL_ResultSrc_in;
        end if;
    end process;

end df;

---- Registradores MEM/WB
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MEM_WB_PIPE is
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
end entity;

architecture df of MEM_WB_PIPE is

begin

    process(MEM_WB_clk) begin
        if (rising_edge(MEM_WB_clk)) then
            MEM_WB_mem_data_out <= MEM_WB_mem_data_in;

            MEM_WB_Alu_out <= MEM_WB_Alu_in;

            MEM_WB_rd_out <= MEM_WB_rd_in;

            MEM_WB_PC_plus_Imm_out <= MEM_WB_PC_plus_Imm_in;
            
            MEM_WB_imm_out <= MEM_WB_imm_in;

            MEM_WB_PC_PLUS_4_out <= MEM_WB_PC_PLUS_4_in;

            MEM_WB_CONTROL_RegWrite_out <= MEM_WB_CONTROL_RegWrite_in;
            MEM_WB_CONTROL_ResultSrc_out <= MEM_WB_CONTROL_ResultSrc_in;
        end if;
    end process;

end df;