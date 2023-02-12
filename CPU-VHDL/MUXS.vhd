--- Multiplexadores 2 para 1 

---- Mux do PC
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MUX_PC is
	port (
  		selector : in std_logic;
  		a : in std_logic_vector(31 downto 0);
        b : in std_logic_vector(31 downto 0);
        s : out std_logic_vector(31 downto 0)
 	);
end entity MUX_PC;

architecture df of MUX_PC is
    
begin

    S <= a when selector = '0' else b;

end df;

---- Mux da ULA
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MUX_ULA is
	port (
  		selector : in std_logic;
  		a : in std_logic_vector(31 downto 0);
        b : in std_logic_vector(31 downto 0);
        s : out std_logic_vector(31 downto 0)
 	);
end entity MUX_ULA;

architecture df of MUX_ULA is
    
begin

    S <= a when selector = '0' else b;

end df;

---- Mux do XREG
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MUX_XREG is
	port (
  		selector : in std_logic;
  		a : in std_logic_vector(31 downto 0);
        b : in std_logic_vector(31 downto 0);
        s : out std_logic_vector(31 downto 0)
 	);
end entity MUX_XREG;

architecture df of MUX_XREG is
    
begin

    S <= a when selector = '0' else b;

end df;