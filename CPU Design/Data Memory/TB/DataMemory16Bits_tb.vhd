----------------------------------------------------------------------------------
-- Ruben Ramirez
-- 2694
--                      DATA MEMORY TESTBENCH
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

entity DataMemory16Bits_tb is
--  Port ( );
end DataMemory16Bits_tb;

architecture Behavioral of DataMemory16Bits_tb is

COMPONENT DataMemory16Bits is 
	port (
	  reset: IN STD_LOGIC;
	  carry_in : in STD_LOGIC;  -- carry out from ALU
	  Address_DM     : IN STD_LOGIC_VECTOR(15 downto 0) := (others =>'0'); -- memory address of input
	  Data_In_DM : IN STD_LOGIC_VECTOR(15 downto 0) := (others =>'0');  -- data to be written or read
      Clock      : IN STD_LOGIC;
      We_DM, Re_DM   : IN STD_LOGIC :='0'; --write and read enable
      Data_Out_DM    : OUT STD_LOGIC_VECTOR(16 downto 0):= (others =>'0')); -- data of last read from memory
      
	END COMPONENT;
	
SIGNAL Clock: STD_LOGIC:= '0';
SIGNAL reset: STD_LOGIC;
SIGNAL carry_in: STD_LOGIC:='0';
SIGNAL Address_DM: STD_LOGIC_VECTOR(15 downto 0);
SIGNAL Data_In_DM: STD_LOGIC_VECTOR(15 downto 0);
SIGNAL We_DM, Re_DM: STD_LOGIC;
SIGNAL Data_Out_DM:  STD_LOGIC_VECTOR(16 downto 0);

CONSTANT clockperiod : TIME := 20NS;


begin

UUT: DataMemory16Bits  PORT MAP (
                      reset,
                      carry_in,
                      Address_DM,
                      Data_In_DM,
                      Clock,
                      We_DM,
                      Re_DM,
                      Data_Out_DM);

Clock<= NOT Clock AFTER clockperiod/2;

data_memory_test:  process

BEGIN

    Re_DM <= '1';
    We_DM <= '1';
    reset <= '1';
    Address_DM <= x"0000";
    
    Data_In_DM <= x"0421";
    
    
    wait for ClockPeriod;
    
    Re_DM <= '1';
    
    Address_DM <= x"0001";
    
    Data_In_DM <= x"6101";
    
    wait for ClockPeriod;
    
    We_DM <= '0';
    Re_DM <= '1';    
    Address_DM <= x"0000";
    
    Data_In_DM <= x"ffff";
    wait for ClockPeriod;
    
    We_DM <= '0';
    Re_DM <= '0'; 

    wait for ClockPeriod;
    reset <= '0';

WAIT;
END process;


end Behavioral;
