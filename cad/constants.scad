// values defined here are not to be customised
// values that do not meet this requirement should go in parameters.scad instead

// number of fragments (used for gear teeth)
$fn = $preview ? 32 : 128;

// minimum printable thickness
thickness_standoff = 0.8;

// 28BYJ-48 model
diameter_min_stepper_shaft = 3;
diameter_max_stepper_shaft = 5;
// offset of the center of the mounting holes from the centre of its bounding box
offset_x_stepper_holes = -1.75; 
// offset of the stepper shaft relative from the centre of its bounding box `offset_x_stepper_holes-8`
offset_x_stepper_shaft = -9.75;
// between the center of the mounting holes
separation_y_stepper_holes = 35;
// distance between top of main body and bottom of the flat section at the top of the shaft `10-6`
separation_z_stepper_shaft = 4;
// between opposite ends perpendicular to the mounting holes
size_x_stepper = 31;
// outer diameter of the 'wings'
size_x_stepper_mount = 7;
// parallel to the mounting holes not including them; only the main body
size_y_stepper = 28;
// not including anything above the top of the mounting holes
size_z_stepper = 19;
// only taking the 'wings' into account
size_z_stepper_mount = 0.8;
// size of the flat section at the top of the shaft
size_z_stepper_shaft = 6;

