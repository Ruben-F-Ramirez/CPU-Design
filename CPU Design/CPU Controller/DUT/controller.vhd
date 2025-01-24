----------------------------------------------------------------------------------
-- Ruben Ramirez
-- controller module for CPU
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity controller is
    Port ( 
           clk: in STD_LOGIC;
           opcode : in STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
           enable : in STD_LOGIC := '0';
           sel : out STD_LOGIC := '0';
           WeDM : out STD_LOGIC := '0';
           ReDM : out STD_LOGIC := '0';
           LoadA : out STD_LOGIC := '0';
           LoadB : out STD_LOGIC := '0';
           LoadC : out STD_LOGIC := '0';
           Load_IR : out STD_LOGIC := '0';
           ALU_mode : out STD_LOGIC := '0';
           ALU_opcode : out STD_LOGIC_VECTOR (2 downto 0):= (others => '0');
           Load_pc : out STD_LOGIC := '0';
           reset : out std_logic);
end controller;

architecture Behavioral of controller is






TYPE state_type is (s_PRESET,s_fetch_0,s_fetch_1,s_fetch_2,s_decode_3,
                        s_LDA_4,s_LDA_5,s_LDA_6,
                        s_LDB_4,s_LDB_5,s_LDB_6,
                        s_EXIT_4,
                        s_STORE_C_4,
                        s_ALU_4,s_ALU_5,
                        s_RDMEM_4);
SIGNAL ns: state_type;
SIGNAL ps: state_type:= s_PRESET;
--------------------------------------------
-- FUNCT HOLDS 3 MSB OF OPCODE 
-- DETERMINES WHAT FUNCTION CPU IS TO EXECUTE
SIGNAL FUNCT:STD_LOGIC_VECTOR (2 DOWNTO 0);
---------------------------------------------
begin

FUNCT <= opcode(7 DOWNTO 5);

state_clocked: process (clk,enable)

begin
    IF enable = '0' THEN
        ps <= s_fetch_0;
 
                   
    ELSIF (rising_edge(clk)) then
        ps <= ns;
    end if;
end process;

state_comb: process(enable,opcode,ps)


begin
     IF (ps = s_PRESET) THEN
        ns <= s_PRESET;
     ELSIF (ps = s_fetch_0) THEN
        ns <= s_fetch_1;
     ELSIF (ps = s_fetch_1) THEN
        ns <= s_fetch_2;
     ELSIF (ps = s_fetch_2) THEN
        ns <= s_decode_3; 
     ELSIF (ps = s_decode_3) THEN
 
        
----------------------------------------- BRANCH FOR EACH INSTRUCTION ----------------------------------
 
        
-------------------------------------------------------------------------------------------------------- 
----------------------------------- LOAD A BRANCH ------------------------------------------------------   
--------------------------------------------------------------------------------------------------------        
  
       
        IF FUNCT = "000" THEN
            IF opcode(0) = '0' THEN
                ns <= s_LDA_4;
            ELSIF opcode(0) = '1' THEN
-------------------------------------------------------------------------------------------------------- 
----------------------------------- LOAD B BRANCH ------------------------------------------------------   
--------------------------------------------------------------------------------------------------------        
              
                ns <= s_LDB_4;
            END IF;
-------------------------------------------------------------------------------------------------------- 
----------------------------------- STORE C BRANCH -----------------------------------------------------  
--------------------------------------------------------------------------------------------------------   

     ELSIF FUNCT = "001" THEN
            ns <=s_STORE_C_4;

-------------------------------------------------------------------------------------------------------- 
----------------------------------- ALU BRANCH ---------------------------------------------------------  
--------------------------------------------------------------------------------------------------------

     ELSIF FUNCT = "010" THEN
            ns <=s_ALU_4;

-------------------------------------------------------------------------------------------------------- 
----------------------------------- READ DATA MEMORY BRANCH -------------------------------------------- 
--------------------------------------------------------------------------------------------------------        
          
     ELSIF FUNCT = "011" THEN
            ns <=s_RDMEM_4;      
              
   
-------------------------------------------------------------------------------------------------------- 
----------------------------------- EXIT BRANCH --------------------------------------------------------   
--------------------------------------------------------------------------------------------------------        
  
     ELSIF std_match("1--",FUNCT) THEN
            ns <=s_EXIT_4;
   
            
        

            
         END IF;
