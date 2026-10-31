# Enclosures

Printable cases for the two HayPaComer nodes and the pieces that mount them on a fridge, designed in [OpenSCAD](https://openscad.org) so every
size is a number in `params.scad`. The STL and 3MF files in `stl/` and `3mf/` are ready to slice; `renders/` shows each part.

| Part | File | Prints | What it holds |
|---|---|---|---|
| Fit test | `fit_test.scad` | 1 | Print it first: ESP32 rails, HX711 slot, cable, LED and magnet holes, load cell M4 and M5 holes |
| Door node base | `door_node.scad`, `part="base"` | 1 | ESP32 on two rails, perfboard slot, USB opening, cable gland with a zip tie bar, two magnet pockets |
| Door node lid | `door_node.scad`, `part="lid"` | 1 | Buzzer grille and a 0.4 mm window over the LED; snaps on |
| Scale base | `scale_platform.scad`, `part="base"` | 1 | Load cell fixed end, electronics bay, overload stops, LED and buzzer at the front, USB at the back |
| Scale top | `scale_platform.scad`, `part="top"` | 1 | Rests only on the free end of the cell; prints upside down |
| Scale bay cover | `scale_platform.scad`, `part="cover"` | 1 | Slides over the bay |
| Reed switch mounts | `reed_mounts.scad` | 1 set | Holders for the MC-38 switch and magnet, spacers of 1, 2, 3 and 5 mm |
| Cable clips | `cable_clip.scad` | 1 set | Three clips and a 1 mm bridge for the probe cable across the door gasket |

## Before printing

1. Measure the parts you received with a caliper (ESP32 board, HX711, load cell holes, cables, LED, magnets) and correct `params.scad`.
2. Print `fit_test.scad` and try every part in it. Adjust `clearance` if things are tight or loose.
3. Run `./export.sh`: it exports every part, renders it, and stops if a part is not one closed solid or does not fit a 220 x 220 mm bed.

## Print settings

- **PETG**, not PLA: PLA turns brittle in the cold and slowly bends under a steady load like the scale's.
- 0.4 mm nozzle, 0.2 mm layers, 4 walls, 30 % gyroid infill; the scale base and top with 5 walls and 40 %.
- No supports: every part is modelled in its print orientation (the scale top is already upside down).

## Hardware to buy

| Item | Qty | For |
|---|---|---|
| M5 x 10 socket head screws | 2 | Load cell fixed end to the scale base |
| M4 x 12 countersunk screws | 2 | Scale top to the free end of the cell |
| M3 x 6 screws | 2 | Perfboard, if it does not stay in its slot |
| Neodymium discs 10 x 3 mm | 2 | Door node on a steel fridge side (or use foam tape) |
| 3M VHB foam tape, 19 mm | 1 roll | Door node, reed mounts, cable clips |
| Adhesive rubber feet, 8 mm | 4 | Under the scale base |
| Silicone bumpers | 4 | Under the washable plate on the scale |
| Washable plate (glass, acrylic or a dish), up to 17 cm | 1 | Food never touches printed plastic |
| Zip tie, 2.5 mm | 1 | Strain relief inside the door node |

## Assembly

1. **Door node.** Solder the buzzer transistor and resistors on the perfboard and stand it in its slot. Lay the ESP32 on its rails with the USB end against the wall. Pass the probe and reed cables through the gland and close the zip tie around them on the bar. Snap the lid on. Stick the box outside the fridge, on its side or top, with tape or the magnets.
2. **Door switch.** Stick the switch holder on the fridge body and the magnet holder on the door, face to face, adding spacers until they are level and within 15 mm when the door is shut.
3. **Probe.** Run the probe cable along the wall with the clips and across the gasket in the bridge, so the door still seals. Check the temperature recovers after the door closes.
4. **Scale.** Screw the cell's M5 end to the base block from below, arrow pointing down, and the top plate to its M4 end from above. Put the ESP32 and the HX711 in the bay, slide the cover on, stick the feet. Put the washable plate on the silicone bumpers, then tare and calibrate from the app.
