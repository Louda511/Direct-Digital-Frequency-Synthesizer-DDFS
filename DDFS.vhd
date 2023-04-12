
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DDFS is
	generic (
		N : positive := 8;
		M : positive := 8
	);
	port(
		clk       : in  std_logic;                      -- clk @ 125 MHz
		reset     : in  std_logic;                      -- async reset
		wave      : in  std_logic_vector(2   downto 0); -- Generated waveform.
		fw    	  : in  std_logic_vector(N-1 downto 0); -- frequency word
		--flag_sine : out  std_logic;                      -- flag_sine wave
		yq        : out std_logic_vector(M-1 downto 0)  -- sin quantized. M is the size
	);
end entity DDFS;

architecture struct of DDFS is

	component PhaseAccumulator is
		generic (
			N : positive
		);	
		port(
			clk    : in  std_logic;
			rst    : in  std_logic;
			pa_in  : in  std_logic_vector(N-1 downto 0);
			pa_out : out std_logic_vector(N-1 downto 0)
		);
	end component;
		

	component LUT_DDFS is
		port (
			LUT_line : in  std_logic_vector(7 downto 0);
			LUT_data : out std_logic_vector(7 downto 0) 
		);
	end component;

	signal pa_to_LUT  : std_logic_vector(N-1 downto 0); -- intermediate wire between PA and LUT
    signal lut_output : std_logic_vector(N-1 downto 0);

	begin

		i_PA: PhaseAccumulator generic map (N=>N) port map(clk, reset, fw, pa_to_LUT);
		i_LUT: LUT_DDFS port map(pa_to_LUT, lut_output);
		--if wave = "001" then
		--	flag_sine <= '1';
		--	else then
		--	flag_sine <= '0';
		--	end if;
		with wave select
			yq <= (pa_to_LUT and std_logic_vector(to_unsigned(128, pa_to_LUT'length))) 										 when "000", -- Square wave.
			      (lut_output)				                                    										         when "001", -- Sine wave.
				  (pa_to_LUT)														     										 when "010", -- single positive triangular wave.
				  (not pa_to_LUT)														 										 when "011", -- single negative triangular wave.
				  (pa_to_LUT and std_logic_vector(to_unsigned(64, pa_to_LUT'length) + to_unsigned(187, pa_to_LUT'length )))      when "100", -- double sided triangular wave.
				  (pa_to_LUT)														   											 when "101", -- single sided positive staircase wave.
				  (not pa_to_LUT)														   										 when "110", -- single sided negative staircase wave.
				  (lut_output)															   										 when "111", -- double sided staircase wave.
				  std_logic_vector(to_unsigned(0, yq'length))                            										 when others;

end struct;