--------------------------------------------------------------------------------------------------------
--                      END OF INSTRUCTION BRANCH 
-------------------------------------------------------------------------------------------------------- 
 




--------------------------------------------------------------------------------------------------------
--                      INSTRUCTION STATES
-------------------------------------------------------------------------------------------------------- 
 
 
 ------------------------------------------ LOAD A -----------------------------------------------------
       
    ELSIF (ps = s_LDA_4) THEN
        ns <= s_LDA_5;
    ELSIF (ps = s_LDA_5) THEN
        ns <= s_LDA_6;
    ELSIF (ps = s_LDA_6) THEN
        ns <= s_fetch_1;

------------------------------------------ LOAD B ----------------------------------------------------
       
    ELSIF (ps = s_LDB_4) THEN
        ns <= s_LDB_5;
    ELSIF (ps = s_LDB_5) THEN
        ns <= s_LDB_6;
    ELSIF (ps = s_LDB_6) THEN
        ns <= s_fetch_1;
------------------------------------------ STORE C ----------------------------------------------------
    ELSIF (ps = s_STORE_C_4) THEN
        ns <= s_fetch_1;
------------------------------------------- ALU -------------------------------------------------------
    ELSIF (ps = s_ALU_4) THEN
        ns <= s_ALU_5;
    ELSIF (ps = s_ALU_5) THEN
        ns <= s_fetch_1;
    
------------------------------------------ READ DATA MEMORY -------------------------------------------
    ELSIF (ps = s_RDMEM_4) THEN
        ns <= s_fetch_1;



------------------------------------------ EXIT -------------------------------------------------------

    ELSIF (ps = s_EXIT_4) THEN
        ns <= s_EXIT_4;


END IF;
--------------------------------------------------------------------------------------------------------
--                     END OF INSTRUCTION STATES
-------------------------------------------------------------------------------------------------------- 

    
--------------------------------------------------------------------------------------------------------
--                      INSTRUCTION OUTPUTS
-------------------------------------------------------------------------------------------------------- 
end process;
          
output_comb : process(ps,enable,opcode)
begin

    CASE ps is
    
------------------------------------------ PRESET  ----------------------------------------------------
        WHEN s_PRESET =>
           Load_pc <= '0';  -- LOAD PC = 1 STARTS PROGRAM COUNTER 
           sel <= '0';      -- INPUT ADDRESS = 0, PROGRAM COUNTER = 1
           WeDM <= '0';     -- WEDM = 1 WRITE TO DATA MEMORY
           ReDM <= '0';     -- REDM = 1 READ FROM DATA MEMORY
           LoadA <= '0';    -- LOAD A = 1 WRITES TO REGISTER A
           LoadB <= '0';    -- LOAD B = 1 WRITES TO REGISTER B
           LoadC <= '0';    -- LOAD C = 1 WRITES TO REGISTER C
           ALU_mode <= opcode(1); -- ALU MODE = 0 |LOGIC OPERATIONS|, ALU MODE = 1 |SHIFTER|ARITHMETIC|
           ALU_opcode <= (others => '0');
           Load_IR <= '0';  -- LOAD IR = 1 LOADS INSTRUCTION REGISTER WITH OPCODE AND OPERAND
           reset <= '0';
           
