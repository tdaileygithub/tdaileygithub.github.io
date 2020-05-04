---
title:  "Embedded Notes"
date:   2020-05-03 00:00:01 -0700
categories: embedded
tags: [jlink]

---
# [J-Link - SWD pinout on JTAG](https://www.segger.com/products/debug-probes/j-link/technology/interface-description/) 

## SWD and SWO (also called SWV) Compatibility

![swd jlink](/assets/images/swd-jlink.png)

| Pin  | Signal  |  Type  | Description  |
|------|---------|--------|--------------|
| 1    | VTref   | Input  | This is the target reference voltage. It is used to check if the target has power, to create the logic-level reference for the input comparators and to control the output logic levels to the target. It is normally fed from Vdd of the target board and must not have a series resistor.  |
| 2    | Vsupply  | NC  | This pin is not connected in J-Link. It is reserved for compatibility with other equipment. Connect to Vdd or leave open in target system.  |
| 3    | NA  | NC  | This pin is not used by J-Link. If the device may also be accessed via JTAG, this pin may be connected to nTRST, otherwise leave open.  |
| 5    | NA  | NC  | This pin is not used by J-Link. If the device may also be accessed via JTAG, this pin may be connected to TDI, otherwise leave open.  |
| 7    | SWDIO  | I/O  | Single bi-directional data pin. |
| 9    | SWCLK  | Output  | Clock signal to target CPU. It is recommended that this pin is pulled to a defined state of the target board. Typically connected to TCK of target CPU.. |
| 11    | NA  | NC  | This pin is not used by J-Link. This pin is not used by J-Link when operating in SWD mode. If the device may also be accessed via JTAG, this pin may be connected to RTCK, otherwise leave open.  |
| 13    | SWO  | Input  | Serial Wire Output trace port. (Optional, not required for SWD communication.) |
| 15    | nRESET  | I/O  | Target CPU reset signal. Typically connected to the RESET pin of the target CPU, which is typically called "nRST", "nRESET" or "RESET". This signal is an active low signal. |
| 17    | NA  | NC  | 	This pin is not connected in J-Link.
| 19    | 5V-Supply  | Output  | 	This pin is used to supply power to some eval boards.

Pins 4, 6, 8, 10, 12, 14, 16, 18, 20 are GND pins connected to GND in J-Link. 

They should also be connected to GND in the target system.

# Pullup Resistor / Pull Down

- [http://www.resistorguide.com/pull-up-resistor_pull-down-resistor/]()
- [https://learn.sparkfun.com/tutorials/pull-up-resistors/all]()

Pull-up resistors are resistors which are used to ensure that a wire is pulled to a high logical level in the absence of an input signal.

Another application is the I2C protocol bus, where pull-up resistors are used to enable a single pin to act as an input or an output. When not connected to a bus, the pin floats in a high-impedance state.
Pull-down resistors are also used on outputs to provide a known output impedance.

Read more http://www.resistorguide.com/pull-up-resistor_pull-down-resistor/
