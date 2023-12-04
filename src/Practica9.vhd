LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.STD_LOGIC_ARITH.all;

ENTITY Practica9 IS			
	PORT(
		CLK 		: IN STD_LOGIC;
		RST 		: IN STD_LOGIC;
		H			: in std_logic;
		
		B_R1         : in std_logic;
		B_L1         : in std_logic;
		B_U1         : in std_logic;
		B_D1         : in std_logic;
		
		B_R2         : in std_logic;
		B_L2         : in std_logic;
		B_U2         : in std_logic;
		B_D2         : in std_logic;
		
		vga_r 		: OUT STD_LOGIC :='0';
		vga_g 		: OUT STD_LOGIC :='0';
		vga_b 		: OUT STD_LOGIC :='0';
		vga_vs		: OUT STD_LOGIC :='0';
		
		RST_SCREENS : IN STD_LOGIC;
		vga_hs		: OUT STD_LOGIC :='0');
END ENTITY Practica9;

ARCHITECTURE simple OF Practica9 IS
SIGNAL vga_clk  : STD_LOGIC:= '0';
SIGNAL disp_ena	: STD_LOGIC:= '0';
SIGNAL column   : INTEGER:= 0;
SIGNAL row 		: INTEGER:= 0;
signal BdT_GC : std_logic;

signal OUT_R1 : std_logic;
signal OUT_L1 : std_logic;
signal OUT_U1 : std_logic;
signal OUT_D1 : std_logic;

signal OUT_R2 : std_logic;
signal OUT_L2 : std_logic;
signal OUT_U2 : std_logic;
signal OUT_D2 : std_logic;

--signal H_BDT_SCREENS : std_logic;
signal FREEZE_MOVEMENT : std_logic;
signal FREEZE_MOVEMENT_2 : std_logic;

BEGIN				

	c1 : ENTITY WORK.BdT_VGA PORT MAP(clk, vga_clk); 
	--c2 : entity work.BdT_GC generic map(50000000,26) port map (CLK, RST, H, BdT_GC);
	--c2 : entity work.BdT_GC generic map(833334,20) port map (CLK, RST, H, BdT_GC);
	c2 : entity work.BdT_GC generic map(12500000,24) port map (CLK, RST, H, BdT_GC);
	c3 : ENTITY WORK.VGA_Controller PORT MAP (vga_clk, RST, vga_hs, vga_vs, disp_ena, column, row);
	--c4 : ENTITY WORK.P_Margen PORT MAP (disp_ena, row, column,RST, BdT_GC, vga_r, vga_g, vga_b);
	c4 : ENTITY WORK.P_Margen PORT MAP (disp_ena, row, column,RST, BdT_GC, OUT_R1, OUT_L1, OUT_U1, OUT_D1, vga_r, vga_g, vga_b, FREEZE_MOVEMENT, RST_SCREENS, OUT_R2, OUT_L2, OUT_U2, OUT_D2, FREEZE_MOVEMENT_2);
	c5 : entity work.Estados_Botones port map (CLK, RST, B_R1, B_L1, B_U1, B_D1, OUT_R1, OUT_L1, OUT_U1, OUT_D1, FREEZE_MOVEMENT);
	c6 : entity work.Estados_Botones_2 port map (CLK, RST, B_R2, B_L2, B_U2, B_D2, OUT_R2, OUT_L2, OUT_U2, OUT_D2, FREEZE_MOVEMENT_2);
	--c6 : entity work.BdT_Screens generic map (50000000,26) port map (CLK, RST, H_BDT_SCREENS, RST_SCREENS);
	--c5 : ENTITY WORK.T_Cuadrado PORT MAP (disp_ena, row, column,RST, BdT_GC, B_R, vga_r, vga_g, vga_b);
		
END ARCHITECTURE simple;