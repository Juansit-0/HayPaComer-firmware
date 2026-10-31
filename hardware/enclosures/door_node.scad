// The door and temperature node: a box that lives outside the fridge, on its side or top. Inside, the ESP32 rests on two rails and the
// perfboard with the buzzer transistor stands beside it; the probe and the reed switch cables come in through a gland with a zip tie bar;
// the USB plug goes in at one end. The lid carries the buzzer grille and a thin window over the LED. The flat back takes foam tape, and two
// pockets take disc magnets, so it sticks to the fridge either way.
//
// part = "base" | "lid" | "both" (both is for looking at it, not for printing)

include <params.scad>

part = "both";

inner_length = esp32_length + perf_width + 3 * 3 + 2 * clearance;
inner_width = max(esp32_width, perf_length) + 2 * 3 + 2 * clearance;
inner_height = esp32_under + esp32_pcb + esp32_above + buzzer_height - 4;
outer_length = inner_length + 2 * wall;
outer_width = inner_width + 2 * wall;
base_height = floor_thickness + inner_height;
corner = 4;

module rounded_box(size, radius) {
  hull() for (x = [radius, size[0] - radius], y = [radius, size[1] - radius]) translate([x, y, 0]) cylinder(r = radius, h = size[2]);
}

magnets_at = [16, outer_length - 16];
magnet_depth = disc_magnet_height;

module base() {
  difference() {
    union() {
      shell();
      // The floor is thinner than tape plus magnet, so each magnet pocket sits in a boss that rises inside
      for (x = magnets_at) translate([x, outer_width / 2, 0]) cylinder(d = disc_magnet_diameter + 2 * wall, h = magnet_depth + 1.2);
    }
    for (x = magnets_at) translate([x, outer_width / 2, -1]) cylinder(d = disc_magnet_diameter + clearance, h = 1 + magnet_depth);
  }
  insides();
}

module shell() {
  difference() {
    rounded_box([outer_length, outer_width, base_height], corner);
    translate([wall, wall, floor_thickness]) rounded_box([inner_length, inner_width, inner_height + 1], corner - wall / 2);
    // USB plug at the ESP32 end
    translate([-1, wall + 3 + clearance + esp32_width / 2 - usb_width / 2, floor_thickness + esp32_under - usb_height / 2 + esp32_pcb]) cube([wall + 2, usb_width, usb_height]);
    // Cable gland: probe and reed switch side by side, at the far end, low so drips run away from the board
    for (i = [0, 1]) translate([outer_length - wall - 1, outer_width / 2 + (i - 0.5) * 12, floor_thickness + 5]) rotate([0, 90, 0]) cylinder(d = (i == 0 ? probe_cable : reed_cable) + clearance, h = wall + 2);
    // Ventilation slots under the board, away from the cable side
    for (i = [0 : 3]) translate([32 + i * 6, outer_width / 2 - 10, -1]) cube([2, 20, floor_thickness + 2]);
    // The back stays flat for foam tape (a recess there would leave the floor printed over air)
  }
}

module insides() {
  // Rails the ESP32 rests on by its edges, with a stop at the far end so the USB end stays at the wall
  for (y = [0, esp32_width - 2]) translate([wall, wall + 3 + clearance + y, floor_thickness]) cube([esp32_length + clearance, 2, esp32_under]);
  translate([wall + esp32_length + clearance, wall + 3, floor_thickness]) cube([2, esp32_width + 2 * clearance, esp32_under + esp32_pcb + 2]);
  // A slot that holds the perfboard upright beside the ESP32
  for (x = [0, 2.8]) translate([wall + esp32_length + 3 + clearance + 4 + x, wall + 3, floor_thickness]) cube([1.2, perf_length + clearance, 6]);
  // Zip tie bar inside the gland, so a pulled cable never reaches the solder joints
  translate([outer_length - wall - 9, outer_width / 2 - 14, floor_thickness]) difference() {
    cube([5, 28, 9]);
    translate([-1, 3, 3]) cube([7, 22, 3]);
  }
}

module lid() {
  difference() {
    union() {
      rounded_box([outer_length, outer_width, lid_thickness], corner);
      // Inner lip that keys into the base and snaps on two small bumps
      translate([wall + clearance / 2, wall + clearance / 2, lid_thickness]) difference() {
        rounded_box([inner_length - clearance, inner_width - clearance, lip], corner - wall / 2);
        translate([1.2, 1.2, -1]) rounded_box([inner_length - clearance - 2.4, inner_width - clearance - 2.4, lip + 2], corner - wall / 2 - 1.2);
      }
    }
    // Buzzer grille over the perfboard side
    for (i = [0 : 3]) translate([outer_length - wall - 3 - perf_width / 2 - 6 + i * 4, outer_width / 2 - 6, -1]) cube([1.6, 12, lid_thickness + 2]);
    // LED window: a hole closed by a 0.4 mm skin on top that lets the colour through
    translate([wall + 8, outer_width / 2, 0.4]) cylinder(d = led_diameter + clearance, h = lid_thickness + lip);
  }
  for (x = [outer_length / 3, 2 * outer_length / 3], side = [0, 1]) translate([x, side == 0 ? wall + clearance / 2 - 0.4 : outer_width - wall - clearance / 2 + 0.4, lid_thickness + lip - 0.8]) sphere(d = 1.2);
}

if (part == "base") base();
if (part == "lid") lid();
if (part == "both") {
  base();
  translate([0, outer_width + 10, 0]) lid();
}
echo(str("door node outside: ", outer_length, " x ", outer_width, " x ", base_height + lid_thickness, " mm"));
