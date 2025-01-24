----------------------------------------------------------------------------------
-- Ruben Ramirez
-- 2694
--                          Instruction Register
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity InstReg24bit is
	Port(
	    reset : IN STD_LOGIC; -- clear register values when 0
		Instr   : IN STD_LOGIC_VECTOR(23 downto 0); -- Input Instruction
		Load_IR: IN STD_LOGIC:='0'; -- Load the input when Load_IR='1' 
		Clock   : IN STD_LOGIC:='0'; 
		Opcode : OUT STD_LOGIC_VECTOR(7 downto 0) := (others => '0'); -- function code for alu
		RegOut: OUT STD_LOGIC_VECTOR (15 downto 0) := (others => '0')); -- address location to store value of register c in data memory
 end InstReg24bit;

architecture Behavioral of InstReg24bit is

begin

process(Clock,reset) is
begin

    IF reset = '0' THEN
        RegOut <= (others => '0');
    ELSIF rising_edge(Clock) then
        
           IF Load_IR = '1' then
               Opcode <= Instr(23 downto 16);
               RegOut <= Instr(15 downto 0);
           
            END IF;
    END IF;
END process;

END Behavioral;
