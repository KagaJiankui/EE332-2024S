library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith;
USE IEEE.std_logic_unsigned;
use IEEE.numeric_std.all;

entity prior_16_4_tb is
end prior_16_4_tb;

architecture test of prior_16_4_tb is
component tree_prior_16 is
port 
(
    S: in std_logic_vector(15 downto 0);
    Z: out std_logic_vector(3 downto 0);
    R: out std_logic

);
end component;
signal S_test: std_logic_vector(15 downto 0):="0000000000000000";
signal Z_test: std_logic_vector(3 downto 0):="0000";
signal R_test: std_logic:= '0';

begin

uut:tree_prior_16 port map
(
    S => S_test,  
    Z => Z_test,
    R => R_test
);

stimulus: process is
constant PERIOD:time :=20ns;
constant n: integer :=16;
    begin
        for i in 0 to 2**16 -1 loop
            S_test <= std_logic_vector(TO_UNSIGNED (i,n));
            wait for PERIOD;
     end loop;

end process;
end test;
