library ieee;
use ieee.std_logic_1164.all;

entity BinaryBlast is
    port
    (
        clk     : in  std_logic;
        btn     : in  std_logic;
        sw      : in  std_logic_vector(9 downto 0);
        led     : out std_logic_vector(9 downto 0)
    );
end entity;

architecture rtl of BinaryBlast is

    -- Build an enumerated type for the state machine
    type state_type is (s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14);

    -- Register to hold the current state
    signal state : state_type;

begin

    -- State Transition Logic
    -- This process determines the next state based on the current state and inputs.
    process (clk)
    begin
        if rising_edge(clk) then
            -- Determine the next state
            case state is
                when s0 =>
                    if sw = "0000000000" then
                        state <= s1;
                    end if;
                when s1 =>
                    if sw = "0000000001" then
                        state <= s2;
                    end if;
                when s2 =>
                    if sw = "0000000011" then
                        state <= s3;
                    end if;
                when s3 =>
                    if sw = "0000000111" then
                        state <= s4;
                    end if;
                when s4 =>
                    if sw = "0000010001" then
                        state <= s5;
                    end if;
                when s5 =>
                    if sw = "0000101010" then
                        state <= s6;
                    end if;
                when s6 =>
                    if sw = "0001000101" then
                        state <= s7;
                    end if;
                when s7 =>
                    if sw = "0001111100" then
                        state <= s8;
                    end if;
                when s8 =>
                    if sw = "0010000000" then
                        state <= s9;
                    end if;
                when s9 =>
                    if sw = "0100000000" then
                        state <= s10;
                    end if;
                when s10 =>
                    if sw = "0110100100" then
                        state <= s11;
                    end if;
                when s11 =>
                    if sw = "1000000000" then
                        state <= s12;
                    end if;
                when s12 =>
                    if sw = "1111110010" then
                        state <= s13;
                    end if;
                when s13 =>
                    if sw = "1111111111" then
                        state <= s14;
                    end if;
                when s14 =>
                    if btn = '1' then
                        state <= s0;
                    end if;
            end case;
        end if;
    end process;

    -- Output Logic (Mealy Machine)
    -- The LED output depends on the current state AND the required switch pattern for the next state.
    -- This way, the LEDs display the pattern the user needs to match.
    process (state)
    begin
        case state is
            when s0 =>
                led <= "0000000000"; -- User needs to set switches to 0000000000 to advance
            when s1 =>
                led <= "0000000001"; -- User needs to set switches to 0000000001 to advance
            when s2 =>
                led <= "0000000011";
            when s3 =>
                led <= "0000000111";
            when s4 =>
                led <= "0000010001";
            when s5 =>
                led <= "0000101010";
            when s6 =>
                led <= "0001000101";
            when s7 =>
                led <= "0001111100";
            when s8 =>
                led <= "0010000000";
            when s9 =>
                led <= "0100000000";
            when s10 =>
                led <= "0110100100";
            when s11 =>
                led <= "1000000000";
            when s12 =>
                led <= "1111110010";
            when s13 =>
                led <= "1111111111";
            when s14 =>
                led <= "1111111111"; -- Final state, all LEDs on
        end case;
    end process;

end rtl;