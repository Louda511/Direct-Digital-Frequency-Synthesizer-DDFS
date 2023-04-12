
library IEEE;
use IEEE.std_logic_1164.all;

entity dflipflop is
    port (
        clk_dff     : in  std_logic;
        rst_dff     : in  std_logic; -- reset is active high, not low as usual, otherwise its trickier to be tested onto the ZYBO
        d_dff       : in  std_logic;
        q_dff       : out std_logic
    );
end dflipflop;

architecture behaviour of dflipflop is
begin

    dff_p: process(clk_dff, rst_dff) -- the process triggers whenever one of these
                                     -- 2 signals in the sensitivity list triggers
        begin
            if rst_dff='1' then 
                q_dff <= '0';
            elsif (clk_dff='1' and clk_dff'event) then
                q_dff <= d_dff;
            end if;
        end process dff_p;
end behaviour;
