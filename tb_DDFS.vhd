
library ieee;
use ieee.std_logic_1164.all;
-- use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity tb_DDFS is
end entity tb_DDFS;



architecture struct of tb_DDFS is

	constant N       : positive := 8;
	constant M       : positive := 8;

	constant clk_per :  TIME     := 1 ns;  -- clk period

	component DDFS is
			generic (
				N : positive := 8;
				M : positive := 8
			);
			port(
				clk   : in  std_logic;                      -- clk @ 125 MHz
				reset : in  std_logic;                      -- async reset
				wave  : in  std_logic_vector(2 downto 0);   -- Generated waveform.
				fw    : in  std_logic_vector(N-1 downto 0); -- frequency word
				yq    : out std_logic_vector(M-1 downto 0)  -- sin quantized. M is the size
			);

	end component;
		
	signal clk_ext   : std_logic := '0';
	signal reset_ext : std_logic := '1';
	signal wave_sel  : std_logic_vector(2 downto 0);
	signal fw_ext    : std_logic_vector(N-1 downto 0);
	signal yq_out    : std_logic_vector(M-1 downto 0);
	SIGNAL Testing   : Boolean := True;


	begin

		clk_ext <= NOT clk_ext AFTER clk_per/2 WHEN Testing;-- ELSE '0';

		i_dut1: DDFS
			generic map (N, M)
			port map(clk_ext, reset_ext, wave_sel, fw_ext, yq_out);

		drive_p: process
	  	begin
	  		wait for 80 ns;
	  		reset_ext <= '0';

			---- Square wave generation
			--wave_sel <= "000";
			--fw_ext <= std_logic_vector(to_unsigned(10, fw_ext'length));
			--wait for 800 ns;
			---- sin wave generation
			--wave_sel <= "001";
			--fw_ext <= std_logic_vector(to_unsigned(10, fw_ext'length));
			--wait for 800 ns;
			---- single sided positive triangular wave generation
			--wave_sel <= "010";
			--fw_ext <= std_logic_vector(to_unsigned(5, fw_ext'length));
			--wait for 800 ns;
			---- single sided negative triangular wave generation
			--wave_sel <= "011";
			--fw_ext <= std_logic_vector(to_unsigned(5, fw_ext'length));
			--wait for 800 ns;
			-- double sided triangular wave generation
			--wave_sel <= "100";
			--fw_ext <= std_logic_vector(to_unsigned(128, fw_ext'length));
			--wait for 800 ns;
			--single sided positive staircase wave.
			--wave_sel <= "101";
			--fw_ext <= std_logic_vector(to_unsigned(64, fw_ext'length));
			--wait for 800 ns;
			--single sided negative staircase wave.
			wave_sel <= "110";
			fw_ext <= std_logic_vector(to_unsigned(64, fw_ext'length));
			wait for 800 ns;
			-- staircase double sided wave generation
--			wave_sel <= "111";
	--		fw_ext <= std_logic_vector(to_unsigned(64, fw_ext'length));
		--	wait for 800 ns;

			-- no signal
			--wave_sel <= "010";
			--wait for 800 ns;

	  		Testing <= False;
	  		wait;
	  	end process;

end architecture struct;


