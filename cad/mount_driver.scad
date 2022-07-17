include <MCAD/boxes.scad>;

include <common.scad>;
include <constants.scad>;
include <parameters.scad>;
use <utils.scad>;

module mount_driver() {
	mount_pcb(x=standoff_separation_x_driver, y=standoff_separation_y_driver, height=standoff_height_driver, diameter=diameter_thread_driver);
}

mount_driver();
