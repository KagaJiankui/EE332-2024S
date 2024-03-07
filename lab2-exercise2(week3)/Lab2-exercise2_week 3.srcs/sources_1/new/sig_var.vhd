 library IEEE;
 use IEEE.std_logic_1164.all;
 
 entity sig_var is
 port (x, y, z: in std_logic;res1, res2: out std_logic);
 end entity sig_var;
 
 architecture behavior of sig_var is
 signal sig_s1, sig_s2: std_logic;
 begin
 proc1: process (x, y, z)is 
variable var_s1, var_s2: std_logic;

 begin
 L1: var_s1:= x and y;
 L2: var_s2:= var_s1 xor z;
 L3: res1<= var_s1 nand var_s2;
 

 end process proc1;

 
 proc2: process (x, y, z) is 
begin
 L1: sig_s1<= x and y;
 L2: sig_s2<= sig_s1 xor z;
 L3: res2 <= sig_s1 nand sig_s2;

 
 end process proc2;
 end architecture behavior;