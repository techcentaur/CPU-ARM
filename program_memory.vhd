----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/20/2018 02:02:39 PM
-- Design Name: 
-- Module Name: program_memory - Behavioral
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

entity program_memory is
    Port ( clock: in std_logic;
            addr : in STD_LOGIC_VECTOR (31 downto 0);
           data : out STD_LOGIC_VECTOR (31 downto 0));
end program_memory;

architecture Behavioral of program_memory is
type memory is array(0 to 1023) of std_logic_vector(31 downto 0);
signal mem: memory;
begin
    process(clock) is
    begin
        if clock='1' and clock'event then
           data <= mem(to_integer(unsigned(addr)));
        end if;
    end process;
end Behavioral;
