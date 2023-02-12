--- Controle

-- NOT COMPLETE

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity IF_ID is
	port (
  		clk : in std_logic;
        instr : in std_logic_vector(31 downto 0);
        --EX
        ALUSrc : out std_logic;
        ALUOp : out std_logic_vector(1 downto 0);
        --MEM
        Branch : out std_logic;
        MemRead : out std_logic;
        MemWrite : out std_logic;
        --WB
        RegWrite : out std_logic;
        Mem2Reg : out std_logic;
 	);
end entity;

architecture df of IF_ID is

    signal opcode : std_logic_vector(7 downto 0);
    signal funct3 : std_logic_vector(3 downto 0);
    signal funct7 : std_logic_vector(7 downto 0);

begin

    opcode <= resize(unsigned('0' & instr(6 downto 0)), 8);
    funct3 <= resize(unsigned('0' & instr(14 downto 12)), 4);
    funct7 <= resize(unsigned('0' & instr(31 downto 25)), 8);

    ---- Lógico-Aritméticas

    -- ADD (R)
    if (opcode = x"33" and funct3 = x"0" and funct7 = x"00") then
        ALUSrc <= '0';
        ALUOp <= "10";
        Branch <= '0';
        MemRead <= '0';
        MemWrite <= '0';
        RegWrite <= '1';
        Mem2Reg <= '0';
    
    -- ADDi 
    elsif (opcode = x"13" and func3 = x"0") then
        ALUSrc <= '1';
        ALUOp <= "10";
        Branch <= '0';
        MemRead <= '0';
        MemWrite <= '0';
        RegWrite <= '1';
        Mem2Reg <= '0';

    -- SUB (R)
    elsif (opcode = x"33" and funct3 = x"0" and funct7 = x"20") then
        ALUSrc <= '0';
        ALUOp <= "10";
        Branch <= '0';
        MemRead <= '0';
        MemWrite <= '0';
        RegWrite <= '1';
        Mem2Reg <= '0';

    -- AND (R)
    elsif (opcode = x"33" and funct3 = x"7" and funct7 = x"00") then
        ALUSrc <= '0';
        ALUOp <= "10";
        Branch <= '0';
        MemRead <= '0';
        MemWrite <= '0';
        RegWrite <= '1';
        Mem2Reg <= '0';
        
    -- ANDi
    elsif (opcode = x"13" and func3 = x"7") then

    -- LUI
    elsif (opcode = x"37") then

    -- SLT (R)
    elsif (opcode = x"33" and funct3 = x"2" and funct7 = x"00") then
        ALUSrc <= '0';
        ALUOp <= "10";
        Branch <= '0';
        MemRead <= '0';
        MemWrite <= '0';
        RegWrite <= '1';
        Mem2Reg <= '0';
        
    -- OR (R)
    elsif (opcode = x"33" and funct3 = x"6" and funct7 = x"00") then
        ALUSrc <= '0';
        ALUOp <= "10";
        Branch <= '0';
        MemRead <= '0';
        MemWrite <= '0';
        RegWrite <= '1';
        Mem2Reg <= '0';
        
    -- ORi
    elsif (opcode = x"13" and func3 = x"6") then

    -- XOR (R)
    elsif (opcode = x"33" and funct3 = x"4" and funct7 = x"00") then
        ALUSrc <= '0';
        ALUOp <= "10";
        Branch <= '0';
        MemRead <= '0';
        MemWrite <= '0';
        RegWrite <= '1';
        Mem2Reg <= '0';
        
    -- XORi
    elsif (opcode = x"13" and func3 = x"4") then

    -- SLLi
    elsif (opcode = x"13" and funct3 = x"1" and funct7 = x"00") then

    -- SRLi
    elsif (opcode = x"13" and funct3 = x"5" and funct7 = x"00") then

    -- SRAi
    elsif (opcode = x"13" and funct3 = x"5" and funct7 = x"20") then

    -- SLTi
    elsif (opcode = x"13" and funct3 = x"2") then

    -- SLTU (R)
    elsif (opcode = x"33" and funct3 = x"3" and funct7 = x"00") then
        ALUSrc <= '0';
        ALUOp <= "10";
        Branch <= '0';
        MemRead <= '0';
        MemWrite <= '0';
        RegWrite <= '1';
        Mem2Reg <= '0';
        
    -- SLTUi
    elsif (opcode = x"13" and funct3 = x"3") then

    -- AUIPC
    elsif (opcode = x"17") then
        ALUSrc <= '0';
        ALUOp <= "10";
        Branch <= '0';
        MemRead <= '0';
        MemWrite <= '0';
        RegWrite <= '1';
        Mem2Reg <= '0';
    
    ---- Subrotinas

    -- JAL (UJ) 
    else if (opcode = x"6f") then

    -- JALR (I)
    else if (opcode = x"67" and funct3 = x"0") then

    ---- Saltos

    -- BEQ (SB)
    else if (opcode = x"63" and funct3 = x"0") then

    -- BNE (SB)
    else if (opcode = x"63" and funct3 = x"1") then

    -- BLT (SB)
    else if (opcode = x"63" and funct3 = x"4") then

    -- BGE (SB)
    else if (opcode = x"63" and funct3 = x"5") then

    -- BGEU (SB)
    else if (opcode = x"63" and funct3 = x"7") then

    -- BLTU (SB)
    else if (opcode = x"63" and funct3 = x"6") then

    ---- Memória

    -- LW (I)
    else if (opcode = x"03" and func3 = x"2") then

    -- SW (S)
    else if (opcode = x"23" and func3 = x"2") then

    ---- NOP
    else

    end if;

end df;