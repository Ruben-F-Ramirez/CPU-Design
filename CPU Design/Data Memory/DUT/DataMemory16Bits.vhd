----------------------------------------------------------------------------------
-- Ruben Ramires
-- 2694
--                          Data Memory
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity DataMemory16Bits is 
	port (
	  reset: IN STD_LOGIC;
	  carry_in : in STD_LOGIC;  -- carry out from ALU
	  Address_DM     : IN STD_LOGIC_VECTOR(15 downto 0) := (others =>'0'); -- memory address of input
	  Data_In_DM : IN STD_LOGIC_VECTOR(15 downto 0) := (others =>'0');  -- data to be written or read
      Clock      : IN STD_LOGIC := '0';
      We_DM, Re_DM   : IN STD_LOGIC :='0'; --write and read enable
      Data_Out_DM    : OUT STD_LOGIC_VECTOR(16 downto 0):= (others =>'0')); -- data of last read from memory
      
	end DataMemory16Bits;

architecture Behavioral of DataMemory16Bits is

-- create new array of 15 std_logic_vector  of size 16 bits
type mem is array (0 to 15) of STD_LOGIC_VECTOR( 16 downto 0);  

-- initialiaze an array of 15 - 17 bit values
signal mem16: mem := (others =>(others =>'0'));


begin

    process(Address_DM,Data_In_DM,Clock,We_DM, Re_DM,reset)
        
        
        variable address: integer;  -- for integer value of index in mem16 array
        
        begin
          
         
         address := (to_integer(unsigned(Address_DM(3 downto 0)))); -- passes index of mem16 to access
           
           
           IF reset = '0' THEN 
                mem16 <= (others =>(others =>'0'));
           
           ELSIF (Clock'EVENT and Clock = '1') THEN
           
           
           
           -- determination of whether to read/write from/to mem16
           CASE We_DM is
                    when '1' => 
                    mem16(address) <= carry_in & Data_In_DM;       -- write Data_In_DM to mem16 at given value from Address_DM
                    when '0' =>
                     
                    IF Re_DM = '1' THEN
                     
                    Data_Out_DM <= mem16(address);      -- read value from mem16 at given value from Address_DM
                    
                    END IF;
                    when others => 
                    Data_Out_DM <= (others => 'Z');
            end case;
     
                       
            end if;
        end process;



end Behavioral;
