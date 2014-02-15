--------------------------
-- testbench lecture ecriture fichiers
----------------------------

library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.numeric_std.all;


entity filtre_RIF_tb is

end filtre_RIF_tb;


architecture test of filtre_RIF_tb is

constant n : natural :=16;

component pulse_2kHz is
generic (cptmax: natural range 0 to 24999999:=24999999); 
                                                        --  valeur par defaut
port(
clk,rst: in std_logic;
pulse_2kHz: out std_logic);
end component;

component filtre_RIF is
	generic(N: natural:=16); --valeur par defaut echantillon de 16 bits
		port(clk,rst: in std_logic;
				ena_Te : in std_logic;
				entree: in std_logic_vector(N-1 downto  0);-- entree du filtre
				sortie : out std_logic_vector(N-1 downto  0)--sortie du filtre
				);
end component;
 


signal s_ena_Te: std_logic;


signal clk_t : std_logic :='0';
signal rst_t: std_logic := '0';
signal entree_t : std_logic_vector(n-1 downto 0):=(others=>'X');
signal sortie_t : std_logic_vector(n-1 downto 0);

File ENT_VALDEC : text open read_mode is "carre_bruit100Hz.txt"; --"carre.txt";
File SOR_VALDEC : text open write_mode is "fichier_resultat_carre_bruit100Hz_V2.txt";-- "fichier_resultat_carre.txt"



begin
  
PULS1: pulse_2kHz 
generic map(cptmax => 24) -- au lieu de 24999999 pour avoir des temps de simulation plus courts
                                                        --  valeur par defaut
port map(
clk =>clk_t,
rst => rst_t,
pulse_2kHz => s_ena_Te);


  
	 
RIF1 : filtre_RIF 
generic map(N=>16)
           
port map(clk =>clk_t,
		rst =>rst_t,
		ena_Te =>s_ena_Te,
		entree =>entree_t, --s_echantillon,
		sortie =>sortie_t);
  


  

-- stimulis horloge, reset	
    rst_t <= '1' after 7 ns;
	 clk_t <= not clk_t after 20 ns;-- horloge  a 25MHz
   
     

---------------------------------------------------------------
-- Process de lecture des echantillons dans le fichier.txt 
---------------------------------------------------------------
Read_input : process(clk_t,rst_t)

variable dec_in : integer:=0;
variable file_line : line;

begin
  if rst_t='0' then null; --pas de lecture de donnees effectuees
    elsif rising_edge(clk_t)then -- equivalent à (clk_t'event and clk_t='1')
		 if (s_ena_Te='1') then  -- à chaque instant d'échantillonnnage
		            if not (endfile(ENT_VALDEC)) then -- tant que la fin du fichier d'entrée n'est pas atteinte
				            readline(ENT_VALDEC,file_line); -- lecture de la ligne du fichier d'entrée
				            read(file_line,dec_in);-- affectation de la valeur entière qui est sur cette ligne à la variable dec_in
			             entree_t <= std_logic_vector(to_unsigned(dec_in,N));-- conversion de dec_in dans le type std_logic_vector sur N bits
				        end if;
			
		 end if;
		 
  end if;
	
end process Read_input;

---------------------------------------------------------------
-- Process d'écriture des données 
---------------------------------------------------------------
Write_output:process(clk_t,rst_t)

variable temp_out: integer:=0;

variable file_line : line;

begin
	if rst_t='0' then null; --pas de donnee a ecrire
       elsif rising_edge(clk_t)then
            if (s_ena_Te = '1'and not (endfile(ENT_VALDEC))) then -- à chaque instant d'échantillonnage 
            --                                                  tant que la fin du fichier d'entrée n'est pas atteinte
					temp_out := to_integer(unsigned(sortie_t));--conversion de sortie_t en entier et mémoristaion dans la variable temp_out
					write(file_line,temp_out);-- écriture de temp_out dans la ligne 
					writeline(SOR_VALDEC,file_line);-- écriture de la ligne dans le fichier de sortie
						end if;
	end if;
end process Write_output;

end test;

