--- Controle

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
        CONTROL_Jal : out std_logic_vector(1 downto 0); -- indica se a instrução é do tipo Jal (== 01) or Jalr (== 10)
        CONTROL_MemWrite : out std_logic; -- memWrite = 1; memRead = 0

        --WB
        CONTROL_RegWrite : out std_logic;
        CONTROL_ResultSrc : out std_logic_vector(2 downto 0) -- Mem2Reg extendido
 	);
end entity;

architecture df of CONTROL is

    signal opcode : std_logic_vector(7 downto 0);
    signal funct3 : std_logic_vector(3 downto 0);
    signal funct7 : std_logic_vector(7 downto 0);

begin

    opcode <= '0' & CONTROL_instr(6 downto 0);
    funct3 <= '0' & CONTROL_instr(14 downto 12);
    funct7 <= '0' & CONTROL_instr(31 downto 25);

    process(CONTROL_instr) begin

    ---- Lógico-Aritméticas
    
    -- Type R : ADD, SUB, AND, SLT, OR, XOR, SLTU
    if (opcode = x"33") then
        CONTROL_ALUSrc <= '0'; -- Use Reg Value for ALU
        CONTROL_ALUOp <= "10"; -- R type or I type
        CONTROL_Branch <= '0'; -- Don't update PC due to Branch
        CONTROL_Jal <= "00"; -- Don't update PC due to Jal(r)
        CONTROL_MemWrite <= '-'; -- (Don't care)
        CONTROL_RegWrite <= '1'; -- Write Back to Register
        CONTROL_ResultSrc <= "000"; -- Register receives ALU output
    
    -- Type I : ADDi, ANDi, ORi, XORi, SLLi, SRLi, SRAi, SLTi, SLTUi
    elsif (opcode = x"13") and (funct3 = x"0") then
        CONTROL_ALUSrc <= '1'; -- Use IMM Value for ALU
        CONTROL_ALUOp <= "10"; -- R type or I type
        CONTROL_Branch <= '0'; -- Don't update PC due to Branch
        CONTROL_Jal <= "00"; -- Don't update PC due to Jal(r)
        CONTROL_MemWrite <= '-'; -- (Don't care)
        CONTROL_RegWrite <= '1'; -- Write Back to Register
        CONTROL_ResultSrc <= "000"; -- Register receives ALU output

    -- TYPE U 
    elsif (opcode = x"17") then -- AUIPC
        CONTROL_ALUSrc <= '-'; -- (Don't care)
        CONTROL_ALUOp <= "--"; -- (Don't care)
        CONTROL_Branch <= '0'; -- Don't update PC due to Branch
        CONTROL_Jal <= "00"; -- Don't update PC due to Jal(r)
        CONTROL_MemWrite <= '-'; -- (Don't care)
        CONTROL_RegWrite <= '1'; -- Write Back to Register
        CONTROL_ResultSrc <= "011"; -- Register receives IMM + PC
    
    elsif (opcode = x"37") then -- LUI
        CONTROL_ALUSrc <= '-'; -- (Don't care)
        CONTROL_ALUOp <= "--"; -- (Don't care)
        CONTROL_Branch <= '0'; -- Don't update PC due to Branch
        CONTROL_Jal <= "00"; -- Don't update PC due to Jal(r)
        CONTROL_MemWrite <= '-'; -- (Don't care)
        CONTROL_RegWrite <= '1'; -- Write Back to Register
        CONTROL_ResultSrc <= "100"; -- Register receives IMM

    ---- Subrotinas

    -- JAL 
    elsif (opcode = x"6F") then
        CONTROL_ALUSrc <= '-'; -- (Don't Care)
        CONTROL_ALUOp <= "--"; -- (Don't Care)
        CONTROL_Branch <= '0'; -- Don't update PC due to Branch
        CONTROL_Jal <= "01"; -- Update PC due to Jal
        CONTROL_MemWrite <= '-'; -- (Don't care)
        CONTROL_RegWrite <= '1'; -- Write Back to Register
        CONTROL_ResultSrc <= "010"; -- Register RD receives PC+4

    -- JALR 
    elsif (opcode = x"67") and (funct3 = x"0") then
        CONTROL_ALUSrc <= '1'; -- Use IMM Value for ALU
        CONTROL_ALUOp <= "10"; -- R type or I type
        CONTROL_Branch <= '0'; -- Don't update PC due to Branch
        CONTROL_Jal <= "10"; -- Update PC due to Jalr
        CONTROL_MemWrite <= '-'; -- (Don't care)
        CONTROL_RegWrite <= '1'; -- Write Back to Register
        CONTROL_ResultSrc <= "010"; -- Register RD receives PC+4

    ---- Saltos
    -- Type SB (BRANCH):  BEQ, BNE, BLT, BGE, BLTU, BGEU
    elsif (opcode = x"63") then
        CONTROL_ALUSrc <= '0'; -- Use Reg Value for ALU
        CONTROL_ALUOp <= "01"; -- Branch Type
        CONTROL_Branch <= '1'; -- update PC due to Branch
        CONTROL_Jal <= "00"; -- Don't update PC due to Jal(r)
        CONTROL_MemWrite <= '-'; -- (Don't care)
        CONTROL_RegWrite <= '0'; -- Don't Write Back to Register
        CONTROL_ResultSrc <= "---"; -- (Don't Care)


    ---- Memória

    -- LW (I)
    elsif (opcode = x"03") and (funct3 = x"2") then
        CONTROL_ALUSrc <= '1'; -- Use Imm Value for ALU
        CONTROL_ALUOp <= "00"; -- Memory Type
        CONTROL_Branch <= '0'; -- Don't update PC due to Branch
        CONTROL_Jal <= "00"; -- Don't update PC due to Jal(r)
        CONTROL_MemWrite <= '0'; -- Read Mem
        CONTROL_RegWrite <= '1'; -- Write Back to Register
        CONTROL_ResultSrc <= "001"; -- Register receives Mem output

    -- SW (S)
    elsif (opcode = x"23") and (funct3 = x"2") then
        CONTROL_ALUSrc <= '1'; -- Use Imm Value for ALU
        CONTROL_ALUOp <= "00"; -- Memory Type
        CONTROL_Branch <= '0'; -- Don't update PC due to Branch
        CONTROL_Jal <= "00"; -- Don't update PC due to Jal(r)
        CONTROL_MemWrite <= '1'; -- Write in Mem
        CONTROL_RegWrite <= '0'; -- Write Back to Register
        CONTROL_ResultSrc <= "---"; -- (Don't Care)

    ---- NOP (TODO)
    --else
    
    end if;

    end process;
end df;