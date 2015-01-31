-- ---------------------------------------------------------------- --
--                                                                  --
--  Clock Divider                                                   --
--                                                                  --
--  Original from:                                                  --
--  https://www.mikrocontroller.net/articles/Clockgenerator_in_VHDL --
-- ---------------------------------------------------------------- --

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity clock_divider is
  generic (
    InputFreq  : integer := 50000000;
    OutputFreq : integer := 5
  );
  port (
    RST           : in std_logic;
    CLK           : in std_logic;
    CLKOUT        : out std_logic
  );
end clock_divider;



architecture rtl1 of clock_divider is

  -- log2 is used to get the MSB+1 of val
  function log2 (val: INTEGER) return natural is
    variable res : natural;
  begin
        for i in 0 to 31 loop
            if (val <= (2**i)) then
                res := i;
                exit;
            end if;
        end loop;
        return res;
  end function log2;

  function max(L, R: integer) return integer is
  begin
      if L > R then
          return L;
      else
          return R;
      end if;
  end;

  -- Greatest common divisor
  function GCD(v1 : integer; v2 : integer) return integer is
    variable a : integer;
    variable b : integer;
    variable h : integer;
  begin
    a := v1; b := v2;
    while (b /= 0) loop
      h := a mod b;
      a := b;
      b := h;
    end loop;
    return a;
  end;

  CONSTANT tmpGCD        : integer := GCD(2 * OutputFreq , InputFreq);
  CONSTANT Multiplikator : integer := 2 * OutputFreq / tmpGCD; -- Multiply by 2 because we generate clock edges
  CONSTANT Teiler        : integer := InputFreq / tmpGCD;
  CONSTANT N : integer := max(log2(Multiplikator), log2(Teiler));

  -- Clock mutliplier
  CONSTANT m : unsigned(N-1 downto 0) := to_unsigned(Multiplikator, N);
  -- Clock divisor
  CONSTANT d : unsigned(N-1 downto 0) := to_unsigned(Teiler, N);

  -- Counter register
  SIGNAL a : unsigned(N-1 downto 0) := to_unsigned(0, N);
  -- Output latch
  SIGNAL q : STD_LOGIC := '0';

begin

  -- Connect q with output
  CLKOUT <= q;

  -- Clock division with remainder
  pDiv: process(RST, CLK)
  begin
    if RST = '1' then
      a <= to_unsigned(0,N);
      q <= '0';
    elsif rising_edge(CLK) then
      if a > d then
        -- Subtract d to prevent overflow
        -- a will now hold the remainder of the division
        a <= a + m - d;
        -- Toggle the output
        q <= NOT q;
      else
        -- increase a by multiplier
        a <=  a + m;
      end if;
    end if;
  end process pDiv;

end rtl1;
-- EOF
