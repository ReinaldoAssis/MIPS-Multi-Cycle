-- Processor.vhdl
-- Author: Reinaldo Miranda de Assis
-- Date: 2023-05-05
-- Description: The central component for the MIPS Multicycle Processor
-- Revision: 0.1

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
use ieee.numeric_std.all;
USE IEEE.NUMERIC_STD.ALL;

entity processor is 
end processor;

architecture Behavioral of processor is

    -- Component Declaration

    -- component unit is
    --     port (
    --         clk: in std_logic;
    --         opcode: in std_logic_vector(5 downto 0);
    --         func: in std_logic_vector(5 downto 0);
    --         PCSrc: out std_logic;
    --         PCWriteCond: out std_logic;
    --         PCWrite: out std_logic;
    --         ALUCtrl: out std_logic_vector(5 downto 0);
    --         AluSrcA: out std_logic;
    --         AluSrcB: out std_logic_vector(1 downto 0);
    --         RegDst: out std_logic;
    --         RegWrite: out std_logic;
    --         MemToReg: out std_logic;
    --         MemRead: out std_logic;
    --         MemWrite: out std_logic;
    --         IorD: out std_logic;
    --         InstRegWrite: out std_logic
    --     );
    -- end component unit;

    component alu is 
        port (
            a, b : in std_logic_vector(31 downto 0);
            clk : in std_logic;
            func : in std_logic_vector(5 downto 0);
            shift : in std_logic_vector(4 downto 0);
            result : out std_logic_vector(31 downto 0); --TODO: add overflow 
            highreg : out std_logic_vector(31 downto 0);
            zero : out std_logic
        );
    end component alu;

    component register32 is 
        port(
        data_in   : IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- data input
        load  : IN STD_LOGIC; -- load/enable.
        clr : IN STD_LOGIC; -- async. clear.
        clk : IN STD_LOGIC; -- clock.
        data_out   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) -- output
    );
    end component register32;

    component register_bank is 
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
    end component register_bank;

    component Mem is 
        port (
            clk: in std_logic;
            rd: in std_logic; -- read
            wr: in std_logic; -- write
            addr: in std_logic_vector(31 downto 0);
            data_in: in std_logic_vector(31 downto 0);
            data_out: out std_logic_vector(31 downto 0)
        );
    end component Mem;

    --general
    signal clk : std_logic;

    --unit
    signal opcode: std_logic_vector(5 downto 0);
    signal func: std_logic_vector(5 downto 0);
    signal PCSrc: std_logic;
    signal PCWriteCond: std_logic;
    signal PCWrite: std_logic;
    signal aLUCtrl: std_logic_vector(5 downto 0);
    signal aluSrcA: std_logic;
    signal aluSrcB: std_logic_vector(1 downto 0);
    signal regDst: std_logic;
    signal regWrite: std_logic;
    signal memToReg: std_logic;
    signal memRead: std_logic := '0';
    signal memWrite: std_logic := '0';
    signal IorD: std_logic;
    signal instRegWrite: std_logic;

    --alu
    signal a: std_logic_vector(31 downto 0);
    signal b: std_logic_vector(31 downto 0);
    signal aluout: std_logic_vector(31 downto 0);
    signal highreg: std_logic_vector(31 downto 0);
    signal shift: std_logic_vector(4 downto 0);
    signal zero: std_logic;

    --Mem
    signal memAddr: std_logic_vector(31 downto 0) := (others => '0');
    signal memDatain: std_logic_vector(31 downto 0);
    signal memDataout: std_logic_vector(31 downto 0);

    --PC
    signal PC: std_logic_vector(31 downto 0) := (others => '0');

    --Instruction Register
    signal IR: std_logic_vector(31 downto 0) := (others => '0');

    --Control
    signal stage: std_logic_vector(1 downto 0) := "00";
    signal start: std_logic := '0';
    signal rt : std_logic_vector(4 downto 0);
    signal rd : std_logic_vector(4 downto 0);

    begin

    alu1: alu port map (
        a => a,
        b => b,
        clk => clk,
        func => func,
        shift => shift,
        result => aluout,
        highreg => highreg,
        zero => zero
    );

    mem1: Mem port map (
        clk => clk,
        rd => memRead,
        wr => memWrite,
        addr => memAddr,
        data_in => memDatain,
        data_out => memDataout
    );

    -- generates the clock
    clk_process: process begin
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
    end process;
    

    --unit
    -- ctrlunit: unit port map (
    --     clk => clk,
    --     opcode => opcode,
    --     func => func,
    --     PCSrc => PCSrc,
    --     PCWriteCond => PCWriteCond,
    --     PCWrite => PCWrite,
    --     ALUCtrl => ALUCtrl,
    --     AluSrcA => AluSrcA,
    --     AluSrcB => AluSrcB,
    --     RegDst => RegDst,
    --     RegWrite => RegWrite,
    --     MemToReg => MemToReg,
    --     MemRead => memRead,
    --     MemWrite => MemWrite,
    --     IorD => IorD,
    --     InstRegWrite => InstRegWrite
    -- );

    
    process
    begin

    wait for 300 ns;

    if rising_edge(clk) and start = '0' then -- idk why this condition is not being met AAAAA
        memDatain <= x"00094020";
        memWrite <= '1';

        wait for 100 ns;

        start <= '1';
    end if;

    if rising_edge(clk) and start = '1' then -- for some wild reason, start is not being set to 1
        
        --Fetch
        if stage = "00" then
            memAddr <= PC;
            memRead <= '1';
            memWrite <= '0';
            IR <= memDataout;
            PC <= PC + 4;
            stage <= "01";

            wait for 100 ns;

        
        --Decode
        elsif stage = "01" then
            opcode <= IR(31 downto 26);
            func <= IR(5 downto 0);
            rt <= IR(25 downto 21);
            rd <= IR(20 downto 16);
            shift <= IR(10 downto 6);
            stage <= "10";

            --Todo: calculate branch address
            wait for 3000 ns;

        end if;


    end if;

    end process;

end Behavioral;






