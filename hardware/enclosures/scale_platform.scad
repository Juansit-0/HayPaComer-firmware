// The scale: a loose platform that sits on any shelf, or on the counter to weigh while cooking. The bar load cell is bolted at one end to the
// base and at the other to the top plate, so the plate only touches the cell; a stop 2 mm under the plate's far corners keeps a heavy pot
// from bending the cell past its limit. The ESP32 and the HX711 live in a bay in the base under a sliding cover, with the LED and the buzzer
// at the front and the USB plug at the back. A washable plate (glass, acrylic or a dish) rests on top on four silicone bumpers: nothing
// printed touches food. The top plate prints upside down, its flat face on the bed.
//
// part = "base" | "top" | "cover" | "both"

include <params.scad>

part = "both";

size = 180;
plate = 5;               // solid and flat: there is no room for ribs in the 3 mm under it
gap = 3;                 // clearance between the top plate and the base
stop = 2;                // travel before the overload stops touch
bay_height = esp32_under + esp32_pcb + esp32_above + 1;
// The walls are as tall as the bay needs; the cell's fixed end sits on a block that lifts its top to the same height, so its free end can
// bend down and the plate above touches nothing else.
wall_height = floor_thickness + max(3 + cell_section, bay_height);
cell_lift = wall_height - floor_thickness - cell_section;
base_height = wall_height + gap;
bay_length = esp32_length + hx711_width + 12;
bay_width = esp32_width + 10;
corner = 8;

module rounded_plate(x, y, h, r) {
  hull() for (i = [r, x - r], j = [r, y - r]) translate([i, j, 0]) cylinder(r = r, h = h);
}

// Holes of one end of the cell, along x from a point
module cell_holes(d, h) {
  for (i = [0, 1]) translate([i * cell_hole_spacing, 0, 0]) cylinder(d = d, h = h);
}

cell_x = size / 2 - cell_length / 2;
cell_y = size / 2;

module base() {
  difference() {
    union() {
      // Rim and floor
      difference() {
        rounded_plate(size, size, base_height - gap, corner);
        translate([wall, wall, floor_thickness]) rounded_plate(size - 2 * wall, size - 2 * wall, base_height, corner - wall);
      }
      // Fixed end block of the cell
      translate([cell_x - 2, cell_y - cell_section / 2 - 4, 0]) cube([cell_hole_from_end + cell_hole_spacing + 8, cell_section + 8, floor_thickness + cell_lift]);
      // Electronics bay walls
      translate([size - wall - bay_length - 4, wall + 4, 0]) difference() {
        cube([bay_length + 4, bay_width + 4, base_height - gap]);
        translate([2, 2, floor_thickness]) cube([bay_length, bay_width, base_height]);
      }
      // Overload stops near the far corners, 2 mm below the plate
      for (x = [24, size - 24], y = [size - 24]) translate([x, y, 0]) cylinder(d = 10, h = base_height - stop);
    }
    // Cell screws (M5 x 10 socket head) from below, their heads sunk 5 mm into the block
    translate([cell_x + cell_hole_from_end, cell_y, -1]) cell_holes(m5, 40);
    translate([cell_x + cell_hole_from_end, cell_y, -1]) cell_holes(9.5, 6);
    // USB at the back of the bay, LED and buzzer at the front edge
    translate([size - wall - 6, wall + 4 + 2 + bay_width / 2 - usb_width / 2, floor_thickness + esp32_under - usb_height / 2]) cube([20, usb_width, usb_height]);
    translate([size - 30, -1, floor_thickness + 8]) rotate([-90, 0, 0]) cylinder(d = led_diameter + clearance, h = wall + 8);
    for (i = [0 : 2]) translate([size - 52 + i * 4, -1, floor_thickness + 4]) cube([1.6, wall + 8, 8]);
    // Pockets for adhesive rubber feet
    for (x = [16, size - 16], y = [16, size - 16]) translate([x, y, -1]) cylinder(d = rubber_foot + clearance, h = 1.6);
  }
}

module top() {
  difference() {
    union() {
      rounded_plate(size - 2 * wall - 2, size - 2 * wall - 2, plate, corner - wall);
      // Boss that sits on the free end of the cell
      translate([cell_x - wall - 1 + cell_length - cell_hole_from_end - cell_hole_spacing - 4, cell_y - wall - 1 - cell_section / 2 - 4, -gap]) cube([cell_hole_spacing + 8 + cell_hole_from_end, cell_section + 8, gap]);
    }
    // Cell screws (M4 end) from the top, countersunk under the washable plate
    translate([cell_x - wall - 1 + cell_length - cell_hole_from_end - cell_hole_spacing, cell_y - wall - 1, -gap - 1]) cell_holes(m4, 20);
    translate([cell_x - wall - 1 + cell_length - cell_hole_from_end - cell_hole_spacing, cell_y - wall - 1, plate - 2]) cell_holes(8, 3);
  }
}

module cover() {
  difference() {
    cube([bay_length + 3, bay_width + 3, 1.6]);
    translate([bay_length - 6, (bay_width + 3) / 2 - 5, -1]) cube([2, 10, 3]);
  }
}

if (part == "base") base();
// Printed upside down, its flat face on the bed and the cell boss pointing up.
if (part == "top") rotate([180, 0, 0]) top();
if (part == "cover") cover();
if (part == "both") {
  base();
  translate([wall + 1, wall + 1, base_height + 12]) top();
  translate([size + 12, 0, 0]) cover();
}
echo(str("scale outside: ", size, " x ", size, " x ", base_height + plate, " mm; walls ", wall_height, " mm; cell lifted ", cell_lift, " mm"));
