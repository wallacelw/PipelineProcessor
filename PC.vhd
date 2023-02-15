--- PC Register

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity PC is
	port (
  		PCReg_clk : in std_logic;
  		PCReg_in : in std_logic_vector(31 downto 0);
        PCReg_out : out std_logic_vector(31 downto 0);

        PCReg_address_out : out std_logic_vector(7 downto 0)
 	);
end entity;

architecture df of PC is

begin

    process(PCReg_clk) begin
        if (rising_edge(PCReg_clk)) then
            PCReg_out <= PCReg_in;
            PCReg_address_out <= PCReg_in(7 downto 0);
        end if;
    end process;

end df;