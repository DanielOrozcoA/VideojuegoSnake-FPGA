LIBRARY ieee;
--USE ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.STD_LOGIC_ARITH.all;

ENTITY Estados_Botones_2 IS
--  GENERIC(
--    pixels_y1 :  INTEGER := 50;   --row that first color will persist until
--    pixels_x1 :  INTEGER := 50  --column that first color will persist until
--	);
  PORT(
    BT_GC    :  IN std_logic;
  	RST      :  in std_logic;
	B_R      :  in std_logic;
	B_L      :  in std_logic;
	B_U      :  in std_logic;
	B_D      :  in std_logic;
	OUT_R    :  out std_logic;
	OUT_L    :  out std_logic;
	OUT_U    :  out std_logic;
	OUT_D    :  out std_logic;
	RST_SCREENS : in std_logic
	
	);
END Estados_Botones_2;

ARCHITECTURE behavior OF Estados_Botones_2 IS

signal Qp, Qn : std_logic_vector(3 downto 0) := (others => '0');

BEGIN
  PROCESS(Qp, B_R, B_L, B_U, B_D, RST_SCREENS)
  BEGIN
	  --
	  case Qp is
		  when "0000" => -- ESTADO INICIAL
		  if(B_R = '1') then
			  Qn <= "0001";
		  elsif(B_L = '1') then
			  Qn <= "0010";
		  elsif(B_U = '1') then
			  Qn <= "0011";
		  elsif(B_D = '1') then
			  Qn <= "0100";
		  else
			  Qn <= "0000";
			  OUT_R <= '0';
			  OUT_L <= '0';
			  OUT_U <= '0';
			  OUT_D <= '0';
		  end if;
		  
		  when "0001" => -- BOTON DERECHO PRESIONADO
		  OUT_R <= '1';
		  OUT_L <= '0';
		  OUT_U <= '0';
		  OUT_D <= '0';
		  if(B_R = '1') then
			  Qn <= "0001";
		  elsif(B_L = '1') then
			  Qn <= "0001";
		  elsif(B_U = '1') then
			  Qn <= "0011";
		  elsif(B_D = '1') then
			  Qn <= "0100";
		  elsif(RST_SCREENS = '1') then
			  Qn <= "0000";
		  else
		     Qn <= "0001";
		  end if;
		  
		  when "0010" => -- BOTON IZQUIERDO PRESIONADO
		  --
		  OUT_R <= '0';
		  OUT_L <= '1';
		  OUT_U <= '0';
		  OUT_D <= '0';
		  if(B_R = '1') then
			  Qn <= "0010";
		  elsif(B_L = '1') then
			  Qn <= "0010";
		  elsif(B_U = '1') then
			  Qn <= "0011";
		  elsif(B_D = '1') then
			  Qn <= "0100";
		  elsif(RST_SCREENS = '1') then
			  Qn <= "0000";
		  else
		     Qn <= "0010";
		  end if;
		  
		  when "0011" => -- BOTON ARRIBA PRESIONADO
		  --
		  OUT_R <= '0';
		  OUT_L <= '0';
		  OUT_U <= '1';
		  OUT_D <= '0';
		  if(B_R = '1') then
			  Qn <= "0001";
		  elsif(B_L = '1') then
			  Qn <= "0010";
		  elsif(B_U = '1') then
			  Qn <= "0011";
		  elsif(B_D = '1') then
			  Qn <= "0011";
		  elsif(RST_SCREENS = '1') then
			  Qn <= "0000";
		  else
		     Qn <= "0011";
		  end if;
		  
		  when "0100" => -- BOTON ARRIBA PRESIONADO
		  --
		  OUT_R <= '0';
		  OUT_L <= '0';
		  OUT_U <= '0';
		  OUT_D <= '1';
		  if(B_R = '1') then
			  Qn <= "0001";
		  elsif(B_L = '1') then
			  Qn <= "0010";
		  elsif(B_U = '1') then
			  Qn <= "0100";
		  elsif(B_D = '1') then
			  Qn <= "0100";
		  elsif(RST_SCREENS = '1') then
			  Qn <= "0000";
		  else
		     Qn <= "0100";
		  end if;
		  
		  when others =>
		      Qn <= "0000";
	  end case;
  
  END PROCESS;
  

  FF: process(RST, BT_GC) is
	begin
		if RST = '0' then
			Qp <= (others=>'0');
		elsif  BT_GC'event and BT_GC = '1' then
			Qp <= Qn;
		end if;
	end process FF;

END behavior;