--- PC Control
--- Choses which signal will be selected to the PC

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity PC_Control is
	port (
  		PC_Control_Branch : in std_logic;
        PC_Control_Zero : in std_logic;
        PC_Control_Jal : in std_logic_vector(1 downto 0);

        PC_Control_PCSRC : out std_logic(1 downto 0);
 	);
end entity;

architecture df of PC_Control is

begin

    if (PC_Control_Branch and (not PC_Control_Zero)) then -- Branch
        PC_Control_PCSRC <= "01";

    elsif (PC_Control_Jal = "01") then -- JAL
        PC_Control_PCSRC <= "01";

    elsif (PC_Control_Jal = "10") then -- JALR
        PC_Control_PCSRC <= "10";

    else -- PC + 4
        PC_Control_PCSRC <= "00";

    end if;
end df;