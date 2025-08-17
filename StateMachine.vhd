-- BinaryBlast

-- A Mealy machine has outputs that depend on both the state and
-- the inputs.	When the inputs change, the outputs are updated
-- immediately, without waiting for a clock edge.  The outputs
-- can be written more than once per state or per clock cycle.

library ieee;
use ieee.std_logic_1164.all;

entity BinaryBlast is

	port
	(
		clk		: in	std_logic;
		btn	 	: in	std_logic;
		sw			: in	std_logic_vector(9 downto 0);
		led	 	: out	std_logic_vector(9 downto 0) := "0000000000"
		--svn_seg	: out	std_logic_vector(6 downto 0)
	);

end entity;

architecture rtl of BinaryBlast is

	
	signal rst	:	std_logic	:= '1';
	
	-- Build an enumerated type for the state machine
	type state_type is (s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14);

	-- Register to hold the current state
	signal state : state_type;

begin

	process (clk, btn)
	begin

		if rst = '1' then
			rst <= '0';
			state <= s0;

		elsif (rising_edge(clk)) then
			-- Determine the next state synchronously, based on
			-- the current state and the input
			case state is
				when s0=>
					if sw = "0000000000" then
						state <= s1;
					end if;
				when s1=>
					if sw = "0000000001" then
						state <= s2;
					end if;
				when s2=>
					if sw = "0000000011" then
						state <= s3;
					end if;
				when s3=>
					if sw = "0000000111" then
						state <= s4;
					end if;
				when s4=>
					if sw = "0000010001" then
						state <= s5;
					end if;
				when s5=>
					if sw = "0000101010" then
						state <= s6;
					end if;
				when s6=>
					if sw = "0001000101" then
						state <= s7;
					end if;
				when s7=>
					if sw = "0001111100" then
						state <= s8;
					end if;
				when s8=>
					if sw = "0010000000" then
						state <= s9;
					end if;
				when s9=>
					if sw = "0100000000" then
						state <= s10;
					end if;
				when s10=>
					if sw = "0110100100" then
						state <= s11;
					end if;
				when s11=>
					if sw = "1000000000" then
						state <= s12;
					end if;
				when s12=>
					if sw = "1111110010" then
						state <= s13;
					end if;
				when s13=>
					if sw = "1111111111" then
						state <= s14;
					end if;
				when s14=>
					if btn = '1' then
						state <= s0;
					end if;
			end case;

		end if;
	end process;

	-- Determine the output based only on the current state
	-- and the input (do not wait for a clock edge).
	process (state, sw)
	begin
			case state is
				when s0=>
					if sw = "0000000000" then
						led <= "1111111111";
					end if;
				when s1=>
					if sw = "0000000000" then
						led <= "0000000001";
					end if;
				when s2=>
					if sw = "0000000000" then
						led <= "0000000011";
					end if;
				when s3=>
					if sw = "0000000000" then
						led <= "0000000111";
					end if;
				when s4=>
					if sw = "0000000000" then
						led <= "0000010001";
					end if;
				when s5=>
					if sw = "0000000000" then
						led <= "0000101010";
					end if;
				when s6=>
					if sw = "0000000000" then
						led <= "0001000101";
					end if;
				when s7=>
					if sw = "0000000000" then
						led <= "0001111100";
					end if;
				when s8=>
					if sw = "0000000000" then
						led <= "0010000000";
					end if;
				when s9=>
					if sw = "0000000000" then
						led <= "0100000000";
					end if;
				when s10=>
					if sw = "0000000000" then
						led <= "0110100100";
					end if;
				when s11=>
					if sw = "0000000000" then
						led <= "1000000000";
					end if;
				when s12=>
					if sw = "0000000000" then
						led <= "1111110010";
					end if;
				when s13=>
					if sw = "0000000000" then
						led <= "1111111111";
					end if;
				when s14=>
					if sw = "1111111111" then
						led <= "1111111111";
					end if;
			end case;
	end process;

end rtl;

