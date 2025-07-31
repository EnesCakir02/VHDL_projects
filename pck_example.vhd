library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package math_op_pck is

function slv_to_int(slv: std_logic_vector) return integer;

function int_to_slv(value, bit_width: integer) return std_logic_vector;
 
function safe_add(a, b: integer; max_val: integer) return integer;  

function cal_parity(data : std_logic_vector) return std_logic;

end package;

package body math_op_pck is
    function slv_to_int(slv: std_logic_vector) return integer is
    begin
        return TO_INTEGER(unsigned(slv));
    end function; 
    function int_to_slv(value, bit_width: integer) return std_logic_vector is
    begin 
        return std_logic_vector(to_unsigned(value, bit_width));
    end function; 
    function safe_add(a, b: integer; max_val: integer) return integer is
    variable result: integer;  
    begin 
    result := a + b;
    if result > max_val then
        return max_val;
    else 
        return result;
    end if;
    end function;
    function cal_parity(data : std_logic_vector) return std_logic is
    variable parity: std_logic := '0';
    begin
        for i in data'range loop
            parity := parity xor data(i);
        end loop;
        return parity;         
    end function;
end package body math_op_pck;

library IEEE;
library work;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.math_op_pck.all;

entity pck_example is
    Port ( 
    a,b : in std_logic_vector(7 downto 0); 
    op  : in std_logic_vector(1 downto 0); 
    result: out std_logic_vector(7 downto 0);
    parity: out std_logic 
    );
end pck_example;

architecture Behavioral of pck_example is
    function slv_to_integer(data: std_logic_vector) return integer is 
    begin
        return to_integer(unsigned(data));
    end function; 
    signal a_int, b_int, res_int : integer;
begin
    a_int <= slv_to_int(a);
    b_int <= slv_to_int(b);
    
    cal_proc:process(a_int, b_int, op)
    begin 
        case op is
            when "00" => 
                res_int <= safe_add(a_int, b_int, 255);
            when others =>
                res_int <= 0;
        end case;      
    end process cal_proc;
    
    result <= int_to_slv(res_int, 8);
    
    parity <= cal_parity(int_to_slv(res_int, 8));
     
end Behavioral;
