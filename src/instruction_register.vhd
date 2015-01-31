-- ------------------------ --
--  THM CPU RA WS 2013/14   --
--                          --
--  Instruction Register    --
-- ------------------------ --
-- Authors: Matthias Roell, --
--          Fabian Stahl    --
-- Date:    07.02.2014      --
-- ------------------------ --

library ieee;
use ieee.std_logic_1164.all;

entity instruction_register is
    port(
        clk    : in  std_logic;
        irLoad : in  std_logic;
        memOut : in  std_logic_vector(7 downto 0);
        opCode : out std_logic_vector(2 downto 0);
        irOut  : out std_logic_vector(4 downto 0)
    );
end instruction_register;

architecture rtl of instruction_register is
begin

    -- Simple memory signal splitter. On clock signal set op_code and ir_out
    -- (memory address) from memory output
    --
    CLK_PROCESS : process(clk)
    begin
        if rising_edge(clk) then
            if irLoad = '1' then
                opCode <= memOut(7 downto 5);
                irOut  <= memOut(4 downto 0);
            end if;
        end if;
    end process;

end;
