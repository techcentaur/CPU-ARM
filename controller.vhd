----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/13/2018 01:41:07 PM
-- Design Name: 
-- Module Name: controller - Behavioral
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

entity controller is
--  Port ( );
end controller;

architecture Behavioral of controller is
--type STATE_TYPE IS(fetch, rdAB, arith, addr, brn, wrRF, wrM, rdM, M2RF);
signal state: std_logic_vector(3 downto 0);
begin


end Behavioral;

-----------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
--type STATE_TYPE IS(fetch 0 , rdAB 1, arith 2, addr 3, brn 4, wrRF 5, wrM 6, rdM 7, M2RF 8, rdRFagain 9);

entity ins_decoder is
  Port ( 
         ins: in std_logic_vector(31 downto 0);
         ins_states: out std_logic_vector(3 downto 0));
end ins_decoder;

architecture Behavioral of ins_decoder is
begin

    ins_states<= "0000" when (ins(27 downto 25)="001") else
                 "0001" when (ins(27 downto 25)="000" and ins(4)='0') else
                 "0010" when (ins(27 downto 25)="000" and ins(4)='1' and ins(7)='0' and ins(11 downto 8)/="1111") else
                 "0011" when (ins(27 downto 23)="00000" and ins(7 downto 4)="1001") else
                 "0100" when (ins(27 downto 25)="000" and ins(22)='1' and ins(7)='1' and ins(4)='1' and ins(6 downto 5)/="00") else
                 "0101" when (ins(27 downto 25)="000" and ins(22)='0' and ins(7)='1' and ins(4)='1' and ins(6 downto 5)/="00") else
                 "0110" when (ins(27 downto 25)="010") else
                 "0111" when (ins(27 downto 25)="011" and ins(4)='0') else
                 "1000" when (ins(27 downto 25)="011" and ins(4)='1') else
                 "1001" when (ins(27 downto 25)="101") else
                 "1111";
end Behavioral;

--0 -> DP imm
--1 -> DP ShAmt imm
--2 -> DP ShAmt reg
--3 -> MUL,MLA
--4 -> Halfword DT reg offset
--5 -> Halfword DT imm offset
--6 -> DT imm offset
--7 -> DT reg offset
--8 -> undefined
--9 ->  B,BL
--15 -> not implemented


-----------------------------------------------------------------------------
-------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity BCtrl is
  Port ( flags: in std_logic_vector(3 downto 0);
        ins: in std_logic_vector(3 downto 0);
        p: out std_logic );
end BCtrl;

architecture Behavioral of BCtrl is

begin
-- flags 3-CVNZ-0
with ins select p <=
    flags(0) when "0000",
    (not flags(0)) when "0001",
    (flags(3)) when "0010",
    (not flags(3)) when "0011",
    (flags(1)) when "0100",
    (not flags(1)) when "0101",
    (flags(2)) when "0110",
    (not flags(2)) when "0111",
    (flags(2) and (not flags(0))) when "1000",
    (not (flags(2) and (not flags(0)))) when "1001",
    (not (flags(2) xor flags(1))) when "1010",
    ((flags(2) xor flags(1))) when "1011",
    ((not flags(0)) and (not (flags(2) xor flags(1)))) when "1100",
    (not ((not flags(0)) and (not (flags(2) xor flags(1))))) when "1101",
    '1' when "1110",
    '0' when others;

end Behavioral;

------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
--type STATE_TYPE IS(fetch 0 , rdAB 1, arith 2, addr 3, brn 4, wrRF 5, wrM 6, rdM 7, M2RF 8, rdRFagain 9);

entity next_state is
  Port ( clock: in std_logic;
        state: in std_logic_vector(3 downto 0);
        ins2726: in std_logic_vector(1 downto 0);
        ins20: in std_logic;
        ins: in std_logic_vector(31 downto 0);
        outstate: out std_logic_vector(3 downto 0));
end next_state;

