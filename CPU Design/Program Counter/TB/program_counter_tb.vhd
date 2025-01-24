----------------------------------------------------------------------------------
-- Ruben Ramirez
-- 2694 
--                          Program Counter testbench
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity program_counter_tb is
--  Port ( );
end program_counter_tb;

architecture Behavioral of program_counter_tb is


COMPONENT program_counter is
    Port( 


         Load  : IN STD_LOGIC:= '0';      -- input load at load =1
         clk : IN STD_LOGIC:= '0';      
         reset: IN STD_LOGIC:= '0';
         RegOut: OUT STD_LOGIC_VECTOR (3 downto 0):= (others => '0'));
    
end COMPONENT;




SIGNAL   Load_tb  :  STD_LOGIC;      -- input load at load =1
SIGNAL   clk_tb :  STD_LOGIC:='0';      
SIGNAL   reset_tb: STD_LOGIC;
SIGNAL   RegOut_tb:  STD_LOGIC_VECTOR (3 downto 0);

-- clk declaration
constant clkPeriod    : time    := 20 ns; 


begin

clk_tb <= not clk_tb after clkPeriod/2;

UUT: program_counter PORT MAP (reset =>reset_tb,
                               Load =>Load_tb,
                               clk => clk_tb,
                               RegOut =>RegOut_tb);




TEST: PROCESS

BEGIN

reset_tb <= '0';
Load_tb <= '0';
wait for clkPeriod;

--TEST 0 LOAD = 0 count = 0, reg out = 0, reset = 0
reset_tb <= '1';
Load_tb <= '1';




WAIT FOR 16*clkPeriod;


reset_tb <= '0';
Load_tb <= '0';


WAIT;
END PROCESS;





end Behavioral;
