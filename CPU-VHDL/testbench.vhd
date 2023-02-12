-- Code your testbench here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity testbench is
end entity;

architecture arch of testbench is

    component MEM_INSTR is
        port (
            clock : in std_logic;
            address : in std_logic_vector(7 downto 0);
            dataout : out std_logic_vector(31 downto 0)
        );
    end component;

    signal clock_i : std_logic;
    signal address_i : std_logic_vector(7 downto 0);
    signal dataout_o : std_logic_vector(31 downto 0);

begin

    dut: MEM_INSTR port map (
        clock => clock_i,
        address => address_i,
        dataout => dataout_o
    );

    drive: process begin

        for i in 0 to 255 loop

            clock_i <= '0';
            address_i <= std_logic_vector(to_unsigned(i,8));

            wait for 1 ns;
            clock_i <= '1';

            wait for 1 ns;
            assert(dataout_o = std_logic_vector(to_unsigned(i,30)) & "00") 

            report "falha em ler dados previamente lidos do arquivo" 
            severity warning;
            
        end loop;

        wait;
    end process;

end arch;