----------------------------------------------------------------------------------
-- Ruben Ramirez
-- 2694
--                      CPU TESTBENCH
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

entity CPU_TB is
--  Port ( );
end CPU_TB;



architecture Behavioral of CPU_TB is

COMPONENT CPU is
    Port ( 
           enable : in STD_LOGIC;
           instruct_address : in STD_LOGIC_VECTOR (3 downto 0);
           input_instruct : in STD_LOGIC_VECTOR (23 downto 0);
           CPU_out : out STD_LOGIC_VECTOR (15 downto 0);
           DM_out : out STD_LOGIC_VECTOR (16 downto 0);
           weIM : in STD_LOGIC;
           clock : in STD_LOGIC;
           Cout : out STD_LOGIC);
end COMPONENT;

SIGNAL     enable :  STD_LOGIC;
SIGNAL     instruct_address :  STD_LOGIC_VECTOR (3 downto 0);
SIGNAL     input_instruct :  STD_LOGIC_VECTOR(23 downto 0);
SIGNAL     CPU_out :  STD_LOGIC_VECTOR (15 downto 0);
SIGNAL     DM_out :  STD_LOGIC_VECTOR (16 downto 0);
SIGNAL     weIM :  STD_LOGIC;
SIGNAL     clock :  STD_LOGIC:='0';
SIGNAL     Cout :  STD_LOGIC;

constant ClockPeriod    : time    := 20 ns;



begin

Clock <= not Clock after ClockPeriod/2; -- set clock value


UUT: CPU PORT MAP(
            
            enable,
            instruct_address,
            input_instruct,
            CPU_out,
            DM_out,
            weIM,
            Clock,
            Cout);

TEST_cpu: PROCESS
begin
    
    -- preset state
    
 
    
    wait for 2*ClockPeriod;

    -- TEST CASE : 0
    -- LOAD A
    enable <='0';
    instruct_address <= "0000";
    input_instruct <= "000"&"000"&'0'&'0'&X"0003";
    weIM <= '1';
    WAIT FOR ClockPeriod;
    -- TEST CASE : 1
    -- LOAD B
    enable <='0';
    instruct_address <= "0001";
    input_instruct <= "000"&"000"&'0'&'1'&X"0005";
    weIM <= '1';
    WAIT FOR ClockPeriod;
    -- TEST CASE : 2
    -- ALU : A + B = X"0008"
    enable <='0';
    instruct_address <= "0010";
    input_instruct <= "010"&"001"&'1'&'0'&X"0006";
    weIM <= '1';
    WAIT FOR ClockPeriod;
    -- TEST CASE : 3
    -- STORE C
    enable <='0';
    instruct_address <= "0011";
    input_instruct <= "001"&"000"&'0'&'0'&X"0001";
    weIM <= '1';
    WAIT FOR ClockPeriod;
    -- TEST CASE : 4
    -- READ DATA MEMORY
    enable <='0';
    instruct_address <= "0100";
    input_instruct <= "011"&"000"&'0'&'0'&X"0001";
    weIM <= '1';
    WAIT FOR ClockPeriod;
    -- TEST CASE : 5
    -- EXIT
    enable <='0';
    instruct_address <= "0101";
    input_instruct <= "111"&"000"&'0'&'0'&X"0006";
    weIM <= '1';
    WAIT FOR ClockPeriod;
    -- TEST CASE : 6
    -- DUMMY INSTRUCTION TO TEST EXIT
    enable <='0';
    instruct_address <= "1111";
    input_instruct <= "000"&"000"&'0'&'0'&X"FFFF";
    weIM <= '1';
    WAIT FOR ClockPeriod;

 ----------------------------EXECUTE --------------------------   
 -- 1) LOAD A WITH "0011"
 -- 2) LOAD B WITH "0101"
 -- 3) ADD A,B
 -- 4) STORE ADD A,B TO DATA MEMORY ADDRESS "0001"
 -- 5) READ DATA MEMORY ADDRESS "0001"
 -- 6) EXIT
 -- 7) NOT EXECUTED
    enable <='1';
    weIM <= '0';
    wait FOR 36*ClockPeriod;
    
    enable <='0';

    weIM <= '1';
    wait ;
    
    
WAIT;
end process;
end Behavioral;
