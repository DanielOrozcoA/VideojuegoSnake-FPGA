LIBRARY ieee;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.STD_LOGIC_ARITH.all;

ENTITY P_Margen IS
  GENERIC(
    pixels_y1 :  INTEGER := 15;   --row that first color will persist until
    pixels_x1 :  INTEGER := 640;  --column that first color will persist until
	pixels_y2 :  INTEGER := 465;
	pixels_x2 :  INTEGER := 0;
	pixels_y3 :  INTEGER := 480;
	pixels_x3 :  INTEGER := 15
	);
  PORT(
    disp_ena :  IN   STD_LOGIC;  --display enable ('1' = display time, '0' = blanking time)
    row      :  IN   INTEGER;    --row pixel coordinate
    column   :  IN   INTEGER;    --column pixel coordinate
	RST		 :  IN std_logic;
	BT_GC    :  IN std_logic;
	B_R1      :  in std_logic;
	B_L1      :  in std_logic;
	B_U1      :  in std_logic;
	B_D1      :  in std_logic;
	red      :  out std_logic;
	green    :  out std_logic;
	blue     :  out std_logic;
	FREEZE_MOVEMENT : out std_logic;
	RST_SCREENS : in std_logic;
	B_R2      :  in std_logic;
	B_L2      :  in std_logic;
	B_U2      :  in std_logic;
	B_D2      :  in std_logic;
	FREEZE_MOVEMENT_2 : out std_logic
	);
END P_Margen;

ARCHITECTURE behavior OF P_Margen IS

signal Qp, Qn : std_logic_vector(3 downto 0) := (others => '0');
signal flag_v1 : std_logic := '0';
signal flag_v2 : std_logic := '0';
signal flag_tie : std_logic := '0';

--------------------- SERPIENTE 1 ---------------------

-- CABEZA - SERPIENTE 1
signal sq1_y1 : integer range 0 to 480 := 100;
signal sq1_x1 : integer range 0 to 640 := 100;
signal sq1_y2 : integer range 0 to 480 := 120;
signal sq1_x2 : integer range 0 to 640 := 120;
-- CUERPO 1 - SERPIENTE 1
signal sq2_y1 : integer range 0 to 480 := 100;
signal sq2_x1 : integer range 0 to 640 := 80;
signal sq2_y2 : integer range 0 to 480 := 120;
signal sq2_x2 : integer range 0 to 640 := 100;
-- CUERPO 2 - SERPIENTE 1
signal sq3_y1 : integer range 0 to 480 := 100;
signal sq3_x1 : integer range 0 to 640 := 60;
signal sq3_y2 : integer range 0 to 480 := 120;
signal sq3_x2 : integer range 0 to 640 := 80;
-- CUERPO 2 - SERPIENTE 1
signal sq4_y1 : integer range 0 to 480 := 100;
signal sq4_x1 : integer range 0 to 640 := 40;
signal sq4_y2 : integer range 0 to 480 := 120;
signal sq4_x2 : integer range 0 to 640 := 60;
-- COLA - SERPIENTE 1
signal sq5_y1 : integer range 0 to 480 := 100;
signal sq5_x1 : integer range 0 to 640 := 20;
signal sq5_y2 : integer range 0 to 480 := 120;
signal sq5_x2 : integer range 0 to 640 := 40;


-- POSICIONES FUTURAS - SERPIENTE 1

-- CABEZA - FUTURO - SERPIENTE 1
signal sqf1_y1 : integer range 0 to 480 := 100;
signal sqf1_x1 : integer range 0 to 640 := 100;
signal sqf1_y2 : integer range 0 to 480 := 120;
signal sqf1_x2 : integer range 0 to 640 := 120;
-- CUERPO 1 - FUTURO - SERPIENTE 1
signal sqf2_y1 : integer range 0 to 480 := 100;
signal sqf2_x1 : integer range 0 to 640 := 80;
signal sqf2_y2 : integer range 0 to 480 := 120;
signal sqf2_x2 : integer range 0 to 640 := 100;
-- CUERPO 2 - FUTURO - SERPIENTE 1
signal sqf3_y1 : integer range 0 to 480 := 100;
signal sqf3_x1 : integer range 0 to 640 := 60;
signal sqf3_y2 : integer range 0 to 480 := 120;
signal sqf3_x2 : integer range 0 to 640 := 80;
-- CUERPO 2 - FUTURO - SERPIENTE 1
signal sqf4_y1 : integer range 0 to 480 := 100;
signal sqf4_x1 : integer range 0 to 640 := 40;
signal sqf4_y2 : integer range 0 to 480 := 120;
signal sqf4_x2 : integer range 0 to 640 := 60;
-- COLA - FUTURO - SERPIENTE 1
signal sqf5_y1 : integer range 0 to 480 := 100;
signal sqf5_x1 : integer range 0 to 640 := 20;
signal sqf5_y2 : integer range 0 to 480 := 120;
signal sqf5_x2 : integer range 0 to 640 := 40;



--------------------- SERPIENTE 2 ---------------------

-- CABEZA - SERPIENTE 2
signal sq1_2_y1 : integer range 0 to 480 := 300;
signal sq1_2_x1 : integer range 0 to 640 := 520;
signal sq1_2_y2 : integer range 0 to 480 := 320;
signal sq1_2_x2 : integer range 0 to 640 := 540;
-- CUERPO 1 - SERPIENTE 2
signal sq2_2_y1 : integer range 0 to 480 := 300;
signal sq2_2_x1 : integer range 0 to 640 := 540;
signal sq2_2_y2 : integer range 0 to 480 := 320;
signal sq2_2_x2 : integer range 0 to 640 := 560;
-- CUERPO 2 - SERPIENTE 2
signal sq3_2_y1 : integer range 0 to 480 := 300;
signal sq3_2_x1 : integer range 0 to 640 := 560;
signal sq3_2_y2 : integer range 0 to 480 := 320;
signal sq3_2_x2 : integer range 0 to 640 := 580;
-- CUERPO 2 - SERPIENTE 2
signal sq4_2_y1 : integer range 0 to 480 := 300;
signal sq4_2_x1 : integer range 0 to 640 := 580;
signal sq4_2_y2 : integer range 0 to 480 := 320;
signal sq4_2_x2 : integer range 0 to 640 := 600;
-- COLA - SERPIENTE 2
signal sq5_2_y1 : integer range 0 to 480 := 300;
signal sq5_2_x1 : integer range 0 to 640 := 600;
signal sq5_2_y2 : integer range 0 to 480 := 32;
signal sq5_2_x2 : integer range 0 to 640 := 620;


-- POSICIONES FUTURAS - SERPIENTE 2

-- CABEZA - FUTURO - SERPIENTE 2
signal sqf1_2_y1 : integer range 0 to 480 := 300;
signal sqf1_2_x1 : integer range 0 to 640 := 520;
signal sqf1_2_y2 : integer range 0 to 480 := 320;
signal sqf1_2_x2 : integer range 0 to 640 := 540;
-- CUERPO 1 - FUTURO - SERPIENTE 2
signal sqf2_2_y1 : integer range 0 to 480 := 300;
signal sqf2_2_x1 : integer range 0 to 640 := 540;
signal sqf2_2_y2 : integer range 0 to 480 := 320;
signal sqf2_2_x2 : integer range 0 to 640 := 560;
-- CUERPO 2 - FUTURO - SERPIENTE 2
signal sqf3_2_y1 : integer range 0 to 480 := 300;
signal sqf3_2_x1 : integer range 0 to 640 := 560;
signal sqf3_2_y2 : integer range 0 to 480 := 320;
signal sqf3_2_x2 : integer range 0 to 640 := 580;
-- CUERPO 2 - FUTURO - SERPIENTE 2
signal sqf4_2_y1 : integer range 0 to 480 := 300;
signal sqf4_2_x1 : integer range 0 to 640 := 580;
signal sqf4_2_y2 : integer range 0 to 480 := 320;
signal sqf4_2_x2 : integer range 0 to 640 := 600;
-- COLA - FUTURO - SERPIENTE 2
signal sqf5_2_y1 : integer range 0 to 480 := 300;
signal sqf5_2_x1 : integer range 0 to 640 := 600;
signal sqf5_2_y2 : integer range 0 to 480 := 320;
signal sqf5_2_x2 : integer range 0 to 640 := 620;


