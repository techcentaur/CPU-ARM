----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/05/2018 01:18:15 PM
-- Design Name: 
-- Module Name: memory - Behavioral
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

entity memory is
    Port ( clock : in STD_LOGIC;
           addr : in STD_LOGIC_VECTOR (31 downto 0);
           data_in : in STD_LOGIC_VECTOR (31 downto 0);
           mem_write : in STD_LOGIC;
           mem_read : in STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR (31 downto 0));
end memory;


architecture Behavioral of memory is
type memory is array(0 to 1023) of std_logic_vector(31 downto 0);
signal mem: memory;
begin
    process(clock) is
    begin
        if clock='1' and clock'event then
            if mem_write = '1' then
                mem(to_integer(unsigned(addr))) <= data_in;
            end if;
            if mem_read='1' then
                data_out <= mem(to_integer(unsigned(addr)));
            end if;
        end if;
    end process;
end Behavioral;
