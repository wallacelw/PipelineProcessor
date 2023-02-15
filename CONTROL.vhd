--- Controle

-- NOT COMPLETE

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity CONTROL is
	port (
        CONTROL_instr : in std_logic_vector(31 downto 0);

        --EX
        CONTROL_ALUSrc : out std_logic;
        CONTROL_ALUOp : out std_logic_vector(1 downto 0);

        --MEM
        CONTROL_Branch : out std_logic;
        CONTROL_Jal : out std_logic; -- indica se a instrução é do tipo Jal or Jalr
        CONTROL_MemWrite : out std_logic; -- memWrite = 1; memRead = 0

        --WB
        CONTROL_RegWrite : out std_logic;
        CONTROL_ResultSrc : out std_logic_vector(1 downto 0); -- Mem2Reg extendido
 	);
end entity;

architecture df of CONTROL is

    signal opcode : std_logic_vector(7 downto 0);
    signal funct3 : std_logic_vector(3 downto 0);
    signal funct7 : std_logic_vector(7 downto 0);

begin

    opcode <= resize(unsigned('0' & instr(6 downto 0)), 8);
    funct3 <= resize(unsigned('0' & instr(14 downto 12)), 4);
    funct7 <= resize(unsigned('0' & instr(31 downto 25)), 8);

    ---- Lógico-Aritméticas
    
    -- Type R : ADD, SUB, AND, SLT, OR, XOR, SLTU
    if (opcode = x"33") then
        CONTROL_ALUSrc <= "0"; -- Use Reg Value for ALU
        CONTROL_ALUOp <= "10"; -- R type or I type
        CONTROL_Branch <= "0"; -- Don't update PC due to Branch
        CONTROL_Jal <= "0"; -- Don't update PC due to Jal(r)
        CONTROL_MemWrite <= "-"; -- (Don't care)
        CONTROL_RegWrite <= "1"; -- Write Back to Register
        CONTROL_ResultSrc <= "00"; -- Register receives ALU output
    
    -- Type I : ADDi, ANDi, ORi, XORi, SLLi, SRLi, SRAi, SLTi, SLTUi
    elsif (opcode = x"13" and func3 = x"0") then
        CONTROL_ALUSrc <= "1"; -- Use IMM Value for ALU
        CONTROL_ALUOp <= "10"; -- R type or I type
        CONTROL_Branch <= "0"; -- Don't update PC due to Branch
        CONTROL_Jal <= "0"; -- Don't update PC due to Jal(r)
        CONTROL_MemWrite <= "-"; -- (Don't care)
        CONTROL_RegWrite <= "1"; -- Write Back to Register
        CONTROL_ResultSrc <= "00"; -- Register receives ALU output

    -- AUIPC
    elsif (opcode = x"17") then
    
    -- LUI
    elsif (opcode = x"37") then


    ---- Subrotinas

    -- JAL (UJ) 
    else if (opcode = x"6F") then

    -- JALR (I)
    else if (opcode = x"67" and funct3 = x"0") then

    ---- Saltos
    -- Type SB (BRANCH):  BEQ, BNE, BLT, BGE, BLTU, BGEU
    else if (opcode = x"63") then
        CONTROL_ALUSrc <= "0"; -- Use Reg Value for ALU
        CONTROL_ALUOp <= "01"; -- Branch Type
        CONTROL_Branch <= "1"; -- update PC due to Branch
        CONTROL_Jal <= "0"; -- Don't update PC due to Jal(r)
        CONTROL_MemWrite <= "-"; -- (Don't care)
        CONTROL_RegWrite <= "0"; -- Don't Write Back to Register
        CONTROL_ResultSrc <= "--"; -- (Don't Care)


    ---- Memória

    -- LW (I)
    else if (opcode = x"03" and func3 = x"2") then
        CONTROL_ALUSrc <= "1"; -- Use Imm Value for ALU
        CONTROL_ALUOp <= "00"; -- Memory Type
        CONTROL_Branch <= "0"; -- Don't update PC due to Branch
        CONTROL_Jal <= "0"; -- Don't update PC due to Jal(r)
        CONTROL_MemWrite <= "0"; -- Read Mem
        CONTROL_RegWrite <= "1"; -- Write Back to Register
        CONTROL_ResultSrc <= "01"; -- Register receives Mem output

    -- SW (S)
    else if (opcode = x"23" and func3 = x"2") then
        CONTROL_ALUSrc <= "1"; -- Use Imm Value for ALU
        CONTROL_ALUOp <= "00"; -- Memory Type
        CONTROL_Branch <= "0"; -- Don't update PC due to Branch
        CONTROL_Jal <= "0"; -- Don't update PC due to Jal(r)
        CONTROL_MemWrite <= "1"; -- Write in Mem
        CONTROL_RegWrite <= "0"; -- Write Back to Register
        CONTROL_ResultSrc <= "--"; -- (Don't Care)

    ---- NOP (TODO)
    else


    end if;
end df;