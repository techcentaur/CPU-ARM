----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/04/2018 11:03:33 PM
-- Design Name: 
-- Module Name: PROCESSOR - Behavioral
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

entity PROCESSOR is
  Port ( 
  clock: std_logic);
end PROCESSOR;

architecture Behavioral of PROCESSOR is

signal outstate: std_logic_vector(3 downto 0);

        signal PCbW, IW, DW, AW, BW, CW, Bnew, MULnew, Fset, ResW, PW, RW, MW, MR, Rsrc2, TD, PinA: std_logic;
        signal M2R, IorD, Rsrc, Asrc1, Wsrc, Cnew, Carrynew : std_logic_vector(1 downto 0);
        signal TYPEW: std_logic_vector(3 downto 0);
        signal BCnew : std_logic_vector(2 downto 0);
        signal Shiftcontrol: std_logic_vector(1 downto 0);

signal flags: std_logic_vector(3 downto 0);
signal p: std_logic;
signal op: std_logic_vector(3 downto 0);
signal ins: std_logic_vector(31 downto 0);

signal nextstate: std_logic_vector(3 downto 0) := "1111";

begin
-- ACtrl : output -> opcode -----> datapath
ACtrl: entity work.Actrl port map(outstate, ins, op);
--BCtrl : output -> predicate: p-----------> main_control
BCtrl: entity work.BCtrl port map(flags, ins(31 downto 28), p);
--next_state: output -> outstate -------------> main_control
next_state: entity work.next_state port map(clock, nextstate, ins(27 downto 26), ins(20), ins, outstate);
-- main_control: input <- predicate, outstate, instruction_32bit :: output -> control_signal -------------------------------> datapath
main_control: entity work.main_control port map(p, outstate, ins, PCbW, IW, DW, AW, BW, CW, Bnew, MULnew, Fset, ResW, PW, RW, MW, MR, Rsrc2, TD, PinA, M2R, IorD, Rsrc, Asrc1, Wsrc, Cnew, Carrynew, BCnew, Shiftcontrol);
--datapath: input <- clock, all control signals, opcode ----------------------------------> output?
datapath: entity work.datapath port map(clock, PCbW, IW, DW, AW, BW, CW, Bnew, MULnew, Fset, ResW, PW, RW, MW, MR, Rsrc2, TD, PinA,  M2R, IorD, Rsrc, Asrc1, Wsrc, Cnew, Carrynew, BCnew, Shiftcontrol, op, ins);

process(clock)
   begin
   if clock='1' and clock'event then
       nextstate <= outstate;
   end if;
end process;
end Behavioral;
