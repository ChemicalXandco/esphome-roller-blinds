include <MCAD/involute_gears.scad>;
include <MCAD/boxes.scad>;

include <constants.scad>;
include <parameters.scad>;
use <utils.scad>;

// number_of_teeth must be >= 8
// any gears made this way will be compatible
module standard_gear(number_of_teeth){
    gear(
        number_of_teeth=number_of_teeth,
        circular_pitch=gear_circular_pitch,
        // diametral_pitch=gear_diametral_pitch,
        pressure_angle=gear_pressure_angle,
        bore_diameter=0,
        hub_thickness=size_z_gear,
        rim_thickness=size_z_gear,
        gear_thickness=size_z_gear,
        backlash=backlash_gear
    );
};

// TODO 180 is changed to pi in a newer version of MCAD
diameter_pitch_gear_stepper = (gear_circular_pitch*teeth_gear_stepper)/180;
diameter_pitch_gear_drive = (gear_circular_pitch*teeth_gear_drive)/180;
diameter_outer_gear_stepper = diameter_pitch_gear_stepper+((diameter_pitch_gear_stepper/teeth_gear_stepper)*2);
diameter_outer_gear_drive = diameter_pitch_gear_drive+((diameter_pitch_gear_drive/teeth_gear_drive)*2);
separation_x_gears = (diameter_pitch_gear_stepper+diameter_pitch_gear_drive)/2;

// margins (3) between:
// case <-> mcu / driver
// mcu / driver <-> seperator
// (no margin between seperator and stepper, gears)
// drive <-> case
size_x_compartment_pcb = (margin*2)+max(size_x_mcu, size_x_driver);
size_x_case_internal = margin+size_x_compartment_pcb-offset_x_stepper_holes-offset_x_stepper_shaft+separation_x_gears+(diameter_outer_gear_drive/2);
size_y_case_internal = (margin*2)+max(size_y_stepper, diameter_outer_gear_drive);

// measured from the top of the casing
// length of end of shaft contained in gear
position_z_stepper = thickness_z_case+margin_z_gear+size_z_gear+separation_z_stepper_shaft;
// unless the size_z_gear is ridiculously high the limiting factor is probably the stepper driver
size_z_case_internal = max(
    // margins above and below pcbs
    size_y_mcu+(margin*2),
    size_y_driver+(margin*2),
    position_z_stepper+size_z_stepper-thickness_z_case,
    // margin below drive and in between sprocket and top bearing
    (margin_z_gear*2)+size_z_gear+size_z_sprocket+size_z_bearing
);

size_x_case = size_x_case_internal+(thickness_xy_case*2);
size_y_case = size_y_case_internal+(thickness_xy_case*2);
size_z_case = size_z_case_internal+(thickness_z_case*2);

// TODO work out why the variables below will not work without a trailing character
// margin_z_gear below the gear and above the sprocket
size_z_case_bottom_ = thickness_z_case+(margin_z_gear*2)+size_z_gear+size_z_sprocket;
size_z_case_top_ = size_z_case-size_z_case_bottom_;

position_x_separator = ((size_x_case_internal-size_x_stepper_mount)/2)-size_x_compartment_pcb;

module case_half(height) {
    translate([0, 0, height/2]) {
        difference() {
            // TODO replace with `roundedCube` in newer version of MCAD
            roundedBox([size_x_case,size_y_case,height], case_bevel_radius_outer, true);
            translate([0, 0, thickness_z_case]) {
                roundedBox([size_x_case-(thickness_xy_case*2),size_y_case-(thickness_xy_case*2),height], case_bevel_radius_inner, true);
            }
        }
    }
}

offset_case_screw = max(case_bevel_radius_outer, diameter_head_case/2);
position_y_case_screw = (size_y_case/2)-offset_case_screw;
position_x2_case_screw = (size_x_case/-2)+offset_case_screw;

module case_screws(x1=true, x2=true) {
    mirror_copy([0, 1, 0]) {
        translate([0, position_y_case_screw, 0]) {
            translate([position_x_separator, 0, 0]) {
                if (x1) {
                    children();
                }
            }
            translate([position_x2_case_screw, 0, 0]) {
                if (x2) {
                    children();
                }
            }
        }
    }
}

separation_x_slot = size_x_case_internal+((size_x_case-size_x_case_internal)/2);
separation_y_slot = size_y_case_internal+((size_y_case-size_y_case_internal)/2);

module case_slot() {
    translate([0, 0, size_z_case_slot/2]) {
        difference() {
            // TODO replace with `roundedCube` in newer version of MCAD
            roundedBox([separation_x_slot+thickness_xy_case_slot, separation_y_slot+thickness_xy_case_slot, size_z_case_slot], 3, true);
            roundedBox([separation_x_slot-thickness_xy_case_slot, separation_y_slot-thickness_xy_case_slot, size_z_case_slot+epsilon], 3, true);
            case_screws() {
				// TODO define diameter offset
				cylinder(h=size_z_case_slot+epsilon, d=diameter_head_case+2, center=true);
            }
			// separator
			translate([position_x_separator, 0, 0]) {
				cube([size_x_stepper_mount, size_y_case, size_z_case_slot+epsilon], center=true);
			}
        }
    }
}

module spindle_bearing() {
    union() {
        translate([0, 0, margin_z_gear/2]) {
            cylinder(h=margin_z_gear, d=diameter_inner_bearing+(offset_xy_bearing_rim*2), center=true);
        }
        translate([0, 0, margin_z_gear+(size_z_bearing/2)]) {
            cylinder(h=size_z_bearing, d=diameter_inner_bearing, center=true);
        }
    }
}

module standoffs(x, y, height, diameter, diameter_standoff) {
    mirror_copy([1,0,0]) {
        mirror_copy([0,1,0]) {
            translate([x/2, y/2, height/2]) {
                difference() {
                    cylinder(h=height, d=diameter_standoff, center=true);
                    cylinder(h=height+epsilon, d=diameter, center=true);
                }
            }
        }
    }
}

module mount_pcb(x, y, height, diameter) {
    diameter_standoff = diameter+(thickness_standoff*2);

    union() {
    	translate([0, 0, thickness_base_mount_pcb]) {
    		standoffs(x=x, y=y, height=height, diameter=diameter, diameter_standoff=diameter_standoff);
    	}
    	translate([0, 0, thickness_base_mount_pcb/2]) {
            // TODO: replace with `roundedCube` in newer version of MCAD
            roundedBox([x+diameter_standoff, size_z_case_internal, thickness_base_mount_pcb], radius_bevel_base_mount_pcb, true);
    	}
    }
}

// miscellaneous values that must be derived
// all positions are measured from the center point of the bounding box of the object to the origin
position_x_pcbs = ((size_x_case-size_x_compartment_pcb)/2)-thickness_xy_case;
position_x_stepper = position_x_pcbs-(size_x_compartment_pcb/2)+offset_x_stepper_holes;
position_x_gear_stepper = position_x_stepper+offset_x_stepper_shaft;
position_x_drive = position_x_gear_stepper-separation_x_gears;

diameter_sprocket = (separation_chain_bead*teeth_sprocket)/pi;
diameter_outer_bearing_rim = diameter_outer_bearing-(offset_xy_bearing_rim*2);
