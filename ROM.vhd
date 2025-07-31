library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package log_package is
	function log2_int(din: integer) return integer; --Rom Derinliği 
end package;

package body log_package is
	
	function log2_int(din: integer) return integer is
		variable Result: integer;
	begin
		for i in 0 to 31 loop
			if(din = (2**i ) ) then
				Result := i;
				exit;
			end if;		
		end loop;	
	return Result;	
	end function log2_int;

end package body log_package;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use work.log_package.all;

entity ROM is
	Generic(
		ROM_DEPT: integer := 30;
		ROM_WIDTH: integer := 4
	);
	Port ( 
		clk: in std_logic; 
		we_rom: in std_logic; 
		din_addr: in std_logic_vector((log2_int(ROM_DEPT) - 1) downto 0);
		dout: out std_logic_vector(ROM_WIDTH - 1 downto 0)
	);
end ROM;
architecture Behavioral of ROM is

	type t_DROM is array(ROM_DEPT - 1 downto 0) of std_logic_vector(ROM_WIDTH - 1 downto 0); 
	
	constant c_DROM: t_DROM := ( X"0", X"3", X"6", X"9", X"0", X"3", X"6", X"9", X"0", X"3", X"6", X"9", X"0", X"3", X"6", X"9", X"0", X"3",
	X"6", X"9", X"0", X"3", X"6", X"9", X"0", X"3", X"6", X"9", X"0", X"6");
	
begin
	
	process(clk) begin 
		if(rising_edge(clk)) then
			if(we_rom = '1') then
				dout <= c_DROM(conv_integer(din_addr));
			end if;
		end if;
	end process;

end Behavioral;
