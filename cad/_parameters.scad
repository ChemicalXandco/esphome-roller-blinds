// this file is to customize the output
// it should be unique to your specific requirements

// all measurements in millimetres unless otherwise stated
// defaults provided here are for raspberry pi pico w as mcu and a ZC_A0591 uln2003an driver

// When a small distance is needed to overlap shapes for boolean cutting, etc.
// set to 0 for final export
epsilon = 0.02;
// epsilon = 0;

// minimum distance around components
margin = 1;
margin_z_gear = 1;

// angle to the horizontal plane
// increase to improve print quality, decrease to obviate supports
angle_max_slope = 60;

size_z_case_top = 10;
size_z_case_slot = 5;
thickness_xy_case = 5;
thickness_xy_case_slot = 2;
thickness_z_case = 2;
case_bevel_radius_outer = 5;
case_bevel_radius_inner = 1;

// mount used to attach mcu and driver modules
thickness_base_mount_pcb = 2;
radius_bevel_base_mount_pcb = 5;

// these 2 values directly correspond to the size of the cutout for the micro usb cable b
size_y_usb = 11;
size_z_usb = 13;
offset_y_usb = 10;

// TODO verify all this
// case screws
// M3 (socket cap)
diameter_head_case = 5.5;
diameter_hole_case = 3;
diameter_thread_case = 2.65;
size_z_screw_head_case = 3;

// consider largest length and width (with the x being the largest of the 2)
// nodemcu
size_x_mcu = 57;
size_y_mcu = 30.5;
// rpi pico
// size_x_mcu = 51;
// size_y_mcu = 21;
size_x_driver = 35;
size_y_driver = 32.5;

standoff_height_mcu = 5;
standoff_height_driver = 3;

// distance between centers of 2 holes
// nodemcu
// standoff_separation_x_mcu = 51.5;
// standoff_separation_y_mcu = 25;
// rpi pico
standoff_separation_x_mcu = 47;
standoff_separation_y_mcu = 11.4;
standoff_separation_x_driver = 29.5;
standoff_separation_y_driver = 26.8;

// diameter of the holes of the standoffs on the mount
// nodemcu (M3)
// diameter_thread_mcu = 2.65;
// rpi pico (M2)
diameter_thread_mcu = 1.75;
// M3
diameter_thread_driver = 2.65;
// M4
diameter_thread_stepper = 3.65;

// cannot be lower than size_z_bearing
size_z_gear = 10;
gear_circular_pitch = 300;
gear_pressure_angle = 28;
// minium 8
teeth_gear_stepper = 8;
// increase if not enough torque
teeth_gear_drive = 31;
// increase if gears too tight
backlash_gear = 0.1;

diameter_inner_bearing = 8;
diameter_outer_bearing = 22;
size_z_bearing = 7;
offset_xy_bearing_rim = 1;

size_z_sprocket = 10;
diameter_chain_bead = 5;
diameter_chain_rope = 2;
separation_chain_bead = 20;
// 3 in considered the minimum, although 2 might be feasible in some circumstances
teeth_sprocket = 3;
// must leave enough clearance to guarantee chain does not hit wall in the worst case
size_cutout_chain = 30;

