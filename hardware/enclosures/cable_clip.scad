// Clips that guide the probe cable along the fridge wall and across the door gasket. The part on the gasket is a flat bridge only 1 mm thick,
// so the door still seals; the clips either side hold the cable so a slammed door never pinches it.
//
// part = "clip" | "bridge" | "all"

include <params.scad>

part = "all";

module clip() {
  hole = probe_cable + clearance;
  centre = 1.6 + hole / 2 + 0.4;
  difference() {
    union() {
      cube([14, 12, 1.6]);
      translate([7, 12, centre]) rotate([90, 0, 0]) cylinder(d = hole + 2 * 1.6, h = 12);
    }
    translate([7, 13, centre]) rotate([90, 0, 0]) cylinder(d = hole, h = 14);
    // Opening on top, a little narrower than the cable, to press it in
    translate([7 - (probe_cable - 0.8) / 2, -1, centre]) cube([probe_cable - 0.8, 14, hole]);
  }
}

module bridge() {
  difference() {
    cube([40, 10, 1.0]);
    translate([3, 5 - probe_cable / 2 - 0.2, 0.4]) cube([34, probe_cable + 0.4, 1]);
  }
}

if (part == "clip") clip();
if (part == "bridge") bridge();
if (part == "all") {
  for (i = [0 : 2]) translate([i * 18, 0, 0]) clip();
  translate([0, 18, 0]) bridge();
}
