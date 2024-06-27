-- Authors: Group 2, Mihir Seth, Ruben Rehal

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity State_Machine_Example is
  port (
    clk_input, reset, IO, I1, I2 : in std_logic;
    output1, output2 : out std_logic
  );
end entity;

architecture SM of State_Machine_Example is

  type STATE_NAMES is (S0, S1, S2, S3, S4, S5, S6, S7); -- list all the STATE_NAMES values
  signal current_state, next_state : STATE_NAMES; -- signals of type STATE_NAMES

begin

  -- -----------------------------------------------------
  -- State Machine:
  -- -----------------------------------------------------

  -- REGISTER_LOGIC PROCESS EXAMPLE
  Register_Section: process (clk_input) -- this process updates with a clock
  begin
    if rising_edge(clk_input) then
      if (reset = '1') then
        current_state <= S0;
      elsif (reset = '0') then
        current_state <= next_state;
      end if;
    end if;
  end process;

  -- TRANSITION LOGIC PROCESS EXAMPLE
  Transition_Section: process (IO, I1, I2, current_state)
  begin
    case current_state is
      when S0 =>
        if (IO='1') then
          next_state <= S1;
        else
          next_state <= S0;
        end if;
      when S1 =>
        next_state <= S2;
      when S2 =>
        if ((IO='1')) then
          next_state <= S6;
        elsif (I1='1') then
          next_state <= S3;
        else
          next_state <= S2;
        end if;
      when S3 =>
        if (IO='1') then
          next_state <= S4;
        else
          next_state <= S3;
        end if;
      when S4 =>
        next_state <= S5;
      when S5 =>
        next_state <= S0;
      when S6 =>
        if (IO='1') then
          next_state <= S7;
        else
          next_state <= S6;
        end if;
      when S7 =>
        if (I2='1') then
          next_state <= S0;
        else
          next_state <= S7;
        end if;
      when others =>
        next_state <= S0;
    end case;
  end process;

  -- DECODER SECTION PROCESS EXAMPLE (MOORE FORM SHOWN)
  Decoder_Section: process (current_state)
  begin
    case current_state is
      when S0 =>
        output1 <= '1';
        output2 <= '0';
      when S1 =>
        output1 <= '0';
        output2 <= '0';
      when S2 =>
        output1 <= '0';
        output2 <= '0';
      when S3 =>
        output1 <= '0';
        output2 <= '0';
      when S4 =>
        output1 <= '0';
        output2 <= '0';
      when S5 =>
        output1 <= '0';
        output2 <= '0';


