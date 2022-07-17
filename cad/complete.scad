include <MCAD/multiply.scad>
include <MCAD/regular_shapes.scad>
include <nopscadlib/vitamins/ball_bearings.scad>
include <nopscadlib/core.scad> // VERY IMPORTANT
include <nopscadlib/vitamins/geared_steppers.scad>
include <nopscadlib/vitamins/pcbs.scad>
include <nopscadlib/vitamins/screws.scad>

include <common.scad>

use <case_bottom.scad>
use <case_top.scad>
use <drive.scad>
use <gear_stepper.scad>
use <mount_driver.scad>
use <mount_mcu.scad>

offset_case_top = size_y_case+10;
// offset_case_top = 0;

angle_gear_drive = 5.75;

cutaway_x = 0;
// cutaway_x = -100+position_x_stepper;
// cutaway_y = -100;
cutaway_y = 300;
// cutaway_y = 0;
cutaway_z = 0;

_size_x_chain = 100;

module _chain() {
	difference() {
		union() {
	        torus2(r1=diameter_sprocket/2, r2=diameter_chain_rope/2);
		    spin(teeth_sprocket) {
				rotate([0, 0, angle_gear_drive]) {
			        translate([diameter_sprocket/2,0,0]){
			            sphere(d=diameter_chain_bead);
			        }
				}
		    }
		}
		translate([0, diameter_sprocket/-2, 0]) {
			cube([diameter_sprocket+(diameter_chain_rope*2), diameter_sprocket, diameter_chain_bead], center=true);
		}
	}
	mirror_copy([1, 0, 0]) {
		translate([diameter_sprocket/2, _size_x_chain/-2, 0]) {
			rotate([90, 0, 0]) {
				cylinder(h=_size_x_chain, d=diameter_chain_rope, center=true);
			}
		}
	}
	linear_multiply(no=_size_x_chain/separation_chain_bead, separation=-separation_chain_bead, axis=[0, 1, 0]) {
		// TODO make the beads go around the chain for animation
		union() {
			translate([diameter_sprocket/2, 0, 0]) {
	            sphere(d=diameter_chain_bead);
			}
			translate([diameter_sprocket/-2, 0, 0]) {
	            sphere(d=diameter_chain_bead);
			}
		}
	}
}

module complete() {
	case_bottom();
	translate([0,offset_case_top,size_z_case]) {
		rotate([180,0,0]) {
			case_top();
		}
		case_screws() {
			translate([0, 0, -size_z_screw_head_case]) {
				screw(M3_cap_screw, size_z_case-size_z_screw_head_case);
			}
		}
	}

	translate([position_x_pcbs, size_y_case_internal/2, thickness_z_case+(size_z_case_internal/2)]) {
		rotate([90, 0, 0]) {
			mount_mcu();
			translate([0, 0, standoff_height_mcu+3.6]) {
				rotate([0, 180, 0]) {
					pcb(RPI_Pico);
				}
				mirror_copy([1, 0, 0]) {
					mirror_copy([0, 1, 0]) {
						translate([standoff_separation_x_mcu/2, standoff_separation_y_mcu/2, 0]) {
							screw(M2_cap_screw, standoff_height_mcu);
						}
					}
				}
			}
		}
	}

	translate([position_x_pcbs, size_y_case_internal/-2, thickness_z_case+(size_z_case_internal/2)]) {
		rotate([-90,0,0]) {
			mount_driver();
			translate([0, 0, standoff_height_driver+2]) {
				pcb(ZC_A0591);
				mirror_copy([1, 0, 0]) {
					mirror_copy([0, 1, 0]) {
						translate([standoff_separation_x_driver/2, standoff_separation_y_driver/2, 1.6]) {
							screw(M3_cap_screw, standoff_height_driver);
						}
					}
				}
			}
		}
	}

	translate([position_x_stepper+offset_x_stepper_shaft, 0, position_z_stepper]) {
		rotate([0, 0, 90]) {
			geared_stepper(28BYJ_48);
		}
		mirror_copy([0, 1, 0]) {
			translate([-offset_x_stepper_shaft+offset_x_stepper_holes, separation_y_stepper_holes/2, position_z_stepper-size_z_stepper+3]) {
				screw(M4_cap_screw, position_z_stepper);
			}
		}
	}

	translate([position_x_gear_stepper,0,position_z_stepper-separation_z_stepper_shaft-(size_z_gear/2)]) {
		gear_stepper();
	}

	translate([position_x_drive,0,position_z_stepper-separation_z_stepper_shaft-size_z_gear]) {
		translate([0, 0, size_z_bearing/2]) {
			ball_bearing(BB608);
		}
		rotate([0, 0, angle_gear_drive]) {
			drive();
		}
		translate([0, 0, size_z_gear+(size_z_sprocket/2)]) {
			#_chain();
		}
		translate([0, 0, size_z_gear+size_z_sprocket+margin_z_gear+(size_z_bearing/2)]) {
			ball_bearing(BB608);
		}
	}
}

difference() {
	complete();
	translate([cutaway_x, cutaway_y, cutaway_z]) {
		cube([200, 200, 200], center = true);
	}
}
