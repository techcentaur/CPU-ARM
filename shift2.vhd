----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.02.2018 15:18:44
-- Design Name: 
-- Module Name: shift2 - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity shift2 is
    Port ( op1 : in STD_LOGIC_VECTOR (31 downto 0);
           amount : in STD_LOGIC;
           out1 : out STD_LOGIC_VECTOR (31 downto 0);
           carry1 : out STD_LOGIC_VECTOR(0 downto 0);
           carryin: in STD_LOGIC_VECTOR(0 downto 0);
           shifttype: in STD_LOGIC_VECTOR(1 downto 0));
end shift2;

architecture Behavioral of shift2 is

begin

    out1(29 downto 2) <= (op1(31 downto 4)) when ((shifttype="11" or shifttype="01" or shifttype="10") and amount='1') else
                         op1(27 downto 0) when ((amount='1' and shifttype="00")) else
                         op1(29 downto 2) when amount='0';
    
    out1(31 downto 30) <= op1(1 downto 0) when (amount='1' and (shifttype="11")) else
                           "00" when (amount='1' and (shifttype="01" )) else
                           op1(31)&op1(31) when (amount='1' and (shifttype="10")) else
                           op1(29 downto 28) when ((amount='1' and shifttype="00")) else
                           op1(31 downto 30) when amount='0';

    out1(1 downto 0) <= "00" when (amount='1' and (shifttype="00")) else
                        op1(3 downto 2) when ((shifttype="11" or shifttype="01" or shifttype="10") and amount='1') else
                        op1(1 downto 0) when amount='0';
                
    carry1(0) <= op1(1) when ((shifttype="01" or shifttype="10") and amount='1') else
                op1(2) when ((shifttype="11") and amount='1') else
                op1(30) when ((shifttype="00") and amount='1') else
                carryin(0) when amount='0';
    

end Behavioral;
