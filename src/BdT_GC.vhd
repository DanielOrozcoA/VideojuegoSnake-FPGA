library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_arith.all;
use IEEE.STD_LOGIC_unsigned.all;

entity BdT_GC is
	
	generic(
    K: integer:=833334;
	N: integer:=20
	);
	
	port(
	CLK : in std_logic;
	RST : in std_logic;
	H : in std_logic;
	BdT : out std_logic
	);
end BdT_GC;

architecture simple of BdT_GC is				 
signal Qp,Qn : std_logic_vector(N-1 downto 0):=(others =>'0');
signal BT : std_logic :='0';
signal BdTconH: std_logic_vector(1 downto 0):=(others =>'0');
signal Led_p, Led_n : std_logic :='0';

begin					
	BdT <= BT;
	--PWM <= Led_p;
	BdTconH <= BT & H;
	
	Mux: process (BdTconH, Qp) is
	begin		
		case BdTconH is
			when "01" => Qn <= Qp+1;
			when "11" => Qn <= (others=>'0');
			when others => Qn <= Qp;
		end case;
	end process Mux;
	
	Comparador: process (Qp) is
	begin
		if Qp = K then
			BT <= '1';
			Led_n <= not Led_p;
		else BT <= '0';
		end if;
	end process Comparador;
	
	Combinacional: process (CLK, RST) is
	begin
		if RST = '0' then
			Qp <= (others => '0');
		elsif CLK'event and CLK = '1' then
			Qp <= Qn;
			Led_p <= Led_n;
		end if;
	end process Combinacional;


end architecture simple;