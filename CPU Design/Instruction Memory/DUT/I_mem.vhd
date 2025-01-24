----------------------------------------------------------------------------------
-- Ruben Ramirez
-- 2694
--                      INSTRUCTION MEMORY
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

entity I_mem is
port (
	  reset : IN std_logic;
	  Address_reg     : IN std_logic_vector(3 downto 0) := (others =>'0'); -- address for instruction memory
	  Instruction_in   : IN std_logic_vector(23 downto 0):= (others =>'0'); -- Input Instruction
      Clock      : IN std_logic := '0';
      We_DM   : IN std_logic :='0'; --write and read enable
      instruction_reg    : OUT std_logic_vector(23 downto 0) :=(others =>'0')); -- current instruction
end I_mem;

architecture Behavioral of I_mem is


-- create new array of 15 std_logic_vector  of size 24 bits
type mem is array (0 to 15) of std_logic_vector( 23 downto 0);  

-- initialiaze an array of 16 - 24 bit values
signal mem16: mem := (others =>(others =>'0'));


begin


    process(clock,reset)
        
        
        variable address: integer;  -- for integer value of index in mem16 array
        
        begin
          
         
         address := (to_integer(unsigned(Address_reg))); -- passes index of mem16 to access
           
           IF reset = '0' THEN 
                mem16 <= (others =>(others =>'0'));
           
           
           ELSIF (Clock'EVENT and Clock = '1') THEN
           
           -- determination of whether to read/write from/to mem16
           IF We_DM = '1' THEN
                    mem16(address) <= Instruction_in;       -- write input instruction to mem16 address
               ELSIF We_DM = '0' THEN
                    instruction_reg <= mem16(address);      -- read value from mem16 at given value from Address_reg
                   
            END IF;
     
                       
            END IF;
            
            
        END process;


END Behavioral;
