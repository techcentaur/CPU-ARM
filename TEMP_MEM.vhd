----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/10/2018 01:23:35 PM
-- Design Name: 
-- Module Name: TEMP_MEM - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TEMP_MEM is
 Port ( clock: in std_logic;
        addr : in STD_LOGIC_VECTOR (31 downto 0);
          data_in : in STD_LOGIC_VECTOR (31 downto 0);
          MW : in STD_LOGIC;
          MR : in STD_LOGIC;
          mem_read : out STD_LOGIC_VECTOR (31 downto 0));
end TEMP_MEM;

architecture Behavioral of TEMP_MEM is
type memory is array(0 to 1023) of std_logic_vector(31 downto 0);
signal mem: memory;
begin
    process(clock) is
    begin
        if clock='1' and clock'event then
            if MW = '1' then
                mem(to_integer(unsigned(addr))) <= data_in;
            end if;
            if MR = '1' then
                mem_read <= mem(to_integer(unsigned(addr)));
            end if;
        end if;
    end process;

end Behavioral;
