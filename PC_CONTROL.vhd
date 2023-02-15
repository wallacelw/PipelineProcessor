--- PC Control
--- Choses which signal will be selected to the PC

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Branch_Control is
	port (
  		Branch_Control_Branch : in std_logic;
        Branch_Control_Zero : in std_logic;
        Branch_Control_Jal : in std_logic_vector(1 downto 0);

        Branch_Control_PCSRC : out std_logic(1 downto 0);
 	);
end entity Branch_Control;

architecture df of Branch_Control is

begin

    if (Branch_Control_Branch and (not Branch_Control_Zero)) then -- Branch
        Branch_Control_PCSRC <= "01";

    elsif (Branch_Control_Jal = "01") then -- JAL
        Branch_Control_PCSRC <= "01";

    elsif (Branch_Control_Jal = "10") then -- JALR
        Branch_Control_PCSRC <= "10";

    else -- PC + 4
        Branch_Control_PCSRC <= "00";

    end if;
end df;