// Every measurement of the parts the enclosures hold, in millimetres, in one place. The values come from the sellers' sheets of the parts in
// docs/hardware.md; measure the parts you received with a caliper and change them here before the final print (print fit_test.scad first).

$fn = 48;

// Fit and print
clearance = 0.4;        // gap around a part so it slides in
wall = 2.4;             // six perimeters of a 0.4 mm nozzle
floor_thickness = 2.0;
lid_thickness = 2.0;
lip = 1.6;              // height of the lid's inner lip

// ESP32 DevKit V1 (ESP-WROOM-32). The 30-pin board is 51.5 x 28.3; the 38-pin one is 55.3 x 28.3.
esp32_length = 51.5;
esp32_width = 28.3;
esp32_pcb = 1.6;
esp32_under = 9.0;      // header pins and solder below the board, so it rests on its edges
esp32_above = 6.0;      // the WROOM can and the buttons
usb_width = 12.0;       // opening for a micro-USB or USB-C plug with its overmould
usb_height = 8.0;

// HX711 module (green board)
hx711_length = 34.0;
hx711_width = 21.0;
hx711_height = 4.0;

// Perfboard with the buzzer transistor and the resistors
perf_length = 40.0;
perf_width = 30.0;

// Active buzzer, 12 x 9.5 mm
buzzer_diameter = 12.0;
buzzer_height = 9.5;

// RGB LED, 5 mm (10 mm: change to 10.0)
led_diameter = 5.0;

// Cables
probe_cable = 4.2;      // DS18B20 waterproof probe cable
reed_cable = 3.2;       // MC-38 cable

// Load cell, 5 kg bar (TAL220 type): two M5 holes at one end, two M4 at the other, 15 mm apart, 5 mm from each end
cell_length = 80.0;
cell_section = 12.7;
cell_hole_spacing = 15.0;
cell_hole_from_end = 5.0;
m4 = 4.4;
m5 = 5.4;
m3 = 3.3;

// MC-38 reed switch and its magnet
reed_length = 27.0;
reed_width = 14.0;
reed_height = 8.0;
magnet_length = 27.0;
magnet_width = 10.0;
magnet_height = 8.0;

// Mounting
disc_magnet_diameter = 10.0;   // 10 x 3 mm neodymium discs
disc_magnet_height = 3.0;
rubber_foot = 8.0;             // adhesive rubber bumpers
