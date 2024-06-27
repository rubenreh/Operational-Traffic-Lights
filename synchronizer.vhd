-- Authors: Group 2, Mihir Seth, Ruben Rehal

library ieee;
use ieee.std_logic_1164.all;

-- The function synchronizes external signals to a shared global clock
-- signal by connecting two register stages in series, both clocked by the same signal

entity synchronizer is port (
    clk   : in  std_logic;  -- global clock signal
    reset : in  std_logic;  -- asynchronous reset signal linked with pb(3)
    din   : in  std_logic;  -- external input
    dout  : out std_logic   -- output signal from the synchronizer
);
end synchronizer;

architecture circuit of synchronizer is
    signal sreg : std_logic_vector(1 downto 0);  -- 2 bit signal with first bit assigned to the output of first register
                                                 -- and second bit assigned to the output of second register
BEGIN
    sync_process: process(clk)
    begin
        if (rising_edge(clk)) then  -- The register is synchronized with the global clock, utilizing a positive-edge-triggered flip-flop.
            sreg(1) <= sreg(0);     -- changing the output of the second register
            if (reset = '1') then   -- If a reset is applied, the first register changes to 0
                sreg(0) <= '0';
            else
                sreg(0) <= din;     -- changing the value of the first register
            end if;
        end if;
        dout <= sreg(1);            -- output synchronized from the second register
    end process;
end circuit;
