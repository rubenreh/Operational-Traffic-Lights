-- Authors: Ruben Rehal, Mihir Seth

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY LogicalStep_Lab4_top IS
    PORT (
        clkin_50       : in std_logic;                             -- The 50 MHz FPGA clock input
        rst_n          : in std_logic;                             -- The RESET input (ACTIVE LOW)
        pb_n           : in std_logic_vector(3 downto 0);          -- The push-button inputs (ACTIVE LOW)
        sw             : in std_logic_vector(7 downto 0);          -- The switch inputs
        leds           : out std_logic_vector(7 downto 0);         -- for displaying the lab4 project details
        ---------------------------------------------------------
        -- Temporary output ports can be added here for debugging purposes or to include internal signals
        -- for simulations
        ---------------------------------------------------------
        sm_clk_en      : out std_logic;
        blink_signal   : out std_logic;
        NS_red_show    : out std_logic;
        NS_amber_show  : out std_logic;
        NS_green_show  : out std_logic;
        EW_red_show    : out std_logic;
        EW_amber_show  : out std_logic;
        EW_green_show  : out std_logic;
        ---------------------------------------------------------
        seg7_data      : out std_logic_vector(6 downto 0);        -- 7-bit outputs to a 7-segment
        seg7_char1     : out std_logic;                           -- 7 Seven Display digit selectors
        seg7_char2     : out std_logic                            -- 7 Seven Display digit selectors
    );
END LogicalStep_Lab4_top;

ARCHITECTURE SimpleCircuit OF LogicalStep_Lab4_top IS
    component segment7_mux port (
        clk    : in std_logic := '0';
        DIN2   : in std_logic_vector(6 downto 0); -- Bits 6 to 0 that represent segments G,F,E,D,C,B,A
        DIN1   : in std_logic_vector(6 downto 0); -- Bits 6 to 0 that represent segments G,F,E,D,C,B,A
        DOUT   : out std_logic_vector(6 downto 0);
        DIG2   : out std_logic;
        DIG1   : out std_logic
    );
    end component;

    component clock_generator port (
        sim_mode  : in boolean;   -- The clocking frequency for the output signals "sm_clken" and "blink" is determined by the selection process
        reset     : in std_logic; -- The input utilized for clocking the counter and register
        clkin     : in std_logic; -- The output employed to enable the state machine to progress by one clock cycle.
        sm_clken  : out std_logic;
        blink     : out std_logic -- The output utilized for generating the blink signal, which operates at a frequency one-fourth that of the "sm_clken" signal.
    );
    end component;

    component pb_inverters port (
        rst_n : in std_logic;                      -- input reset signal
        rst   : out std_logic;                     -- output reset signal
        pb_n  : in std_logic_vector(3 downto 0);   -- input button signals
        pb    : out std_logic_vector(3 downto 0)   -- output button signals
    );
    end component;

    component synchronizer port (
        clk    : in std_logic;  -- global clock signal
        reset  : in std_logic;  -- asynchronous reset signal linked with pb(3)
        din    : in std_logic;  -- external input
        dout   : out std_logic  -- output signal from the synchronizer
    );
    end component;

    component holding_register port (
        clk          : in std_logic;  -- global clock signal
        reset        : in std_logic;  -- asynchronous reset signal
        register_clr : in std_logic;  -- signal which is used to clear the holding registers
        din          : in std_logic;  -- input into the register coming from the synchronizer
        dout         : out std_logic  -- output signal which will be connected to the state machine
    );
    end component;

    component PB_filters port (
        clkin        : in std_logic;
        rst_n        : in std_logic;
        rst          : out std_logic;
        pb_n         : in std_logic_vector(3 downto 0);
        pb_n_filtered: out std_logic_vector(3 downto 0)
    );
    end component;

    component TLC_State_Machine port (
        clk            : in std_logic;
        clk_enable     : in std_logic;
        reset          : in std_logic;
        NS_INPUT       : in std_logic;
        EW_INPUT       : in std_logic;
        blink_signal   : in std_logic;
        ns_red         : out std_logic;
        ns_amber       : out std_logic;
        ns_green       : out std_logic;
        ew_red         : out std_logic;
        ew_amber       : out std_logic;
        ew_green       : out std_logic;
        state_number   : out std_logic_vector(3 downto 0)
    );
    end component;

    ---------------------------------------------------------
    CONSTANT sim_mode : boolean := FALSE; -- FALSE for LogicalStep board downloads, TRUE for simulations
    ---------------------------------------------------------
    signal sm_clken, blink_sig         : std_logic;                  -- The "sm_clken" signal serves as the enabling input for the register section within the state machine
                                                                      -- The "blink_sig" signal is utilized as the blinking clock for the EW (East-West) and NS (North-South) green signals.
    signal pb_n_filter, pb             : std_logic_vector(3 downto 0);-- Buttons used for multiple different functions
    signal rst, rst_n_filtered         : std_logic;                  -- Reset variable inserted within the holding register
    signal ns_synch_output, ew_synch_output : std_logic;             -- Synchronizer output for NS / EW
    signal synch_rst                   : std_logic;                  -- Global reset variable
    signal ns_register_out             : std_logic;                  -- Holding register output for NS
    signal ew_register_out             : std_logic;                  -- Holding register output for EW
    signal ns_red, ns_amber, ns_green  : std_logic;                  -- Signals related to the status of the light for the North-South (NS) direction.
    signal ew_red, ew_amber, ew_green  : std_logic;                  -- Combined output displayed on the FBGA board for the North-South (NS) direction.
                                                                      -- Signals corresponding to the state of the light for the East-West (EW) direction.
