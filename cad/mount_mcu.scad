include <MCAD/boxes.scad>;

include <common.scad>;
include <constants.scad>;
include <parameters.scad>;
use <utils.scad>;

module mount_mcu() {
	mount_pcb(x=standoff_separation_x_mcu, y=standoff_separation_y_mcu, height=standoff_height_mcu, diameter=diameter_thread_mcu);
}

mount_mcu();
