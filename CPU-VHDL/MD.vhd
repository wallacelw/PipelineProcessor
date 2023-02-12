--- Memória de Dados (MD)
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MEM_DADOS is
    port (
        clock : in std_logic;
        we : in std_logic;
        address : in std_logic_vector(7 downto 0);
        datain : in std_logic_vector(31 downto 0);
        dataout : out std_logic_vector(31 downto 0)
    );
end entity MEM_DADOS;

architecture df of MEM_DADOS is

    Type ram_type is array (0 to (2**address'length)-1) of std_logic_vector(dataout'range);
    signal mem : ram_type;
    signal read_address : std_logic_vector(address'range);
    
begin

    Write: process (clock) begin
        if (rising_edge(clock) and we = '1') then
            mem(to_integer(unsigned(address))) <= datain;
        end if;
        read_address <= address; -- Adds 1 cycle
    end process;
    
    dataout <= mem(to_integer(unsigned(address)));

end df;