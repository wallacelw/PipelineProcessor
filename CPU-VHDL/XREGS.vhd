--- Banco de Registradores (XREGS)
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity XREGS is
    
    port (
        clk, wren, rst : in std_logic;
        rs1, rs2, rd : in std_logic_vector(4 downto 0);
        data : in std_logic_vector(31 downto 0);
        ro1, ro2 : out std_logic_vector(31 downto 0)
	);
    
end XREGS;

architecture df of XREGS is

    type regArray is array(natural range <>) of std_logic_vector(31 downto 0);
    signal breg: regArray(31 downto 0);
    
begin

	--Leitura
    ro1 <= (others => '0') when (rs1 = "00000") 
    		else breg(to_integer(unsigned(rs1)));
    
    ro2 <= (others => '0') when (rs2 = "00000") 
    		else breg(to_integer(unsigned(rs2)));
    
    process(clk) begin

        if (rising_edge(clk)) then

            --Reset
            if (rst = '1') then 
                for i in 31 downto 0 loop
                    breg(i) <= x"00000000";
                end loop;
            
            --Escrita  
            elsif (wren = '1') then
                breg(to_integer(unsigned(rd))) <= data;

            end if;

        end if;

    end process;
    
end df;
