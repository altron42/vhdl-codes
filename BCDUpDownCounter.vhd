-- Created by Micael Pimentel
-- More at github.com/altron42/vhdl-codes

Library IEEE;
Use IEEE.STD_LOGIC_1164.all;
Use IEEE.STD_LOGIC_UNSIGNED.all;
Use IEEE.NUMERIC_STD.all;

Entity BCDUpDownCounter Is
   Port (
      trig, rst, sel : In Std_Logic;
      x : Out Std_Logic_Vector(3 Downto 0));
End BCDUpDownCounter;

Architecture Counter Of BCDUpDownCounter Is
Begin
   Process(trig, rst)
		Variable count : Std_Logic_Vector(3 Downto 0) := "0000";
	Begin
	   If rst = '0' Then
		   count := "0000";
		ElsIf rising_edge(trig) Then
		   If sel = '0' Then
			   count := count + "01";
			   If count >= "1010" Then count := "0000"; End If;
			Else
			   count := count - "01";
				If count >= "1010" Then count := "1001"; End If;
			End If;
		End If;
		x <= count;
	End Process;
End Counter;
