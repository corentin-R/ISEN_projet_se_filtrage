library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use ieee.std_logic_unsigned.all;

entity filtre_tb is

end filtre_tb;




architecture test of filtre_tb is
component filtre
  port(
       clk, rst : in  std_logic;
       ena_reg  : in  std_logic;
       data     : in  std_logic_vector(15 downto 0);
       data_moy : out std_logic_vector(15 downto 0)
       );
 end component;
 
 signal clk      : std_logic:='0';
 signal rst      : std_logic;
 signal ena_reg  : std_logic;
 signal data     : std_logic_vector(15 downto 0);
 signal data_moy : std_logic_vector(15 downto 0);
 
 begin
 
  -- component instantiation
  DUT: filtre
  port map (clk      => clk,
            rst      => rst,
            ena_reg  => ena_reg,
            data     => data,
            data_moy => data_moy);
            
            
  clk <= not clk after 20 ns;   
  rst <= '0', '1' after  40 ns;
  
  ena_reg <= '1' after 0 ns;
  data <= "0000000110110101" after 0 ns, "0000000000000001" after 5000 ns;
 
end test;




configuration filtre_cfg of filtre_tb is
  for test
  end for;
end filtre_cfg;