architecture Behavioral of next_state is
begin
process(clock) is
begin
    if clock='1' and clock'event then
        if state="1111" then outstate<="0000";
        elsif state="0000" then outstate<="0001";
        elsif state="0001" then
            if ins2726 = "00" then 
                if (ins(25 downto 23)="000" and ins(7 downto 4)="1001") then outstate<="1001";
                elsif (ins(25)='0' and ins(11 downto 8)/="1111" and ins(7)='0' and ins(4)='1') then outstate<="1001";
                else outstate<="0010";
                end if;
            elsif ins2726="01" then outstate<="0011";
            elsif ins2726="10" then outstate<="0100";
            end if;
        elsif state="0010" then outstate<="0101";
        elsif state="0011" then
            if ins20='0' then outstate<="0110";
            else outstate<="0111";
            end if;
        elsif state="0100" then outstate<="0000";
        elsif state="0101" then outstate<="0000";
        elsif state="0110" then outstate<="0000";
        elsif state="0111" then outstate<="1000";
        elsif state="1000" then outstate<="0000";
        elsif state="1001" then outstate<="0010";
        end if;
    end if;
end process;
end Behavioral;

-----------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
--type STATE_TYPE IS(fetch 0 , rdAB 1, arith 2, addr 3, brn 4, wrRF 5, wrM 6, rdM 7, M2RF 8, rdRFagain 9);


entity control_state is
  Port ( clock: in std_logic;
        state: in std_logic_vector(3 downto 0);
        outstate: out std_logic_vector(3 downto 0));
end control_state;

architecture Behavioral of control_state is
begin
process(clock) is
begin
    if clock='1' and clock'event then
        outstate<=state;
    end if;
end process;
end Behavioral;


-----------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
--type STATE_TYPE IS(fetch 0 , rdAB 1, arith 2, addr 3, brn 4, wrRF 5, wrM 6, rdM 7, M2RF 8, rdRFagain 9);

entity ACtrl is
  Port ( state: in std_logic_vector(3 downto 0);
         ins: in std_logic_vector(31 downto 0);
         op: out std_logic_vector(3 downto 0));
end ACtrl;

architecture Behavioral of ACtrl is
signal ins_states: std_logic_vector(3 downto 0);
begin
ins_decoder: entity work.ins_decoder port map(ins, ins_states);

    op <= "1101" when (ins_states="0011" and state="0010" and ins(21)='0') else
          "0100" when (ins_states="0011" and state="0010" and ins(21)='1') else
          "0100" when (state="0100") else
          "0100" when (state="0011" and ins(23)='1' and (ins_states="0110" or ins_states="0111" or ins_states="0100" or ins_states="0101")) else
          "0010" when (state="0011" and ins(23)='0' and (ins_states="0110" or ins_states="0111" or ins_states="0100" or ins_states="0101")) else
          "0100" when (state="0000") else
          ins(24 downto 21);
          
end Behavioral;

-----------------------------------------------------------------------------

--0 -> DP imm
--1 -> DP ShAmt imm
--2 -> DP ShAmt reg
--3 -> MUL,MLA
--4 -> Halfword DT reg offset
--5 -> Halfword DT imm offset
--6 -> DT imm offset
--7 -> DT reg offset
--8 -> undefined
--9 ->  B,BL
--15 -> not implemented

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
--type STATE_TYPE IS(fetch 0 , rdAB 1, arith 2, addr 3, brn 4, wrRF 5, wrM 6, rdM 7, M2RF 8, rdRFagain 9);

entity main_control is
  Port ( 
        p: in std_logic;
        state: in std_logic_vector(3 downto 0);
        ins: in std_logic_vector(31 downto 0);
        PCbW, IW, DW, AW, BW, CW, Bnew, MULnew, Fset, ResW, PW, RW, MW, MR, Rsrc2, TD, PinA: out std_logic;
        M2R, IorD, Rsrc, Asrc1, Wsrc, Cnew, Carrynew : out std_logic_vector(1 downto 0);
        BCnew : out std_logic_vector(2 downto 0);
        Shiftcontrol: out std_logic_vector(1 downto 0)
          );
end main_control;

