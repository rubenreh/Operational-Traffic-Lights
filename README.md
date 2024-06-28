# Traffic Light Simulation on FPGA

This repository contains the VHDL code for simulating a traffic light system on an FPGA board. The project utilizes a synchronizer and a holding register to manage and update the traffic light signals based on clock inputs and reset signals. 

## Authors
- Mihir Seth
- Ruben Rehal

## Table of Contents

- [Introduction](#introduction)
- [Hardware Requirements](#hardware-requirements)
- [Software Requirements](#software-requirements)
- [Files Description](#files-description)
- [Installation and Usage](#installation-and-usage)
- [License](#license)

## Introduction

The Traffic Light Simulation project aims to demonstrate a simple yet effective implementation of a traffic light control system using VHDL on an FPGA board. This project showcases the use of registers and synchronization techniques to ensure reliable signal management.

## Hardware Requirements

- FPGA board (e.g., Altera DE2, Xilinx Spartan, etc.)
- Clock signal source
- LEDs to represent traffic lights
- Push buttons for reset and manual controls

## Software Requirements

- VHDL-compatible IDE (e.g., Quartus Prime, Xilinx Vivado)
- Simulation tool (e.g., ModelSim)
- Git for version control

## Files Description

### `synchronizer.vhd`

The synchronizer module ensures that external signals are synchronized to the shared global clock signal. It consists of two register stages in series, both clocked by the same signal.

### `holding_register.vhd`

The holding register module holds the output of the synchronizer and ensures the signal remains active until a specific pattern is detected. It clears the signal when the required state is reached.

### `LogicalStep_Lab4_top.vhd`

This file contains the top-level design that integrates the synchronizer and holding register to implement the traffic light control logic. It defines the overall architecture and interconnections of the traffic light system.

### `State_Machine_Example.vhd`

This file provides an example of a state machine used in the traffic light simulation to manage the different states of the traffic light signals.

### `PB_inverters.vhd`

This file includes additional logic required for the traffic light simulation, such as push-button signal inverters.

### `TLC_State_Machine.vhd`

This file defines the state machine specifically designed for the traffic light control logic, handling the transitions between different traffic light states.

## Installation and Usage

1. Clone this repository to your local machine using:
   ```bash
   git clone https://github.com/your-username/traffic-light-simulation-fpga.git
   ```

2. Open the project in your VHDL-compatible IDE (e.g., Quartus Prime, Xilinx Vivado).

3. Compile the project to ensure all modules are correctly synthesized.

4. Load the compiled design onto your FPGA board.

5. Connect the necessary hardware components (LEDs, push buttons) to the FPGA board.

6. Run the simulation and observe the traffic light signals changing according to the defined state machine logic.
