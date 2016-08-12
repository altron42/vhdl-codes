-- Written By Jon Carrier
-- at http://carrierfrequency.blogspot.com.br/2013/11/here-is-yet-another-pwm-module-what.html

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity pwm is
  generic (
    prescale: integer := 0; --frequency(PWM_clk)=frequency(i_CLK/(prescale+1))
    quantas:  integer := 128  --PWM stages, determines granularity    
  );
  port (
    i_CLK:  in  std_logic;  --Main input clock signal 
    i_PWM:  in  std_logic_vector(7 downto 0); --Controls the Duty Cycle of o_PWM
    o_PWM:  out std_logic := '1' --The Pulse Width Modulated output signal
  );
end pwm;

architecture PWM_arch of pwm is
  signal  PWM_clk : std_logic :='0';  
  signal  PWM_acc : std_logic_vector(7 downto 0) := x"00";
begin

--PRESCALING PROCESS
--Generates the clock divided signal, frequency(PWM_clk)=frequency(i_CLK/(prescale+1))
--PWM_clk drives the rest of the PWM logic
  prescale_proc : process(i_CLK)
    variable  prescale_cnt : std_logic_vector(7 downto 0) := x"00";
  begin
    if rising_edge(i_CLK) then
      if prescale_cnt >= prescale then
        prescale_cnt := x"00";
        PWM_clk <= not PWM_clk;
      else
        prescale_cnt := prescale_cnt + 1;
      end if;
    end if;
  end process;
  
--ACCUMULATOR PROCESS
--Generates the accumlation variable PWM_acc
--This variable is used in the PWM as a means to determine
--when the PWM signal should switch.
  accumulate: process(PWM_clk)
  begin
    if falling_edge(PWM_clk) then
      if PWM_acc >= std_logic_vector(to_unsigned(quantas - 1, PWM_acc'length)) then
        PWM_acc <= x"00";
      else
        PWM_acc  <=  PWM_acc + 1;
      end if;
    end if;
  end process;
  
--PWM PROCESS
--Generates the PWM output signal, o_PWM
--i_PWM controls the output and specifies how many Time Quantas
--out of a Total Quanta the output must be set HIGH
  modulate : process(PWM_clk, i_PWM)
  begin
    if rising_edge(PWM_clk) then
      if PWM_acc >= i_PWM then
        o_PWM <= '0';
      elsif PWM_acc = x"00" then
        o_PWM <= '1';
      end if;     
    end if;
  end process;
  
end PWM_arch;
