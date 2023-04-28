
-- AluTb.vhdl
-- Author: Reinaldo Miranda de Assis
-- Date: 2023-04-21
-- Description: ALU Testbench

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- Instruction	funccode/Function	
-- add 	    100000	    x 
-- addu 	100001	    x
-- addi 	001000	    x
-- and 	    100100	    x
-- andi 	001100	    x
-- div 	    011010	    x
-- divu 	011011	    x
-- mult 	011000	    x
-- multu 	011001	    x
-- nor 	    100111	    x
-- or 	    100101	    x
-- ori 	    001101	    x
-- sll 	    000000	    x
-- sllv 	000100      x
-- sra 	    000011	    x
-- srav 	000111	    x
-- srl 	    000010	    x
-- srlv 	000110	    x
-- sub 	    100010	    x
-- subu 	100011	    x
-- xor 	    100110	    x
-- xori 	001110	    x

entity alutb is
end alutb;

architecture behavior of alutb is

    component alu is
        port (
            a, b : in std_logic_vector(31 downto 0);
            clk : in std_logic;
            func : in std_logic_vector(5 downto 0);
            shift : in std_logic_vector(4 downto 0);
            result : out std_logic_vector(31 downto 0);
            highreg : out std_logic_vector(31 downto 0);
            zero : out std_logic
        );
    end component alu;

    signal a, b : std_logic_vector(31 downto 0);
    signal func : std_logic_vector(5 downto 0);
    signal shift : std_logic_vector(4 downto 0);
    signal result : std_logic_vector(31 downto 0);
    signal highreg : std_logic_vector(31 downto 0);
    signal zero : std_logic;
    signal clk : std_logic;

begin
    
        uut : alu port map (
            a => a,
            b => b,
            clk => clk,
            func => func,
            shift => shift,
            result => result,
            highreg => highreg,
            zero => zero
        );
    
        clk_process :process
        begin
                clk <= '0';
                wait for 10 ns;
                clk <= '1';
                wait for 10 ns;
        end process;

        process
        begin
            a <= "00000000000000000000000000000000";
            b <= "00000000000000000000000000000000";

            func <= "100000"; -- add

            wait for 100 ns;
            assert result = "00000000000000000000000000000000" report "add failed" severity error;
            assert zero = '1' report "add failed" severity error;

            a <= "00000000000000000000000000000001";
            b <= "00000000000000000000000000000001";
            func <= "100001"; -- addu
            wait for 100 ns;
            assert result = "00000000000000000000000000000010" report "addu failed" severity error;
            assert zero = '0' report "addu failed" severity error;

            a <= "00000000000000000000000000000001";
            b <= "11111111111111111111111111111111"; -- twos complement of 0x"00000001"
            func <= "100000"; -- add
            wait for 100 ns;
            assert result = "00000000000000000000000000000000" report "add failed" severity error;
            assert zero = '1' report "add failed" severity error;

            a <= "00000000000000000000000000000011";
            b <= "00000000000000000000000000000101";
            func <= "100010"; -- sub
            wait for 100 ns;
            assert result = "11111111111111111111111111111110" report "sub failed" severity error;
            assert zero = '0' report "sub failed" severity error;

            func <= "100100"; -- and
            wait for 100 ns;
            assert result = "00000000000000000000000000000001" report "and failed" severity error;
            assert zero = '0' report "and failed" severity error;

            func <= "100101"; -- or
            wait for 100 ns;
            assert result = "00000000000000000000000000000111" report "or failed" severity error;
            assert zero = '0' report "or failed" severity error;

            func <= "000000"; -- sll 
            shift <= "00001";
            wait for 100 ns;
            assert result = "00000000000000000000000000000110" report "sll failed" severity error;
            assert zero = '0' report "sll failed" severity error;

            func <= "000010"; -- srl
            wait for 100 ns;
            assert result = "00000000000000000000000000000001" report "srl failed" severity error;
            assert zero = '0' report "srl failed" severity error;

            a <= "10000000000000000000000000000111";
            shift <= "00011";
            func <= "000011"; -- sra
            wait for 100 ns;
            assert result = "11110000000000000000000000000000" report "sra failed" severity error;
            assert zero = '0' report "sra failed" severity error;

            a <= "00000000000000000000000001100111";
            b <= "00000000000000000000000000000101";
            func <= "100110"; -- xor
            wait for 100 ns;
            assert result = "00000000000000000000000001100010" report "xor failed" severity error;
            assert zero = '0' report "xor failed" severity error;

            func <= "100111"; -- nor
            wait for 100 ns;
            assert result = "11111111111111111111111110011000" report "nor failed" severity error;
            assert zero = '0' report "nor failed" severity error;

            func <= "000100"; -- sllv
            wait for 100 ns;
            assert result = "00000000000000000000110011100000" report "sllv failed" severity error;
            assert zero = '0' report "sllv failed" severity error;

            func <= "000110"; -- srlv
            wait for 100 ns;
            assert result = "00000000000000000000000000000011" report "srlv failed" severity error;
            assert zero = '0' report "srlv failed" severity error;

            a <= "10000000000000000000000000000111";
            b <= "00000000000000000000000000000101";
            func <= "000111"; -- srav
            wait for 100 ns;
            assert result = "11111100000000000000000000000000" report "srav failed" severity error;
            assert zero = '0' report "srav failed" severity error;

            
            a <= "00000000000000000000000000000101";
            b <= "00000000000000000000000000000010";
            func <= "011000"; -- mult
            wait for 100 ns;
            assert highreg = "00000000000000000000000000000000" report "mult failed" severity error;
            assert result = "00000000000000000000000000001010" report "mult failed" severity error;
            assert zero = '0' report "mult failed" severity error;

            func <= "011010"; -- div
            wait for 100 ns;
            assert highreg = "00000000000000000000000000000001" report "div failed" severity error;
            assert result = "00000000000000000000000000000010" report "div failed" severity error;
            assert zero = '0' report "div failed" severity error;


            wait;
        end process;
end;