library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith;


entity tree_prior_16 is
    port
    (
    S: in std_logic_vector (15 downto 0);
    Z: out std_logic_vector (3 downto 0);
    R: out std_logic

     );
end tree_prior_16;

architecture Structure of tree_prior_16 is
    component prior_4_2 is 
        port (S0 : in std_logic_vector(3 downto 0); 
        Z0 : out std_logic_vector(1 downto 0); 
        R0: out std_logic);
    end component ;
    
    signal rst1 :std_logic ;
    signal rst2 :std_logic ;
    signal rst3 :std_logic ;
    signal rst4 :std_logic ;
    signal lsb2: std_logic_vector(1 downto 0) ;
    signal msb2 :std_logic_vector(1 downto 0) ; 
    signal tmp1: std_logic_vector(1 downto 0) ;
    signal tmp2: std_logic_vector(1 downto 0) ;
    signal tmp3: std_logic_vector(1 downto 0) ;
    signal tmp4: std_logic_vector(1 downto 0) ;
    signal tmp5: std_logic_vector(1 downto 0) ;
    signal rst: std_logic_vector(3 downto 0);
    
begin  
    
            
pr_enc1:prior_4_2 port map
(
    S0 => S(15 downto 12),
    Z0 => tmp1,
    R0 => rst1
);
pr_enc2:prior_4_2 port map
(
    S0 => S(11 downto 8),
    Z0 => tmp2,
    R0 => rst2
);
pr_enc3:prior_4_2 port map
(
    S0 => S(7 downto 4),
    Z0 => tmp3,
    R0 => rst3
);

pr_enc4:prior_4_2 port map
(
    S0 => S(3 downto 0),
    Z0 => tmp4,
    R0 => rst4
);

pr_enc5:prior_4_2 port map
(
    S0 => rst,
    Z0 => tmp5
    
);

    rst <= rst1&rst2&rst3&rst4;
    Z <= msb2 & lsb2;
    R <= rst1 or rst2 or rst3 or rst4;
    msb2 <= tmp5;
    lsb2 <= tmp1 when rst1='1' else
            tmp2 when rst2='1' else
            tmp3 when rst3='1' else
            tmp4;
end Structure;
