--- Gerador de Imediatos (Imm Gen)
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity GenImm is
    port (
        GEN_IMM_instr : in std_logic_vector(31 downto 0);
        GEN_IMM_imm32 : out signed(31 downto 0)
    );
end entity;

architecture df of GenImm is

    signal opcode: signed(7 downto 0);
    
begin
  
    opcode <= resize(signed('0' & GEN_IMM_instr(6 downto 0)), 8);
    
    process	( GEN_IMM_instr(31 downto 0), opcode ) begin
        case opcode is
        
            -- type R
            when x"33" => -- Logic-Arithmetic
                GEN_IMM_imm32 <= X"00000000";
                
            -- type I
            when x"03" => -- LW
                GEN_IMM_imm32 <= resize(signed(GEN_IMM_instr(31 downto 20)), 32);
            when x"13" => -- Logic-Arithmetic
                GEN_IMM_imm32 <= resize(signed(GEN_IMM_instr(31 downto 20)), 32);
            when x"67" => -- JALR
                GEN_IMM_imm32 <= resize(signed(GEN_IMM_instr(31 downto 20)), 32);
                
            -- type S
            when X"23" => -- SW
                GEN_IMM_imm32 <= resize(signed(GEN_IMM_instr(31 downto 25) & GEN_IMM_instr(11 downto 7)), 32);

            -- type SB
            when X"63" => -- BRANCHES
                GEN_IMM_imm32 <= resize(
                    signed (
                    GEN_IMM_instr(31) &
                    GEN_IMM_instr(7) &
                    GEN_IMM_instr(30 downto 25) &
                    GEN_IMM_instr(11 downto 8) &
                    '0'
                    ), 32);

            -- type U
            when X"37" => -- LUI
            GEN_IMM_imm32 <= resize(
                    signed (
                    GEN_IMM_instr(31 downto 12) & x"000"
                    ), 32);
            when X"17" => -- AUIPC
            GEN_IMM_imm32 <= resize(
                    signed (
                    GEN_IMM_instr(31 downto 12) & x"000"
                    ), 32);
                            
            -- type UJ
            when X"6F" => -- JAL
                GEN_IMM_imm32 <= resize(
                        signed (
                        GEN_IMM_instr(31) &
                        GEN_IMM_instr(19 downto 12) &
                        GEN_IMM_instr(20) &
                        GEN_IMM_instr(30 downto 21) &
                        '0'
                        ), 32);
                    
                when others =>
                GEN_IMM_imm32 <= X"00000000"; 
            
        end case;
    end process; 
end df;