------------------------------------------ FETCH PROCESS  ----------------------------------------------------

        WHEN s_fetch_0 =>
           Load_pc <= '0';  -- LOAD PC = 1 STARTS PROGRAM COUNTER 
           sel <= '0';      -- INPUT ADDRESS = 0, PROGRAM COUNTER = 1
           WeDM <= '0';     -- WEDM = 1 WRITE TO DATA MEMORY
           ReDM <= '0';     -- REDM = 1 READ FROM DATA MEMORY
           LoadA <= '0';    -- LOAD A = 1 WRITES TO REGISTER A
           LoadB <= '0';    -- LOAD B = 1 WRITES TO REGISTER B
           LoadC <= '0';    -- LOAD C = 1 WRITES TO REGISTER C
           ALU_mode <= opcode(1); -- ALU MODE = 0 |LOGIC OPERATIONS|, ALU MODE = 1 |SHIFTER|ARITHMETIC|
           ALU_opcode <= (others => '0');
           Load_IR <= '0';  -- LOAD IR = 1 LOADS INSTRUCTION REGISTER WITH OPCODE AND OPERAND
           reset <= '1';
           
        WHEN s_fetch_1 =>
           Load_pc <= '0';  -- LOAD PC = 1 STARTS PROGRAM COUNTER 
           sel <= '1';      -- INPUT ADDRESS = 0, PROGRAM COUNTER = 1
           WeDM <= '0';     -- WEDM = 1 WRITE TO DATA MEMORY
           ReDM <= '0';     -- REDM = 1 READ FROM DATA MEMORY
           LoadA <= '0';    -- LOAD A = 1 WRITES TO REGISTER A
           LoadB <= '0';    -- LOAD B = 1 WRITES TO REGISTER B
           LoadC <= '0';    -- LOAD C = 1 WRITES TO REGISTER C
           ALU_mode <= opcode(1); -- ALU MODE = 0 |LOGIC OPERATIONS|, ALU MODE = 1 |SHIFTER|ARITHMETIC|
           ALU_opcode <= opcode(4 DOWNTO 2);
           Load_IR <= '1';  -- LOAD IR = 1 LOADS INSTRUCTION REGISTER WITH OPCODE AND OPERAND
           reset <= '1';
           
        WHEN s_fetch_2 =>
           Load_pc <= '0';  -- LOAD PC = 1 STARTS PROGRAM COUNTER 
           sel <= '1';      -- INPUT ADDRESS = 0, PROGRAM COUNTER = 1
           WeDM <= '0';     -- WEDM = 1 WRITE TO DATA MEMORY
           ReDM <= '0';     -- REDM = 1 READ FROM DATA MEMORY
           LoadA <= '0';    -- LOAD A = 1 WRITES TO REGISTER A
           LoadB <= '0';    -- LOAD B = 1 WRITES TO REGISTER B
           LoadC <= '0';    -- LOAD C = 1 WRITES TO REGISTER C
           ALU_mode <= opcode(1); -- ALU MODE = 0 |LOGIC OPERATIONS|, ALU MODE = 1 |SHIFTER|ARITHMETIC|
           ALU_opcode <= opcode(4 DOWNTO 2);
           Load_IR <= '1';  -- LOAD IR = 1 LOADS INSTRUCTION REGISTER WITH OPCODE AND OPERAND
           reset <= '1';
           
        WHEN s_decode_3 =>
           Load_pc <= '1';  -- LOAD PC = 1 STARTS PROGRAM COUNTER 
           sel <= '1';      -- INPUT ADDRESS = 0, PROGRAM COUNTER = 1
           WeDM <= '0';     -- WEDM = 1 WRITE TO DATA MEMORY
           ReDM <= '0';     -- REDM = 1 READ FROM DATA MEMORY
           LoadA <= '0';    -- LOAD A = 1 WRITES TO REGISTER A
           LoadB <= '0';    -- LOAD B = 1 WRITES TO REGISTER B
           LoadC <= '0';    -- LOAD C = 1 WRITES TO REGISTER C
           ALU_mode <= opcode(1); -- ALU MODE = 0 |LOGIC OPERATIONS|, ALU MODE = 1 |SHIFTER|ARITHMETIC|
           ALU_opcode <= opcode(4 DOWNTO 2);
           Load_IR <= '0';  -- LOAD IR = 1 LOADS INSTRUCTION REGISTER WITH OPCODE AND OPERAND
           reset <= '1';
           
           
 ------------------------------------------ LOAD A ----------------------------------------------------
        WHEN s_LDA_4 =>
           Load_pc <= '0';  -- LOAD PC = 1 STARTS PROGRAM COUNTER 
           sel <= '1';      -- INPUT ADDRESS = 0, PROGRAM COUNTER = 1
           WeDM <= '0';     -- WEDM = 1 WRITE TO DATA MEMORY
           ReDM <= '0';     -- REDM = 1 READ FROM DATA MEMORY
           LoadA <= '1';    -- LOAD A = 1 WRITES TO REGISTER A
           LoadB <= '0';    -- LOAD B = 1 WRITES TO REGISTER B
           LoadC <= '0';    -- LOAD C = 1 WRITES TO REGISTER C
           ALU_mode <= opcode(1); -- ALU MODE = 0 |LOGIC OPERATIONS|, ALU MODE = 1 |SHIFTER|ARITHMETIC|
           ALU_opcode <= opcode(4 DOWNTO 2);
           Load_IR <= '0';  -- LOAD IR = 1 LOADS INSTRUCTION REGISTER WITH OPCODE AND OPERAND
           reset <= '1';
           
        WHEN s_LDA_5 =>
           Load_pc <= '0';  -- LOAD PC = 1 STARTS PROGRAM COUNTER 
           sel <= '1';      -- INPUT ADDRESS = 0, PROGRAM COUNTER = 1
           WeDM <= '0';     -- WEDM = 1 WRITE TO DATA MEMORY
           ReDM <= '0';     -- REDM = 1 READ FROM DATA MEMORY
           LoadA <= '1';    -- LOAD A = 1 WRITES TO REGISTER A
           LoadB <= '0';    -- LOAD B = 1 WRITES TO REGISTER B
           LoadC <= '0';    -- LOAD C = 1 WRITES TO REGISTER C
           ALU_mode <= opcode(1); -- ALU MODE = 0 |LOGIC OPERATIONS|, ALU MODE = 1 |SHIFTER|ARITHMETIC|
           ALU_opcode <= opcode(4 DOWNTO 2);
           Load_IR <= '0';  -- LOAD IR = 1 LOADS INSTRUCTION REGISTER WITH OPCODE AND OPERAND           
           reset <= '1';
           
        WHEN s_LDA_6 =>
           Load_pc <= '0';  -- LOAD PC = 1 STARTS PROGRAM COUNTER 
           sel <= '1';      -- INPUT ADDRESS = 0, PROGRAM COUNTER = 1
           WeDM <= '0';     -- WEDM = 1 WRITE TO DATA MEMORY
           ReDM <= '0';     -- REDM = 1 READ FROM DATA MEMORY
           LoadA <= '0';    -- LOAD A = 1 WRITES TO REGISTER A
           LoadB <= '0';   -- LOAD B = 1 WRITES TO REGISTER B
           LoadC <= '0';    -- LOAD C = 1 WRITES TO REGISTER C
           ALU_mode <= opcode(1); -- ALU MODE = 0 |LOGIC OPERATIONS|, ALU MODE = 1 |SHIFTER|ARITHMETIC|
           ALU_opcode <= opcode(4 DOWNTO 2);
           Load_IR <= '0';  -- LOAD IR = 1 LOADS INSTRUCTION REGISTER WITH OPCODE AND OPERAND
           reset <= '1';
 ------------------------------------------ LOAD B ----------------------------------------------------
        WHEN s_LDB_4 =>
           Load_pc <= '0';  -- LOAD PC = 1 STARTS PROGRAM COUNTER 
           sel <= '1';      -- INPUT ADDRESS = 0, PROGRAM COUNTER = 1
           WeDM <= '0';     -- WEDM = 1 WRITE TO DATA MEMORY
           ReDM <= '0';     -- REDM = 1 READ FROM DATA MEMORY
           LoadA <= '0';    -- LOAD A = 1 WRITES TO REGISTER A
           LoadB <= '1';    -- LOAD B = 1 WRITES TO REGISTER B
           LoadC <= '0';    -- LOAD C = 1 WRITES TO REGISTER C
           ALU_mode <= opcode(1); -- ALU MODE = 0 |LOGIC OPERATIONS|, ALU MODE = 1 |SHIFTER|ARITHMETIC|
           ALU_opcode <= opcode(4 DOWNTO 2);
           Load_IR <= '0';  -- LOAD IR = 1 LOADS INSTRUCTION REGISTER WITH OPCODE AND OPERAND
           reset <= '1';
        
        WHEN s_LDB_5 =>
           Load_pc <= '0';  -- LOAD PC = 1 STARTS PROGRAM COUNTER 
           sel <= '1';      -- INPUT ADDRESS = 0, PROGRAM COUNTER = 1
           WeDM <= '0';     -- WEDM = 1 WRITE TO DATA MEMORY
           ReDM <= '0';     -- REDM = 1 READ FROM DATA MEMORY
           LoadA <= '0';    -- LOAD A = 1 WRITES TO REGISTER A
           LoadB <= '1';    -- LOAD B = 1 WRITES TO REGISTER B
           LoadC <= '0';    -- LOAD C = 1 WRITES TO REGISTER C
           ALU_mode <= opcode(1); -- ALU MODE = 0 |LOGIC OPERATIONS|, ALU MODE = 1 |SHIFTER|ARITHMETIC|
           ALU_opcode <= opcode(4 DOWNTO 2);
           Load_IR <= '0';  -- LOAD IR = 1 LOADS INSTRUCTION REGISTER WITH OPCODE AND OPERAND 
           reset <= '1';          

        WHEN s_LDB_6 =>
           Load_pc <= '0';  -- LOAD PC = 1 STARTS PROGRAM COUNTER 
           sel <= '1';      -- INPUT ADDRESS = 0, PROGRAM COUNTER = 1
           WeDM <= '0';     -- WEDM = 1 WRITE TO DATA MEMORY
           ReDM <= '0';     -- REDM = 1 READ FROM DATA MEMORY
           LoadA <= '0';    -- LOAD A = 1 WRITES TO REGISTER A
           LoadB <= '0';    -- LOAD B = 1 WRITES TO REGISTER B
           LoadC <= '0';    -- LOAD C = 1 WRITES TO REGISTER C
           ALU_mode <= opcode(1); -- ALU MODE = 0 |LOGIC OPERATIONS|, ALU MODE = 1 |SHIFTER|ARITHMETIC|
           ALU_opcode <= opcode(4 DOWNTO 2);
           Load_IR <= '0';  -- LOAD IR = 1 LOADS INSTRUCTION REGISTER WITH OPCODE AND OPERAND
           reset <= '1';
           
