--- Shift left one
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity SHIFTER is
	port (
  		SHIFTER_in : in std_logic_vector(31 downto 0);
        SHIFTER_out : out std_logic_vector(31 downto 0)
 	);
end entity SHIFTER;

architecture df of SHIFTER is
    
begin

    SHIFTER_out <= std_logic_vector( unsigned(SHIFTER_in) sll 1);

end df;