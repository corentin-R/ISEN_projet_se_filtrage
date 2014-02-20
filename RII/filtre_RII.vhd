library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity filtre_RII is
  generic(N: natural:=16); --valeur par defaut echantillon de 16 bits
    port(clk,rst: in std_logic;
        ena_Te : in std_logic;
        entree : in std_logic_vector(N-1 downto  0);-- entree du filtre
        sortie : out std_logic_vector(N-1 downto  0)--sortie du filtre
        );
end filtre_RII;

architecture beh of filtre_RII is
  
  type tableau is array (0 to 19) of std_logic_vector(15 downto 0);
  signal temp_x : tableau;
  signal s_somme_x : std_logic_vector(20 downto 0);
  signal s_data_moy_x : std_logic_vector(41 downto 0);

  signal temp_y : tableau;
  signal s_somme_y : std_logic_vector(20 downto 0);
  signal s_data_moy_y : std_logic_vector(41 downto 0);


  constant H : std_logic_vector(20 downto 0) := '1'& X"99999";
  signal s_sortie : std_logic_vector(15 downto  0);
  signal s_sortie_x : std_logic_vector(15 downto  0);
  signal s_sortie_y : std_logic_vector(15 downto  0);

begin
 
------ Bloc banc de registre -----------------------------------------------------------------------------------------------
  
  pRegDecal : process (clk, rst)
    begin
      if rst = '0' then temp_x <= (others =>(others =>'0'));
                        temp_y <= (others =>(others =>'0'));


      elsif clk'event and clk = '1' then
        if  ena_Te='1' then 
                 
          temp_x <= entree & temp_x(0 to 18);  
          temp_y <= s_sortie & temp_y(0 to 18);

        end if;
      end if;

    end process pRegDecal;
            

---------------------------------------------------------------------------------------------------------------------------
          s_somme_x <= ("00000"&temp_x(0)) + ("00000"&temp_x(1)) + ("00000"&temp_x(2)) + ("00000"&temp_x(3)) + ("00000"&temp_x(4)) + ("00000"&temp_x(5)) + ("00000"&temp_x(6)) + ("00000"&temp_x(7)) + ("00000"&temp_x(8)) + ("00000"&temp_x(9)) + ("00000"&temp_x(10)) + ("00000"&temp_x(11)) + ("00000"&temp_x(12)) + ("00000"&temp_x(13)) + ("00000"&temp_x(14)) + ("00000"&temp_x(15)) + ("00000"&temp_x(16)) + ("00000"&temp_x(17)) + ("00000"&temp_x(18)) + ("00000"&temp_x(19));
          s_data_moy_x <= s_somme_x * H;   
          s_somme_y <= ("00000"&temp_y(0)) + ("00000"&temp_y(1)) + ("00000"&temp_y(2)) + ("00000"&temp_y(3)) + ("00000"&temp_y(4)) + ("00000"&temp_y(5)) + ("00000"&temp_y(6)) + ("00000"&temp_y(7)) + ("00000"&temp_y(8)) + ("00000"&temp_y(9)) + ("00000"&temp_y(10)) + ("00000"&temp_y(11)) + ("00000"&temp_y(12)) + ("00000"&temp_y(13)) + ("00000"&temp_y(14)) + ("00000"&temp_y(15)) + ("00000"&temp_y(16)) + ("00000"&temp_y(17)) + ("00000"&temp_y(18)) + ("00000"&temp_y(19));
          s_data_moy_y <= s_somme_y * H; 

------ Bloc de registre stockage valeure finale-----------------------------------------------------------------------------------------------
  
  pRegFinal : process (clk, rst)
    begin
      if rst = '0' then s_sortie <= (others =>'0');
                        sortie <= (others =>'0');
                        s_sortie_x <= (others =>'0');
                        s_sortie_y <= (others =>'0');
      elsif clk'event and clk = '1' then

            s_sortie_x <= s_data_moy_x(40 downto 25);
            s_sortie_y <= s_data_moy_y(40 downto 25);                

            s_sortie <= s_sortie_x-s_sortie_y;
            sortie <= s_sortie;
              
          
       end if;
  end process pRegFinal;
---------------------------------------------------------------------------------------------------------------------------

end beh;