----------------------------------------------------------------------------------
-- Ruben Ramirez
-- 2694
--                  INSTRUCTION REGISTER TEST BENCH
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity InstReg24bit_tb is
--  Port ( );
end InstReg24bit_tb;

architecture Behavioral of InstReg24bit_tb is

component InstReg24bit is
	Port(
	    reset : IN STD_LOGIC; -- clear register values when 0
		Instr   : IN STD_LOGIC_VECTOR(23 downto 0); -- Input Instruction
		Load_IR: IN STD_LOGIC:='0'; -- Load the input when Load_IR='1' 
		Clock   : IN STD_LOGIC:='0'; 
		Opcode : OUT STD_LOGIC_VECTOR(7 downto 0) := (others => '0'); -- function code for alu
		RegOut: OUT STD_LOGIC_VECTOR (15 downto 0) := (others => '0')); -- address location to store value of register c in data memory
 end component;


constant ClockPeriod    : time    := 20 ns;

signal reset :std_logic;
signal Instr :std_logic_vector(23 downto 0);
signal Load_IR  : std_logic := '0';
signal Clock : std_logic := '0';
signal Opcode : std_logic_vector( 7 downto 0);
signal RegOut: std_logic_vector (15 downto 0);

begin
-- port mapping
utt: InstReg24bit port map (
                            reset,
                            Instr,
                            Load_IR,
                            Clock,
                            Opcode,
                            RegOut);



Clock <= not Clock after ClockPeriod/2;

    process
        
    begin
    reset <= '0';
    
    wait for 2*ClockPeriod;
    
    reset <= '1';
    Instr <= (0 => '1',1 => '1',2 => '1',
          16 =>'1',23 =>'1',22=>'1', others => '0');
    
    -- tc0 load = 1, regout = a
    Load_IR <= '1';
    wait for ClockPeriod;
    
    -- tc1 Load_IR = 0, regout = a
    Load_IR <= '0';
    wait for ClockPeriod;
    
    -- tc2 change in input value test that regout is unchanged
    Instr <= (7 => '1',9 => '1',10 => '1',
          16 =>'1',23 =>'1',22=>'1', others => '0');
    wait for ClockPeriod;
    
    -- tc3 Load_IR = 0, regout = a
    Load_IR <= '1';

    wait for ClockPeriod;
    reset <= '0';    
    wait;
    end process;



end Behavioral;
