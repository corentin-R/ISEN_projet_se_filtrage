library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use ieee.std_logic_unsigned.all;

entity filtre is
  port(
       clk, rst : in  std_logic;
       ena_reg  : in  std_logic;
       data     : in  std_logic_vector(15 downto 0);
       data_moy : out std_logic_vector(15 downto 0)  
       );
end filtre;

architecture beh of filtre is
  
  type tableau is array (0 to 19) of std_logic_vector(15 downto 0);
  signal temp : tableau;
  type tableau_natural is array (0 to 19) of natural;
  signal temp_natural : tableau_natural;
  signal s_somme : natural;
  signal s_data_moy : natural;
  
begin
 
------ Bloc banc de registre -----------------------------------------------------------------------------------------------
  
  pRegDecal : process (clk, rst)
    VARIABLE a : integer := 1;
    begin
      if rst = '0' then temp <= (others =>(others =>'0'));
                        temp_natural <= (others=>0);
                        
      elsif clk'event and clk = '1' then
        if  ena_reg='1' then -- front montant ou descendant de sena reg peut etre? 
                 
            temp <= data & temp(0 to 18);                    
            a := 0;                 
                    
            loop1: FOR a IN 0 TO 19 LOOP -- la variable de boucle est a de 0 à 19
                   temp_natural(a) <= to_integer(unsigned(temp(a)));
            END LOOP loop1;
                
            s_somme <= temp_natural(0) + temp_natural(1) + temp_natural(2) + temp_natural(3) + temp_natural(4) + temp_natural(5) + temp_natural(6) + temp_natural(7) + temp_natural(8) + temp_natural(9) + temp_natural(10) + temp_natural(11) + temp_natural(12) + temp_natural(13) + temp_natural(14) + temp_natural(15) + temp_natural(16) + temp_natural(17) + temp_natural(18) + temp_natural(19);
            s_data_moy <= s_somme/20;
            
        end if;
        
       end if;
  end process pRegDecal;
---------------------------------------------------------------------------------------------------------------------------

  data_moy <= std_logic_vector(to_unsigned(s_data_moy,16)); --non signé


end beh;