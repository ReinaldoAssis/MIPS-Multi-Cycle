-- Unit.vhdl
-- Author: Reinaldo Miranda de Assis
-- Date: 2023-04-17
-- Description: Unit controller for the MIPS processor
-- Revision: 0.1

-- -------------------------------
-- Uses an internal state machine to control the signals
-- Utiliza uma máquina de estados interna para controlar os sinais

-- The state machine diagram can be found in the file "UnitFSM.pdf"
-- O diagrama da máquina de estados pode ser encontrado no arquivo "UnitFSM.pdf"
-- -------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity unit is
    port (
        clk: in std_logic;
        opcode: in std_logic_vector(5 downto 0);
        func: in std_logic_vector(5 downto 0);
        PCSrc: out std_logic;
        PCWriteCond: out std_logic;
        PCWrite: out std_logic;
        ALUCtrl: out std_logic_vector(5 downto 0);
        AluSrcA: out std_logic;
        AluSrcB: out std_logic_vector(1 downto 0);
        RegDst: out std_logic;
        RegWrite: out std_logic;
        MemToReg: out std_logic;
        MemRead: out std_logic;
        MemWrite: out std_logic;
        IorD: out std_logic;
        InstRegWrite: out std_logic
    );
end unit;

architecture behavior of unit is

    signal state: std_logic_vector(3 downto 0) := "0000";

begin

    process(clk)
    begin
        if rising_edge(clk) then
           

        end if;
    end process;

end behavior;
    
