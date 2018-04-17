----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.02.2018 17:04:24
-- Design Name: 
-- Module Name: alu - Behavioral
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

entity alu is
    Port ( op1 : in STD_LOGIC_VECTOR (31 downto 0);
           op2 : in STD_LOGIC_VECTOR (31 downto 0);
           opc : in STD_LOGIC_VECTOR (3 downto 0);
           carry : in STD_LOGIC_VECTOR(0 downto 0); -- conversion std_logic -> signed ??
           op3 : out STD_LOGIC_VECTOR (31 downto 0);
           flags : out STD_LOGIC_VECTOR (3 downto 0));
end alu;

--flag terminology + setF terminology -> NZVC 

architecture Behavioral of alu is
signal outtemp: std_logic_vector (31 downto 0);
signal setF: std_logic_vector(3 downto 0);
signal c31: std_logic;
signal c32: std_logic;
signal noresult: std_logic;
begin

--        setF <= "0000";
--        noresult <= '0';
--        flags <= "0000";

    outtemp <= (op1 and op2) when opc="0000" else
                (op1 xor op2) when opc="0001" else
                (std_logic_vector(signed(op1)+signed(not op2)+1)) when opc="0010" else
                (std_logic_vector(signed(not op1)+1+signed(op2))) when opc="0011" else
                (std_logic_vector(signed(op1)+signed(op2))) when opc="0100" else
                (std_logic_vector(signed(op1)+signed(op2)+signed(carry))) when opc="0101" else
                (std_logic_vector(signed(op1)+signed(not op2)+signed(carry))) when opc="0110" else
                (std_logic_vector(signed(not op1)+signed(op2)+signed(carry))) when opc="0111" else
                (op1 and op2) when opc="1000" else
                (op1 xor op2) when opc="1001" else
                (std_logic_vector(signed(op1)+signed(not op2)+1)) when opc="1010" else
                (std_logic_vector(signed(not op1)+1+signed(op2))) when opc="1011" else
                (op1 or op2) when opc="1100" else
                (op2) when opc="1101" else
                (op1 and (not op2)) when opc="1111" else
                not op2;

     
     noresult <= '1' when (opc="1000" or opc="1001" or opc="1010" or opc="1011") else
                '0';
          
     setF(3 downto 2) <= "11" when (opc="1100" or opc="1101" or opc="1110" or opc="1111" or opc="1000" or opc="0000" or opc="0001" or opc="1001");
     
     setF(3 downto 0) <= "1111" when (opc="0010" or opc="0011" or opc="0100" or opc="0101" or opc="0110" or opc="0111" or opc="1010" or opc="1011");
     
     flags(3) <= '1' when (setF(3)='1' and outtemp(31)='1');
     
     flags(2) <= '1' when (setF(2)='1' and outtemp="0000000000000000000000000000000");
       
     c31 <= (op1(31) xor op2(31) xor outtemp(31));   
     c32 <= ((op1(31) and c31) xor (op2(31) and c31) xor (op2(31) and op1(31)));
     
     flags(0) <= c32 when (setF(0) = '1');
     
     flags(1) <= (c32 xor c31)  when(setF(1)='1');

     op3 <= outtemp when (noresult = '0');
    
 end Behavioral;
