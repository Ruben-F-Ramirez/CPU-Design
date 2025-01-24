----------------------------------------------------------------------------------
-- Ruben Ramirez
-- 2694
--                      INSTRUCTION MEMORY TESTBENCH
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity I_mem_tb is
--  Port ( );
end I_mem_tb;

architecture Behavioral of I_mem_tb is

component I_mem is
port (
	  reset : IN std_logic;
	  Address_reg     : IN std_logic_vector(3 downto 0) := (others =>'0'); -- address for instruction memory
	  Instruction_in   : IN std_logic_vector(23 downto 0); -- Input Instruction
      Clock      : IN std_logic := '0';
      We_DM  : IN std_logic :='0'; --write and read enable
      instruction_reg    : OUT std_logic_vector(23 downto 0)); -- current instruction
end component;

signal reset   :  std_logic;
signal Address_reg     :  std_logic_vector(3 downto 0) := (others =>'0'); -- address for instruction memory
signal Instruction_in   :  std_logic_vector(23 downto 0); -- Input Instruction
signal Clock      :  std_logic := '0';
signal We_DM   :  std_logic :='0'; --write and read enable
signal instruction_reg    :  std_logic_vector(23 downto 0); -- current instruction

-- clock declaration
constant ClockPeriod    : time    := 20 ns;    

begin

Clock <= not Clock after ClockPeriod/2;

UUT: I_mem  PORT MAP (reset,
                      Address_reg,
                      Instruction_in,
                      Clock,
                      We_DM,
                      instruction_reg);
                               
    process
    
    begin
    We_DM <= '1';
    reset <= '1';
    Address_reg <= "0000";
    
    Instruction_in <= x"100421";
    
    
    wait for ClockPeriod;
    
    Address_reg <= "0001";
    
    Instruction_in <= x"906101";
    
    wait for ClockPeriod;
    
    We_DM <= '0';
    
    
    Address_reg <= "0000";
    
    Instruction_in <= x"ffffff";
    

    
    wait;

    end process;                               
                  
                               
                               

end Behavioral;
