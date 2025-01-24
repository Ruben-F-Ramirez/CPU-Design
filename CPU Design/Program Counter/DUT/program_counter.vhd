----------------------------------------------------------------------------------
-- Ruben Ramirez
-- 2694
--                      PROGRAM COUNTER
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

entity program_counter is
  Port (
  
		Load  : IN STD_LOGIC:= '0';      -- input load at load =1
        clk : IN STD_LOGIC:= '0';      
        reset: IN STD_LOGIC:= '0';  
        RegOut: OUT STD_LOGIC_VECTOR (3 downto 0):= (others => '0'));
		
		
end program_counter;

architecture Behavioral of program_counter is


signal counter: integer;
SIGNAL temp_reg: Unsigned(3 DOWNTO 0);


begin


        
PROGRAM_COUNTER : process (clk,reset)
begin
    if (reset = '0') then
        temp_reg <= x"0";
        counter <= 0;
    elsif rising_edge(clk) then
        IF Load = '1' THEN
        
            if counter = 0 then    
                
                counter<=1;
                temp_reg <= temp_reg + 1;
            elsif counter = 1 then
                temp_reg <= temp_reg + 1;
            end if;
         END IF;
    end if;
   
end process;
        



RegOut <=STD_LOGIC_VECTOR(temp_reg);

end Behavioral;
