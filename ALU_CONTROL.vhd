--- ALU CONTROL

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALU_Control is
	port (
  		ALU_Control_instr : in std_logic_vector(31 downto 0);
        ALU_Control_alu_op : in std_logic_vector(1 downto 0);
        ALU_Control_out : out std_logic_vector(3 downto 0)
 	);
end entity;

architecture df of ALU_Control is
    
    signal funct3 : std_logic_vector(3 downto 0);
    signal funct7 : std_logic_vector(7 downto 0);

begin

    funct3 <= ('0' & (ALU_Control_instr(14 downto 12)));
    funct7 <= ('0' & (ALU_Control_instr(31 downto 25)));

    process(ALU_Control_alu_op, ALU_Control_instr) begin
        -- for LW, SW
        if (ALU_Control_alu_op = "00") then 
            ALU_Control_out <= "0000"; -- ADD 

        -- for BRANCHES (SB)
        elsif (ALU_Control_alu_op = "01") then 
            if    (funct3 = x"0") then -- BEQ
                ALU_Control_out <= "1100"; -- SEQ

            elsif (funct3 = x"1") then -- BNE
                ALU_Control_out <= "1101"; -- SEQ
            
            elsif (funct3 = x"4") then -- BLT
                ALU_Control_out <= "1000"; -- SLT

            elsif (funct3 = x"5") then -- BGE
                ALU_Control_out <= "1010"; -- SGE

            elsif (funct3 = x"6") then -- BLTU
                ALU_Control_out <= "1001"; -- SLTU

            elsif (funct3 = x"7") then -- BGEU
                ALU_Control_out <= "1011"; -- SGEU

            end if;

        -- for R type and I type
        elsif (ALU_Control_alu_op = "10") then 
            if    (funct3 = x"0" and funct7 = x"00") then
                ALU_Control_out <= "0000"; -- ADD

            elsif (funct3 = x"0" and funct7 = x"20") then
                ALU_Control_out <= "0001"; -- SUB

            elsif (funct3 = x"7" and funct7 = x"00") then
                ALU_Control_out <= "0010"; -- AND
            
            elsif (funct3 = x"6" and funct7 = x"00") then
                ALU_Control_out <= "0011"; -- OR

            elsif (funct3 = x"4" and funct7 = x"00") then
                ALU_Control_out <= "0100"; -- XOR

            elsif (funct3 = x"1" and funct7 = x"00") then
                ALU_Control_out <= "0101"; -- SLL

            elsif (funct3 = x"5" and funct7 = x"00") then
                ALU_Control_out <= "0110"; -- SRL

            elsif (funct3 = x"5" and funct7 = x"20") then
                ALU_Control_out <= "0111"; -- SRA

            elsif (funct3 = x"2"                   ) then
                ALU_Control_out <= "1000"; -- SLT

            elsif (funct3 = x"3"                   ) then
                ALU_Control_out <= "1001"; -- SLTU

            elsif (funct3 = x"0"                   ) then --JALR
                ALU_Control_out <= "0000"; -- ADD

            end if;

        end if;
    end process;
end df;