include <MCAD/boxes.scad>;
include <MCAD/utilities.scad>;

include <common.scad>;

// TODO define diameter offset
_diameter_screw_holder = diameter_head_case+2;

module _support_bearing(offset_x) {
	length_support_bearing = length2([offset_x, position_y_case_screw]);
	// if offset_x is positive, the cube needs to be mirrored or it will point in the opposite direction
	factor_mirror = offset_x < 0 ? 1 : -1;

	rotate([0, 0, atan(position_y_case_screw/offset_x)]) {
		translate([(length_support_bearing/2)*factor_mirror, 0, size_z_case_top_/2]) {
			cube([length_support_bearing, _diameter_screw_holder, size_z_case_top_], center=true);
		}
	}
}

module case_top() {
	difference() {
		union() {
			case_half(size_z_case_top_);
			translate([0, 0, size_z_case_top_]) {
				case_slot();
			}
			case_screws() {
				translate([0, 0, size_z_case_top_/2]) {
					cylinder(h=size_z_case_top_, d=_diameter_screw_holder, center=true);
				}
			}
			// drive bearing holder
			translate([position_x_drive, 0, size_z_case_top_/2]) {
				cylinder(h=size_z_case_top_, d=diameter_outer_bearing+(thickness_xy_case*2), center=true);
			}
			case_screws(x2=false) {
				_support_bearing(position_x_separator-position_x_drive);
			}
			case_screws(x1=false) {
				_support_bearing(position_x2_case_screw-position_x_drive);
			}
		}
		case_screws() {
			// head
			translate([0, 0, size_z_screw_head_case/2]) {
				cylinder(h=size_z_screw_head_case+epsilon, d=diameter_head_case, center=true);
			}
			// body
			translate([0, 0, size_z_case_top_/2]) {
				cylinder(h=size_z_case_top_+epsilon, d=diameter_hole_case, center=true);
			}
		}
		// drive bearing holder
		translate([position_x_drive, 0, (size_z_case_top_-size_z_bearing)+(size_z_case_top_/2)]) {
			cylinder(h=size_z_case_top_, d=diameter_outer_bearing, center=true);
		}
		translate([position_x_drive, 0, thickness_z_case+(size_z_case_top_/2)]) {
			cylinder(h=size_z_case_top_, d=diameter_outer_bearing_rim, center=true);
		}
	}
}

case_top();
