--- Unidade Lógico Aritmética (ULA)
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ULA is
    port (
        opcode : in std_logic_vector(3 downto 0);
        A, B : in std_logic_vector(31 downto 0);
        Z : out std_logic_vector(31 downto 0);
        zero : out std_logic
    );
end entity ULA;

architecture df of ULA is

    signal a32 : std_logic_vector(31 downto 0);
    
begin

    Z <= a32;

    proc_ula: process (A, B, opcode, a32) begin
        if (a32 = x"00000000") then zero <= '1'; else zero <= '0'; end if;

        case opcode is 
            when "0000" => -- ADD
                a32 <= std_logic_vector(signed(A) + signed(B));
            when "0001" => -- SUB
                a32 <= std_logic_vector(signed(A) - signed(B));
            when "0010" => -- AND
                a32 <= A and B;
            when "0011" => -- OR
                a32 <= A or B;
            when "0100" => -- XOR
                a32 <= A xor B;
            when "0101" => -- SLL 
                a32 <= std_logic_vector( unsigned(A) sll To_integer( signed(B) ));
            when "0110" => -- SRL 
                a32 <= std_logic_vector( unsigned(A) srl To_integer( signed(B) ));
            when "0111" => -- SRA
                a32 <= std_logic_vector( signed(A) sra To_integer( signed(B) ) );
            when "1000" => -- SLT
                if (signed(A) < signed(B)) then a32 <= x"00000001";
                else a32 <= x"00000000";
                end if;
            when "1001" => -- SLTU
                if (unsigned(A) < unsigned(B)) then a32 <= x"00000001";
                else a32 <= x"00000000";
                end if;
            when "1010" => -- SGE
                if (signed(A) >= signed(B)) then a32 <= x"00000001";
                else a32 <= x"00000000";
                end if;
            when "1011" => -- SGEU
                if (unsigned(A) >= unsigned(B)) then a32 <= x"00000001";
                else a32 <= x"00000000";
                end if;
            when "1100" => -- SEQ
                if (A = B) then a32 <= x"00000001";
                else a32 <= x"00000000";
                end if;
            when "1101" => -- SNE
                if (A /= B) then a32 <= x"00000001";
                else a32 <= x"00000000";
                end if;
            when others => -- Default
                a32 <= x"00000000";
        end case;
    end process;
    
end df;