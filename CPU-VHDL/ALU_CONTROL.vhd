--- ALU CONTROL

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALU_Control is
	port (
  		instr_in : in std_logic_vector(31 downto 0);
        alu_op : in std_logic_vector(1 downto 0);
        s : out std_logic_vector(31 downto 0)
 	);
end entity ALU_Control;

architecture df of ALU_Control is
    
begin

    s <= std_logic_vector(signed(a) + signed(b));

end df;