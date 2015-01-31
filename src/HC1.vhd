-- ------------------------ --
--  THM CPU RA WS 2013/14   --
--                          --
--  HC1 Mapping             --
-- ------------------------ --
-- Authors: Matthias Roell, --
-- Date:    07.12.2014      --
-- ------------------------ --

library ieee;
use ieee.std_logic_1164.all;
use work.all;

entity HC1 is
    port(
        SW          : in  std_logic_vector(17 downto 0);

        LEDR        : out std_logic_vector(17 downto 0);
        LEDG        : out std_logic_vector(7 downto 0);

        CLOCK_50    : in std_logic;

        HEX0        : out std_logic_vector(6 downto 0);
        HEX1        : out std_logic_vector(6 downto 0);
        HEX2        : out std_logic_vector(6 downto 0);
        HEX3        : out std_logic_vector(6 downto 0);

        HEX4        : out std_logic_vector(6 downto 0);
        HEX5        : out std_logic_vector(6 downto 0);
        HEX6        : out std_logic_vector(6 downto 0);
        HEX7        : out std_logic_vector(6 downto 0);

        KEY         : in  std_logic_vector(3 downto 0)
    );
end HC1;

architecture rtl of HC1 is
    signal divided_clock : std_logic;
    signal output_storage : std_logic_vector(7 downto 0);
begin
    CLOCK:  clock_divider port map(not KEY(3), CLOCK_50, divided_clock);
    CPU:    cpu port map(divided_clock, not KEY(3), not KEY(0), SW(7 downto 0), LEDR(0), output_storage, LEDR(17), LEDR(16));

    InputDisp0: seven_segment port map (SW(3 downto 0), HEX0);
    InputDisp1: seven_segment port map (SW(7 downto 4), HEX1);

    OutputDisp0: seven_segment port map (not output_storage(3 downto 0), HEX4);
    OutputDisp1: seven_segment port map (not output_storage(7 downto 4), HEX5);

    HEX2 <= "1111111";
    HEX3 <= "1111111";
    
    HEX6 <= "1111111";
    HEX7 <= "1111111";

    LEDG <= output_storage;
end;
