--- Registradores Auxiliares do Pipeline

---- Registradores IF -> ID
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity IF_ID is
	port (
  		IF_ID_clk : in std_logic;

  		IF_ID_PC_in : in std_logic_vector(31 downto 0);
        IF_ID_PC_out : out std_logic_vector(31 downto 0);
        
        IF_ID_Instr_in : in std_logic_vector(31 downto 0);
        IF_ID_Instr_out : out std_logic_vector(31 downto 0);

        IF_ID_rs1_out : out std_logic_vector(4 downto 0);
        IF_ID_rs2_out : out std_logic_vector(4 downto 0);
        IF_ID_rd_out : out std_logic_vector(4 downto 0);

 	);
end entity;

architecture df of IF_ID is

begin

    process(IF_ID_clk) begin
        if (rising_edge(clk_IFID)) then
            IF_ID_PC_out <= IF_ID_PC_in;

            IF_ID_Instr_out <= IF_ID_Instr_in;

            IF_ID_rs1_out <= IF_ID_Instr_in(19 downto 15);
            IF_ID_rs2_out <= IF_ID_Instr_in(24 downto 20);
            IF_ID_rd_out <= IF_ID_Instr_in(11 downto 7);
        end if;
    end process;

end df;

---- Registradores ID -> EX
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ID_EX is
	port (
  		IF_EX_clk : in std_logic;

  		ID_EX_PC_in : in std_logic_vector(31 downto 0);
        ID_EX_rs1_in : in std_logic_vector(4 downto 0);
        ID_EX_rs2_in : in std_logic_vector(4 downto 0);
        ID_EX_rd_in : in std_logic_vector(4 downto 0);
        ID_EX_imm_in : in std_logic_vector(31 downto 0);
        ID_EX_instr_in : in std_logic_vector(31 downto 0);
        
        ID_EX_PC_out : out std_logic_vector(31 downto 0);
        ID_EX_rs1_out : out std_logic_vector(4 downto 0);
        ID_EX_rs2_out : out std_logic_vector(4 downto 0);
        ID_EX_rd_out : out std_logic_vector(4 downto 0);
        ID_EX_imm_out : out std_logic_vector(31 downto 0);
        ID_EX_instr_out : out std_logic_vector(31 downto 0)
 	);
end entity;

architecture df of ID_EX is

begin

    process(IF_EX_clk) begin
        if (rising_edge(IF_EX_clk)) then
            ID_EX_PC_out <= ID_EX_PC_in;
            ID_EX_rs1_out <= ID_EX_rs1_in;
            ID_EX_rs2_out <= ID_EX_rs2_in;
            ID_EX_rd_out <= ID_EX_rd_in;
            ID_EX_imm_out <= ID_EX_imm_in;
            ID_EX_instr_out <= ID_EX_instr_in;
        end if;
    end process;

end df;

---- Registradores EX/MEM
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity EX_MEM is
	port (
  		EX_MEM_clk : in std_logic;

  		EX_MEM_pc_in : in std_logic_vector(31 downto 0);
        EX_MEM_pc_out : out std_logic_vector(31 downto 0);

        EX_MEM_zero_in : in std_logic;
        EX_MEM_zero_out : out std_logic;

        EX_MEM_rs2_in : in std_logic_vector(4 downto 0);
        EX_MEM_rs2_out : out std_logic_vector(4 downto 0);

        EX_MEM_rd_in : in std_logic_vector(4 downto 0);
        EX_MEM_rd_out : out std_logic_vector(4 downto 0);

        EX_MEM_ula_in : in std_logic_vector(31 downto 0);
        EX_MEM_ula_out : out std_logic_vector(31 downto 0)
 	);
end entity;

architecture df of EX_MEM is

begin

    process(EX_MEM_clk) begin
        if (rising_edge(EX_MEM_clk)) then
            EX_MEM_pc_out <= EX_MEM_pc_in;
            
            EX_MEM_zero_out <= EX_MEM_zero_in;
            
            EX_MEM_rs2_out <= EX_MEM_rs2_in;
            EX_MEM_rd_out <= EX_MEM_rd_in;
            
            EX_MEM_ula_out <= EX_MEM_ula_in;
        end if;
    end process;

end df;

---- Registradores MEM/WB
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MEM_WB is
	port (
  		MEM_WB_clk : in std_logic;

  		MEM_WB_mem_data_in : in std_logic_vector(31 downto 0);
        MEM_WB_mem_data_out : out std_logic_vector(31 downto 0);

        MEM_WB_address_in : in std_logic_vector(7 downto 0);
        MEM_WB_address_out : out std_logic_vector(7 downto 0);

        MEM_WB_rd_in : in std_logic_vector(4 downto 0);
        MEM_WB_rd_out : out std_logic_vector(4 downto 0)
 	);
end entity;

architecture df of MEM_WB is

begin

    process(MEM_WB_clk) begin
        if (rising_edge(MEM_WB_clk)) then
            MEM_WB_mem_data_out <= MEM_WB_mem_data_in;
            MEM_WB_address_out <= MEM_WB_address_in;
            MEM_WB_rd_out <= MEM_WB_rd_in;
        end if;
    end process;

end df;