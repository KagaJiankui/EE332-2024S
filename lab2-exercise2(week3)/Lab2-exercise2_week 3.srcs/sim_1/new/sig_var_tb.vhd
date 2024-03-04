----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2024/03/04 16:31:58
-- Design Name: 
-- Module Name: sig_var_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sig_var_tb is
--  Port ( );

end sig_var_tb;

architecture Behavioral of sig_var_tb is
component sig_var 
port(
    x : IN std_logic;
    y : IN std_logic; 
    z : IN std_logic;   
    res1: OUT std_logic; 
    res2: OUT std_logic 

    );
end component;
-- Inputs
    signal x : std_logic := '0';
    signal y : std_logic := '0';
    signal z : std_logic := '0';
 
 -- Outputs
    signal res1 : std_logic; 
    signal res2 : std_logic;

begin
    uut : sig_var PORT MAP
    (
      x => x,
      y => y, 
      z => z,
      res1 => res1,
      res2 => res2
     );
x_proc : process
begin
    x <= '0';
    wait for 40ns;
    x <= '1';
    wait for 40ns;
end process;

y_proc : process
begin
    y <= '0';
    wait for 20ns;
    y <= '1';
    wait for 20ns;
 end process;
 
 z_proc : process
 begin
    z <= '0';
    wait for 10ns;
    z <= '1';
    wait for 10ns;
 end process;
 
end Behavioral;
