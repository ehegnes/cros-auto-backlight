# cros-auto-backlight: Chromebook C720 Automatic Brightness
This project concerns a collection of Bash scripts I have written/modified and used to prepare
and utilize custom brightness scaling on my Acer C720P. Preferred brightness levels are stored
with the corresponding ALS (Ambient Light Sensor) IR reading, and the data is fit by a
linear equation to be used when determining the automatic brightness level. Right now this is
really young, and I am not quite sure where I want it to end up, but I think this could be the
base for an *actually* useful automatic backlight daemon. =)


## Dependencies
- `gnuplot`
- `bc`
- ALS: isl29018 driver `CONFIG_SENSORS_ISL29018={y,m}`
  - C720 patchset (more on this later)


## Usage

### Configuration
Ensure that all paths in the scripts are set properly.  
Clean `blsettings.dat` and `bl.dat`.

### Calibration
Set the backlight to a comfortable level. Run `blstore.sh`.  

This will store the current ALS reading and backlight level in `bl.dat` for later use by
`gnuplot`. I recommend running this script (remember to modify your brightness first)
whenever it pops into your mind to populate the data over time.  

When you run `gnuplot bl.gpi`, the slope and y-intercept of your brightness fit will
be stored in `blsettings.dat`, which is then read by `backlight.sh`.  

_Note_: You may have to manually remove outliers. Simply delete the offending line(s) in `bl.dat`.

### Installation
No _installation_ for now, just some scripts.  

1. Store values: `blstore.sh` (can be run consecutively)  
2. Store linear fit coefficients and render visualization: `gnuplot bl.gpi`  
3. Enjoy reasonable backlight levels: `backlight.sh`  


## Future Work
- General clean-up
  - Polish scripts to be _professional grade_
  - `gnuplot` is nice for visualization, but there must exist a more lean option for
    pure calculation
  - Raw ALS IR readings can be misleading and sporadic. Can we filter these outliers
    without manually editing `bl.dat`?
- There are **so** many options for polling procedures. I wonder what people will prefer.
- Extend to support more devices (ALS specifically; backlight is trivial)
- I love Bash, but pure C is cool too! Maybe a future port would be nice...
