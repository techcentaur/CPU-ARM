----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.02.2018 14:09:12
-- Design Name: 
-- Module Name: shiftbytype - Behavioral
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

entity shiftbytype is
    Port ( opr1 : in STD_LOGIC_VECTOR (31 downto 0);
           amount : in STD_LOGIC_VECTOR (4 downto 0);
           output : out STD_LOGIC_VECTOR (31 downto 0);
           carry : out STD_LOGIC_VECTOR(0 downto 0);
           shifttype: in STD_LOGIC_VECTOR(1 downto 0));
end shiftbytype;

architecture Behavioral of shiftbytype is
signal out01: STD_LOGIC_VECTOR (31 downto 0);
signal carry01: STD_LOGIC_VECTOR(0 downto 0);
signal out02: STD_LOGIC_VECTOR (31 downto 0);
signal carry02: STD_LOGIC_VECTOR(0 downto 0);
signal out04: STD_LOGIC_VECTOR (31 downto 0);
signal carry04: STD_LOGIC_VECTOR(0 downto 0);
signal out08: STD_LOGIC_VECTOR (31 downto 0);
signal carry08: STD_LOGIC_VECTOR(0 downto 0);
signal out16: STD_LOGIC_VECTOR (31 downto 0);
signal carry16 :STD_LOGIC_VECTOR(0 downto 0);
begin
shift1: entity work.shift1 port map(opr1,amount(0),out01,carry01,"0", shifttype);
shift2: entity work.shift2 port map(out01,amount(1),out02,carry02,carry01,shifttype);
shift4: entity work.shift4 port map(out02,amount(2),out04,carry04,carry02,shifttype);
shift8: entity work.shift8 port map(out04,amount(3),out08,carry08,carry04,shifttype);
shift16: entity work.shift16 port map(out08,amount(4),out16,carry16,carry08,shifttype);

            output <= out16;
            carry <= carry16;

end Behavioral;
