--- Memória de Dados (MD)
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MEM_DADOS is
    port (
        MD_clk : in std_logic;
        MD_we : in std_logic;
        MD_address : in std_logic_vector(7 downto 0);
        MD_datain : in std_logic_vector(31 downto 0);
        MD_dataout : out std_logic_vector(31 downto 0)
    );
end entity MEM_DADOS;

architecture df of MEM_DADOS is

    Type ram_type is array (0 to (2**MD_address'length)-1) of std_logic_vector(MD_dataout'range);
    signal mem : ram_type;
    signal read_address : std_logic_vector(MD_address'range);
    
begin

    Write: process (MD_clk) begin
        if (rising_edge(MD_clk) and MD_we = '1') then
            mem(to_integer(unsigned(MD_address))) <= MD_datain;
        end if;
        read_address <= MD_address; -- Adds 1 cycle
    end process;
    
    MD_dataout <= mem(to_integer(unsigned(MD_address)));

end df;