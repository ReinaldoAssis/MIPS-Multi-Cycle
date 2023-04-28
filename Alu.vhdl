-- Alu.vhdl
-- Author: Reinaldo Miranda de Assis
-- Date: 2023-04-17
-- Description: ALU for MIPS processor

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

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
use ieee.numeric_std.all;
USE IEEE.NUMERIC_STD.ALL;

entity alu is
    port (
        a, b : in std_logic_vector(31 downto 0);
        clk : in std_logic;
        func : in std_logic_vector(5 downto 0);
        shift : in std_logic_vector(4 downto 0);
        result : out std_logic_vector(31 downto 0); --TODO: add overflow 
        highreg : out std_logic_vector(31 downto 0);
        zero : out std_logic
    );
end alu;

architecture rtl of alu is
    signal a_s, b_s : signed(31 downto 0);
    signal result_s : signed(31 downto 0);
    signal multdiv_reg : signed(63 downto 0);



begin
    a_s <= signed(a);
    b_s <= signed(b);

    process (clk)
    begin
        -- func codes from standard MIPS instruction set
        if rising_edge(clk) then
            case func is
                when "000000" => -- sll
                    result_s <= a_s sll to_integer(unsigned(shift));
                when "000010" => -- srl
                    result_s <= a_s srl to_integer(unsigned(shift));
                when "000011" => -- sra
                    -- duplicates the sign bit when shifting right
                    result_s <= a_s sra to_integer(unsigned(shift));
                when "000100" => -- sllv
                    result_s <= a_s sll to_integer(unsigned(b_s));
                when "000110" => -- srlv
                    result_s <= a_s srl to_integer(unsigned(b_s));
                when "000111" => -- srav
                    result_s <= a_s sra to_integer(unsigned(b_s));
                when "001000" => -- addi
                    result_s <= a_s + b_s;
                when "001001" => -- addiu

                    -- One important difference between addi and addiu is that 
                    -- addi will set the overflow flag if the result is too large to fit in the register, 
                    -- while addiu will not.

                    -- the name addiu is a misnomer, because it does not add unsigned integers, instead it adds signed integers.

                    result_s <= a_s + b_s; 

                when "001100" => -- andi
                    result_s <= a_s and b_s;
                when "001101" => -- ori
                    result_s <= a_s or b_s;
                when "001110" => -- xori
                    result_s <= a_s xor b_s;
                when "011000" => -- mult
                    multdiv_reg <= a_s * b_s;
                    result_s <= multdiv_reg(31 downto 0);
                when "011001" => -- multu
                    multdiv_reg <= a_s * b_s;
                    result_s <= multdiv_reg(31 downto 0);
                when "011010" => -- div
                    result_s <= a_s / b_s;
                    multdiv_reg(63 downto 32) <= a_s mod b_s;
                when "011011" => -- divu
                    result_s <= a_s / b_s;
                    multdiv_reg(63 downto 32) <= a_s mod b_s;
                    
                when "100000" => -- add
                    result_s <= a_s + b_s;
                when "100001" => -- addu
                    -- See addiu comment
                    result_s <= a_s + b_s;

                when "100010" => -- sub
                    result_s <= a_s - b_s;
                when "100011" => -- subu
                    result_s <= a_s - b_s;
                when "100100" => -- and
                    result_s <= a_s and b_s;
                when "100101" => -- or
                    result_s <= a_s or b_s;
                when "100110" => -- xor
                    result_s <= a_s xor b_s;
                when "100111" => -- nor
                    result_s <= not(a_s or b_s);
                when others =>
                    result_s <= (others => '0');
            end case;

            if result_s = 0 then
                zero <= '1';
            else
                zero <= '0';
            end if;

            result <= std_logic_vector(result_s);
            highreg <= std_logic_vector(multdiv_reg(63 downto 32));

        end if;
    end process;
end rtl;
            