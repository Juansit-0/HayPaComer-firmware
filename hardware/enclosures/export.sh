#!/bin/sh
# Exports every printable part to stl/ and 3mf/, renders a picture of each to renders/, and stops if a part is not one closed solid or does
# not fit a 220 x 220 x 250 mm bed. Needs OpenSCAD 2025 or newer on the PATH (brew install --cask openscad@snapshot).
set -eu
cd "$(dirname "$0")"
mkdir -p stl 3mf renders
fails=0
part() {
  name=$1 file=$2 choice=$3
  openscad --backend=manifold -D "part=\"$choice\"" --summary=all --summary-file="/tmp/$name.json" -o "stl/$name.stl" "$file" 2>/dev/null
  openscad --backend=manifold -D "part=\"$choice\"" -o "3mf/$name.3mf" "$file" 2>/dev/null
  openscad --backend=manifold -D "part=\"$choice\"" -o "renders/$name.png" --imgsize=1200,800 --colorscheme=Tomorrow --autocenter --viewall --camera=0,0,0,55,0,25,0 "$file" 2>/dev/null
  python3 - "$name" "/tmp/$name.json" <<'PY' || fails=$((fails + 1))
import json, sys
name, path = sys.argv[1], sys.argv[2]
summary = json.load(open(path))["geometry"]
size = summary["bounding_box"]["size"]
fits = size[0] <= 220 and size[1] <= 220 and size[2] <= 250
print(f"{name:16} {size[0]:6.1f} x {size[1]:6.1f} x {size[2]:5.1f} mm  {'fits' if fits else 'TOO BIG'}  {'closed' if summary.get('simple', True) else 'NOT CLOSED'}")
sys.exit(0 if fits and summary.get("simple", True) else 1)
PY
}
part fit-test fit_test.scad all
part door-base door_node.scad base
part door-lid door_node.scad lid
part scale-base scale_platform.scad base
part scale-top scale_platform.scad top
part scale-cover scale_platform.scad cover
part reed-mounts reed_mounts.scad all
part cable-clips cable_clip.scad all
[ "$fails" -eq 0 ] || { echo "$fails part(s) failed"; exit 1; }
