----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.02.2018 15:51:32
-- Design Name: 
-- Module Name: regFile - Behavioral
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
library UNISIM;
use UNISIM.VComponents.all;

entity regFile is
    Port ( clock : in STD_LOGIC;
           reset: in STD_LOGIC;
           write_enable: in std_logic;
           rd_addr1: in std_logic_vector(3 downto 0);
           rd_addr2: in std_logic_vector(3 downto 0);
           wr_addr: in std_logic_vector(3 downto 0);
           wr_data: in std_logic_vector(31 downto 0);
           rd_data1: out std_logic_vector(31 downto 0);
           rd_data2: out std_logic_vector(31 downto 0);
           program_counter: out std_logic_vector(31 downto 0));
end regFile;

architecture Behavioral of regFile is
type t_rfile is array (0 to 15) of std_logic_vector(31 downto 0);
signal rfile: t_rfile;

begin
process (clock) is
begin
    if clock='1' and clock'event then
        if write_enable = '1' then
            rfile(to_integer(unsigned(wr_addr))) <= wr_data;
        else
            rd_data1 <= rfile(to_integer(unsigned(rd_addr1)));
            rd_data2 <= rfile(to_integer(unsigned(rd_addr2)));
        end if;
        if reset='1' then
            program_counter <= "00000000000000000000000000000000";
        else
            program_counter <= rfile(15);
        end if;
    end if;
end process;
end Behavioral;
