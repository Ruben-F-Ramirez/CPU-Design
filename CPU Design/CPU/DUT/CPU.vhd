----------------------------------------------------------------------------------
-- Ruben Ramirez
-- 2694
--                              CPU
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

entity CPU is
    Port ( 
           enable : in STD_LOGIC;
           instruct_address : in STD_LOGIC_VECTOR (3 downto 0);
           input_instruct : in STD_LOGIC_VECTOR (23 downto 0);
           CPU_out : out STD_LOGIC_VECTOR (15 downto 0);
           DM_out : out STD_LOGIC_VECTOR (16 downto 0);
           weIM : in STD_LOGIC;
           clock : in STD_LOGIC;
           Cout : out STD_LOGIC);
end CPU;

architecture Structural of CPU is


-------------------- COMPONENT INSTANTIATION ----------------------

----------------------- ALU ------------------------
component ALU is
  Port (A,B : in STD_LOGIC_VECTOR(15 downto 0);
        Opcode : in STD_LOGIC_VECTOR(2 downto 0);    
        Mode : in std_logic;
        ALUout : out STD_LOGIC_VECTOR(15 downto 0);
        Cout : out std_logic    
             );
end component;

----------------------- CONTROLLER ---------------------------------
COMPONENT controller is
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
END COMPONENT;

----------------------- INSTRUCTION MEMORY ------------------------
component I_mem is
port (
	  reset : IN std_logic;
	  Address_reg     : IN STD_LOGIC_VECTOR(3 downto 0) := (others =>'0'); -- address for instruction memory
	  Instruction_in   : IN STD_LOGIC_VECTOR(23 downto 0); -- Input Instruction
      Clock      : IN std_logic := '0';
      We_DM   : IN std_logic :='0'; --write and read enable
      instruction_reg    : OUT STD_LOGIC_VECTOR(23 downto 0)); -- current instruction sent to instruction register
end component;
------------------------ INSTRUCTION REGISTER -----------------------
component InstReg24bit is
	Port( 
	    reset : IN STD_LOGIC; -- clear register values when 0
		Instr   : IN STD_LOGIC_VECTOR(23 downto 0); -- Input Instruction
		Load_IR: IN std_logic; -- Load the input when Load_IR='1' 
		Clock   : IN std_logic; 
		Opcode : OUT STD_LOGIC_VECTOR(7 downto 0) := (others => '0'); -- function code for alu
		RegOut: OUT STD_LOGIC_VECTOR (15 downto 0) := (others => '0')); -- address location to store value of register c in data memory
 end component;

------------------------ DATA MEMORY ---------------------------------
component DataMemory16Bits is 
	port (
	  reset: IN STD_LOGIC;
	  carry_in : in std_logic;  -- carry out from ALU
	  Address_DM     : IN STD_LOGIC_VECTOR(15 downto 0) := (others =>'0'); -- memory address of input
	  Data_In_DM : IN STD_LOGIC_VECTOR(15 downto 0) := (others =>'0');  -- data to be written or read
      Clock      : IN std_logic := '0';
      We_DM, Re_DM   : IN std_logic :='0'; --write and read enable
      Data_Out_DM    : OUT STD_LOGIC_VECTOR(16 downto 0):= (others =>'0')); -- data of last read from memory
      
end component;
------------------------ REGISTER A,B,C ----------------------------------
component register_16_bit is
    Port( A    : IN STD_LOGIC_VECTOR(15 downto 0) := (others => '0');  -- input
         Load  : IN std_logic;      -- input load at load =1
         Clock : IN std_logic;      
         Reset : IN std_logic;      -- reset register value
         RegOut: OUT STD_LOGIC_VECTOR (15 downto 0):= (others => '0'));
    
end component;

------------------------ PROGRAM COUNTER ----------------------------------
COMPONENT program_counter is
    Port(
    	Load  : IN STD_LOGIC:= '0';      -- input load at load =1
        clk : IN STD_LOGIC:= '0';      
        reset: IN STD_LOGIC:= '0';  
        RegOut: OUT STD_LOGIC_VECTOR (3 downto 0):= (others => '0'));
    
end COMPONENT;
------------------------ 2-1 MUX 4-BIT ----------------------------------
component MUX_4BIT_2_1 is
    Port ( a : in STD_LOGIC_VECTOR (3 downto 0); -- this will be low input for mux
           b : in STD_LOGIC_VECTOR (3 downto 0); -- this will be high input for mux
           y : out STD_LOGIC_VECTOR (3 downto 0);   -- ouput of mux dependent on sel
           sel: in STD_LOGIC);      -- input which will determine which input a or b will pass to output
end component;
-------------------------------------------------------------------------------------------------






 ----------------- INTERNAL SIGNALS ---------------------
 -- used to pass data between components
 --------------------------------------------------------
 
 
 
