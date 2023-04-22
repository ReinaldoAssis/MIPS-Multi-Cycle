LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY registertb IS
END registertb;

ARCHITECTURE behavior OF registertb IS 

    -- Component Declaration for the Unit Under Test (UUT)

    COMPONENT register32
    PORT(
         data_in : IN  std_logic_vector(31 downto 0);
         load    : IN  std_logic;
         clr     : IN  std_logic;
         clk     : IN  std_logic;
         data_out: OUT std_logic_vector(31 downto 0)
        );
    END COMPONENT;

   --Inputs
   signal data_in : std_logic_vector(31 downto 0) := (others => '0');
   signal load : std_logic := '0';
   signal clr : std_logic := '0';
   signal clk : std_logic := '0';

   --Outputs
   signal data_out : std_logic_vector(31 downto 0);

BEGIN

    -- Instantiate the Unit Under Test (UUT)
   uut: register32 PORT MAP (
          data_in => data_in,
          load => load,
          clr => clr,
          clk => clk,
          data_out => data_out
        );

   -- Clock process definitions
   clk_process :process
   begin
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
   end process;

   -- Stimulus process
   stim_proc: process
   begin        
        -- Reset the component
        clr <= '1';
        wait for 20 ns;
        clr <= '0';

        -- Load some data into the register
        data_in <= x"ABCD1234"; -- Load in hex
        load <= '1';
        wait for 20 ns;
        load <= '0';

        -- Check the output data
        assert data_out = x"ABCD1234"
            report "Error: Data output is not as expected"
            severity error;

        -- Load some new data into the register
        data_in <= x"56789ABC"; -- Load in hex
        load <= '1';
        wait for 20 ns;
        load <= '0';

        -- Check the output data
        assert data_out = x"56789ABC"
            report "Error: Data output is not as expected"
            severity error;

        -- Load in some new data but don't enable the load signal
        data_in <= x"FEDCBA98"; -- Load in hex
        wait for 20 ns;

        -- Check that the output data hasn't changed
        assert data_out = x"56789ABC"
            report "Error: Data output is not as expected"
            severity error;

        wait;
   end process;

END;