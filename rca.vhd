
library ieee;
use ieee.std_logic_1164.all;
-- use ieee.std_logic_unsigned.all;
 use ieee.numeric_std.all;


entity rca is
	generic (
		N : positive := 12
	);

	port (
		x   : in  std_logic_vector(N -1 downto 0);
		y   : in  std_logic_vector(N -1 downto 0);
		c0  : in  std_logic;

		s   : out std_logic_vector(N -1 downto 0);
		cn  : out std_logic
	) ;
end entity ; -- rca



architecture struct of rca is
	component fa
		port(
		x    : in std_logic;
		y    : in std_logic;
		cin  : in std_logic;

		s    : out std_logic;
		cout : out std_logic
	);
	end component;
	signal c : std_logic_vector(N  downto 0);
begin
	c(0) <= c0;
	cn <= c(N);   
	-- ripple carry adder generator
	GEN_RCA: for i in 0 to N-1 generate
		i_fa : fa port map( x(i), y(i), c(i), s(i), c(i+1) );
	end generate;
	
end struct;





