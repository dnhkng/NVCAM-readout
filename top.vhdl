

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

LIBRARY eagle_macro;
USE eagle_macro.EAGLE_COMPONENTS.ALL;

entity top is
	port(
		NVCAM_CLK: 		in std_logic;
		NVCAM: 			in std_logic_vector(13 downto 0);
		NVCAM_SYNC: 	in std_logic;
		NVCAM_VSYNC: 	in std_logic;
		NVCAM_LOCK: 	in std_logic;
		RST_N: 			in std_logic;
		R: 				out std_logic_vector(0 to 7);
		G: 				out std_logic_vector(0 to 7);
		B: 				out std_logic_vector(0 to 7);
		LCD_CLK: 		out std_logic;
		LCD_HSYNC: 		out std_logic;
		LCD_VSYNC: 		out std_logic;
		LCD_DEN: 		out std_logic;
		LCD_PWM: 		out std_logic	
	);
end top;

architecture top_arch of top is
	-- internal signal declaration 
	signal clk_lcd: 				std_logic;
	signal RST: 					std_logic;
	signal intensity:				std_logic_vector(7 downto 0);

 begin
	RST <= not RST_N;

	decoder_inst : Entity work.decoder
	port map (
		NVCAM_CLK => NVCAM_CLK,
		NVCAM_SYNC => NVCAM_SYNC,
		NVCAM_VSYNC => NVCAM_VSYNC,
		NVCAM_LOCK => NVCAM_LOCK,
		NVCAM_VALID => NVCAM(9),
		lcd_clk => LCD_CLK,
		lcd_pwm => LCD_PWM,
		lcd_hsync => LCD_HSYNC,
		lcd_vsync => LCD_VSYNC,
		lcd_de => LCD_DEN
    );
	
	B <= NVCAM(7 downto 0);
end top_arch;
