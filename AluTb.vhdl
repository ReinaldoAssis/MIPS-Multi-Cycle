
-- AluTb.vhdl
-- Author: Reinaldo Miranda de Assis
-- Date: 2023-04-21
-- Description: ALU Testbench

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- Instruction	funccode/Function	
-- add 	    100000	
-- addu 	100001	
-- addi 	001000	
-- and 	    100100	
-- andi 	001100	
-- div 	    011010	
-- divu 	011011	 
-- mult 	011000	
-- multu 	011001	
-- nor 	    100111	
-- or 	    100101	
-- ori 	    001101	
-- sll 	    000000	
-- sllv 	000100	
-- sra 	    000011	
-- srav 	000111	
-- srl 	    000010	
-- srlv 	000110	
-- sub 	    100010	
-- subu 	100011	
-- xor 	    100110	
-- xori 	001110	

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
            zero : out std_logic
        );
    end component alu;

    signal a, b : std_logic_vector(31 downto 0);
    signal func : std_logic_vector(5 downto 0);
    signal shift : std_logic_vector(4 downto 0);
    signal result : std_logic_vector(31 downto 0);
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

            wait;
        end process;
end;