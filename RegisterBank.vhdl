-- register_bank.vhdl
-- Author: Reinaldo Miranda de Assis
-- Date: 2023-04-17
-- Description: Register bank for the MIPS processor

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE IEEE.NUMERIC_STD.ALL;


entity register_bank is
    port (
        clk : in std_logic;
        reset : in std_logic;
        write_enable : in std_logic;
        write_register : in std_logic_vector(4 downto 0);
        write_data : in std_logic_vector(31 downto 0);
        read_address1 : in std_logic_vector(4 downto 0);
        read_address2 : in std_logic_vector(4 downto 0);
        enable : in std_logic;
        A : out std_logic_vector(31 downto 0);
        B : out std_logic_vector(31 downto 0)
    );
end register_bank;

architecture register_bank_arch of register_bank is
    type register_bank_type is array (0 to 31) of std_logic_vector(31 downto 0);
    
    -- array of registers
    signal reg_bank : register_bank_type := (others => (others => '0')); -- initialize all registers to 0
    
    begin
    process(clk, reset)
    begin
        if reset = '1' then
            reg_bank <= (others => (others => '0'));
        elsif rising_edge(clk) then
            if write_enable = '1' then
                reg_bank(to_integer(unsigned(write_register))) <= write_data;
            end if;
        end if;
    end process;
    process(read_address1, read_address2)
    begin
        if enable = '1' then
            A <= reg_bank(to_integer(unsigned(read_address1)));
            B <= reg_bank(to_integer(unsigned(read_address2)));
        end if;
    end process;
end register_bank_arch;