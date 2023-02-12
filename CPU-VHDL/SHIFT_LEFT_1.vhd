--- Shift left one
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity SHIFTER is
	port (
  		a : in std_logic_vector(31 downto 0);
        s : out std_logic_vector(31 downto 0)
 	);
end entity SHIFTER;

architecture df of SHIFTER is
    
begin

    s <= std_logic_vector( unsigned(a) sll 1);

end df;