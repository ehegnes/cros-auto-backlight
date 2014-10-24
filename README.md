# cros-auto-backlight: Chromebook C720 Automatic Brightness
This project concerns a collection of Bash scripts I have written/modified and
used to prepare and utilize custom brightness scaling on my Acer C720P.
Preferred brightness levels are stored with the corresponding ALS (Ambient
Light Sensor) IR reading, and the data is fit by a linear equation to be used
when determining the automatic brightness level. Right now this is really
young, and I am not quite sure where I want it to end up, but I think this
could be the base for an *actually* useful automatic backlight daemon. =)

### Dependencies
- `gnuplot`
- `bc`
- ALS: isl29018 driver `CONFIG_SENSORS_ISL29018={y,m}`
    - C720 patchset (more on this later)

## Overview

### Configuration
Ensure that all paths in the script(s) are set properly.

### Calibration
Set the backlight to a comfortable level. Run `blstore`.

This will store the current ALS reading and backlight level in `bl.dat` for
later use by `gnuplot`. I recommend running this script (remember to modify
your brightness first) whenever it pops into your mind to populate the data
over time, removing outliers whenever necessary.

When you run `gnuplot bl.gpi`, the slope and y-intercept of your
brightness fit will be stored in `blsettings`, which is then sourced by
`backlightd`. Use the `--persist` flag to view the visualization.

_Note_: You may have to manually remove outliers. Simply delete the offending
line(s) in `bl.dat`.

### Usage
No _installation_ for now, just some scripts.

1. Store values: `blstore` (meant to populate bl.dat with sensor values)
2. Store linear fit coefficients and [render visualization]: `gnuplot
   [--persist] bl.gpi`
3. Enjoy reasonable backlight levels: `backlightd &`

## Future Work
- General clean-up
    - Polish scripts to be _professional grade_
    - `gnuplot` is nice for visualization, but there must exist a more lean
      option for pure calculation
    - Raw ALS IR readings can be misleading and sporadic. Can we filter these
      outliers without manually editing `bl.dat`?
- There are **so** many options for polling procedures. I wonder what people
  will prefer.
- Extend to support more devices (ALS specifically; backlight support is
  trivial)
- I love Bash, but pure C is cool too! Maybe a future port would be nice...

## Related Stuff!
* [Learn about your ALS sensor here! (PDF)](http://www.intersil.com/content/dam/Intersil/documents/isl2/isl29018.pdf)
* [Learn about the current problems with modern automatic backlighting](http://www.displaymate.com/AutoBrightness_Controls_2.htm)
