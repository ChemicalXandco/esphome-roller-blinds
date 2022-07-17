include <MCAD/multiply.scad>
include <MCAD/regular_shapes.scad>

include <common.scad>

_cone_height = (tan(angle_max_slope)*diameter_outer_bearing_rim)/2;

radius_chain_rope = diameter_chain_rope/2;

radius_sprocket_hole_rope_inner = radius_chain_rope*cos(angle_max_slope);

offset_sprocket_hole_rope = radius_chain_rope*sin(angle_max_slope);

// thin part
size_z_sprocket_middle = radius_sprocket_hole_rope_inner*2;
// sloped sections
size_z_sprocket_end = (size_z_sprocket-size_z_sprocket_middle)/2;
length_sprocket_slope = (size_z_sprocket/2)/sin(angle_max_slope);

radius_sprocket_inner = (diameter_sprocket/2)-offset_sprocket_hole_rope;
radius_sprocket_outer = radius_sprocket_inner+(size_z_sprocket_end/tan(angle_max_slope));

// inverted
module _sprocket_hole() {
    difference() {
        union() {
            sphere(d=diameter_chain_bead);
            mirror_copy([0, 0, 1]) {
                rotate([0, 90-angle_max_slope, 0]) {
                    translate([0, 0, length_sprocket_slope/2]) {
                        cylinder(h=length_sprocket_slope, d=diameter_chain_bead, center=true);
                    }
                }
            }
        }
    }
}

module _sprocket() {
    difference() {
        union() {
            cylinder(h=size_z_sprocket_middle, d=diameter_sprocket, center=true);
            mirror_copy([0, 0, 1]) {
                translate([0, 0, (size_z_sprocket_middle+size_z_sprocket_end)/2]) {
                    cylinder(h=size_z_sprocket_end, r1=radius_sprocket_inner, r2=radius_sprocket_outer, center=true);
                }
            }
        }
        // TODO: requires newer version
        spin(teeth_sprocket) {
            translate([diameter_sprocket/2,0,0]){
                _sprocket_hole();
            }
        }
        torus2(r1=diameter_sprocket/2, r2=radius_chain_rope);
    }
}

module drive() {
    difference() {
        union() {
            standard_gear(teeth_gear_drive);
            translate([0, 0, size_z_gear+(size_z_sprocket/2)]) {
                _sprocket();
            }
            translate([0, 0, size_z_gear+size_z_sprocket]) {
                spindle_bearing();
            }
        }
        translate([0, 0, size_z_bearing/2]) {
            cylinder(h=size_z_bearing+epsilon, d=diameter_outer_bearing, center=true);
        }
        // reduce supports required
        translate([0, 0, size_z_bearing+(_cone_height/2)]) {
            cylinder(h=_cone_height+epsilon, d1=diameter_outer_bearing_rim, d2=0, center=true);
        }
    }
}

drive();
// _sprocket_hole();
