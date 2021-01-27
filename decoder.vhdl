
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all ;

entity decoder is
	port(	
		NVCAM_CLK: 		in std_logic;
		NVCAM_SYNC: 		in std_logic;
		NVCAM_VSYNC: 		in std_logic;
		NVCAM_LOCK: 		in std_logic;
		NVCAM_VALID: 		in std_logic;
		lcd_clk: 		out std_logic;
		lcd_pwm: 		out std_logic;
		lcd_hsync: 		out std_logic;
		lcd_vsync: 		out std_logic;
		lcd_de: 		out std_logic
		
	);
end decoder;

architecture decoder_arch of decoder is
	-- constant declaration
	constant h_screen:		integer := 500;
	constant v_screen:		integer := 300;
	
	-- internal signal declaration 
	signal row_counter:		unsigned(8 downto 0) := (others => '0');
	signal line_counter:		unsigned(8 downto 0) := (others => '0');

	
begin
	process (NVCAM_CLK)
	begin
		if rising_edge(NVCAM_CLK) then
			if (NVCAM_SYNC = '1') then  -- Sync pulse! But what kind?
				lcd_hsync <= '0';
				if (NVCAM_VSYNC = '1') then -- New frame
					line_counter <= (others => '0');
					lcd_vsync <= '0';
				elsif (NVCAM_VALID = '0') then -- New line of data starts
					row_counter <= (others => '0');
					line_counter <= line_counter + 1;
					lcd_de <= '1';
				elsif (NVCAM_VALID = '1') then -- New line of zeros
					line_counter <= line_counter + 1;
					if (line_counter >= v_screen) then  -- Time for a VSYNC pulse, we are still in the 'black' section from the NVCAM
						lcd_vsync <= '1';
					end if;	
				end if;	
			else
				row_counter	<= row_counter + 1;  -- Work our way across a horizontal line
				if (row_counter >= h_screen) then  -- We have reached the end of the screen, time for a HSYNC
					lcd_hsync <= '1';
					lcd_de <= '0';	-- No more data for this frame is valid, lets just ignore everything from here on...
				end if;
			end if;
		end if;
	end process;

	lcd_clk <= NVCAM_CLK;
	lcd_pwm <= '1';
	
end decoder_arch;
