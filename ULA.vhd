--- Unidade Lógico Aritmética (ULA)
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ULA is
    port (
        ULA_opcode : in std_logic_vector(3 downto 0);
        ULA_A, ULA_B : in std_logic_vector(31 downto 0);
        ULA_Z : out std_logic_vector(31 downto 0);
        ULA_zero : out std_logic
    );
end entity ULA;

architecture df of ULA is

    signal a32 : std_logic_vector(31 downto 0);
    
begin

    ULA_Z <= a32;

    proc_ula: process (ULA_A, ULA_B, ULA_opcode, a32) begin
        if (a32 = x"00000000") then ULA_zero <= '1'; else ULA_zero <= '0'; end if;

        case ULA_opcode is 
            when "0000" => -- ADD
                a32 <= std_logic_vector(signed(ULA_A) + signed(ULA_B));
            when "0001" => -- SUB
                a32 <= std_logic_vector(signed(ULA_A) - signed(ULA_B));
            when "0010" => -- AND
                a32 <= ULA_A and ULA_B;
            when "0011" => -- OR
                a32 <= ULA_A or ULA_B;
            when "0100" => -- XOR
                a32 <= ULA_A xor ULA_B;
            when "0101" => -- SLL 
                a32 <= std_logic_vector( unsigned(ULA_A) sll To_integer( signed(ULA_B) ));
            when "0110" => -- SRL 
                a32 <= std_logic_vector( unsigned(ULA_A) srl To_integer( signed(ULA_B) ));
            when "0111" => -- SRA
                a32 <= std_logic_vector( signed(ULA_A) sra To_integer( signed(ULA_B) ) );
            when "1000" => -- SLT
                if (signed(ULA_A) < signed(ULA_B)) then a32 <= x"00000001";
                else a32 <= x"00000000";
                end if;
            when "1001" => -- SLTU
                if (unsigned(ULA_A) < unsigned(ULA_B)) then a32 <= x"00000001";
                else a32 <= x"00000000";
                end if;
            when "1010" => -- SGE
                if (signed(ULA_A) >= signed(ULA_B)) then a32 <= x"00000001";
                else a32 <= x"00000000";
                end if;
            when "1011" => -- SGEU
                if (unsigned(ULA_A) >= unsigned(ULA_B)) then a32 <= x"00000001";
                else a32 <= x"00000000";
                end if;
            when "1100" => -- SEQ
                if (ULA_A = ULA_B) then a32 <= x"00000001";
                else a32 <= x"00000000";
                end if;
            when "1101" => -- SNE
                if (ULA_A /= ULA_B) then a32 <= x"00000001";
                else a32 <= x"00000000";
                end if;
            when others => -- Default
                a32 <= x"00000000";
        end case;
    end process;
    
end df;