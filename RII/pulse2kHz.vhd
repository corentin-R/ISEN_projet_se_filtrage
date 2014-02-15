library ieee;
use ieee.std_logic_1164.all;

entity pulse_2kHz is
generic (cptmax: natural range 0 to 24999999:=24999999); 
                                                        --  valeur par defaut
port(
clk,rst: in std_logic;
pulse_2kHz: out std_logic);
end pulse_2kHz;

architecture beh of pulse_2kHz is

 	signal	periode: natural  := 25000;
	signal temps_haut: natural := 12500;
  signal s_cpt : natural;

  begin
  
    P1 : process(clk, rst)
    begin
    
      if rst = '0' then s_cpt <= 0;
                  pulse_2kHz<='0';
                    
      elsif clk'event and clk = '1' then

             s_cpt<=s_cpt+1;
	          if (s_cpt <= temps_haut) then pulse_2kHz<='1';
				  	 elsif s_cpt > temps_haut and s_cpt < periode then  pulse_2kHz<='0';
				  	 elsif s_cpt = periode then s_cpt <= 0; 
				  	 end if;
						  
 		end if;

 end process P1;
 
 end beh;
