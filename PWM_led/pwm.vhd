-------------------------------------------------------------------------------
-- Title      : pwm
-- Project    : filtrage du 100Hz
-------------------------------------------------------------------------------
-- File       : pwm.vhd
-- Author     : Corentin Raoult - Gurvan Perrot
-- Created    : 08/02/2014
-------------------------------------------------------------------------------
-- Description: generateur signal PWM
-- entrees: clk et rst
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity pwm is
	port(
		clk,rst: in std_logic;
		pwm_out: out std_logic);
end pwm;


architecture beh of pwm is
  
 	signal	periode: natural  := 5000000;
	signal temps_haut: natural := 2500000;
  signal s_cpt : natural;

  begin
  
    P1 : process(clk, rst)
    begin
    
      if rst = '0' then s_cpt <= 0;
                  pwm_out<='0';
                    
      elsif clk'event and clk = '1' then

             s_cpt<=s_cpt+1;
	          if (s_cpt <= temps_haut) then pwm_out<='1';
				  	 elsif s_cpt > temps_haut and s_cpt < periode then  pwm_out<='0';
				  	 elsif s_cpt = periode then s_cpt <= 0; 
				  	 end if;
						  
      end if;
    
end process P1;
 
 end beh;