------------------------------------------ STORE C  -------------------------------------------------
-- STORES REGISTER C TO DATA MEMORY
-----------------------------------------------------------------------------------------------------
        WHEN s_STORE_C_4 =>
           Load_pc <= '0';  -- LOAD PC = 1 INCREMENTS PROGRAM COUNTER 
           sel <= '1';      -- INPUT ADDRESS = 0, PROGRAM COUNTER = 1
           WeDM <= '1';     -- WEDM = 1 WRITE TO DATA MEMORY
           ReDM <= '0';     -- REDM = 1 READ FROM DATA MEMORY
           LoadA <= '0';    -- LOAD A = 1 WRITES TO REGISTER A
           LoadB <= '0';    -- LOAD B = 1 WRITES TO REGISTER B
           LoadC <= '0';    -- LOAD C = 1 WRITES TO REGISTER C
           ALU_mode <= opcode(1); -- ALU MODE = 0 |LOGIC OPERATIONS|, ALU MODE = 1 |SHIFTER|ARITHMETIC|
           ALU_opcode <= opcode(4 DOWNTO 2);
           Load_IR <= '0';  -- LOAD IR = 1 LOADS INSTRUCTION REGISTER WITH OPCODE AND OPERAND
           reset <= '1';
        
------------------------------------------ ALU  -----------------------------------------------------
-- EXECUTES ALU OPERATION
-----------------------------------------------------------------------------------------------------
        WHEN s_ALU_4 =>
           Load_pc <= '0';  -- LOAD PC = 1 INCREMENTS PROGRAM COUNTER 
           sel <= '1';      -- INPUT ADDRESS = 0, PROGRAM COUNTER = 1
           WeDM <= '0';     -- WEDM = 1 WRITE TO DATA MEMORY
           ReDM <= '0';     -- REDM = 1 READ FROM DATA MEMORY
           LoadA <= '0';    -- LOAD A = 1 WRITES TO REGISTER A
           LoadB <= '0';    -- LOAD B = 1 WRITES TO REGISTER B
           LoadC <= '0';    -- LOAD C = 1 WRITES TO REGISTER C
           ALU_mode <= opcode(1); -- ALU MODE = 0 |LOGIC OPERATIONS|, ALU MODE = 1 |SHIFTER|ARITHMETIC|
           ALU_opcode <= opcode(4 DOWNTO 2);
           Load_IR <= '0';  -- LOAD IR = 1 LOADS INSTRUCTION REGISTER WITH OPCODE AND OPERAND
           reset <= '1';
           
        WHEN s_ALU_5 =>
           Load_pc <= '0';  -- LOAD PC = 1 INCREMENTS PROGRAM COUNTER 
           sel <= '1';      -- INPUT ADDRESS = 0, PROGRAM COUNTER = 1
           WeDM <= '0';     -- WEDM = 1 WRITE TO DATA MEMORY
           ReDM <= '0';     -- REDM = 1 READ FROM DATA MEMORY
           LoadA <= '0';    -- LOAD A = 1 WRITES TO REGISTER A
           LoadB <= '0';    -- LOAD B = 1 WRITES TO REGISTER B
           LoadC <= '1';    -- LOAD C = 1 WRITES TO REGISTER C
           ALU_mode <= opcode(1); -- ALU MODE = 0 |LOGIC OPERATIONS|, ALU MODE = 1 |SHIFTER|ARITHMETIC|
           ALU_opcode <= opcode(4 DOWNTO 2);
           Load_IR <= '0';  -- LOAD IR = 1 LOADS INSTRUCTION REGISTER WITH OPCODE AND OPERAND
           reset <= '1';

