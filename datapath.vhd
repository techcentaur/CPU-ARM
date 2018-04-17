----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/05/2018 01:13:28 PM
-- Design Name: 
-- Module Name: datapath - Behavioral
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

entity datapath is
  Port ( clock : in STD_LOGIC;
    PCbW, IW, DW , AW, BW, CW, Bnew, MULnew, Fset, ResW, PW, RW, MW, MR, Rsrc2, TD, PinA : in std_logic;
    M2R, IorD, Rsrc, Asrc1, Wsrc, Cnew, Carrynew : in std_logic_vector(1 downto 0);
    BCnew: in std_logic_vector(2 downto 0);
    Shiftcontrol: in std_logic_vector(1 downto 0);
    opc: in std_logic_vector(3 downto 0);
    ins: out std_logic_vector(31 downto 0)
  );
end datapath;

architecture Behavioral of datapath is


signal PC: std_logic_vector(31 downto 0) := "00000000000000000000000000000000"; 
signal PCb: std_logic_vector (31 downto 0);
signal RES: std_logic_vector (31 downto 0);
signal IR: std_logic_vector (31 downto 0);
signal DR: std_logic_vector (31 downto 0);
signal A, B, C, D: std_logic_vector (31 downto 0);
signal F: std_logic_vector(3 downto 0);

signal op1, op2, op3 :  STD_LOGIC_VECTOR (31 downto 0);
signal carry : STD_LOGIC_VECTOR(0 downto 0);
signal flags : STD_LOGIC_VECTOR (3 downto 0);
signal reset: std_logic;
signal mem_addr, mem_read, data_in: std_logic_vector (31 downto 0);
signal rd1, rd2, wrReg: std_logic_vector (3 downto 0);
signal wrData, dout1, dout2: std_logic_vector (31 downto 0);
signal progC, opr1, outp1: std_logic_vector (31 downto 0);
signal carry1: std_logic_vector(0 downto 0);
signal amount: std_logic_vector (4 downto 0);
signal shifttype: std_logic_vector (1 downto 0);
signal opr1_m, opr2_m, outp1_m: std_logic_vector (31 downto 0);
signal writeenable: std_logic_vector(3 downto 0);
signal data_pm : STD_LOGIC_VECTOR (31 downto 0);
signal data_mp : STD_LOGIC_VECTOR (31 downto 0);
signal type_data : std_logic_vector (3 downto 0);
signal outp : STD_LOGIC_VECTOR (31 downto 0);
signal outm : STD_LOGIC_VECTOR (31 downto 0);
signal write_en : STD_LOGIC_VECTOR (3 downto 0);
signal byte_off : STD_LOGIC_VECTOR (1 downto 0);
signal TYPEW: std_logic_vector(3 downto 0);
signal unassignedvalueofBorBL: std_logic_vector(31 downto 0);


begin

mem: entity work.TEMP_MEM port map(clock, mem_addr,data_in, MW, MR, mem_read);

regfile: entity work.regFile port map(clock,reset,RW,rd1,rd2,wrReg,wrData,dout1,dout2,ProgC);
alu: entity work.alu port map(op1,op2,opc,carry,op3,flags);
shifter: entity work.shifter port map (opr1,outp1,carry1,amount,shifttype);
multiplier: entity work.multiplier port map (opr1_m,opr2_m,outp1_m);
process_memory_path: entity work.process_memory_path port map(data_pm, data_mp, type_data, outp, outm, write_en, byte_off);


-- before memory unit
    with IorD select mem_addr <=
        PC when "00",
        RES when "01",
        A when "10",
        A when others;
    
    data_pm <= C;
    data_in <= outm;
    
    writeenable <= write_en;

-- before registerfile unit
    IR <= mem_read when (IW = '1');
    DR <= mem_read when (DW = '1');

    data_mp <= DR;
    
    type_data <= "0000" when TD='1' else 
                TYPEW;

    with M2R select wrData <= 
        RES when "00",
        outp when "01",
        PCb when ("10"),
        outp when others;

    with Rsrc2 select rd1<=
        IR(19 downto 16) when '0',
        IR(15 downto 12) when others;
    
    with Rsrc select rd2 <=
        IR(3 downto 0) when "00",
        IR(11 downto 8) when "01",
        IR(15 downto 12) when "10",
        IR(15 downto 12) when others;
        
    with Wsrc select wrReg <=
        IR(15 downto 12) when "00",
        "1110" when "01",
        IR(19 downto 16) when "10",
        IR(19 downto 16) when others;
    
    PCb <= PC when PCbW = '1';

-- before ALU        
    A <=PC when (PinA='1') else 
        dout1 when (AW = '1');
         
    B <= dout2 when BW = '1';
    C <= dout2 when CW = '1';
    
    with Asrc1 select op1 <=
        A when "00",
        PC when "01",
        "00000000000000000000000000000000" when "10",
        "00000000000000000000000000000000" when others;

    with Bnew select opr1 <=
        B when '0',
        "000000000000000000000000"&IR(7 downto 0) when others;

    with Cnew select amount <=
        C(4 downto 0) when "00",
        "00000" when "01",
        IR(11 downto 7) when "10",
        IR(11 downto 8)&'0' when others; --"11"

    with Shiftcontrol select shifttype<=
        "11" when "11",
        IR(6 downto 5) when others;
    
    with Carrynew select carry <=
        flags(0 downto 0) when "00",         --flags(0) is Carry bit
        carry1 when "01",
        carry1 when others;    

    with BCnew select op2 <=
        outp1 when "000",
        "00000000000000000000000000000001" when "001",
        outp1_m when "010",
        unassignedvalueofBorBL when "011",
        "00000000000000000000"&IR(11 downto 0) when "101",
        "00000000000000000000"&IR(11 downto 0) when others;

    unassignedvalueofBorBL <= IR(23)&IR(23)&IR(23)&IR(23)&IR(23)&IR(23)&IR(23)&IR(23)&IR(23 downto 0);


    opr1_m <= B;
    opr2_m <= C;

-- After ALU
    
    F <= (flags) when Fset = '1';
    RES <= op3 when ResW = '1';
    
    
    PC <= op3 when (IR(27 downto 25)="101" and PW='1') else 
          RES when PW = '1';
    
    ins <= IR;
    
   
 
end Behavioral;
