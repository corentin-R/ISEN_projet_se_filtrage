library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use ieee.std_logic_unsigned.all;

entity filtre_RII_tb is

end filtre_RII_tb;




architecture test of filtre_RII_tb is
component filtre_RII
  port(
       clk, rst : in  std_logic;
       ena_Te   : in  std_logic;
       entree   : in  std_logic_vector(15 downto 0);
       sortie   : out std_logic_vector(15 downto 0)
       );
 end component;
 
 signal clk      : std_logic:='0';
 signal rst      : std_logic;
 signal ena_Te  : std_logic;
 signal entree    : std_logic_vector(15 downto 0);
 signal sortie : std_logic_vector(15 downto 0);
 
 begin
 
  -- component instantiation
  DUT: filtre_RII
  port map (clk      => clk,
            rst      => rst,
            ena_Te  => ena_Te,
            entree     => entree,
            sortie => sortie);
            
            
  clk <= not clk after 20 ns;   
  rst <= '0' after 0 ns, '1' after  70 ns;
  
  ena_Te <= '1' after 0 ns;
  entree <= "0000000110110101" after 0 ns, "0000000000000001" after 5000 ns;
 
end test;




configuration filtre_RII_cfg of filtre_RII_tb is
  for test
  end for;
end filtre_RII_cfg;