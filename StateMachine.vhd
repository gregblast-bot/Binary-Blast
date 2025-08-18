library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BinaryBlast is
    port
    (
        clk     : in  std_logic;
        btn     : in  std_logic;
        sw      : in  std_logic_vector(9 downto 0);
        led     : out std_logic_vector(9 downto 0);
        svn_seg : out std_logic_vector(47 downto 0) -- 6 digits x (7 segments + 1 DP)
    );
end entity;

architecture rtl of BinaryBlast is

    -- Build an enumerated type for the state machine
    type state_type is (s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14);

    -- Register to hold the current state
    signal state : state_type := s0;

    -- Signals for required values and their decimal equivalent
    signal required_sw : std_logic_vector(9 downto 0);
    signal decimal_val : natural range 0 to 1023;
    
-- Function to get the seven-segment and DP code for a single digit
    -- The output is 8 bits: (DP, a, b, c, d, e, f, g)
    -- It is active-low, so '0' turns a segment on.
    function seven_seg_decoder(digit : integer; dp_on : boolean) return std_logic_vector is
        variable seg_pattern : std_logic_vector(6 downto 0);
        variable dp_pattern  : std_logic;
    begin
        -- The mapping here is for segments a, b, c, d, e, f, g.
        case digit is
            when 0      => seg_pattern := "0000001"; -- 0
            when 1      => seg_pattern := "1001111"; -- 1
            when 2      => seg_pattern := "0010010"; -- 2
            when 3      => seg_pattern := "0000110"; -- 3
            when 4      => seg_pattern := "1001100"; -- 4
            when 5      => seg_pattern := "0100100"; -- 5
            when 6      => seg_pattern := "0100000"; -- 6
            when 7      => seg_pattern := "0001111"; -- 7
            when 8      => seg_pattern := "0000000"; -- 8
            when 9      => seg_pattern := "0000100"; -- 9
            when others => seg_pattern := "1111111"; -- All segments off
        end case;

        if dp_on then
            dp_pattern := '0';
        else
            dp_pattern := '1';
        end if;

        return dp_pattern & seg_pattern;
    end function;

begin

    -- State Transition Logic
    -- This process determines the next state synchronously on the rising edge of the clock.
    process (clk)
    begin
        if rising_edge(clk) then
            case state is
                when s0  => if sw = "0000000000" then state <= s1; end if;
                when s1  => if sw = "0000000001" then state <= s2; end if;
                when s2  => if sw = "0000000011" then state <= s3; end if;
                when s3  => if sw = "0000000111" then state <= s4; end if;
                when s4  => if sw = "0000010001" then state <= s5; end if;
                when s5  => if sw = "0000101010" then state <= s6; end if;
                when s6  => if sw = "0001000101" then state <= s7; end if;
                when s7  => if sw = "0001111100" then state <= s8; end if;
                when s8  => if sw = "0010000000" then state <= s9; end if;
                when s9  => if sw = "0100000000" then state <= s10; end if;
                when s10 => if sw = "0110100100" then state <= s11; end if;
                when s11 => if sw = "1000000000" then state <= s12; end if;
                when s12 => if sw = "1111110010" then state <= s13; end if;
                when s13 => if sw = "1111111111" then state <= s14; end if;
                when s14 => if btn = '1' then state <= s0; end if;
            end case;
        end if;
    end process;
    
    -- Output Logic (Mealy Machine)
    -- This process sets the required binary number based on the current state.
    process (state)
    begin
        case state is
            when s0  => required_sw <= "0000000000";
            when s1  => required_sw <= "0000000001";
            when s2  => required_sw <= "0000000011";
            when s3  => required_sw <= "0000000111";
            when s4  => required_sw <= "0000010001";
            when s5  => required_sw <= "0000101010";
            when s6  => required_sw <= "0001000101";
            when s7  => required_sw <= "0001111100";
            when s8  => required_sw <= "0010000000";
            when s9  => required_sw <= "0100000000";
            when s10 => required_sw <= "0110100100";
            when s11 => required_sw <= "1000000000";
            when s12 => required_sw <= "1111110010";
            when s13 => required_sw <= "1111111111";
            when s14 => required_sw <= "1111111111";
        end case;
    end process;

    -- Concurrent assignments for LEDs and decimal value
    led <= required_sw;
    decimal_val <= to_integer(unsigned(required_sw));

    -- Seven-Segment Display Decoder Logic
    -- This process converts the decimal value into an 8-bit pattern for each display.
    process (decimal_val)
        variable digit_val : integer;
        variable temp_val  : integer;
        variable svn_seg_temp : std_logic_vector(47 downto 0);
    begin
        temp_val := decimal_val;

        -- Assign the last four digits
        -- i=0 is the least significant digit (ones place)
        for i in 0 to 3 loop
            digit_val := temp_val mod 10;
            svn_seg_temp((i * 8) + 7 downto (i * 8)) := seven_seg_decoder(digit_val, false);
            temp_val := temp_val / 10;
        end loop;

        -- Assign the first two digits to '0' with no DP
        svn_seg_temp(47 downto 40) := seven_seg_decoder(0, false); -- 6th digit (most significant)
        svn_seg_temp(39 downto 32) := seven_seg_decoder(0, false); -- 5th digit
        
        -- To show a decimal point for illustration, let's put it on HEX2 for 1.023
        -- This is a specific case, you can adjust this logic as needed.
        if decimal_val = 1023 then
            svn_seg_temp(31 downto 24) := seven_seg_decoder(1, true);
            svn_seg_temp(23 downto 16) := seven_seg_decoder(0, false);
            svn_seg_temp(15 downto 8)  := seven_seg_decoder(2, false);
            svn_seg_temp(7 downto 0)   := seven_seg_decoder(3, false);
        end if;
        
        svn_seg <= svn_seg_temp;
    end process;

end rtl;