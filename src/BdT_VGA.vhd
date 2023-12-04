LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY BdT_VGA IS		
	 PORT(
		 clk 	 : IN std_logic;
		 vga_clk : INOUT std_logic:='0');
END BdT_VGA;

ARCHITECTURE behavior OF BdT_VGA IS
BEGIN				
	PROCESS(clk, vga_clk) IS
	BEGIN		   
		IF clk'EVENT AND clk = '1' THEN
			vga_clk <= not vga_clk; 
		END IF;
	END PROCESS;	
END behavior;