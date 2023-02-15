--- Memória de Instruções (MI)
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;

entity MEM_INSTR is
    port (
        MI_address : in std_logic_vector(7 downto 0);
        MI_Instr_out : out std_logic_vector(31 downto 0)
    );
end entity;

architecture df of MEM_INSTR is
    
    Type rom_type is array (0 to (2**MI_address'length)-1) of std_logic_vector(MI_Instr_out'range);
    
    impure function init_rom_hex return rom_type is

        file text_file : text open read_mode is "ROM_data.txt";
        variable text_line : line;
        variable rom_content : rom_type;

    begin
        for i in 0 to (2**MI_address'length)-1 loop
            readline(text_file, text_line);
            hread(text_line, rom_content(i));
        end loop;
        
        return rom_content;
    end function;

    signal mem : rom_type := init_rom_hex;
    
begin

    MI_Instr_out <= mem(to_integer(unsigned(MI_address)));

end df;