BEGIN
  PROCESS(disp_ena, row, column, flag_v1, flag_v2, flag_tie)
  BEGIN
	----------------- SERPIENTE 1 -----------------
	sq1_x1 <= sqf1_x1;
	sq1_y1 <= sqf1_y1;
	sq1_x2 <= sqf1_x2;
	sq1_y2 <= sqf1_y2;
	
	sq2_x1 <= sqf2_x1;
	sq2_y1 <= sqf2_y1;
	sq2_x2 <= sqf2_x2;
	sq2_y2 <= sqf2_y2;
	
	sq3_x1 <= sqf3_x1;
	sq3_y1 <= sqf3_y1;
	sq3_x2 <= sqf3_x2;
	sq3_y2 <= sqf3_y2;
	
	sq4_x1 <= sqf4_x1;
	sq4_y1 <= sqf4_y1;
	sq4_x2 <= sqf4_x2;
	sq4_y2 <= sqf4_y2;
	
	sq5_x1 <= sqf5_x1;
	sq5_y1 <= sqf5_y1;
	sq5_x2 <= sqf5_x2;
	sq5_y2 <= sqf5_y2;
	
	
	
	----------------- SERPIENTE 2 -----------------
	sq1_2_x1 <= sqf1_2_x1;
	sq1_2_y1 <= sqf1_2_y1;
	sq1_2_x2 <= sqf1_2_x2;
	sq1_2_y2 <= sqf1_2_y2;
	
	sq2_2_x1 <= sqf2_2_x1;
	sq2_2_y1 <= sqf2_2_y1;
	sq2_2_x2 <= sqf2_2_x2;
	sq2_2_y2 <= sqf2_2_y2;
	
	sq3_2_x1 <= sqf3_2_x1;
	sq3_2_y1 <= sqf3_2_y1;
	sq3_2_x2 <= sqf3_2_x2;
	sq3_2_y2 <= sqf3_2_y2;
	
	sq4_2_x1 <= sqf4_2_x1;
	sq4_2_y1 <= sqf4_2_y1;
	sq4_2_x2 <= sqf4_2_x2;
	sq4_2_y2 <= sqf4_2_y2;
	
	sq5_2_x1 <= sqf5_2_x1;
	sq5_2_y1 <= sqf5_2_y1;
	sq5_2_x2 <= sqf5_2_x2;
	sq5_2_y2 <= sqf5_2_y2;
	
	  --
   	  IF(disp_ena = '1') THEN        --display time
		--
		-- PANTALLA MARGEN
	    IF(row <= 15 AND column <= 640 and flag_v1 = '0' and flag_v2 = '0' and flag_tie = '0') THEN
	      red <= '1';
	      green  <= '0';
	      blue <= '0';
        ELSIF(row >= 465 AND column >= 0 and flag_v1 = '0' and flag_v2 = '0' and flag_tie = '0') then
          red <= '1';
          green  <= '0';
          blue <= '0';
		ELSIF(row <= 480 AND column <= 15 and flag_v1 = '0' and flag_v2 = '0' and flag_tie = '0') then
		  red <= '1';
		  green <= '0';
		  blue <= '0';
		ELSIF(row <= 480 AND column >= 625 and flag_v1 = '0' and flag_v2 = '0' and flag_tie = '0') then
		  red <= '1';
		  green <= '0';
		  blue <= '0';

        ELSIF(row >= 15 AND row <= 20  AND column >=15 AND column <= 625 and flag_v1 = '0' and flag_v2 = '0' and flag_tie = '0') THEN
          red <= '1';
          green  <= '1';
          blue <= '1';
        ELSIF(row >= 460 AND row <= 465  AND column >=15 AND column <= 625 and flag_v1 = '0' and flag_v2 = '0' and flag_tie = '0') then
          red <= '1';
          green  <= '1';
          blue <= '1';
		ELSIF(row >= 15 AND row <= 465 AND column >= 15 AND column <= 20 and flag_v1 = '0' and flag_v2 = '0' and flag_tie = '0') then
		  red <= '1';
		  green <= '1';
		  blue <= '1';
		ELSIF(row >= 15 AND row <= 465 AND column >= 620 AND column <= 625 and flag_v1 = '0' and flag_v2 = '0' and flag_tie = '0') then
		  red <= '1';
		  green <= '1';
		  blue <= '1';
		  
		---------------------------------------------- SERPIENTE 1 --------------------------------------------  
		
		-- IMPRESION CABEZA
		ELSIF(row >= sq1_y1 and row <= sq1_y2 and column >= sq1_x1 and column <= sq1_x2 and flag_v1 = '0' and flag_v2 = '0' and flag_tie = '0') then
			red <= '0';
			green <= '1';
			blue <= '0';
		-- IMPRESION CUADRADO 2
		ELSIF(row >= sq2_y1 and row <= sq2_y2 and column >= sq2_x1 and column <= sq2_x2 and flag_v1 = '0' and flag_v2 = '0' and flag_tie = '0') then
			red <= '0';
			green <= '1';
			blue <= '0';
		-- IMPRESION CUADRADO 3
		ELSIF(row >= sq3_y1 and row <= sq3_y2 and column >= sq3_x1 and column <= sq3_x2 and flag_v1 = '0' and flag_v2 = '0' and flag_tie = '0') then
			red <= '0';
			green <= '1';
			blue <= '0';
		-- IMPRESION CUADRADO 4
		ELSIF(row >= sq4_y1 and row <= sq4_y2 and column >= sq4_x1 and column <= sq4_x2 and flag_v1 = '0' and flag_v2 = '0' and flag_tie = '0') then
			red <= '0';
			green <= '1';
			blue <= '0'; 
		ELSIF(row >= sq5_y1 and row <= sq5_y2 and column >= sq5_x1 and column <= sq5_x2 and flag_v1 = '0' and flag_v2 = '0' and flag_tie = '0') then
			red <= '0';
			green <= '1';
			blue <= '0';


			
		---------------------------------------------- SERPIENTE 2 --------------------------------------------  
		
		-- IMPRESION CABEZA
		ELSIF(row >= sq1_2_y1 and row <= sq1_2_y2 and column >= sq1_2_x1 and column <= sq1_2_x2 and flag_v1 = '0' and flag_v2 = '0' and flag_tie = '0') then
			red <= '0';
			green <= '1';
			blue <= '1';
		-- IMPRESION CUADRADO 2
		ELSIF(row >= sq2_2_y1 and row <= sq2_2_y2 and column >= sq2_2_x1 and column <= sq2_2_x2 and flag_v1 = '0' and flag_v2 = '0' and flag_tie = '0') then
			red <= '0';
			green <= '1';
			blue <= '1';
		-- IMPRESION CUADRADO 3
		ELSIF(row >= sq3_2_y1 and row <= sq3_2_y2 and column >= sq3_2_x1 and column <= sq3_2_x2 and flag_v1 = '0' and flag_v2 = '0' and flag_tie = '0') then
			red <= '0';
			green <= '1';
			blue <= '1';
		-- IMPRESION CUADRADO 4
		ELSIF(row >= sq4_2_y1 and row <= sq4_2_y2 and column >= sq4_2_x1 and column <= sq4_2_x2 and flag_v1 = '0' and flag_v2 = '0' and flag_tie = '0') then
			red <= '0';
			green <= '1';
			blue <= '1'; 
		ELSIF(row >= sq5_2_y1 and row <= sq5_2_y2 and column >= sq5_2_x1 and column <= sq5_2_x2 and flag_v1 = '0' and flag_v2 = '0' and flag_tie = '0') then
			red <= '0';
			green <= '1';
			blue <= '1';
			
			
			
			
			
		-- IMPRESIï¿½N VICTORIA JUGADOR 2
		-- P
		ELSIF(row >= 144 AND row <= 336 AND column >= 160 AND column <= 180 and flag_v1 = '0' and flag_v2 = '1' and flag_tie = '0') then
		  red <= '0';
		  green <= '1';
		  blue <= '0';
		ELSIF(row >= 144 AND row <= 176 AND column >= 180 AND column <= 240 and flag_v1 = '0' and flag_v2 = '1' and flag_tie = '0') then
		  red <= '0';
		  green <= '1';
		  blue <= '0';
		ELSIF(row >= 208 AND row <= 240 AND column >= 180 AND column <= 240 and flag_v1 = '0' and flag_v2 = '1' and flag_tie = '0') then
		  red <= '0';
		  green <= '1';
		  blue <= '0';
		--2
		ELSIF(row >= 144 AND row <= 176 AND column >= 260 AND column <= 320 and flag_v1 = '0' and flag_v2 = '1' and flag_tie = '0') then
		  red <= '0';
		  green <= '1';
		  blue <= '0';
		ELSIF(row >= 176 AND row <= 240 AND column >= 300 AND column <= 320 and flag_v1 = '0' and flag_v2 = '1' and flag_tie = '0') then
		  red <= '0';
		  green <= '1';
		  blue <= '0';
		ELSIF(row >= 240 AND row <= 272 AND column >= 260 AND column <= 320 and flag_v1 = '0' and flag_v2 = '1' and flag_tie = '0') then
		  red <= '0';
		  green <= '1';
		  blue <= '0';
		ELSIF(row >= 272 AND row <= 304 AND column >= 260 AND column <= 280 and flag_v1 = '0' and flag_v2 = '1' and flag_tie = '0') then
		  red <= '0';
		  green <= '1';
		  blue <= '0';
		ELSIF(row >= 304 AND row <= 336 AND column >= 260 AND column <= 320 and flag_v1 = '0' and flag_v2 = '1' and flag_tie = '0') then
		  red <= '0';
		  green <= '1';
		  blue <= '0'; 
		ELSIF(row >= 176 AND row <= 208 AND column >= 220 AND column <= 240 and flag_v1 = '0' and flag_v2 = '1' and flag_tie = '0') then
		  red <= '0';
		  green <= '1';
		  blue <= '0'; 
		--W
		ELSIF(row >= 144 AND row <= 304 AND column >= 380 AND column <= 400 and flag_v1 = '0' and flag_v2 = '1' and flag_tie = '0') then
		  red <= '0';
		  green <= '1';
		  blue <= '0';
		ELSIF(row >= 144 AND row <= 304 AND column >= 420 AND column <= 440 and flag_v1 = '0' and flag_v2 = '1' and flag_tie = '0') then
		  red <= '0';
		  green <= '1';
		  blue <= '0';
		ELSIF(row >= 144 AND row <= 304 AND column >= 460 AND column <= 480 and flag_v1 = '0' and flag_v2 = '1' and flag_tie = '0') then
		  red <= '0';
		  green <= '1';
		  blue <= '0';
		ELSIF(row >= 304 AND row <= 336 AND column >= 380 AND column <= 480 and flag_v1 = '0' and flag_v2 = '1' and flag_tie = '0') then
		  red <= '0';
		  green <= '1';
		  blue <= '0';
		  
		  
		  
		-------------------------- IMPRESIÓN VICTORIA JUGADOR 1 ----------------------
		-- P
		ELSIF(row >= 144 AND row <= 336 AND column >= 160 AND column <= 180 and flag_v1 = '1' and flag_v2 = '0' and flag_tie = '0') then
		  red <= '0';
		  green <= '1';
		  blue <= '0';
		ELSIF(row >= 144 AND row <= 176 AND column >= 180 AND column <= 240 and flag_v1 = '1' and flag_v2 = '0' and flag_tie = '0') then
		  red <= '0';
		  green <= '1';
		  blue <= '0';
		ELSIF(row >= 208 AND row <= 240 AND column >= 180 AND column <= 240 and flag_v1 = '1' and flag_v2 = '0' and flag_tie = '0') then
		  red <= '0';
		  green <= '1';
		  blue <= '0';
		ELSIF(row >= 176 AND row <= 208 AND column >= 220 AND column <= 240 and flag_v1 = '1' and flag_v2 = '0' and flag_tie = '0') then
		  red <= '0';
		  green <= '1';
		  blue <= '0';
		--1
		ELSIF(row >= 144 AND row <= 176 AND column >= 260 AND column <= 300 and flag_v1 = '1' and flag_v2 = '0' and flag_tie = '0') then
		  red <= '0';
		  green <= '1';
		  blue <= '0';
		ELSIF(row >= 176 AND row <= 304 AND column >= 280 AND column <= 300 and flag_v1 = '1' and flag_v2 = '0' and flag_tie = '0') then
		  red <= '0';
		  green <= '1';
		  blue <= '0';
		ELSIF(row >= 304 AND row <= 336 AND column >= 260 AND column <= 320 and flag_v1 = '1' and flag_v2 = '0' and flag_tie = '0') then
		  red <= '0';
		  green <= '1';
		  blue <= '0';
		--W
		ELSIF(row >= 144 AND row <= 304 AND column >= 380 AND column <= 400 and flag_v1 = '1' and flag_v2 = '0' and flag_tie = '0') then
		  red <= '0';
		  green <= '1';
		  blue <= '0';
		ELSIF(row >= 144 AND row <= 304 AND column >= 420 AND column <= 440 and flag_v1 = '1' and flag_v2 = '0' and flag_tie = '0') then
		  red <= '0';
		  green <= '1';
		  blue <= '0';
		ELSIF(row >= 144 AND row <= 304 AND column >= 460 AND column <= 480 and flag_v1 = '1' and flag_v2 = '0' and flag_tie = '0') then
		  red <= '0';
		  green <= '1';
		  blue <= '0';
		ELSIF(row >= 304 AND row <= 336 AND column >= 380 AND column <= 480 and flag_v1 = '1' and flag_v2 = '0' and flag_tie = '0') then
		  red <= '0';
		  green <= '1';
		  blue <= '0';


			
		-- COLOREO ZONAS SIN OBJETOS
	    ELSE
          red <= '0';
          green  <= '0';
          blue <= '1';
      END IF;
      
    ELSE                           --blanking time
        red <= '0';
        green  <= '0';
        blue <= '0';
    END IF;
  
  END PROCESS;
  
