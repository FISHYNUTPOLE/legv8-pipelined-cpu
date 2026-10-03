// Top-level module for the parking lot occupancy counter on the LabsLand DE1-SoC.
// Integrates car_detector, counter, and display modules with GPIO-connected switches and LEDs.
// GPIO inputs (reset, outerSensor, innerSensor) are synchronized through a two DFFs
// to prevent metastability. CLOCK_50 is divided for board use and passed directly for simulation.
// Inputs:
// CLOCK_50 --> 50MHz system clock
// V_GPIO[28] --> reset switch
// V_GPIO[29] --> outer photosensor switch
// V_GPIO[30] --> inner photosensor switch
// Outputs:
// HEX0-HEX5 --> seven-segment displays showing car count, CLEAR, or FULL
// V_GPIO[31] --> LED mirroring outer sensor state
// V_GPIO[32] --> LED mirroring inner sensor state
module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR, V_GPIO);
  input  logic       CLOCK_50;  // 50MHz clock
  output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;  // active low
  output logic [9:0] LEDR;
  inout  logic [35:0] V_GPIO;  // expansion header 0 (LabsLand board)
  

	


endmodule  // DE1_SoC