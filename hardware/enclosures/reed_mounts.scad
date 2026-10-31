// Holders for the MC-38 reed switch (on the fridge body) and its magnet (on the door), and spacers that bring them level: every fridge has a
// different step between the body and the door, and the switch only closes within 15 to 25 mm of the magnet. Each part sticks on with foam
// tape; the spacers stack under either holder.
//
// part = "switch" | "magnet" | "spacers" | "all"

include <params.scad>

part = "all";

module holder(length, width, height) {
  difference() {
    cube([length + 2 * wall, width + 2 * wall, height / 2 + floor_thickness]);
    translate([wall - clearance / 2, wall - clearance / 2, floor_thickness]) cube([length + clearance, width + clearance, height]);
    // Notch for the cable at one end
    translate([-1, wall + width / 2 - reed_cable / 2, floor_thickness + 1]) cube([wall + 2, reed_cable, height]);
  }
  // Two small lips that snap over the part
  for (y = [wall - 0.6, wall + width + 0.6 - 1.2]) translate([wall + length / 2 - 4, y, height / 2 + floor_thickness - 0.8]) cube([8, 1.2, 0.8]);
}

module spacer(thickness) {
  difference() {
    cube([reed_length + 2 * wall, reed_width + 2 * wall, thickness]);
    // The thickness, as notches on the edge, so the spacers are told apart without reading
    for (i = [1 : thickness]) translate([3 + i * 3, -1, -1]) cube([1, 2, thickness + 2]);
  }
}

if (part == "switch") holder(reed_length, reed_width, reed_height);
if (part == "magnet") holder(magnet_length, magnet_width, magnet_height);
if (part == "spacers") for (i = [0 : 3]) translate([0, i * (reed_width + 2 * wall + 4), 0]) spacer([1, 2, 3, 5][i]);
if (part == "all") {
  holder(reed_length, reed_width, reed_height);
  translate([0, reed_width + 2 * wall + 6, 0]) holder(magnet_length, magnet_width, magnet_height);
  for (i = [0 : 3]) translate([reed_length + 2 * wall + 8, i * (reed_width + 2 * wall + 4), 0]) spacer([1, 2, 3, 5][i]);
}
