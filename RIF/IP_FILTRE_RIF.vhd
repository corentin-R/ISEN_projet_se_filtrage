library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity IP_FILTRE_RIF is
generic (N:natural:=16);
port(
			
			clk, reset_n, cs_n,write_n: in std_logic;
			address: in std_logic_vector(1 downto 0);
			writedata: in std_logic_vector(15 downto 0);
			readdata: out std_logic_vector(15 downto 0)
			--irq: out std_logic
			);
        
 end IP_FILTRE_RIF;
 

architecture beh of IP_FILTRE_RIF is

component filtre_RIF is
  generic(N: natural:=16); --valeur par defaut echantillon de 16 bits
    port(clk,rst: in std_logic;
        ena_Te : in std_logic;
        entree : in std_logic_vector(N-1 downto  0);-- entree du filtre
        sortie : out std_logic_vector(N-1 downto  0)--sortie du filtre
        );
end component;

  --signal dvsr_reg: std_logic_vector (w-1 downto 0);
  
  signal entree_reg: std_logic_vector (15 downto 0);
  signal sortie_reg: std_logic_vector (15 downto 0);
  signal wr_entree_reg: std_logic; 
  signal rd_sortie_reg: std_logic;  
  signal start_impul:std_logic;
  signal s_write: std_logic;
    

 begin  -- beh
												 															 
				FILTRE_RIF1: filtre_RIF generic map (N=>N)
				          port map
								( clk=> clk,
                          rst=> reset_n,
                          ena_Te=> start_impul,
                          entree=>entree_reg,
                          sortie=>sortie_reg
                          );
		
		
		-- circuit de decodage pour l'ecriture
-- demande d ecriture
s_write <='1' when ((cs_n='0')and (write_n ='0')) else '0';
--demande d ecriture dans le registre entree
wr_entree_reg <= '1' when ((address="00") and (s_write ='1')) else '0';
--demande d ecriture pour l'impulsion start
start_impul <= '1' when ((address="01") and (s_write ='1')) else '0';


--irq<= control_reg(1) and control_reg(2);
--ledg <= reste_reg(7 downto 0);
--reste_zero(7 downto w)
--control_reg(0)<= div_ready;

	                                                   

   P1: process (clk, reset_n)
       begin  -- process P1
         if reset_n = '0' then                 
            entree_reg<=(others=>'0');
            
                                  
            elsif clk'event and clk = '1' then    --- rising clock edge
              
                    
               if(wr_entree_reg='1') then
                  entree_reg <= writedata;
               end if;
                                                                                                                                          
             end if;
             end process P1;
                                                   

-- circuit combinatoire de multiplexage pour la lecture

--demande de lecture du registre sortie
rd_sortie_reg <= '1' when ((address="10") and (cs_n ='0')) else '0';								  
																	  

readdata <= sortie_reg when rd_sortie_reg = '1' 
             else (others => '-');
                                               

 end beh;

