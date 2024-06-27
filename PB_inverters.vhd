-- Authors: Ruben Rehal, Mihir Seth

library ieee;
use ieee.std_logic_1164.all;

-- The inverter function is employed to convert the buttons from an active-low to an active-high configuration

entity PB_inverters is
    port (
        rst_n  : in  std_logic;                       -- Input signal for reset (active low)
        rst    : out std_logic;                       -- Output signal for reset (active high)
        pb_n   : in  std_logic_vector(3 downto 0);    -- Input signals for buttons (active low)
        pb     : out std_logic_vector(3 downto 0)     -- Output signals for buttons (active high)
    );
end PB_inverters;

architecture ckt of PB_inverters is
begin
    pb  <= NOT(pb_n);    -- Invert the input buttons to make them active high
    rst <= NOT(rst_n);   -- Invert the input reset signal to make it active high
end ckt;