------------------------------------------ READ MEMORY  ---------------------------------------------
        WHEN s_RDMEM_4 =>
           Load_pc <= '0';  -- LOAD PC = 1 INCREMENTS PROGRAM COUNTER 
           sel <= '1';      -- INPUT ADDRESS = 0, PROGRAM COUNTER = 1
           WeDM <= '0';     -- WEDM = 1 WRITE TO DATA MEMORY
           ReDM <= '1';     -- REDM = 1 READ FROM DATA MEMORY
           LoadA <= '0';    -- LOAD A = 1 WRITES TO REGISTER A
           LoadB <= '0';    -- LOAD B = 1 WRITES TO REGISTER B
           LoadC <= '0';    -- LOAD C = 1 WRITES TO REGISTER C
           ALU_mode <= opcode(1); -- ALU MODE = 0 |LOGIC OPERATIONS|, ALU MODE = 1 |SHIFTER|ARITHMETIC|
           ALU_opcode <= opcode(4 DOWNTO 2);
           Load_IR <= '0';  -- LOAD IR = 1 LOADS INSTRUCTION REGISTER WITH OPCODE AND OPERAND
           reset <= '1';
           
------------------------------------------ EXIT  ----------------------------------------------------
-- STOPS EXECUTION OF PROGRAM
-----------------------------------------------------------------------------------------------------
        WHEN s_EXIT_4 =>
           Load_pc <= '0';  -- LOAD PC = 1 STARTS PROGRAM COUNTER 
           sel <= '0';      -- INPUT ADDRESS = 0, PROGRAM COUNTER = 1
           WeDM <= '0';     -- WEDM = 1 WRITE TO DATA MEMORY
           ReDM <= '0';     -- REDM = 1 READ FROM DATA MEMORY
           LoadA <= '0';    -- LOAD A = 1 WRITES TO REGISTER A
           LoadB <= '0';    -- LOAD B = 1 WRITES TO REGISTER B
           LoadC <= '0';    -- LOAD C = 1 WRITES TO REGISTER C
           ALU_mode <= opcode(1); -- ALU MODE = 0 |LOGIC OPERATIONS|, ALU MODE = 1 |SHIFTER|ARITHMETIC|
           ALU_opcode <= opcode(4 DOWNTO 2);
           Load_IR <= '0';  -- LOAD IR = 1 LOADS INSTRUCTION REGISTER WITH OPCODE AND OPERAND
           reset <= '0';

           
