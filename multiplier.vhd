----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.02.2018 19:37:46
-- Design Name: 
-- Module Name: multiplier - Behavioral
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

entity multiplier is
    Port ( op1 : in STD_LOGIC_VECTOR (31 downto 0);
           op2 : in STD_LOGIC_VECTOR (31 downto 0);
           out1 : out STD_LOGIC_VECTOR (31 downto 0));
 end multiplier;

architecture Behavioral of multiplier is
signal outemp: std_logic_vector(63 downto 0);
begin
        outemp <= std_logic_vector(signed(op1)*signed(op2)); 
        out1(31 downto 0) <= outemp(31 downto 0);

end Behavioral;
