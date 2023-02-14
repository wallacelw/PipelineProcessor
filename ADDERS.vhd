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
end entity ADDER_4;

architecture df of ADDER_4 is
    
begin

    PCAdder_out <= std_logic_vector(signed(PCAdder_in) + 4);

end df;

---- Soma PC com IMM
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ADDER_IMM is
	port (
  		IMMAdder1_in : in std_logic_vector(31 downto 0);
        IMMAdder2_in : in std_logic_vector(31 downto 0);
        IMMAdder_out : out std_logic_vector(31 downto 0)
 	);
end entity ADDER_IMM;

architecture df of ADDER_IMM is
    
begin

    IMMAdder_out <= std_logic_vector(signed(IMMAdder1_in) + signed(IMMAdder2_in));

end df;