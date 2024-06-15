# Operational Traffic Lights

This project involves the design and implementation of a 4-way traffic light system using VHDL on an FPGA board with Quartus Prime software. The system is designed to manage traffic flow and pedestrian crossings at a busy intersection, ensuring safe and efficient movement of vehicles and pedestrians.

Features:
-Traffic Light Management: Efficient control of traffic light segments (Red, Yellow, Green) with clear and visible signals for drivers.
-Pedestrian Crossing Requests: Dedicated pushbuttons for North-South and East-West pedestrian crossings with visual indicators (LEDs) to show pending crossings.
-State Machine Implementation: A state machine with 16 states to handle the complex logic of the traffic light system.
-Priority Left Turn: Blinking green segment to indicate a priority left turn, enhancing traffic flow and safety.
-Timers: Integration of timers to manage the duration of each traffic light signal and pedestrian crossing.

roject Components

1. Hardware:
- Arduino Uno: The brain of the project, responsible for controlling the sonar sensor and processing the data.
- HC-SR04 Ultrasonic Sensor: A sonar sensor that emits ultrasonic waves and measures the time it takes for the echo to return, thereby calculating the distance to an object.
- Servo Motor: Used to rotate the sonar sensor, allowing it to scan the environment in a sweeping motion.
- Other Components: Including a breadboard, jumper wires, and a power supply to connect and power the components.

This 4-way traffic light system project demonstrates the application of VHDL and FPGA technology in creating a functional and efficient traffic management system. The use of state machines, timers, and visual indicators ensures safe and smooth operation at the intersection, highlighting the versatility and power of digital design.
