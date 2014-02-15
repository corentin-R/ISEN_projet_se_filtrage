library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity IP_FILTRE_RIF_tb is
end IP_FILTRE_RIF_tb;

architecture test of IP_FILTRE_RIF_tb is
  
  component IP_FILTRE_RIF is
generic (N:natural:=16);
port(
			
			clk, reset_n, cs_n, write_n: in std_logic;
			address: in std_logic_vector(1 downto 0);
			writedata: in std_logic_vector(15 downto 0);
			readdata: out std_logic_vector(15 downto 0)
			);
        
 end component;
    
signal clk_i, reset_n_i:std_logic:='1';
signal readdata_i, writedata_i: std_logic_vector(15 downto 0);
signal address_i: std_logic_vector(1 downto 0);
signal write_n_i, cs_n_i: std_logic;
    
    begin
      
    FSM1: IP_FILTRE_RIF
    ---generic map(N=>16)
    
    port map(
      clk => clk_i,
      reset_n => reset_n_i,
      write_n => write_n_i,
      writedata => writedata_i,
      cs_n => cs_n_i,
      address => address_i,
      readdata => readdata_i      
    );
    
    clk_i <= not clk_i after 20 ns;
    reset_n_i <= '0' after 0 ns,'1' after 50 ns;
    cs_n_i <='1' after 0 ns, '0' after 100 ns;
    write_n_i<= '1' after 0 ns, '0' after 100 ns;
    address_i <= "00" after 00 ns,"01" after 200 ns,  "10" after 1500 ns;--, "01" after 150 ns, "10" after 300 ns;
    writedata_i <= "0000000000001101" after 0 ns;
    
  end test;