------------------- CONTROLLER --------------------------------------------
SIGNAL Load_pc: STD_LOGIC; -- signal to program counter input load pc
SIGNAL ALU_mode:STD_LOGIC; -- signal to ALU mode input
SIGNAL ALU_op_code : STD_LOGIC_VECTOR(2 downto 0); -- signal to ALU opcode
SIGNAL reg_load_A:STD_LOGIC;  -- signal to register A input
SIGNAL reg_load_B:STD_LOGIC;  -- signal to register B input
SIGNAL reg_load_C:STD_LOGIC;  -- signal to register C input 
SIGNAL we_dm: STD_LOGIC; -- signal to data memory write enable
SIGNAL re_dm: STD_LOGIC; -- signal to data memory read enable
SIGNAL sel_mux: STD_LOGIC; -- signal to 2-1 mux control signal
SIGNAL load_ir: STD_LOGIC; -- signal to instruction register to load enable
SIGNAL reset: STD_LOGIC; 
-------------------------------------------------------------------------
--                  REGISTERS A,B,C
--------------------------------------------------------------------------
SIGNAL reg_out_A: STD_LOGIC_VECTOR(15 downto 0); -- signal to ALU
SIGNAL reg_out_B: STD_LOGIC_VECTOR(15 downto 0);  -- signal to ALU
SIGNAL reg_out_C: STD_LOGIC_VECTOR(15 downto 0);  -- signal to CPU out and data memory
-------------------------------------------------------------------------
--                  INSTRUCTION REGISTER
--------------------------------------------------------------------------
SIGNAL control_op : STD_LOGIC_VECTOR(7 downto 0);  -- signal to controller opcode
SIGNAL I_reg_data : STD_LOGIC_VECTOR (15 downto 0);  --signal to registers a,b,c
-------------------------------------------------------------------------
--                  INSTRUCTION MEMORY
--------------------------------------------------------------------------
SIGNAL I_mem_data : STD_LOGIC_VECTOR (23 downto 0);  -- signal to instruction register
-------------------------------------------------------------------------
--                  PROGRAM COUNTER
--------------------------------------------------------------------------
SIGNAL pc_out : STD_LOGIC_VECTOR (3 downto 0); -- signal to 2-1 mux
-------------------------------------------------------------------------
--                  2-1 MUX
--------------------------------------------------------------------------
SIGNAL mux_out : STD_LOGIC_VECTOR (3 downto 0);  -- signal to instruction memory
-------------------------------------------------------------------------
--                  ALU
--------------------------------------------------------------------------

SIGNAL ALU_out : STD_LOGIC_VECTOR (15 downto 0);  -- signal to register c
SIGNAL C_out: STD_LOGIC; -- signal to data memory and carry out for cpu
-------------------------------------------------------------------------
--                  DATA MEMORY
--------------------------------------------------------------------------

 
begin

------------ CPU SIGNALS -------------------------
	  
	  CPU_out <= reg_out_C;
	  
	  Cout <= C_out;


-------------- component port mapping ----------------------------------

------------------------- ALU ------------------------------------------

ALU_COMPONENT : ALU PORT MAP (
        A => reg_out_A,
        B =>reg_out_B,
        Opcode =>ALU_op_code,
        Mode =>ALU_mode,
        ALUout =>ALU_out,
        Cout => C_out);    
            
----------------------- CONTROLLER ---------------------------------
CONTROLLER_COMPONENT: controller PORT MAP(
      
           clk => clock,
           opcode => control_op,
           enable => enable,
           sel =>sel_mux,
           WeDM =>we_dm,
           ReDM => re_dm,
           LoadA => reg_load_A,
           LoadB => reg_load_B,
           LoadC => reg_load_C,
           Load_IR => load_ir,
           ALU_mode => ALU_mode,
           ALU_opcode => ALU_op_code,
           Load_pc => Load_pc,
           reset => reset);


----------------------- INSTRUCTION MEMORY ------------------------
Instruction_memory_COMPONENT: I_mem PORT MAP (
            reset => reset,
            Address_reg => mux_out, 
	        Instruction_in => input_instruct,
            Clock => clock,
            We_DM => weIM,
            instruction_reg =>I_mem_data);
      
------------------------ INSTRUCTION REGISTER -----------------------
Instruction_COMPONENT: InstReg24bit 
	PORT MAP( 
	    reset => reset,
		Instr => I_mem_data,
		Load_IR => load_ir,
		Clock=> clock,
		Opcode=> control_op,
		RegOut=> I_reg_data);


------------------------ DATA MEMORY ---------------------------------
Data_memory_COMPONENT: DataMemory16Bits  
	PORT MAP (
	  reset => reset,
	  carry_in=> C_out,
	  Address_DM=> I_reg_data,
	  Data_In_DM=> reg_out_C,
      Clock=> clock,
      We_DM => we_dm,
      Re_DM=> re_dm,
      Data_Out_DM=> DM_out);
      

------------------------ REGISTER A,B,C ----------------------------------
Register_A_component: register_16_bit 
    PORT MAP ( 
         A => I_reg_data,
         Load => reg_load_A,
         Clock => clock,
         Reset => reset,
         RegOut => reg_out_A);
         
Register_B_component: register_16_bit 
    PORT MAP ( 
         A => I_reg_data,
         Load => reg_load_B,
         Clock => clock,
         Reset => reset,
         RegOut => reg_out_B);
 
Register_C_component: register_16_bit 
    PORT MAP ( 
         A => ALU_out,
         Load => reg_load_C,
         Clock => clock,
         Reset => reset,
         RegOut => reg_out_C);    

------------------------ PROGRAM COUNTER ----------------------------------
Program_counter_COMPONENT: program_counter 
    PORT MAP ( 
         Load => Load_pc,
         clk => clock,    
         RegOut => pc_out,
         reset =>reset);
    
------------------------ 2-1 MUX 4-BIT ----------------------------------
Mux_COMPONENT: MUX_4BIT_2_1 
    PORT MAP(
           a => instruct_address,
           b => pc_out,
           y => mux_out,
           sel => sel_mux);
-------------------------------------------------------------------------------------------------







end Structural;
