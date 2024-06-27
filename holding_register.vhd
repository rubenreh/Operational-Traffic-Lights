-- Authors: Ruben Rehal, Mihir Seth

library ieee;
use ieee.std_logic_1164.all;

-- The "register" function is utilized to hold the output of the synchronizer
-- This output signal from the synchronizer needs to remain active until a specific pattern is detected
-- The signal is cleared from the holding register when the required state is reached.

entity holding_register is
    port (
        clk         : in  std_logic;    -- global clock signal
        reset       : in  std_logic;    -- asynchronous reset signal
        register_clr: in  std_logic;    -- signal which is used to clear the holding registers
        din         : in  std_logic;    -- input into the register coming from the synchronizer
        dout        : out std_logic     -- output signal which will be connected to the state machine
    );
end holding_register;

architecture circuit of holding_register is
    signal sreg   : std_logic;          -- output signal from the register which will be updated by the input for every rising edge
    signal output : std_logic;          -- signal which will be updated according to a set of combinational logic
begin
    processHolding: process(clk)
    begin
        output <= (sreg OR din) AND NOT(register_clr); -- combinational logic derived from the lab manual
        if (rising_edge(clk)) then                      -- register utilizes positive edge flip flop
            if (reset = '1') then                       -- Asynchronous clear the output signal based on pb(3)
                sreg <= '0';
            else
                sreg <= output;                        -- Modifying the value of the output signal.
            end if;
        end if;
        dout <= sreg;                                  -- The final output signal is updated according to changes in the "sreg" signal.
    end process;
end circuit;
