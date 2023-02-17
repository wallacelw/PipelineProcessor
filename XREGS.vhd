--- Banco de Registradores (XREGS)
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity XREGS is  
    port (
        XRegs_clk, XRegs_wren, XRegs_rst : in std_logic;
        XRegs_rs1, Xregs_rs2, XRegs_rd : in std_logic_vector(4 downto 0);
        XRegs_data : in std_logic_vector(31 downto 0);
        XRegs_ro1, XRegs_ro2 : out std_logic_vector(31 downto 0)
	);
end entity;

architecture df of XREGS is

    type regArray is array(natural range <>) of std_logic_vector(31 downto 0);
    signal breg: regArray(31 downto 0);
    
begin

	--Leitura
    XRegs_ro1 <= (others => '0') when (XRegs_rs1 = "00000") 
    		else breg(to_integer(unsigned(XRegs_rs1)));
    
    XRegs_ro2 <= (others => '0') when (Xregs_rs2 = "00000") 
    		else breg(to_integer(unsigned(Xregs_rs2)));
    
    process(XRegs_clk, XRegs_rst, XRegs_wren, breg,XRegs_data) begin

        if (rising_edge(XRegs_clk)) then

            --Reset
            if (XRegs_rst = '1') then 
                for i in 31 downto 0 loop
                    breg(i) <= x"00000000";
                end loop;
            
            --Escrita  
            elsif (XRegs_wren = '1') then
                breg(to_integer(unsigned(XRegs_rd))) <= XRegs_data;

            end if;

        end if;

    end process;
    
end df;
