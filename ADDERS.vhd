--- Somadores

---- Incrementa PC += 4
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ADDER_4 is
	port (
  		a : in std_logic_vector(31 downto 0);
        b : in std_logic_vector(31 downto 0);
        s : out std_logic_vector(31 downto 0)
 	);
end entity ADDER_4;

architecture df of ADDER_4 is
    
begin

    s <= std_logic_vector(signed(a) + signed(b));

end df;

---- Soma PC com IMM
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ADDER_IMM is
	port (
  		a : in std_logic_vector(31 downto 0);
        b : in std_logic_vector(31 downto 0);
        s : out std_logic_vector(31 downto 0)
 	);
end entity ADDER_IMM;

architecture df of ADDER_IMM is
    
begin

    s <= std_logic_vector(signed(a) + signed(b));

end df;