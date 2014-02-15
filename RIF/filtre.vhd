library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity filtre_RIF is
  generic(N: natural:=16); --valeur par defaut echantillon de 16 bits
    port(clk,rst: in std_logic;
        ena_Te : in std_logic;
        entree : in std_logic_vector(N-1 downto  0);-- entree du filtre
        sortie : out std_logic_vector(N-1 downto  0)--sortie du filtre
        );
end filtre_RIF;

architecture beh of filtre_RIF is
  
  type tableau is array (0 to 19) of std_logic_vector(15 downto 0);
  signal temp : tableau;
  signal s_somme : std_logic_vector(20 downto 0);
  signal s_data_moy : std_logic_vector(41 downto 0);
  constant H : std_logic_vector(20 downto 0) := '1'& X"99999";
  signal s_sortie : std_logic_vector(15 downto  0);

begin
 
------ Bloc banc de registre -----------------------------------------------------------------------------------------------
  
  pRegDecal : process (clk, rst)
    begin
      if rst = '0' then temp <= (others =>(others =>'0'));
                         
      elsif clk'event and clk = '1' then
        if  ena_Te='1' then 
                 
            temp <= entree & temp(0 to 18);                    

        end if;
        
       end if;
  end process pRegDecal;
---------------------------------------------------------------------------------------------------------------------------


s_somme <= ("00000"&temp(0)) + ("00000"&temp(1)) + ("00000"&temp(2)) + ("00000"&temp(3)) + ("00000"&temp(4)) + ("00000"&temp(5)) + ("00000"&temp(6)) + ("00000"&temp(7)) + ("00000"&temp(8)) + ("00000"&temp(9)) + ("00000"&temp(10)) + ("00000"&temp(11)) + ("00000"&temp(12)) + ("00000"&temp(13)) + ("00000"&temp(14)) + ("00000"&temp(15)) + ("00000"&temp(16)) + ("00000"&temp(17)) + ("00000"&temp(18)) + ("00000"&temp(19));
s_data_moy <= s_somme * H;
--s_sortie <= s_data_moy(40 downto 25);
 


------ Bloc de registre stockage valeure finale-----------------------------------------------------------------------------------------------
  
  pRegFinal : process (clk, rst)
    begin
      if rst = '0' then s_sortie <= (others =>'0');
                         
      elsif clk'event and clk = '1' then
                      
            sortie <= s_data_moy(40 downto 25);  
              
          
       end if;
  end process pRegFinal;
---------------------------------------------------------------------------------------------------------------------------

end beh;