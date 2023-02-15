--- Unidade Lógico Aritmética (ALU)
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALU is
    port (
        ALU_opcode : in std_logic_vector(3 downto 0);
        ALU_A, ALU_B : in std_logic_vector(31 downto 0);
        ALU_Z : out std_logic_vector(31 downto 0);
        ALU_zero : out std_logic
    );
end entity ALU;

architecture df of ALU is

    signal a32 : std_logic_vector(31 downto 0);
    
begin

    ALU_Z <= a32;

    proc_ula: process (ALU_A, ALU_B, ALU_opcode, a32) begin
        if (a32 = x"00000000") then ALU_zero <= '1'; else ALU_zero <= '0'; end if;

        case ALU_opcode is 
            when "0000" => -- ADD
                a32 <= std_logic_vector(signed(ALU_A) + signed(ALU_B));
            when "0001" => -- SUB
                a32 <= std_logic_vector(signed(ALU_A) - signed(ALU_B));
            when "0010" => -- AND
                a32 <= ALU_A and ALU_B;
            when "0011" => -- OR
                a32 <= ALU_A or ALU_B;
            when "0100" => -- XOR
                a32 <= ALU_A xor ALU_B;
            when "0101" => -- SLL 
                a32 <= std_logic_vector( unsigned(ALU_A) sll To_integer( signed(ALU_B) ));
            when "0110" => -- SRL 
                a32 <= std_logic_vector( unsigned(ALU_A) srl To_integer( signed(ALU_B) ));
            when "0111" => -- SRA
                a32 <= std_logic_vector( signed(ALU_A) sra To_integer( signed(ALU_B) ) );
            when "1000" => -- SLT
                if (signed(ALU_A) < signed(ALU_B)) then a32 <= x"00000001";
                else a32 <= x"00000000";
                end if;
            when "1001" => -- SLTU
                if (unsigned(ALU_A) < unsigned(ALU_B)) then a32 <= x"00000001";
                else a32 <= x"00000000";
                end if;
            when "1010" => -- SGE
                if (signed(ALU_A) >= signed(ALU_B)) then a32 <= x"00000001";
                else a32 <= x"00000000";
                end if;
            when "1011" => -- SGEU
                if (unsigned(ALU_A) >= unsigned(ALU_B)) then a32 <= x"00000001";
                else a32 <= x"00000000";
                end if;
            when "1100" => -- SEQ
                if (ALU_A = ALU_B) then a32 <= x"00000001";
                else a32 <= x"00000000";
                end if;
            when "1101" => -- SNE
                if (ALU_A /= ALU_B) then a32 <= x"00000001";
                else a32 <= x"00000000";
                end if;
            when others => -- Default
                a32 <= x"00000000";
        end case;
    end process;
    
end df;