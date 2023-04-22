-- DataMem.vhdl
-- Author: Reinaldo Miranda de Assis
-- Date: 2023-04-17
-- Description: Data memory for MIPS processor

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Mem is 
    port (
        clk: in std_logic;
        rd: in std_logic; -- read
        wr: in std_logic; -- write
        addr: in std_logic_vector(31 downto 0);
        data_in: in std_logic_vector(31 downto 0);
        data_out: out std_logic_vector(31 downto 0)
    );
end Mem;

architecture Behavioral of Mem is
    type mem_type is array (0 to 1023) of std_logic_vector(31 downto 0);
    signal memvar: mem_type := (others => (others => '0')); -- memory array
    begin
        process(clk)
        begin
            if rising_edge(clk) then
                if wr = '1' then
                    memvar(to_integer(unsigned(addr))) <= data_in;
                end if;
                if rd = '1' then
                    data_out <= memvar(to_integer(unsigned(addr)));
                end if;
            end if;
        end process;
end Behavioral;