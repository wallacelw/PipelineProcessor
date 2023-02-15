--- Somadores

---- Incrementa PC_Fetch_out += 4
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ADDER_4 is
	port (
  		PCAdder_in : in std_logic_vector(31 downto 0);
        PCAdder_out : out std_logic_vector(31 downto 0)
 	);
end entity;

architecture df of ADDER_4 is
    
begin

    PCAdder_out <= std_logic_vector(signed(PCAdder_in) + 4);

end df;

---- Soma PC com IMM
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ADDER_PC_IMM is
	port (
  		PC_IMM_Adder_PC : in std_logic_vector(31 downto 0);
        PC_IMM_Adder_Imm : in std_logic_vector(31 downto 0);
        PC_IMM_Adder_out : out std_logic_vector(31 downto 0)
 	);
end entity;

architecture df of ADDER_PC_IMM is
    
begin

    PC_IMM_Adder_out <= std_logic_vector(signed(PC_IMM_Adder_PC) + signed(PC_IMM_Adder_Imm));

end df;