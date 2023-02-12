--- Processador Pipeline
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity CPU is
	port (
  		clock : in std_logic
 	);
end entity;

architecture structural of CPU is
    
    component MEM_INSTR is
        port (
            clock : in std_logic;
            address : in std_logic_vector(7 downto 0);
            dataout : out std_logic_vector(31 downto 0)
        );
    end component;
    
    component XREGS is
        port (
            clk, wren, rst : in std_logic;
            rs1, rs2, rd : in std_logic_vector(4 downto 0);
            data : in std_logic_vector(31 downto 0);
            ro1, ro2 : out std_logic_vector(31 downto 0)
        );
    end component;

    component GenImm is
        port (
            instr : in std_logic_vector(31 downto 0);
            imm32 : out signed(31 downto 0)
        );
    end component;

    component ULA is
        port (
            opcode : in std_logic_vector(3 downto 0);
            A, B : in std_logic_vector(31 downto 0);
            Z : out std_logic_vector(31 downto 0);
            zero : out std_logic
        );
    end component;
    
    component MEM_DADOS is
        port (
            clock : in std_logic;
            we : in std_logic;
            address : in std_logic_vector(7 downto 0);
            datain : in std_logic_vector(31 downto 0);
            dataout : out std_logic_vector(31 downto 0)
        );
    end component;

    component ADDER_4 is
        port (
            a : in std_logic_vector(31 downto 0);
            b : in std_logic_vector(31 downto 0);
            s : out std_logic_vector(31 downto 0)
        );
    end component;

    component ADDER_IMM is
        port (
            a : in std_logic_vector(31 downto 0);
            b : in std_logic_vector(31 downto 0);
            s : out std_logic_vector(31 downto 0)
        );
    end component;

    component MUX_PC is
        port (
            selector : in std_logic;
            a : in std_logic_vector(31 downto 0);
            b : in std_logic_vector(31 downto 0);
            s : out std_logic_vector(31 downto 0)
        );
    end component;

    component MUX_ULA is
        port (
            selector : in std_logic;
            a : in std_logic_vector(31 downto 0);
            b : in std_logic_vector(31 downto 0);
            s : out std_logic_vector(31 downto 0)
        );
    end component;

    component MUX_XREG is
        port (
            selector : in std_logic;
            a : in std_logic_vector(31 downto 0);
            b : in std_logic_vector(31 downto 0);
            s : out std_logic_vector(31 downto 0)
        );
    end component;

begin

end structural;