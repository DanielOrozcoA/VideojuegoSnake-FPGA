library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity VGA_Controller is	  
	generic(
		H_pulso : integer := 96;	  
		H_back  : integer := 48;
		H_pixel : integer := 640;
		H_front : integer := 16; 
		H_pol   : std_logic := '0';
		V_pulso : integer := 2;	  
		V_back  : integer := 33;
		V_pixel : integer := 480;
		V_front : integer := 10; 
		V_pol   : std_logic := '0');
	port(
	    CLK     : in   std_logic;  
	    RST     : in   std_logic;  
	    h_sync  : out  std_logic;  --sync // pulso horizontal
	    v_sync  : out  std_logic;  --sync // pulso vertical 
	    enable  : out  std_logic;  --'1' = tiempo del display
		fila    : out  integer;   
	    columna : out  integer); 
 end entity VGA_Controller;

architecture behavior of VGA_Controller is
constant h_period : integer := h_pulso + h_back + h_pixel + h_front; --total de pixeles en la fila
constant v_period : integer := v_pulso + v_back + v_pixel + v_front; --total de pixeles en la columna	
begin

	mux : process(CLK, RST)
	variable h_count : integer range 0 TO h_period - 1 := 0;  --cuenta de la columna
	variable v_count : integer range 0 TO v_period - 1 := 0;  --cuenta de la fila
	begin		 

		if RST = '0' then   
			h_count := 0;            
			v_count := 0;             
			h_sync <= not h_pol;    
			v_sync <= not v_pol;      
			enable <= '0';          
			columna <= 0;            
			fila <= 0;              
			
		elsif (CLK'event and CLK = '1') then
			if (h_count < h_period - 1) then h_count := h_count + 1;      --contador horizontal (pixeles) 
	      	else h_count := 0;	
		        if (v_count < v_period - 1) then v_count := v_count + 1;  --contador vertical (filas) 
		        else v_count := 0;
		        end if;
			end if;
	
		    --se?al sync horizontal 
		    if (h_count < h_pixel + h_front or h_count >= h_pixel + h_front + h_pulso) then h_sync <= not h_pol;  
		    else h_sync <= h_pol;       
		    end if;
		      
		    --se?al sync vertical 
			if (v_count < v_pixel + v_front or v_count >= v_pixel + v_front + v_pulso) then v_sync <= NOT v_pol;   
			else v_sync <= v_pol;     
			end if;
		      
			if (h_count < h_pixel) then fila <= h_count;           --salida de las coordenadas en filas
			end if;
			if (v_count < v_pixel) then columna <= v_count;        --salida de las coordenadas en columnas
			end if;
	
			if(h_count < h_pixel AND v_count < v_pixel) THEN enable <= '1';
			else enable <= '0';                                 
			end if;
		end if;
	end process mux;
end architecture behavior;