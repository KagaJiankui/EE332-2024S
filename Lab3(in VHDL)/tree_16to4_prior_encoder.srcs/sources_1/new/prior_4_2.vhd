library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith;

entity prior_4_2 is
port (
       S0: in std_logic_vector(3 downto 0);
       Z0: out std_logic_vector(1 downto 0);
       R0: out std_logic
    );
end entity;

architecture behavioral of prior_4_2 is
begin
Z0 <="11" when S0(3)='1' else
     "10" when S0(2)='1' else
     "01" when S0(1)='1' else
     "00" when S0(0)='1' else
     "00";
     
R0 <= S0(0) or S0(1) or S0(2) or S0(3);
end architecture behavioral;
