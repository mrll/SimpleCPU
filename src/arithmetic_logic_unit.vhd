-- ------------------------ --
--  THM CPU RA WS 2013/14   --
--                          --
--  Arithmetic Logic Unit   --
-- ------------------------ --
-- Authors: Matthias Roell, --
--          Fabian Stahl    --
-- Date:    06.02.2014      --
-- ------------------------ --

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity arithmetic_logic_unit is
    port(
        -- Control Input --
        aluOp      : in  std_logic_vector(1 downto 0);
        -- Data Input --
        memOut     : in  std_logic_vector(7 downto 0);
        accOut     : in  std_logic_vector(7 downto 0);
        -- Data Output  --
        aluOut     : out std_logic_vector(7 downto 0)
    );
end arithmetic_logic_unit;

architecture rtl of arithmetic_logic_unit is
begin

    -- Set output based on aluOp
    with aluOp select aluOut <=
        std_logic_vector(signed(memOut) + signed(accOut)) when "00",    -- ADD
        std_logic_vector(signed(memOut) - signed(accOut)) when "01",    -- SUB
        not (memOut and accOut) when "10",                              -- NAND
            "00000000" when others;                                     -- Not used operation

end;