UPDATE_COORD_SQ1: process (BT_GC, B_R1, B_L1, B_U1, B_D1, sqf1_x1, sqf1_x2, sqf1_y1, sqf1_y2, RST_SCREENS, flag_v1) is
	begin
		if(BT_GC'event and BT_GC = '1') then
		
			if(RST_SCREENS = '0') then
				--flag_v1 <= '0';
				flag_v2 <= '0';
				--flag_tie <= '0';
				FREEZE_MOVEMENT <= '0';
			
			elsif(flag_v1 = '1') then
				--
				sqf1_x1 <= 100;
				sqf1_x2 <= 120;
				sqf1_y1 <= 100;
				sqf1_y2 <= 120;
		
				sqf2_x1 <= 80;
				sqf2_x2 <= 100;
				sqf2_y1 <= 100;
				sqf2_y2 <= 120;
				
				sqf3_x1 <= 60;
				sqf3_x2 <= 80;
				sqf3_y1 <= 100;
				sqf3_y2 <= 120;
				
				sqf4_x1 <= 40;
				sqf4_x2 <= 60;
				sqf4_y1 <= 100;
				sqf4_y2 <= 120;
				
				sqf5_x1 <= 20;
				sqf5_x2 <= 40;
				sqf5_y1 <= 100;
				sqf5_y2 <= 120;
					
				FREEZE_MOVEMENT <= '1';
		
			elsif(B_R1 = '1') then
				sqf1_x1 <= sq1_x1 + 20;
				sqf1_x2 <= sq1_x2 + 20;
				
				sqf2_x1 <= sq1_x1;
				sqf2_x2 <= sq1_x2;
				sqf2_y1 <= sq1_y1;
				sqf2_y2 <= sq1_y2;
				
				sqf3_x1 <= sq2_x1;
				sqf3_x2 <= sq2_x2;
				sqf3_y1 <= sq2_y1;
				sqf3_y2 <= sq2_y2;
				
				sqf4_x1 <= sq3_x1;
				sqf4_x2 <= sq3_x2;
				sqf4_y1 <= sq3_y1;
				sqf4_y2 <= sq3_y2;
				
				sqf5_x1 <= sq4_x1;
				sqf5_x2 <= sq4_x2;
				sqf5_y1 <= sq4_y1;
				sqf5_y2 <= sq4_y2;
				
				-- CONDICIï¿½N DE COLISIï¿½N CON MARGEN DERECHO
				if(sqf1_x2 >= 620) then
				--
					sqf1_x1 <= 100;
					sqf1_x2 <= 120;
					sqf1_y1 <= 100;
					sqf1_y2 <= 120;
		
					sqf2_x1 <= 80;
					sqf2_x2 <= 100;
					sqf2_y1 <= 100;
					sqf2_y2 <= 120;
				
					sqf3_x1 <= 60;
					sqf3_x2 <= 80;
					sqf3_y1 <= 100;
					sqf3_y2 <= 120;
				
					sqf4_x1 <= 40;
					sqf4_x2 <= 60;
					sqf4_y1 <= 100;
					sqf4_y2 <= 120;
				
					sqf5_x1 <= 20;
					sqf5_x2 <= 40;
					sqf5_y1 <= 100;
					sqf5_y2 <= 120;
					
					flag_v2 <= '1';
					FREEZE_MOVEMENT <= '1';
					--H_BDT_SCREENS
				-- CONDICIï¿½N PARA COLISIï¿½N CONSIGO MISMA
				elsif(sqf1_x1 = sqf5_x1 and sqf1_x2 = sqf5_x2 and sqf1_y1 = sqf5_y1 and sqf1_y2 = sqf5_y2) then
					sqf1_x1 <= 100;
					sqf1_x2 <= 120;
					sqf1_y1 <= 100;
					sqf1_y2 <= 120;
		
					sqf2_x1 <= 80;
					sqf2_x2 <= 100;
					sqf2_y1 <= 100;
					sqf2_y2 <= 120;
				
					sqf3_x1 <= 60;
					sqf3_x2 <= 80;
					sqf3_y1 <= 100;
					sqf3_y2 <= 120;
				
					sqf4_x1 <= 40;
					sqf4_x2 <= 60;
					sqf4_y1 <= 100;
					sqf4_y2 <= 120;
				
					sqf5_x1 <= 20;
					sqf5_x2 <= 40;
					sqf5_y1 <= 100;
					sqf5_y2 <= 120;
					
					flag_v2 <= '1';
					FREEZE_MOVEMENT <= '1';
				end if;
				--
				
			elsif(B_L1 = '1') then
				sqf1_x1 <= sq1_x1 - 20;
				sqf1_x2 <= sq1_x2 - 20;
				
				sqf2_x1 <= sq1_x1;
				sqf2_x2 <= sq1_x2;
				sqf2_y1 <= sq1_y1;
				sqf2_y2 <= sq1_y2;
				
				sqf3_x1 <= sq2_x1;
				sqf3_x2 <= sq2_x2;
				sqf3_y1 <= sq2_y1;
				sqf3_y2 <= sq2_y2;
				
				sqf4_x1 <= sq3_x1;
				sqf4_x2 <= sq3_x2;
				sqf4_y1 <= sq3_y1;
				sqf4_y2 <= sq3_y2;
				
				sqf5_x1 <= sq4_x1;
				sqf5_x2 <= sq4_x2;
				sqf5_y1 <= sq4_y1;
				sqf5_y2 <= sq4_y2;
				
				-- CONDICIï¿½N DE COLISIï¿½N CON MARGEN IZQUIERDO
				if(sqf1_x1 <= 20) then
				--
					sqf1_x1 <= 100;
					sqf1_x2 <= 120;
					sqf1_y1 <= 100;
					sqf1_y2 <= 120;
		
					sqf2_x1 <= 80;
					sqf2_x2 <= 100;
					sqf2_y1 <= 100;
					sqf2_y2 <= 120;
				
					sqf3_x1 <= 60;
					sqf3_x2 <= 80;
					sqf3_y1 <= 100;
					sqf3_y2 <= 120;
				
					sqf4_x1 <= 40;
					sqf4_x2 <= 60;
					sqf4_y1 <= 100;
					sqf4_y2 <= 120;
				
					sqf5_x1 <= 20;
					sqf5_x2 <= 40;
					sqf5_y1 <= 100;
					sqf5_y2 <= 120;
					
					flag_v2 <= '1';
					FREEZE_MOVEMENT <= '1';
					
				-- CONDICIï¿½N PARA COLISIï¿½N CONSIGO MISMA
				elsif(sqf1_x1 = sqf5_x1 and sqf1_x2 = sqf5_x2 and sqf1_y1 = sqf5_y1 and sqf1_y2 = sqf5_y2) then
					sqf1_x1 <= 100;
					sqf1_x2 <= 120;
					sqf1_y1 <= 100;
					sqf1_y2 <= 120;
		
					sqf2_x1 <= 80;
					sqf2_x2 <= 100;
					sqf2_y1 <= 100;
					sqf2_y2 <= 120;
				
					sqf3_x1 <= 60;
					sqf3_x2 <= 80;
					sqf3_y1 <= 100;
					sqf3_y2 <= 120;
				
					sqf4_x1 <= 40;
					sqf4_x2 <= 60;
					sqf4_y1 <= 100;
					sqf4_y2 <= 120;
				
					sqf5_x1 <= 20;
					sqf5_x2 <= 40;
					sqf5_y1 <= 100;
					sqf5_y2 <= 120;
					
					flag_v2 <= '1';
					FREEZE_MOVEMENT <= '1';
					
				end if;
				
			elsif(B_U1 = '1') then
				sqf1_y1 <= sq1_y1 - 20;
				sqf1_y2 <= sq1_y2 - 20;
				
				sqf2_x1 <= sq1_x1;
				sqf2_x2 <= sq1_x2;
				sqf2_y1 <= sq1_y1;
				sqf2_y2 <= sq1_y2;
				
				sqf3_x1 <= sq2_x1;
				sqf3_x2 <= sq2_x2;
				sqf3_y1 <= sq2_y1;
				sqf3_y2 <= sq2_y2;
	
				sqf4_x1 <= sq3_x1;
				sqf4_x2 <= sq3_x2;
				sqf4_y1 <= sq3_y1;
				sqf4_y2 <= sq3_y2;
				
				sqf5_x1 <= sq4_x1;
				sqf5_x2 <= sq4_x2;
				sqf5_y1 <= sq4_y1;
				sqf5_y2 <= sq4_y2;
				
				-- CONDICIï¿½N DE COLISIï¿½N CON MARGEN SUPERIOR
				if(sqf1_y1 <= 20) then
				--
					sqf1_x1 <= 100;
					sqf1_x2 <= 120;
					sqf1_y1 <= 100;
					sqf1_y2 <= 120;
		
					sqf2_x1 <= 80;
					sqf2_x2 <= 100;
					sqf2_y1 <= 100;
					sqf2_y2 <= 120;
				
					sqf3_x1 <= 60;
					sqf3_x2 <= 80;
					sqf3_y1 <= 100;
					sqf3_y2 <= 120;
				
					sqf4_x1 <= 40;
					sqf4_x2 <= 60;
					sqf4_y1 <= 100;
					sqf4_y2 <= 120;
				
					sqf5_x1 <= 20;
					sqf5_x2 <= 40;
					sqf5_y1 <= 100;
					sqf5_y2 <= 120;
					
					flag_v2 <= '1';
					FREEZE_MOVEMENT <= '1';
					
				-- CONDICIï¿½N PARA COLISIï¿½N CONSIGO MISMA
				elsif(sqf1_x1 = sqf5_x1 and sqf1_x2 = sqf5_x2 and sqf1_y1 = sqf5_y1 and sqf1_y2 = sqf5_y2) then
					sqf1_x1 <= 100;
					sqf1_x2 <= 120;
					sqf1_y1 <= 100;
					sqf1_y2 <= 120;
		
					sqf2_x1 <= 80;
					sqf2_x2 <= 100;
					sqf2_y1 <= 100;
					sqf2_y2 <= 120;
				
					sqf3_x1 <= 60;
					sqf3_x2 <= 80;
					sqf3_y1 <= 100;
					sqf3_y2 <= 120;
				
					sqf4_x1 <= 40;
					sqf4_x2 <= 60;
					sqf4_y1 <= 100;
					sqf4_y2 <= 120;
				
					sqf5_x1 <= 20;
					sqf5_x2 <= 40;
					sqf5_y1 <= 100;
					sqf5_y2 <= 120;
					
					flag_v2 <= '1';
					FREEZE_MOVEMENT <= '1';
				end if;
				
			elsif(B_D1 = '1') then
				sqf1_y1 <= sq1_y1 + 20;
				sqf1_y2 <= sq1_y2 + 20;
				
				sqf2_x1 <= sq1_x1;
				sqf2_x2 <= sq1_x2;
				sqf2_y1 <= sq1_y1;
				sqf2_y2 <= sq1_y2;
				
				sqf3_x1 <= sq2_x1;
				sqf3_x2 <= sq2_x2;
				sqf3_y1 <= sq2_y1;
				sqf3_y2 <= sq2_y2;
				
				sqf4_x1 <= sq3_x1;
				sqf4_x2 <= sq3_x2;
				sqf4_y1 <= sq3_y1;
				sqf4_y2 <= sq3_y2;
				
				sqf5_x1 <= sq4_x1;
				sqf5_x2 <= sq4_x2;
				sqf5_y1 <= sq4_y1;
				sqf5_y2 <= sq4_y2;
				
				-- CONDICIï¿½N DE COLISIï¿½N CON MARGEN INFERIOR
				if(sqf1_y2 >= 460) then
				--
					sqf1_x1 <= 100;
					sqf1_x2 <= 120;
					sqf1_y1 <= 100;
					sqf1_y2 <= 120;
		
					sqf2_x1 <= 80;
					sqf2_x2 <= 100;
					sqf2_y1 <= 100;
					sqf2_y2 <= 120;
				
					sqf3_x1 <= 60;
					sqf3_x2 <= 80;
					sqf3_y1 <= 100;
					sqf3_y2 <= 120;
				
					sqf4_x1 <= 40;
					sqf4_x2 <= 60;
					sqf4_y1 <= 100;
					sqf4_y2 <= 120;
				
					sqf5_x1 <= 20;
					sqf5_x2 <= 40;
					sqf5_y1 <= 100;
					sqf5_y2 <= 120;
					
					flag_v2 <= '1';
					FREEZE_MOVEMENT <= '1';
			
				-- CONDICIï¿½N PARA COLISIï¿½N CONSIGO MISMA
				elsif(sqf1_x1 = sqf5_x1 and sqf1_x2 = sqf5_x2 and sqf1_y1 = sqf5_y1 and sqf1_y2 = sqf5_y2) then
					sqf1_x1 <= 100;
					sqf1_x2 <= 120;
					sqf1_y1 <= 100;
					sqf1_y2 <= 120;
		
					sqf2_x1 <= 80;
					sqf2_x2 <= 100;
					sqf2_y1 <= 100;
					sqf2_y2 <= 120;
				
					sqf3_x1 <= 60;
					sqf3_x2 <= 80;
					sqf3_y1 <= 100;
					sqf3_y2 <= 120;
				
					sqf4_x1 <= 40;
					sqf4_x2 <= 60;
					sqf4_y1 <= 100;
					sqf4_y2 <= 120;
				
					sqf5_x1 <= 20;
					sqf5_x2 <= 40;
					sqf5_y1 <= 100;
					sqf5_y2 <= 120;
					
					flag_v2 <= '1';
					FREEZE_MOVEMENT <= '1';
				end if;	
			end if;
			
		end if;
	end process;

	
	
UPDATE_COORD_SQ2: process (BT_GC, B_R2, B_L2, B_U2, B_D2, sqf1_2_x1, sqf1_2_x2, sqf1_2_y1, sqf1_2_y2, RST_SCREENS, flag_v2) is
	begin
		if(BT_GC'event and BT_GC = '1') then
		
			if(RST_SCREENS = '0') then
				flag_v1 <= '0';
--				flag_v2 <= '0';
--				flag_tie <= '0';
				FREEZE_MOVEMENT_2 <= '0';

			elsif(flag_v2 = '1') then
				--
				sqf1_2_x1 <= 520;
				sqf1_2_x2 <= 540;
				sqf1_2_y1 <= 300;
				sqf1_2_y2 <= 320;
		
				sqf2_2_x1 <= 540;
				sqf2_2_x2 <= 560;
				sqf2_2_y1 <= 300;
				sqf2_2_y2 <= 320;
				
				sqf3_2_x1 <= 560;
				sqf3_2_x2 <= 580;
				sqf3_2_y1 <= 300;
				sqf3_2_y2 <= 320;
				
				sqf4_2_x1 <= 580;
				sqf4_2_x2 <= 600;
				sqf4_2_y1 <= 300;
				sqf4_2_y2 <= 320;
				
				sqf5_2_x1 <= 600;
				sqf5_2_x2 <= 620;
				sqf5_2_y1 <= 300;
				sqf5_2_y2 <= 320;
					
				FREEZE_MOVEMENT_2 <= '1';
			
			elsif(B_R2 = '1') then
				sqf1_2_x1 <= sq1_2_x1 + 20;
				sqf1_2_x2 <= sq1_2_x2 + 20;
				
				sqf2_2_x1 <= sq1_2_x1;
				sqf2_2_x2 <= sq1_2_x2;
				sqf2_2_y1 <= sq1_2_y1;
				sqf2_2_y2 <= sq1_2_y2;
				
				sqf3_2_x1 <= sq2_2_x1;
				sqf3_2_x2 <= sq2_2_x2;
				sqf3_2_y1 <= sq2_2_y1;
				sqf3_2_y2 <= sq2_2_y2;
				
				sqf4_2_x1 <= sq3_2_x1;
				sqf4_2_x2 <= sq3_2_x2;
				sqf4_2_y1 <= sq3_2_y1;
				sqf4_2_y2 <= sq3_2_y2;
				
				sqf5_2_x1 <= sq4_2_x1;
				sqf5_2_x2 <= sq4_2_x2;
				sqf5_2_y1 <= sq4_2_y1;
				sqf5_2_y2 <= sq4_2_y2;
				
				-- CONDICIï¿½N DE COLISIï¿½N CON MARGEN DERECHO
				if(sqf1_2_x2 >= 620) then
				--
					sqf1_2_x1 <= 520;
					sqf1_2_x2 <= 540;
					sqf1_2_y1 <= 300;
					sqf1_2_y2 <= 320;
		
					sqf2_2_x1 <= 540;
					sqf2_2_x2 <= 560;
					sqf2_2_y1 <= 300;
					sqf2_2_y2 <= 320;
				
					sqf3_2_x1 <= 560;
					sqf3_2_x2 <= 580;
					sqf3_2_y1 <= 300;
					sqf3_2_y2 <= 320;
				
					sqf4_2_x1 <= 580;
					sqf4_2_x2 <= 600;
					sqf4_2_y1 <= 300;
					sqf4_2_y2 <= 320;
				
					sqf5_2_x1 <= 600;
					sqf5_2_x2 <= 620;
					sqf5_2_y1 <= 300;
					sqf5_2_y2 <= 320;
					
					flag_v1 <= '1';
					FREEZE_MOVEMENT_2 <= '1';
					--H_BDT_SCREENS
				-- CONDICIï¿½N PARA COLISIï¿½N CONSIGO MISMA
				elsif(sqf1_2_x1 = sqf5_2_x1 and sqf1_2_x2 = sqf5_2_x2 and sqf1_2_y1 = sqf5_2_y1 and sqf1_2_y2 = sqf5_2_y2) then
					sqf1_2_x1 <= 520;
					sqf1_2_x2 <= 540;
					sqf1_2_y1 <= 300;
					sqf1_2_y2 <= 320;
		
					sqf2_2_x1 <= 540;
					sqf2_2_x2 <= 560;
					sqf2_2_y1 <= 300;
					sqf2_2_y2 <= 320;
				
					sqf3_2_x1 <= 560;
					sqf3_2_x2 <= 580;
					sqf3_2_y1 <= 300;
					sqf3_2_y2 <= 320;
				
					sqf4_2_x1 <= 580;
					sqf4_2_x2 <= 600;
					sqf4_2_y1 <= 300;
					sqf4_2_y2 <= 320;
				
					sqf5_2_x1 <= 600;
					sqf5_2_x2 <= 620;
					sqf5_2_y1 <= 300;
					sqf5_2_y2 <= 320;
					
					flag_v1 <= '1';
					FREEZE_MOVEMENT_2 <= '1';
					
				--Condición para colisión con CABEZA DE SERPIENTE 1
				elsif(sqf1_2_x1 = sqf1_x1 and sqf1_2_x2 = sqf1_x2 and sqf1_2_y1 = sqf1_y1 and sqf1_2_y2 = sqf1_y2) then
					sqf1_2_x1 <= 520;
					sqf1_2_x2 <= 540;
					sqf1_2_y1 <= 300;
					sqf1_2_y2 <= 320;
		
					sqf2_2_x1 <= 540;
					sqf2_2_x2 <= 560;
					sqf2_2_y1 <= 300;
					sqf2_2_y2 <= 320;
				
					sqf3_2_x1 <= 560;
					sqf3_2_x2 <= 580;
					sqf3_2_y1 <= 300;
					sqf3_2_y2 <= 320;
				
					sqf4_2_x1 <= 580;
					sqf4_2_x2 <= 600;
					sqf4_2_y1 <= 300;
					sqf4_2_y2 <= 320;
				
					sqf5_2_x1 <= 600;
					sqf5_2_x2 <= 620;
					sqf5_2_y1 <= 300;
					sqf5_2_y2 <= 320;
					
					flag_v1 <= '1';
					FREEZE_MOVEMENT_2 <= '1';
				--Condición para colisión con CUADRO 1 DE SERPIENTE 1
				elsif(sqf1_2_x1 = sqf2_x1 and sqf1_2_x2 = sqf2_x2 and sqf1_2_y1 = sqf2_y1 and sqf1_2_y2 = sqf2_y2) then
					sqf1_2_x1 <= 520;
					sqf1_2_x2 <= 540;
					sqf1_2_y1 <= 300;
					sqf1_2_y2 <= 320;
		
					sqf2_2_x1 <= 540;
					sqf2_2_x2 <= 560;
					sqf2_2_y1 <= 300;
					sqf2_2_y2 <= 320;
				
					sqf3_2_x1 <= 560;
					sqf3_2_x2 <= 580;
					sqf3_2_y1 <= 300;
					sqf3_2_y2 <= 320;
				
					sqf4_2_x1 <= 580;
					sqf4_2_x2 <= 600;
					sqf4_2_y1 <= 300;
					sqf4_2_y2 <= 320;
				
					sqf5_2_x1 <= 600;
					sqf5_2_x2 <= 620;
					sqf5_2_y1 <= 300;
					sqf5_2_y2 <= 320;
					
					flag_v1 <= '1';
					FREEZE_MOVEMENT_2 <= '1';
				--Condición para colisión con CUADRO 2 DE SERPIENTE 1
				elsif(sqf1_2_x1 = sqf3_x1 and sqf1_2_x2 = sqf3_x2 and sqf1_2_y1 = sqf3_y1 and sqf1_2_y2 = sqf3_y2) then
					sqf1_2_x1 <= 520;
					sqf1_2_x2 <= 540;
					sqf1_2_y1 <= 300;
					sqf1_2_y2 <= 320;
		
					sqf2_2_x1 <= 540;
					sqf2_2_x2 <= 560;
					sqf2_2_y1 <= 300;
					sqf2_2_y2 <= 320;
				
					sqf3_2_x1 <= 560;
					sqf3_2_x2 <= 580;
					sqf3_2_y1 <= 300;
					sqf3_2_y2 <= 320;
				
					sqf4_2_x1 <= 580;
					sqf4_2_x2 <= 600;
					sqf4_2_y1 <= 300;
					sqf4_2_y2 <= 320;
				
					sqf5_2_x1 <= 600;
					sqf5_2_x2 <= 620;
					sqf5_2_y1 <= 300;
					sqf5_2_y2 <= 320;
					
					flag_v1 <= '1';
					FREEZE_MOVEMENT_2 <= '1';
				--Condición para colisión con CUADRO 3 DE SERPIENTE 1
				elsif(sqf1_2_x1 = sqf4_x1 and sqf1_2_x2 = sqf4_x2 and sqf1_2_y1 = sqf4_y1 and sqf1_2_y2 = sqf4_y2) then
					sqf1_2_x1 <= 520;
					sqf1_2_x2 <= 540;
					sqf1_2_y1 <= 300;
					sqf1_2_y2 <= 320;
		
					sqf2_2_x1 <= 540;
					sqf2_2_x2 <= 560;
					sqf2_2_y1 <= 300;
					sqf2_2_y2 <= 320;
				
					sqf3_2_x1 <= 560;
					sqf3_2_x2 <= 580;
					sqf3_2_y1 <= 300;
					sqf3_2_y2 <= 320;
				
					sqf4_2_x1 <= 580;
					sqf4_2_x2 <= 600;
					sqf4_2_y1 <= 300;
					sqf4_2_y2 <= 320;
				
					sqf5_2_x1 <= 600;
					sqf5_2_x2 <= 620;
					sqf5_2_y1 <= 300;
					sqf5_2_y2 <= 320;
					
					flag_v1 <= '1';
					FREEZE_MOVEMENT_2 <= '1';  
				--Condición para colisión con CUADRO 4 DE SERPIENTE 1
				elsif(sqf1_2_x1 = sqf5_x1 and sqf1_2_x2 = sqf5_x2 and sqf1_2_y1 = sqf5_y1 and sqf1_2_y2 = sqf5_y2) then
					sqf1_2_x1 <= 520;
					sqf1_2_x2 <= 540;
					sqf1_2_y1 <= 300;
					sqf1_2_y2 <= 320;
		
					sqf2_2_x1 <= 540;
					sqf2_2_x2 <= 560;
					sqf2_2_y1 <= 300;
					sqf2_2_y2 <= 320;
				
					sqf3_2_x1 <= 560;
					sqf3_2_x2 <= 580;
					sqf3_2_y1 <= 300;
					sqf3_2_y2 <= 320;
				
					sqf4_2_x1 <= 580;
					sqf4_2_x2 <= 600;
					sqf4_2_y1 <= 300;
					sqf4_2_y2 <= 320;
				
					sqf5_2_x1 <= 600;
					sqf5_2_x2 <= 620;
					sqf5_2_y1 <= 300;
					sqf5_2_y2 <= 320;
					
					flag_v1 <= '1';
					FREEZE_MOVEMENT_2 <= '1';
				end if;	
				--
				
			elsif(B_L2 = '1') then
				sqf1_2_x1 <= sq1_2_x1 - 20;
				sqf1_2_x2 <= sq1_2_x2 - 20;
				
				sqf2_2_x1 <= sq1_2_x1;
				sqf2_2_x2 <= sq1_2_x2;
				sqf2_2_y1 <= sq1_2_y1;
				sqf2_2_y2 <= sq1_2_y2;
				
				sqf3_2_x1 <= sq2_2_x1;
				sqf3_2_x2 <= sq2_2_x2;
				sqf3_2_y1 <= sq2_2_y1;
				sqf3_2_y2 <= sq2_2_y2;
				
				sqf4_2_x1 <= sq3_2_x1;
				sqf4_2_x2 <= sq3_2_x2;
				sqf4_2_y1 <= sq3_2_y1;
				sqf4_2_y2 <= sq3_2_y2;
				
				sqf5_2_x1 <= sq4_2_x1;
				sqf5_2_x2 <= sq4_2_x2;
				sqf5_2_y1 <= sq4_2_y1;
				sqf5_2_y2 <= sq4_2_y2;
				
				-- CONDICIï¿½N DE COLISIï¿½N CON MARGEN IZQUIERDO
				if(sqf1_2_x1 <= 20) then
				--
					sqf1_2_x1 <= 520;
					sqf1_2_x2 <= 540;
					sqf1_2_y1 <= 300;
					sqf1_2_y2 <= 320;
		
					sqf2_2_x1 <= 540;
					sqf2_2_x2 <= 560;
					sqf2_2_y1 <= 300;
					sqf2_2_y2 <= 320;
				
					sqf3_2_x1 <= 560;
					sqf3_2_x2 <= 580;
					sqf3_2_y1 <= 300;
					sqf3_2_y2 <= 320;
				
					sqf4_2_x1 <= 580;
					sqf4_2_x2 <= 600;
					sqf4_2_y1 <= 300;
					sqf4_2_y2 <= 320;
				
					sqf5_2_x1 <= 600;
					sqf5_2_x2 <= 620;
					sqf5_2_y1 <= 300;
					sqf5_2_y2 <= 320;
					
					flag_v1 <= '1';
					FREEZE_MOVEMENT_2 <= '1';
					
				-- CONDICIï¿½N PARA COLISIï¿½N CONSIGO MISMA
				elsif(sqf1_2_x1 = sqf5_2_x1 and sqf1_2_x2 = sqf5_2_x2 and sqf1_2_y1 = sqf5_2_y1 and sqf1_2_y2 = sqf5_2_y2) then
					sqf1_2_x1 <= 520;
					sqf1_2_x2 <= 540;
					sqf1_2_y1 <= 300;
					sqf1_2_y2 <= 320;
		
					sqf2_2_x1 <= 540;
					sqf2_2_x2 <= 560;
					sqf2_2_y1 <= 300;
					sqf2_2_y2 <= 320;
				
					sqf3_2_x1 <= 560;
					sqf3_2_x2 <= 580;
					sqf3_2_y1 <= 300;
					sqf3_2_y2 <= 320;
				
					sqf4_2_x1 <= 580;
					sqf4_2_x2 <= 600;
					sqf4_2_y1 <= 300;
					sqf4_2_y2 <= 320;
				
					sqf5_2_x1 <= 600;
					sqf5_2_x2 <= 620;
					sqf5_2_y1 <= 300;
					sqf5_2_y2 <= 320;
					
					flag_v1 <= '1';
					FREEZE_MOVEMENT_2 <= '1';
					
				--Condición para colisión con CABEZA DE SERPIENTE 1
				elsif(sqf1_2_x1 = sqf1_x1 and sqf1_2_x2 = sqf1_x2 and sqf1_2_y1 = sqf1_y1 and sqf1_2_y2 = sqf1_y2) then
					sqf1_2_x1 <= 520;
					sqf1_2_x2 <= 540;
					sqf1_2_y1 <= 300;
					sqf1_2_y2 <= 320;
		
					sqf2_2_x1 <= 540;
					sqf2_2_x2 <= 560;
					sqf2_2_y1 <= 300;
					sqf2_2_y2 <= 320;
				
					sqf3_2_x1 <= 560;
					sqf3_2_x2 <= 580;
					sqf3_2_y1 <= 300;
					sqf3_2_y2 <= 320;
				
					sqf4_2_x1 <= 580;
					sqf4_2_x2 <= 600;
					sqf4_2_y1 <= 300;
					sqf4_2_y2 <= 320;
				
					sqf5_2_x1 <= 600;
					sqf5_2_x2 <= 620;
					sqf5_2_y1 <= 300;
					sqf5_2_y2 <= 320;
					
					flag_v1 <= '1';
					FREEZE_MOVEMENT_2 <= '1';
				--Condición para colisión con CUADRO 1 DE SERPIENTE 1
				elsif(sqf1_2_x1 = sqf2_x1 and sqf1_2_x2 = sqf2_x2 and sqf1_2_y1 = sqf2_y1 and sqf1_2_y2 = sqf2_y2) then
					sqf1_2_x1 <= 520;
					sqf1_2_x2 <= 540;
					sqf1_2_y1 <= 300;
					sqf1_2_y2 <= 320;
		
					sqf2_2_x1 <= 540;
					sqf2_2_x2 <= 560;
					sqf2_2_y1 <= 300;
					sqf2_2_y2 <= 320;
				
					sqf3_2_x1 <= 560;
					sqf3_2_x2 <= 580;
					sqf3_2_y1 <= 300;
					sqf3_2_y2 <= 320;
				
					sqf4_2_x1 <= 580;
					sqf4_2_x2 <= 600;
					sqf4_2_y1 <= 300;
					sqf4_2_y2 <= 320;
				
					sqf5_2_x1 <= 600;
					sqf5_2_x2 <= 620;
					sqf5_2_y1 <= 300;
					sqf5_2_y2 <= 320;
					
					flag_v1 <= '1';
					FREEZE_MOVEMENT_2 <= '1';
				--Condición para colisión con CUADRO 2 DE SERPIENTE 1
				elsif(sqf1_2_x1 = sqf3_x1 and sqf1_2_x2 = sqf3_x2 and sqf1_2_y1 = sqf3_y1 and sqf1_2_y2 = sqf3_y2) then
					sqf1_2_x1 <= 520;
					sqf1_2_x2 <= 540;
					sqf1_2_y1 <= 300;
					sqf1_2_y2 <= 320;
		
					sqf2_2_x1 <= 540;
					sqf2_2_x2 <= 560;
					sqf2_2_y1 <= 300;
					sqf2_2_y2 <= 320;
				
					sqf3_2_x1 <= 560;
					sqf3_2_x2 <= 580;
					sqf3_2_y1 <= 300;
					sqf3_2_y2 <= 320;
				
					sqf4_2_x1 <= 580;
					sqf4_2_x2 <= 600;
					sqf4_2_y1 <= 300;
					sqf4_2_y2 <= 320;
				
					sqf5_2_x1 <= 600;
					sqf5_2_x2 <= 620;
					sqf5_2_y1 <= 300;
					sqf5_2_y2 <= 320;
					
					flag_v1 <= '1';
					FREEZE_MOVEMENT_2 <= '1';
				--Condición para colisión con CUADRO 3 DE SERPIENTE 1
				elsif(sqf1_2_x1 = sqf4_x1 and sqf1_2_x2 = sqf4_x2 and sqf1_2_y1 = sqf4_y1 and sqf1_2_y2 = sqf4_y2) then
					sqf1_2_x1 <= 520;
					sqf1_2_x2 <= 540;
					sqf1_2_y1 <= 300;
					sqf1_2_y2 <= 320;
		
					sqf2_2_x1 <= 540;
					sqf2_2_x2 <= 560;
					sqf2_2_y1 <= 300;
					sqf2_2_y2 <= 320;
				
					sqf3_2_x1 <= 560;
					sqf3_2_x2 <= 580;
					sqf3_2_y1 <= 300;
					sqf3_2_y2 <= 320;
				
					sqf4_2_x1 <= 580;
					sqf4_2_x2 <= 600;
					sqf4_2_y1 <= 300;
					sqf4_2_y2 <= 320;
				
					sqf5_2_x1 <= 600;
					sqf5_2_x2 <= 620;
					sqf5_2_y1 <= 300;
					sqf5_2_y2 <= 320;
					
					flag_v1 <= '1';
					FREEZE_MOVEMENT_2 <= '1';  
				--Condición para colisión con CUADRO 4 DE SERPIENTE 1
				elsif(sqf1_2_x1 = sqf5_x1 and sqf1_2_x2 = sqf5_x2 and sqf1_2_y1 = sqf5_y1 and sqf1_2_y2 = sqf5_y2) then
					sqf1_2_x1 <= 520;
					sqf1_2_x2 <= 540;
					sqf1_2_y1 <= 300;
					sqf1_2_y2 <= 320;
		
					sqf2_2_x1 <= 540;
					sqf2_2_x2 <= 560;
					sqf2_2_y1 <= 300;
					sqf2_2_y2 <= 320;
				
					sqf3_2_x1 <= 560;
					sqf3_2_x2 <= 580;
					sqf3_2_y1 <= 300;
					sqf3_2_y2 <= 320;
				
					sqf4_2_x1 <= 580;
					sqf4_2_x2 <= 600;
					sqf4_2_y1 <= 300;
					sqf4_2_y2 <= 320;
				
					sqf5_2_x1 <= 600;
					sqf5_2_x2 <= 620;
					sqf5_2_y1 <= 300;
					sqf5_2_y2 <= 320;
					
					flag_v1 <= '1';
					FREEZE_MOVEMENT_2 <= '1';	
				end if;
				
			elsif(B_U2 = '1') then
				sqf1_2_y1 <= sq1_2_y1 - 20;
				sqf1_2_y2 <= sq1_2_y2 - 20;
				
				sqf2_2_x1 <= sq1_2_x1;
				sqf2_2_x2 <= sq1_2_x2;
				sqf2_2_y1 <= sq1_2_y1;
				sqf2_2_y2 <= sq1_2_y2;
				
				sqf3_2_x1 <= sq2_2_x1;
				sqf3_2_x2 <= sq2_2_x2;
				sqf3_2_y1 <= sq2_2_y1;
				sqf3_2_y2 <= sq2_2_y2;
	
				sqf4_2_x1 <= sq3_2_x1;
				sqf4_2_x2 <= sq3_2_x2;
				sqf4_2_y1 <= sq3_2_y1;
				sqf4_2_y2 <= sq3_2_y2;
				
				sqf5_2_x1 <= sq4_2_x1;
				sqf5_2_x2 <= sq4_2_x2;
				sqf5_2_y1 <= sq4_2_y1;
				sqf5_2_y2 <= sq4_2_y2;
				
				-- CONDICIï¿½N DE COLISIï¿½N CON MARGEN SUPERIOR
				if(sqf1_2_y1 <= 20) then
				--
					sqf1_2_x1 <= 520;
					sqf1_2_x2 <= 540;
					sqf1_2_y1 <= 300;
					sqf1_2_y2 <= 320;
		
					sqf2_2_x1 <= 540;
					sqf2_2_x2 <= 560;
					sqf2_2_y1 <= 300;
					sqf2_2_y2 <= 320;
				
					sqf3_2_x1 <= 560;
					sqf3_2_x2 <= 580;
					sqf3_2_y1 <= 300;
					sqf3_2_y2 <= 320;
				
					sqf4_2_x1 <= 580;
					sqf4_2_x2 <= 600;
					sqf4_2_y1 <= 300;
					sqf4_2_y2 <= 320;
				
					sqf5_2_x1 <= 600;
					sqf5_2_x2 <= 620;
					sqf5_2_y1 <= 300;
					sqf5_2_y2 <= 320;
					
					flag_v1 <= '1';
					FREEZE_MOVEMENT_2 <= '1';
					
				-- CONDICIï¿½N PARA COLISIï¿½N CONSIGO MISMA
				elsif(sqf1_2_x1 = sqf5_2_x1 and sqf1_2_x2 = sqf5_2_x2 and sqf1_2_y1 = sqf5_2_y1 and sqf1_2_y2 = sqf5_2_y2) then
					sqf1_2_x1 <= 520;
					sqf1_2_x2 <= 540;
					sqf1_2_y1 <= 300;
					sqf1_2_y2 <= 320;
		
					sqf2_2_x1 <= 540;
					sqf2_2_x2 <= 560;
					sqf2_2_y1 <= 300;
					sqf2_2_y2 <= 320;
				
					sqf3_2_x1 <= 560;
					sqf3_2_x2 <= 580;
					sqf3_2_y1 <= 300;
					sqf3_2_y2 <= 320;
				
					sqf4_2_x1 <= 580;
					sqf4_2_x2 <= 600;
					sqf4_2_y1 <= 300;
					sqf4_2_y2 <= 320;
				
					sqf5_2_x1 <= 600;
					sqf5_2_x2 <= 620;
					sqf5_2_y1 <= 300;
					sqf5_2_y2 <= 320;
					
					flag_v1 <= '1';
					FREEZE_MOVEMENT_2 <= '1'; 
					
				--Condición para colisión con CABEZA DE SERPIENTE 1
				elsif(sqf1_2_x1 = sqf1_x1 and sqf1_2_x2 = sqf1_x2 and sqf1_2_y1 = sqf1_y1 and sqf1_2_y2 = sqf1_y2) then
					sqf1_2_x1 <= 520;
					sqf1_2_x2 <= 540;
					sqf1_2_y1 <= 300;
					sqf1_2_y2 <= 320;
		
					sqf2_2_x1 <= 540;
					sqf2_2_x2 <= 560;
					sqf2_2_y1 <= 300;
					sqf2_2_y2 <= 320;
				
					sqf3_2_x1 <= 560;
					sqf3_2_x2 <= 580;
					sqf3_2_y1 <= 300;
					sqf3_2_y2 <= 320;
				
					sqf4_2_x1 <= 580;
					sqf4_2_x2 <= 600;
					sqf4_2_y1 <= 300;
					sqf4_2_y2 <= 320;
				
					sqf5_2_x1 <= 600;
					sqf5_2_x2 <= 620;
					sqf5_2_y1 <= 300;
					sqf5_2_y2 <= 320;
					
					flag_v1 <= '1';
					FREEZE_MOVEMENT_2 <= '1';
				--Condición para colisión con CUADRO 1 DE SERPIENTE 1
				elsif(sqf1_2_x1 = sqf2_x1 and sqf1_2_x2 = sqf2_x2 and sqf1_2_y1 = sqf2_y1 and sqf1_2_y2 = sqf2_y2) then
					sqf1_2_x1 <= 520;
					sqf1_2_x2 <= 540;
					sqf1_2_y1 <= 300;
					sqf1_2_y2 <= 320;
		
					sqf2_2_x1 <= 540;
					sqf2_2_x2 <= 560;
					sqf2_2_y1 <= 300;
					sqf2_2_y2 <= 320;
				
					sqf3_2_x1 <= 560;
					sqf3_2_x2 <= 580;
					sqf3_2_y1 <= 300;
					sqf3_2_y2 <= 320;
				
					sqf4_2_x1 <= 580;
					sqf4_2_x2 <= 600;
					sqf4_2_y1 <= 300;
					sqf4_2_y2 <= 320;
				
					sqf5_2_x1 <= 600;
					sqf5_2_x2 <= 620;
					sqf5_2_y1 <= 300;
					sqf5_2_y2 <= 320;
					
					flag_v1 <= '1';
					FREEZE_MOVEMENT_2 <= '1';
				--Condición para colisión con CUADRO 2 DE SERPIENTE 1
				elsif(sqf1_2_x1 = sqf3_x1 and sqf1_2_x2 = sqf3_x2 and sqf1_2_y1 = sqf3_y1 and sqf1_2_y2 = sqf3_y2) then
					sqf1_2_x1 <= 520;
					sqf1_2_x2 <= 540;
					sqf1_2_y1 <= 300;
					sqf1_2_y2 <= 320;
		
					sqf2_2_x1 <= 540;
					sqf2_2_x2 <= 560;
					sqf2_2_y1 <= 300;
					sqf2_2_y2 <= 320;
				
					sqf3_2_x1 <= 560;
					sqf3_2_x2 <= 580;
					sqf3_2_y1 <= 300;
					sqf3_2_y2 <= 320;
				
					sqf4_2_x1 <= 580;
					sqf4_2_x2 <= 600;
					sqf4_2_y1 <= 300;
					sqf4_2_y2 <= 320;
				
					sqf5_2_x1 <= 600;
					sqf5_2_x2 <= 620;
					sqf5_2_y1 <= 300;
					sqf5_2_y2 <= 320;
					
					flag_v1 <= '1';
					FREEZE_MOVEMENT_2 <= '1';
				--Condición para colisión con CUADRO 3 DE SERPIENTE 1
				elsif(sqf1_2_x1 = sqf4_x1 and sqf1_2_x2 = sqf4_x2 and sqf1_2_y1 = sqf4_y1 and sqf1_2_y2 = sqf4_y2) then
					sqf1_2_x1 <= 520;
					sqf1_2_x2 <= 540;
					sqf1_2_y1 <= 300;
					sqf1_2_y2 <= 320;
		
					sqf2_2_x1 <= 540;
					sqf2_2_x2 <= 560;
					sqf2_2_y1 <= 300;
					sqf2_2_y2 <= 320;
				
					sqf3_2_x1 <= 560;
					sqf3_2_x2 <= 580;
					sqf3_2_y1 <= 300;
					sqf3_2_y2 <= 320;
				
					sqf4_2_x1 <= 580;
					sqf4_2_x2 <= 600;
					sqf4_2_y1 <= 300;
					sqf4_2_y2 <= 320;
				
					sqf5_2_x1 <= 600;
					sqf5_2_x2 <= 620;
					sqf5_2_y1 <= 300;
					sqf5_2_y2 <= 320;
					
					flag_v1 <= '1';
					FREEZE_MOVEMENT_2 <= '1';  
				--Condición para colisión con CUADRO 4 DE SERPIENTE 1
				elsif(sqf1_2_x1 = sqf5_x1 and sqf1_2_x2 = sqf5_x2 and sqf1_2_y1 = sqf5_y1 and sqf1_2_y2 = sqf5_y2) then
					sqf1_2_x1 <= 520;
					sqf1_2_x2 <= 540;
					sqf1_2_y1 <= 300;
					sqf1_2_y2 <= 320;
		
					sqf2_2_x1 <= 540;
					sqf2_2_x2 <= 560;
					sqf2_2_y1 <= 300;
					sqf2_2_y2 <= 320;
				
					sqf3_2_x1 <= 560;
					sqf3_2_x2 <= 580;
					sqf3_2_y1 <= 300;
					sqf3_2_y2 <= 320;
				
					sqf4_2_x1 <= 580;
					sqf4_2_x2 <= 600;
					sqf4_2_y1 <= 300;
					sqf4_2_y2 <= 320;
				
					sqf5_2_x1 <= 600;
					sqf5_2_x2 <= 620;
					sqf5_2_y1 <= 300;
					sqf5_2_y2 <= 320;
					
					flag_v1 <= '1';
					FREEZE_MOVEMENT_2 <= '1';
				end if;
				
			elsif(B_D2 = '1') then
				sqf1_2_y1 <= sq1_2_y1 + 20;
				sqf1_2_y2 <= sq1_2_y2 + 20;
				
				sqf2_2_x1 <= sq1_2_x1;
				sqf2_2_x2 <= sq1_2_x2;
				sqf2_2_y1 <= sq1_2_y1;
				sqf2_2_y2 <= sq1_2_y2;
				
				sqf3_2_x1 <= sq2_2_x1;
				sqf3_2_x2 <= sq2_2_x2;
				sqf3_2_y1 <= sq2_2_y1;
				sqf3_2_y2 <= sq2_2_y2;
				
				sqf4_2_x1 <= sq3_2_x1;
				sqf4_2_x2 <= sq3_2_x2;
				sqf4_2_y1 <= sq3_2_y1;
				sqf4_2_y2 <= sq3_2_y2;
				
				sqf5_2_x1 <= sq4_2_x1;
				sqf5_2_x2 <= sq4_2_x2;
				sqf5_2_y1 <= sq4_2_y1;
				sqf5_2_y2 <= sq4_2_y2;
				
				-- CONDICIï¿½N DE COLISIï¿½N CON MARGEN INFERIOR
				if(sqf1_2_y2 >= 460) then
				--
					sqf1_2_x1 <= 520;
					sqf1_2_x2 <= 540;
					sqf1_2_y1 <= 300;
					sqf1_2_y2 <= 320;
		
					sqf2_2_x1 <= 540;
					sqf2_2_x2 <= 560;
					sqf2_2_y1 <= 300;
					sqf2_2_y2 <= 320;
				
					sqf3_2_x1 <= 560;
					sqf3_2_x2 <= 580;
					sqf3_2_y1 <= 300;
					sqf3_2_y2 <= 320;
				
					sqf4_2_x1 <= 580;
					sqf4_2_x2 <= 600;
					sqf4_2_y1 <= 300;
					sqf4_2_y2 <= 320;
				
					sqf5_2_x1 <= 600;
					sqf5_2_x2 <= 620;
					sqf5_2_y1 <= 300;
					sqf5_2_y2 <= 320;
					
					flag_v1 <= '1';
					FREEZE_MOVEMENT_2 <= '1';
			
				-- CONDICIï¿½N PARA COLISIï¿½N CONSIGO MISMA
				elsif(sqf1_2_x1 = sqf5_2_x1 and sqf1_2_x2 = sqf5_2_x2 and sqf1_2_y1 = sqf5_2_y1 and sqf1_2_y2 = sqf5_2_y2) then
					sqf1_2_x1 <= 520;
					sqf1_2_x2 <= 540;
					sqf1_2_y1 <= 300;
					sqf1_2_y2 <= 320;
		
					sqf2_2_x1 <= 540;
					sqf2_2_x2 <= 560;
					sqf2_2_y1 <= 300;
					sqf2_2_y2 <= 320;
				
					sqf3_2_x1 <= 560;
					sqf3_2_x2 <= 580;
					sqf3_2_y1 <= 300;
					sqf3_2_y2 <= 320;
				
					sqf4_2_x1 <= 580;
					sqf4_2_x2 <= 600;
					sqf4_2_y1 <= 300;
					sqf4_2_y2 <= 320;
				
					sqf5_2_x1 <= 600;
					sqf5_2_x2 <= 620;
					sqf5_2_y1 <= 300;
					sqf5_2_y2 <= 320;
					
					flag_v1 <= '1';
					FREEZE_MOVEMENT_2 <= '1';
				
				--Condición para colisión con CABEZA DE SERPIENTE 1
				elsif(sqf1_2_x1 = sqf1_x1 and sqf1_2_x2 = sqf1_x2 and sqf1_2_y1 = sqf1_y1 and sqf1_2_y2 = sqf1_y2) then
					sqf1_2_x1 <= 520;
					sqf1_2_x2 <= 540;
					sqf1_2_y1 <= 300;
					sqf1_2_y2 <= 320;
		
					sqf2_2_x1 <= 540;
					sqf2_2_x2 <= 560;
					sqf2_2_y1 <= 300;
					sqf2_2_y2 <= 320;
				
					sqf3_2_x1 <= 560;
					sqf3_2_x2 <= 580;
					sqf3_2_y1 <= 300;
					sqf3_2_y2 <= 320;
				
					sqf4_2_x1 <= 580;
					sqf4_2_x2 <= 600;
					sqf4_2_y1 <= 300;
					sqf4_2_y2 <= 320;
				
					sqf5_2_x1 <= 600;
					sqf5_2_x2 <= 620;
					sqf5_2_y1 <= 300;
					sqf5_2_y2 <= 320;
					
					flag_v1 <= '1';
					FREEZE_MOVEMENT_2 <= '1';
				--Condición para colisión con CUADRO 1 DE SERPIENTE 1
				elsif(sqf1_2_x1 = sqf2_x1 and sqf1_2_x2 = sqf2_x2 and sqf1_2_y1 = sqf2_y1 and sqf1_2_y2 = sqf2_y2) then
					sqf1_2_x1 <= 520;
					sqf1_2_x2 <= 540;
					sqf1_2_y1 <= 300;
					sqf1_2_y2 <= 320;
		
					sqf2_2_x1 <= 540;
					sqf2_2_x2 <= 560;
					sqf2_2_y1 <= 300;
					sqf2_2_y2 <= 320;
				
					sqf3_2_x1 <= 560;
					sqf3_2_x2 <= 580;
					sqf3_2_y1 <= 300;
					sqf3_2_y2 <= 320;
				
					sqf4_2_x1 <= 580;
					sqf4_2_x2 <= 600;
					sqf4_2_y1 <= 300;
					sqf4_2_y2 <= 320;
				
					sqf5_2_x1 <= 600;
					sqf5_2_x2 <= 620;
					sqf5_2_y1 <= 300;
					sqf5_2_y2 <= 320;
					
					flag_v1 <= '1';
					FREEZE_MOVEMENT_2 <= '1';
				--Condición para colisión con CUADRO 2 DE SERPIENTE 1
				elsif(sqf1_2_x1 = sqf3_x1 and sqf1_2_x2 = sqf3_x2 and sqf1_2_y1 = sqf3_y1 and sqf1_2_y2 = sqf3_y2) then
					sqf1_2_x1 <= 520;
					sqf1_2_x2 <= 540;
					sqf1_2_y1 <= 300;
					sqf1_2_y2 <= 320;
		
					sqf2_2_x1 <= 540;
					sqf2_2_x2 <= 560;
					sqf2_2_y1 <= 300;
					sqf2_2_y2 <= 320;
				
					sqf3_2_x1 <= 560;
					sqf3_2_x2 <= 580;
					sqf3_2_y1 <= 300;
					sqf3_2_y2 <= 320;
				
					sqf4_2_x1 <= 580;
					sqf4_2_x2 <= 600;
					sqf4_2_y1 <= 300;
					sqf4_2_y2 <= 320;
				
					sqf5_2_x1 <= 600;
					sqf5_2_x2 <= 620;
					sqf5_2_y1 <= 300;
					sqf5_2_y2 <= 320;
					
					flag_v1 <= '1';
					FREEZE_MOVEMENT_2 <= '1';
				--Condición para colisión con CUADRO 3 DE SERPIENTE 1
				elsif(sqf1_2_x1 = sqf4_x1 and sqf1_2_x2 = sqf4_x2 and sqf1_2_y1 = sqf4_y1 and sqf1_2_y2 = sqf4_y2) then
					sqf1_2_x1 <= 520;
					sqf1_2_x2 <= 540;
					sqf1_2_y1 <= 300;
					sqf1_2_y2 <= 320;
		
					sqf2_2_x1 <= 540;
					sqf2_2_x2 <= 560;
					sqf2_2_y1 <= 300;
					sqf2_2_y2 <= 320;
				
					sqf3_2_x1 <= 560;
					sqf3_2_x2 <= 580;
					sqf3_2_y1 <= 300;
					sqf3_2_y2 <= 320;
				
					sqf4_2_x1 <= 580;
					sqf4_2_x2 <= 600;
					sqf4_2_y1 <= 300;
					sqf4_2_y2 <= 320;
				
					sqf5_2_x1 <= 600;
					sqf5_2_x2 <= 620;
					sqf5_2_y1 <= 300;
					sqf5_2_y2 <= 320;
					
					flag_v1 <= '1';
					FREEZE_MOVEMENT_2 <= '1';  
				--Condición para colisión con CUADRO 4 DE SERPIENTE 1
				elsif(sqf1_2_x1 = sqf5_x1 and sqf1_2_x2 = sqf5_x2 and sqf1_2_y1 = sqf5_y1 and sqf1_2_y2 = sqf5_y2) then
					sqf1_2_x1 <= 520;
					sqf1_2_x2 <= 540;
					sqf1_2_y1 <= 300;
					sqf1_2_y2 <= 320;
		
					sqf2_2_x1 <= 540;
					sqf2_2_x2 <= 560;
					sqf2_2_y1 <= 300;
					sqf2_2_y2 <= 320;
				
					sqf3_2_x1 <= 560;
					sqf3_2_x2 <= 580;
					sqf3_2_y1 <= 300;
					sqf3_2_y2 <= 320;
				
					sqf4_2_x1 <= 580;
					sqf4_2_x2 <= 600;
					sqf4_2_y1 <= 300;
					sqf4_2_y2 <= 320;
				
					sqf5_2_x1 <= 600;
					sqf5_2_x2 <= 620;
					sqf5_2_y1 <= 300;
					sqf5_2_y2 <= 320;
					
					flag_v1 <= '1';
					FREEZE_MOVEMENT_2 <= '1';
				end if;	
			end if;
			
		end if;
	end process;
	
	
	
	
FF: process(RST, BT_GC) is
	begin
		if RST = '0' then
			Qp <= (others=>'0');
		elsif  BT_GC'event and BT_GC = '1' then
			Qp <= Qn;
		end if;
	end process FF;

END behavior;