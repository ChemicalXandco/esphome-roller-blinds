include <MCAD/boxes.scad>;

include <common.scad>;

diameter_inner_cutout_gear_stepper = diameter_outer_gear_stepper+(margin*2);
diameter_outer_cutout_gear_stepper = diameter_inner_cutout_gear_stepper+(thickness_xy_case*2);

module case_bottom() {
	difference() {
		union() {
			// second difference is necessary because the slot cutout must be part of the origional empty case
			difference() {
				case_half(size_z_case_bottom_);
				// rim slot
				translate([0, 0, size_z_case_bottom_+epsilon]) {
					rotate([180, 0, 0]) {
						case_slot();
					}
				}
			}
			// separator
			translate([position_x_separator, 0, size_z_case_bottom_/2]) {
				cube([size_x_stepper_mount, size_y_case, size_z_case_bottom_], center=true);
			}
			// stepper gear cutout
			translate([position_x_gear_stepper, 0, size_z_case_bottom_/2]) {
				cylinder(h=size_z_case_bottom_, d=diameter_outer_cutout_gear_stepper, center=true);
			}
			translate([position_x_drive, 0, thickness_z_case]) {
				spindle_bearing();
			}
			case_screws() {
				translate([0, 0, size_z_case_bottom_/2]) {
					// TODO define diameter offset
					cylinder(h=size_z_case_bottom_, d=diameter_head_case+2, center=true);
				}
			}
		}
		// usb cutout
		mirror_copy([0, 1, 0]) {
			translate([(size_x_case-thickness_xy_case)/2, (size_y_case/2)-offset_y_usb, (size_z_case+size_z_case_bottom_)/2]) {
				cube([thickness_xy_case+epsilon, size_y_usb, size_z_usb+size_z_case_bottom_], center=true);
			}
		}
		// stepper mount
		// width cannot be smaller than stepper as defined in common.scad therefore no extra cuts need to be made
		translate([position_x_stepper+offset_x_stepper_holes, 0, position_z_stepper+(size_z_case_bottom_/2)]) {
			mirror_copy([0, 1, 0]) {
				translate([0, separation_y_stepper_holes/2, 0]) {
					cylinder(h=size_z_case_bottom_, d=size_x_stepper_mount, center=true);
					cylinder(h=99, d=diameter_thread_stepper, center=true);
				}
			}
			cube([diameter_outer_cutout_gear_stepper, separation_y_stepper_holes, size_z_case_bottom_], center=true);
		}
		// stepper gear cutout
		translate([position_x_gear_stepper, 0, thickness_z_case+(size_z_case_bottom_/2)]) {
			cylinder(h=size_z_case_bottom_, d=diameter_inner_cutout_gear_stepper, center=true);
		}
		translate([((size_x_case_internal-diameter_outer_cutout_gear_stepper)/2)-size_x_compartment_pcb-size_x_stepper_mount, 0, thickness_z_case+(size_z_case_bottom_/2)]) {
			cube([diameter_outer_cutout_gear_stepper, diameter_outer_cutout_gear_stepper, size_z_case_bottom_], center=true);
		}
		// chain cutout
		mirror_copy([0, 1, 0]) {
			translate([position_x_drive, (size_y_case-thickness_xy_case)/2, (size_z_case_bottom_/2)+thickness_z_case+margin_z_gear+size_z_gear]) {
				cube([size_cutout_chain, thickness_xy_case+epsilon, size_z_case_bottom_], center=true);
			}
		}
		case_screws() {
			translate([0, 0, size_z_case_bottom_/2]) {
				cylinder(h=size_z_case_bottom_+epsilon, d=2.65, center=true);
			}
		}
	}
}

case_bottom();