architecture Behavioral of main_control is
signal ins_states: std_logic_vector(3 downto 0);
begin
ins_decoder: entity work.ins_decoder port map(ins, ins_states);
 
    PinA <= '1' when (state="0001" and ins_states="1001") else
            '0';
 
    TD <= '1' when (state="1000" and ins_states="0110") else
            '0';
 
   MR <= '1' when (state="0000" or state="0111") else
          '0';
 
   ResW <= ('1' and p) when (state="0010" or state="0011") else
            '1' when (state="0000") else
            '0';
    
   PW <= ('1') when ((state="0001" and ins_states/="1001") or state="0100") else
         '0';
    
   Bnew <= '1' when (ins_states="0000") else 
           '0';
    
   Fset <= ('1' and p) when (ins(20)='1' and (state="0010" or state="0011")) else
            '0';

    with state select DW <=
        ('1' and p) when "0111",
        '0' when others;

    IorD <= "01" when (state="0110" or state="0111") else
            "10" when (ins(24)='0' and ins(27 downto 25)="010" and state="0110" and ins(20)='0') else
            "10" when (ins(24)='0' and ins(27 downto 25)="011" and ins(4)='0' and state="0110" and ins(20)='0') else
            "00" when (state="0000");

    with state select MW <=
        ('1' and p) when "0110",
        '0' when others;
        
    
    with state select IW <=
        '1' when ("0000"),
        '0' when others;
    
    
    RW <= ('1' and p) when (state="0101" or state="1000" or (state="0001" and ins_states="1001") or (state="0110" and (ins_states="0110" or ins_states="0111") and ins(21)='1')) else
          '0';
    
    with state select AW <=
        ('1' and p) when ("0001"),
        '0' when others;

    with state select BW <=
        ('1' and p) when ("0001"),
        '0' when others;


    CW <= ('1' and p) when (state="1001" or (ins_states="0110" and state="0001")) else
          '0' ;

    PCbW <= ('1' and p) when (state="0001" and ins_states="1001") else
            '0';

    Wsrc <= "01" when (ins_states="1001" and state="0001") else
            "10" when (ins_states="0011" and state="0101") else
            "10" when (state="0110" and ins_states="0110" and ins(21)='1') else
            "00";

    Rsrc <= "01" when (ins_states="0010" and state="1001") else    --second state read
            "00" when (ins_states="0010" and state="0001") else    --first state read 
            "01" when (ins_states="0011" and state="1001") else  --second read
            "00" when (ins_states="0011" and state="0001") else  --first read
            "10" when (ins_states="0110" and state="0001") else
            "00";  
                   
                
    Rsrc2 <= '1' when (ins_states="0011") else
            '0';

    Asrc1 <= "01" when (state = "0000") else 
             "10" when ((ins_states="0011" and ins(21)='0' and state="0010") or  ((ins(24 downto 21)="1101" or ins(24 downto 21)="1111") and state="0010")) else
             "00" when ((ins_states="1001" and state="0001")) else
             "00";
             
    Cnew <=  "00" when (ins_states="0010" and state="1001") else
             "11" when (ins_states="0000" and state="0001") else
             "10" when (ins_states="0001" and state="0001") else
             "10" when (ins_states="0111" and state="0011");
             
             --0 -> DP imm
             --1 -> DP ShAmt imm
             --2 -> DP ShAmt reg
             --3 -> MUL,MLA
             --4 -> Halfword DT reg offset
             --5 -> Halfword DT imm offset
             --6 -> DT imm offset
             --7 -> DT reg offset
             --8 -> undefined
             --9 ->  B,BL
             --15 -> not implemented

    BCnew <= "011" when (ins_states="1001" and state/="0000") else
             "010" when (ins_states="0011") else
             "101" when ((ins_states="0110" and state="0011") or ((ins(24 downto 21)="1101" or ins(24 downto 21)="1111") and state="0010")) else
             "001" when (state="0000") else
             "000"; --output of shifter - which will be same as B when not workings

    M2R <=   "10" when (state="0001" and ins_states="1001") else
             "01" when (state="1000") else
             "00" when (state="0110" and ins_states="0110") else
             "00";
    
    Carrynew <= "01" when (ins(31 downto 28)="1101" or ins(31 downto 28)="1111") else
                "00";
    
    Shiftcontrol <= "11" when (ins_states="0000" and state="0001") else
                    "00";
    
end Behavioral;

----------------------------------------------------------------------------------