--- Branch Control

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Branch_Control is
	port (
  		Branch_Control_PCSRC : in std_logic;
        Branch_Control_Zero : in std_logic;
        Branch_Control_Jal : in std_logic;
        Branch_Control_out : out std_logic
 	);
end entity Branch_Control;

architecture df of Branch_Control is

begin

    Branch_Control <= (Branch_Control_PCSRC and (not Branch_Control_Zero)) or Branch_Control_Jal;
    
end df;