-------------------------------------- DEFAULT OUTPUTS ------------------------------------------------           
    WHEN OTHERS =>   
           Load_pc <= '0';  -- LOAD PC = 1 STARTS PROGRAM COUNTER 
           sel <= '0';      -- INPUT ADDRESS = 0, PROGRAM COUNTER = 1
           WeDM <= '0';     -- WEDM = 1 WRITE TO DATA MEMORY
           ReDM <= '0';     -- REDM = 1 READ FROM DATA MEMORY
           LoadA <= '0';    -- LOAD A = 1 WRITES TO REGISTER A
           LoadB <= '0';    -- LOAD B = 1 WRITES TO REGISTER B
           LoadC <= '0';    -- LOAD C = 1 WRITES TO REGISTER C
           ALU_mode <= '0'; -- ALU MODE = 0 |LOGIC OPERATIONS|, ALU MODE = 1 |SHIFTER|ARITHMETIC|
           ALU_opcode <= (others => '0');
           Load_IR <= '0';  -- LOAD IR = 1 LOADS INSTRUCTION REGISTER WITH OPCODE AND OPERAND     
           
    END CASE;
--------------------------------------------------------------------------------------------------------
--                   END OF INSTRUCTION OUTPUTS
--------------------------------------------------------------------------------------------------------         




END PROCESS;




end Behavioral;
