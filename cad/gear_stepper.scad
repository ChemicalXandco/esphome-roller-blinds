include <common.scad>

module gear_stepper() {
    difference() {
        translate([0, 0, size_z_gear/-2]) {
            standard_gear(teeth_gear_stepper);
        }
        // shaft hole
        difference() {
            cylinder(h=size_z_gear, d=diameter_max_stepper_shaft, center=true);
            mirror_copy([1, 0, 0]) {
                translate([diameter_max_stepper_shaft/2, 0, 0]) {
                    cube([diameter_max_stepper_shaft-diameter_min_stepper_shaft, diameter_max_stepper_shaft, size_z_gear], center=true);
                }
            }
        }
    }
}

gear_stepper();
