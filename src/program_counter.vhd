-- ------------------------ --
--  THM CPU RA WS 2013/14   --
--                          --
--  Program Counter         --
-- ------------------------ --
-- Authors: Matthias Roell, --
--          Fabian Stahl    --
-- Date:    06.02.2014      --
-- ------------------------ --

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity program_counter is
    port(
        -- Control Input --
        clk        : in  std_logic;
        pcLoad     : in  std_logic;
        pcSel      : in  std_logic_vector(1 downto 0);
        adrSel     : in  std_logic;
        -- Data Input --
        irOut      : in  std_logic_vector(4 downto 0);
        -- Data Output --
        address    : out std_logic_vector(4 downto 0)
    );
end program_counter;

architecture rtl of program_counter is

    -- internal pc address
    signal holdAddress : std_logic_vector(4 downto 0);

begin
    PC_PROCESS : process(clk)
    begin
        if rising_edge(clk) then
            if pcLoad = '1' then
                if pcSel = "00" then        -- increment counter
                    holdAddress <= std_logic_vector(unsigned(holdAddress) + 1);
                elsif pcSel = "01" then     -- set counter to new address from IR
                    holdAddress <= irOut;
                else                        -- reset counter
                    holdAddress <= "00000";
                end if;
            end if;
        end if;
    end process;

    -- Set output based on adrSel
    with adrSel select address <=
        holdAddress when '0',          -- PC address
        irOut when others;             -- IR address

end;
