LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

-- 32 bit register
ENTITY register32 IS PORT(
    data_in   : IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- data input
    load  : IN STD_LOGIC; -- load/enable.
    clr : IN STD_LOGIC; -- async. clear.
    clk : IN STD_LOGIC; -- clock.
    data_out   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) -- output
);
END register32;

ARCHITECTURE description OF register32 IS

BEGIN
    process(clk, clr)
    begin
        if clr = '1' then
            data_out <= x"00000000"; -- 0 in hex
        elsif rising_edge(clk) then
            if load = '1' then
                data_out <=  data_in;
            end if;
        end if;
    end process;
END description;