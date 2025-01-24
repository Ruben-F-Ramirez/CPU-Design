----------------------------------------------------------------------------------
-- Ruben Ramirez
-- 2694
--                          controller testbench
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

entity pc_tb is
--  Port ( );
end pc_tb;

architecture Behavioral of pc_tb is

component controller is
    Port(
           clk: in STD_LOGIC:='0';
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
           reset : out STD_LOGIC);
    
end component;

-- signal declaration
constant ClockPeriod    : time    := 10 ns;


signal     clk: STD_LOGIC:= '0';
signal     opcode :  STD_LOGIC_VECTOR (7 downto 0);
signal     enable :  STD_LOGIC;
signal     sel :  STD_LOGIC;
signal     WeDM :  STD_LOGIC;
signal     ReDM :  STD_LOGIC;
signal     LoadA :  STD_LOGIC;
signal     LoadB :  STD_LOGIC;
signal     LoadC :  STD_LOGIC;
signal     Load_IR :  STD_LOGIC;
signal     ALU_mode :  STD_LOGIC;
signal     ALU_opcode :  STD_LOGIC_VECTOR (2 downto 0);
signal     Load_pc :  STD_LOGIC;
signal     reset : STD_LOGIC;

begin
-- port mapping
utt: controller port map (clk,opcode,enable,sel,WeDM,ReDM,LoadA,LoadB,
LoadC,Load_IR,ALU_mode,ALU_opcode,Load_pc,reset);


clk <= not clk after ClockPeriod/2;

CONTROLLER_TEST:    process

    begin

------------------------ RESET TIME ------------------------
    
    enable <= '0';
    opcode <= x"00";

 
WAIT FOR ClockPeriod;

-------------------------------------- TEST OF LOAD A ---------------------------
-- OPCODE = 000
-- THIS TEST CASE WILL TAKE THE VALUE OF OPERAND IN THE INSTRUCTION REGISTER
-- AND STORE INTO REGISTER A
-- opcode form is "function" & "alu opcode" & "alu mode" & "load bit, A = 0, B = 1"
-------------------------------------------------------------------------------
    enable <= '1';
    opcode <= "000" & "000" & '0' & '0';

WAIT FOR 6*ClockPeriod;

-------------------------------------- TEST OF LOAD B ---------------------------
-- OPCODE = 000
-- THIS TEST CASE WILL TAKE THE VALUE OF OPERAND IN THE INSTRUCTION REGISTER
-- AND STORE INTO REGISTER B
-- opcode form is "function" & "alu opcode" & "alu mode" & "load bit, A = 0, B = 1"
-------------------------------------------------------------------------------

    enable <= '1';
    opcode <= "000" & "000" & '0' & '1';


WAIT FOR 6*ClockPeriod;

-------------------------------------- TEST OF STORE C ---------------------------
-- OPCODE = 001
-- THIS TEST CASE WILL TAKE THE VALUE OF OPERAND IN THE INSTRUCTION REGISTER
-- AND STORE INTO REGISTER C
-- opcode form is "function" & "alu opcode" & "alu mode" & "load bit, A = 0, B = 1"
-------------------------------------------------------------------------------

    enable <= '1';
    opcode <= "001" & "000" & '0' & '1';


WAIT FOR 5*ClockPeriod;

-------------------------------------- TEST OF ALU UNIT ---------------------------
-- OPCODE = 010
-- THE FOLLOWING TEST CASES WILL TEST THE FUNCTIONALITY OF THE ALU UNIT
-- 
-- opcode form is "function" & "alu opcode" & "alu mode" & "load bit, A = 0, B = 1"
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
--  LOGIC: A NOR B, ALU OPCODE: 000, ALU MODE: 0
-------------------------------------------------------------------------------

    enable <= '1';
    opcode <= "010" & "000" & '0' & '0';


WAIT FOR 5*ClockPeriod;

-------------------------------------------------------------------------------
--  LOGIC: A NAND B, ALU OPCODE: 001, ALU MODE: 0
-------------------------------------------------------------------------------

    enable <= '1';
    opcode <= "010" & "001" & '0' & '0';




WAIT FOR 5*ClockPeriod;

-------------------------------------------------------------------------------
--  ARITHMETIC: A * B, ALU OPCODE: 000, ALU MODE: 1
-------------------------------------------------------------------------------

    enable <= '1';
    opcode <= "010" & "000" & '1' & '0';


WAIT FOR 5*ClockPeriod;

-------------------------------------------------------------------------------
--  ARITHMETIC: A + B, ALU OPCODE: 001, ALU MODE: 1
-------------------------------------------------------------------------------

    enable <= '1';
    opcode <= "010" & "001" & '1' & '0';



WAIT FOR 5*ClockPeriod;

-------------------------------------------------------------------------------
--  ARITHMETIC: INCREMENT A, ALU OPCODE: 011, ALU MODE: 1
-------------------------------------------------------------------------------

    enable <= '1';
    opcode <= "010" & "011" & '1' & '0';


WAIT FOR 5*ClockPeriod;

-------------------------------------------------------------------------------
--  SHIFTER: SHIFT LEFT A BY B BITS, ALU OPCODE: 100, ALU MODE: 1
-------------------------------------------------------------------------------

    enable <= '1';
    opcode <= "010" & "100" & '1' & '0';




WAIT FOR 5*ClockPeriod;

-------------------------------------------------------------------------------
--  SHIFTER: ROTATE RIGHT A BY B BITS, ALU OPCODE: 111, ALU MODE: 1
-------------------------------------------------------------------------------

    enable <= '1';
    opcode <= "010" & "111" & '1' & '0';


WAIT FOR 5*ClockPeriod;

----------------------------------------------------------------------------------
-----------------------------END OF ALU TEST--------------------------------------
----------------------------------------------------------------------------------




-------------------------------------- TEST OF READ DATA MEMORY ---------------------------
-- OPCODE = 011
-- THIS TEST CASE WILL READ THE VALUE STORED IN DATA MEMORY AT GIVEN ADDRESS
-- 
-- opcode form is "function" & "alu opcode" & "alu mode" & "load bit, A = 0, B = 1"
-------------------------------------------------------------------------------

    enable <= '1';
    opcode <= "011" & "000" & '0' & '1';


WAIT FOR 8*ClockPeriod;

-------------------------------------- TEST OF EXIT ---------------------------
-- OPCODE = 111
-- THIS TEST CASE WILL EXIT THE INSTRUCTION PROGRAM AND PREVENT 
-- FURTHER EXECUTION OF INSTRUCTIONS
--
-- opcode form is "function" & "alu opcode" & "alu mode" & "load bit, A = 0, B = 1"
-------------------------------------------------------------------------------

    enable <= '1';
    opcode <= "111" & "000" & '0' & '1';


WAIT;
    


end process;
end Behavioral;