signal ns_output: std_logic_vector(6 downto 0);
signal ew_red, ow_amber, aw_green: std_logic;
-- Combined output displayed on the FPGA board for the North-South (NS) direction

signal ew_output: std_logic_vector(6 downto 0);
-- Signals corresponding to the state of the light for the East-West (EW) direction.
-- Combined output displayed on the FPGA board for the East-West (EW) direction.

signal ns_clear, ew_clear: std_logic;
-- signals used to clear the pedestrian signals

BEGIN
    ns_output <= ns_amber & "00" & ns_green & "00" & ns_red; -- Concatenated signal for NS used to display on the FPGA board
    ew_output <= ew_amber & "00" & ew_green & "00" & ew_red; -- Concatenated signal for EW used to display on the FPGA board

    -- Instances of various components
    INST1: PB_inverters port map (rst_n_filtered, pb_n_filter, pb); -- Instance used to change buttons from active low to active high
    INST2: clock_generator port map (sim_mode, pb(a), clk_50, sm_clken, blink_sig); -- generates a clock enabler
    INST3: PB_filters port map (clkin_50, rst_n, rst_n_filtered, pb_n, pb_n_filter); -- Button Synchronizer
    INST4: synchronizer port map (clkin_50, synch_rst, rst, synch_rst); -- Button Synchronizer
    INST5: Synchronizer port map (clkin_50, synch_rst, pb(), ns_synch_output); -- North-South synchronizer
    INST6: Synchronizer port map (clkin_50, synch_rst, pb(1), ew_synch_output); -- East-West synchronizer
    INST7: holding_register port map (clkin_50, synch_rst, ew_clear, ew_synch_output, ew_register_out); -- North-South holding register
    INST8: holding_register port map (clkin_50, synch_rst, ns_clear, ns_synch_output, ns_register_out); -- North-South holding register
    INST9: TLC_State_Machine port map (clkin_50, sm_clken, synch_rst, ns_register_out, ew_register_out, blink_sig, ns_red, ns_amber, ns_green, ew_red, ew_amber, ew_green, ns_clear, ew_clear, leds(0), leds(7), leds(7 downto 4)); -- state machine
    INST10: segment7_mux port map (clkin_50, ns_output, ew_output, seg7_data, seg7_char2, seg7_char1); -- Display to the FPGA board

    leds(1) <= ns_register_out;
    leds(3) <= ew_register_out;

    -- Additional signals and assignments
    -- sm_clken, blink_signal, ns_red, ns_amber, ns_green, ew_red, ew_amber, ew_green

END SimpleCircuit;

