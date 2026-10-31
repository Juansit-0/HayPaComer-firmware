// Print this first and try the real parts in it: the ESP32 on its rails, the HX711 in its slot, the probe and reed cables
// in the gland holes, the LED in its window, the load cell bolts in both hole sizes and a disc magnet in its pocket. Change params.scad
// until everything fits, then print the enclosures.

include <params.scad>

difference() {
  cube([esp32_length + 2 * wall + 4, esp32_width + 2 * wall + 6 + 30, floor_thickness + 4]);
  // Gland holes, LED window and magnet pocket
  translate([8, esp32_width + 2 * wall + 14, -1]) cylinder(d = probe_cable + clearance, h = 10);
  translate([16, esp32_width + 2 * wall + 14, -1]) cylinder(d = reed_cable + clearance, h = 10);
  translate([24, esp32_width + 2 * wall + 14, -1]) cylinder(d = led_diameter + clearance, h = 10);
  translate([36, esp32_width + 2 * wall + 14, -1]) cylinder(d = disc_magnet_diameter + clearance, h = 1 + disc_magnet_height);
  // Load cell hole pattern, M5 and M4
  for (i = [0, 1]) translate([8 + i * cell_hole_spacing, esp32_width + 2 * wall + 26, -1]) cylinder(d = m5, h = 10);
  for (i = [0, 1]) translate([34 + i * cell_hole_spacing, esp32_width + 2 * wall + 26, -1]) cylinder(d = m4, h = 10);
}
// ESP32 rails with the end stop, as in the door node
for (y = [0, esp32_width - 2]) translate([wall, wall + 3 + clearance + y, floor_thickness + 4]) cube([esp32_length + clearance, 2, 3]);
translate([wall + esp32_length + clearance, wall + 3, floor_thickness + 4]) cube([2, esp32_width + 2 * clearance, 3 + esp32_pcb + 2]);
// HX711 slot
translate([esp32_length + 2 * wall + 8, 0, 0]) difference() {
  cube([hx711_width + 2 * wall + clearance, hx711_length + 2 * wall + clearance, floor_thickness + 4]);
  translate([wall, wall, floor_thickness]) cube([hx711_width + clearance, hx711_length + clearance, 10]);
}
