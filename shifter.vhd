----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.02.2018 13:43:20
-- Design Name: 
-- Module Name: shifter - Behavioral
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

entity shifter is
    Port ( op1 : in STD_LOGIC_VECTOR (31 downto 0);
           out1 : out STD_LOGIC_VECTOR (31 downto 0);
           carryout: out STD_LOGIC_VECTOR(0 downto 0);
           amount : in STD_LOGIC_VECTOR (4 downto 0);
           shifttype : in STD_LOGIC_VECTOR (1 downto 0));
end shifter;

architecture Behavioral of shifter is
signal outlsl : STD_LOGIC_VECTOR(31 downto 0);
signal carryy: STD_LOGIC_VECTOR(0 downto 0);

begin

shiftbytype: entity work.shiftbytype port map(op1,amount,outlsl,carryy,shifttype);


        out1<=outlsl;
        carryout <= carryy;
        
end Behavioral;