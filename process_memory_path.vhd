----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/07/2018 05:16:53 PM
-- Design Name: 
-- Module Name: process_memory_path - Behavioral
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

entity process_memory_path is
    Port ( data_pm : in STD_LOGIC_VECTOR (31 downto 0);
           data_mp : in STD_LOGIC_VECTOR (31 downto 0);
           type_data : in std_logic_vector (3 downto 0);
           outp : out STD_LOGIC_VECTOR (31 downto 0);
           outm : out STD_LOGIC_VECTOR (31 downto 0);
           write_en : out STD_LOGIC_VECTOR (3 downto 0);
           byte_off : in STD_LOGIC_VECTOR (1 downto 0));
end process_memory_path;

architecture Behavioral of process_memory_path is
begin
-- terminology
--0000 ldr
--0001 ldrb
--0010 ldrh
--0011 ldrsb
--0100 ldrsh
--0101 str
-- 0110 strb
-- 0111 strh

outm <= data_pm;
outp <= data_mp when (type_data = "0000") else
        "0000000000000000"&data_mp(15 downto 0) when (type_data="0010" or (data_mp(15)='0' and type_data="0100")) else
        "000000000000000000000000"&data_mp(7 downto 0) when (type_data="0001" or (data_mp(7)='0' and type_data="0011")) else
        "1111111111111111"&data_mp(15 downto 0) when (type_data="0100" and data_mp(15)='0') else
        "111111111111111111111111"&data_mp(7 downto 0) when (type_data="0011" and data_mp(7)='0');
        
write_en <= "1111" when (type_data = "0101") else
              "1100" when (type_data = "0111" and byte_off="00") else
              "0011" when (type_data = "0111" and byte_off="11") else
              "1000" when (type_data="0110" and byte_off="00") else
              "0100" when (type_data="0110" and byte_off="01") else
              "0010" when (type_data="0110" and byte_off="10") else
              "0001" when (type_data="0110" and byte_off="11");
             
end Behavioral;
