--- Registradores Auxiliares do Pipeline

---- Registradores IF -> ID
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity IF_ID is
	port (
  		clk : in std_logic;
  		pc_in : in std_logic_vector(31 downto 0);
        instr_in : in std_logic_vector(31 downto 0);
        pc_out : out std_logic_vector(31 downto 0);
        instr_out : out std_logic_vector(31 downto 0)
 	);
end entity;

architecture df of IF_ID is

begin

    process(clk) begin
        if (rising_edge(clk)) then
            pc_out <= pc_in;
            instr_out <= instr_in;
        end if;
    end process;

end df;

---- Registradores ID -> EX
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ID_EX is
	port (
  		clk : in std_logic;
  		pc_in : in std_logic_vector(31 downto 0);
        pc_out : out std_logic_vector(31 downto 0);
        rs1_in : in std_logic_vector(31 downto 0);
        rs1_out : out std_logic_vector(31 downto 0);
        rs2_in : in std_logic_vector(31 downto 0);
        rs2_out : out std_logic_vector(31 downto 0);
        imm_in : in std_logic_vector(31 downto 0);
        imm_out : out std_logic_vector(31 downto 0);
        instr_in : in std_logic_vector(31 downto 0);
        instr_out : out std_logic_vector(31 downto 0)
 	);
end entity;

architecture df of ID_EX is

begin

    process(clk) begin
        if (rising_edge(clk)) then
            pc_out <= pc_in;
            rs1_out <= rs1_in;
            rs2_out <= rs2_in;
            imm_out <= imm_in;
            instr_out <= instr_in;
        end if;
    end process;

end df;

---- Registradores EX/MEM
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity EX_MEM is
	port (
  		clk : in std_logic;
  		pc_in : in std_logic_vector(31 downto 0);
        pc_out : out std_logic_vector(31 downto 0);
        zero_in : in std_logic_vector(31 downto 0);
        zero_out : out std_logic_vector(31 downto 0);
        rs2_in : in std_logic_vector(31 downto 0);
        rs2_out : out std_logic_vector(31 downto 0);
        ula_in : in std_logic_vector(31 downto 0);
        ula_out : out std_logic_vector(31 downto 0);
        instr_in : in std_logic_vector(31 downto 0);
        instr_out : out std_logic_vector(31 downto 0)
 	);
end entity;

architecture df of EX_MEM is

begin

    process(clk) begin
        if (rising_edge(clk)) then
            pc_out <= pc_in;
            zero_out <= zero_in;
            ula_out <= ula_in;
            rs2_out <= rs2_in;
            instr_out <= instr_in;
        end if;
    end process;

end df;

---- Registradores MEM/WB
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MEM_WB is
	port (
  		clk : in std_logic;
  		mem_data_in : in std_logic_vector(31 downto 0);
        mem_data_out : out std_logic_vector(31 downto 0);
        address_in : in std_logic_vector(31 downto 0);
        address_out : out std_logic_vector(31 downto 0);
        instr_in : in std_logic_vector(31 downto 0);
        instr_out : out std_logic_vector(31 downto 0)
 	);
end entity;

architecture df of MEM_WB is

begin

    process(clk) begin
        if (rising_edge(clk)) then
            mem_data_out <= mem_data_in;
            address_out <= address_in;
            instr_out <= instr_in;
        end if;
    end process;

end df;