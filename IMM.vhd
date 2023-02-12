--- Gerador de Imediatos (Imm Gen)
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity GenImm is
    port (
        instr : in std_logic_vector(31 downto 0);
        imm32 : out signed(31 downto 0)
    );
end entity;

architecture df of GenImm is

	signal opcode: signed(7 downto 0);
    
begin
	
    opcode <= resize(signed('0' & instr(6 downto 0)), 8);
    
    process	( instr(31 downto 0), opcode ) begin
    	case opcode is
        
        	-- type R
        	when x"33" =>
            	imm32 <= X"00000000";
            
            -- type I
            when x"03" =>
            	imm32 <= resize(signed(instr(31 downto 20)), 32);
            when x"13" =>
            	imm32 <= resize(signed(instr(31 downto 20)), 32);
            when x"67" =>
            	imm32 <= resize(signed(instr(31 downto 20)), 32);
            
            -- type S
        	when X"23" =>
        		imm32 <= resize(signed(instr(31 downto 25) & instr(11 downto 7)), 32);
          	-- type SB
            when X"63" =>
                imm32 <= resize(
                    signed (
                      instr(31) &
                      instr(7) &
                      instr(30 downto 25) &
                      instr(11 downto 8) &
                      '0'
                    ), 32);
            -- type U
            when X"37" => 
            	imm32 <= resize(
                    signed (
                      instr(31 downto 12) & x"000"
                    ), 32);
                    
            -- type UJ
        	when X"6F" =>
        		imm32 <= resize(
                    signed (
                      instr(31) &
                      instr(19 downto 12) &
                      instr(20) &
                      instr(30 downto 21) &
                      '0'
                    ), 32);
                
            when others =>
            	imm32 <= X"00000000"; 
            
        end case;
    end process; 
end df;