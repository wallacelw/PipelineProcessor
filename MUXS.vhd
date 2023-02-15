--- Multiplexadores 2 para 1 

---- Mux do PC
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MUX_PC is
	port (
  		PCMux_Src: in std_logic_vector(1 downto 0);
  		PCMux_Adder_in : in std_logic_vector(31 downto 0);
        PCMux_PC_Imm_in : in std_logic_vector(31 downto 0);
		PCMux_Reg_Imm_in : in std_logic_vector(31 downto 0);
        PCMux_out : out std_logic_vector(31 downto 0)
 	);
end entity MUX_PC;

architecture df of MUX_PC is
    
begin

    PCMux_out <= PCMux_Adder_in when PCMux_Src = "00" else
		PCMux_PC_Imm_in when PCMux_Src = "01" else
		PCMux_Reg_Imm_in; -- JALR;  src="10"

end df;

---- Mux da ULA
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MUX_ALU is
	port (
  		ALUMUX_ALUSrc : in std_logic;
  		ALUMUX_rs2 : in std_logic_vector(31 downto 0);
        ALUMUX_imm : in std_logic_vector(31 downto 0);
        ALUMUX_out : out std_logic_vector(31 downto 0)
 	);
end entity MUX_ALU;

architecture df of MUX_ALU is
    
begin

    ALUMUX_out <= ALUMUX_rs2 
	when selector = '0' 
	else ALUMUX_imm;

end df;

---- Mux do Result que vai para o DATA do Xregs
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MUX_XREG is
	port (
  		XREGSMUX_ResultSrc : in std_logic_vector(1 downto 0);
  		XREGSMUX_ALU_in : in std_logic_vector(31 downto 0);
        XREGSMUX_mem_data_in : in std_logic_vector(31 downto 0);
		XREGSMUX_pc_plus_4_in : in std_logic_vector(31 downto 0);
        XREGSMUX_out : out std_logic_vector(31 downto 0)
 	);
end entity MUX_XREG;

architecture df of MUX_XREG is
    
begin

    XREGSMUX_out <= XREGSMUX_ALU_in when selector = "00"  else 
		XREGSMUX_mem_data_in when selector = "01" else
		XREGSMUX_pc_plus_4_in;

end df;