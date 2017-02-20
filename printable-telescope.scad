$fn = 160;
beam_x = 82.6;
beam_r = 6.4;
beam_d = beam_r * 2;
inch = 25.4;

rod_r = 2;

base_z = 20;
base_r1 = 62;
base_r2 = base_r1 + 1;
base_r3 = base_r1 + 2.5;
base_r4 = base_r1 + 3.5;
base_r5 = base_r1 + 13.5;

secondary_r1 = 13.25;
secondary_r2 = 10.25;

module erector_beam() {
    translate([0, 0, -0.45])
        hull() {
            cylinder(r = beam_r + 0.25, h = 0.9);
            translate([beam_x, 0, 0])
                cylinder(r = beam_r + 0.25, h = 0.9);
        }
}
module mirror() {
    scale([1, secondary_r2 / secondary_r1, 1])
        cylinder(r = secondary_r1, h = 2);
}


module mount_hardware() {
    translate([-1, 0, beam_d * 2 + beam_r * 1.5 - 1.5])
        rotate([0, 45, 0]) {
            mirror();
            translate([0, 0, 1.98])
                scale([1.5, 1.5, 10])
                    mirror();
        }
    translate([0, 0, beam_r * 1.5])
        rotate([90, 0, 0])
            translate([-beam_x / 2, 0, 0])
                erector_beam();
    rotate([90, 0, 0])
        translate([-beam_x / 2, 0, 0])
            erector_beam();
    translate([0, 0, beam_d + beam_r * 1.5])
        rotate([90, 0, 90])
            translate([-beam_x / 2, 0, 0])
                erector_beam();
    translate([0, 0, beam_d + beam_r])
        rotate([90, 0, 90])
            translate([-beam_x / 2, 0, 0])
                erector_beam();
    translate([-11.02, 0, beam_d + beam_r * 1.5])
        rotate([0, 90, 0]) {
            cylinder(r = 2.25, h = 18);
            cylinder(r = 3.5, h = 3);
        }
    translate([4, -3.5, beam_d + beam_r * 1.5 -4]) {
        cube([3, 7, 10]);
        //#cube([3, 7, 7.5]);
    }
    translate([0, -11.02, beam_r])
        rotate([0, 90, 90]) {
            cylinder(r = 2.25, h = 18);
            cylinder(r = 3.5, h = 3);
        }
    translate([-3.5, 4, -0.02]) {
        cube([7, 3, 11]);
    }
}

module mirror_mount() {
    difference() {
        cylinder(r = 11, h = beam_d * 3.5);
        mount_hardware();
    }
}


module nuts() {
    for (r = [0 : 90 : 270]) {
        rotate([0, 0, r]) {
            translate([1-base_r5, -4, 0]) {
                cube([base_r5 - base_r4 - .5, 8, 4]);
            }
        }
    }
}

module rods(h = 10) {
    for (r = [0 : 90 : 270]) {
        rotate([0, 0, r]) {
            translate([-(base_r5 + base_r4) / 2, 0, -0.02]) {
                cylinder(r = rod_r, h = h + 0.04);
            }
        }
    }
}

module tube_ring() {
    difference() {
        union() {
            cylinder(r = base_r5, h = 2);
            cylinder(r = base_r4+1, h = base_z);
            nuts();
        }
        translate([0, 0, -.1])
            cylinder(r = base_r3, h = base_z + 0.2);
        rods();
    }
}

module tube_ring_cut() {
    difference() {
        tube_ring();
        
        translate([0, 0, 30])
            rotate([90, 10, 45])
                erector_beam();
        translate([0, 0, 30])
            rotate([90, 10, 180+45])
                erector_beam();
        translate([0, 0, -10])
            rotate([-90, -10, -45])
                erector_beam();
        translate([0, 0, -10])
            rotate([-90, -10, 180-45])
                erector_beam();
    }
}

module tube_base() {
    difference() {
        union() {
            cylinder(r = base_r5, h = 2);
            cylinder(r = base_r2, h = base_z);
            nuts();
        }
        translate([0, 0, -.1])
            cylinder(r = base_r1, h = base_z + 0.2);
        rods();
    }
    difference() {
        cylinder(r = base_r4, h = base_z);
        translate([0, 0, 2])
            cylinder(r = base_r3, h = base_z);
        translate([0, 0, -.1])
            cylinder(r = base_r1, h = base_z + 0.2);
    }
}

module lens() {
    cylinder(r1=1,r2=25.5, h=1.25);
    translate([0, 0, 1.23])
        cylinder(r=25.5, h=2.54);
    translate([0, 0, 3.75])
        cylinder(r1=25.5, r2=1, h=1.25);
}

module lens_tube(support = true) {
    difference() {
        union() {
            cylinder(r=30, h=7);
            cylinder(r = 1.25 * inch / 2 - .6, h = 50);
            /*
            translate([-30, -.3, 0])
                cube([30 - 1.25 * inch / 2, .6, 50]);
            translate([-30, - 1.25 * inch / 2, 0])
                cube([30, .6, 50]);
            translate([-30, 1.25 * inch / 2 - .6, 0])
                cube([30, .6, 50]);
            translate([-30, - 1.25 * inch / 4, 0])
                cube([30, .5, 50]);
            translate([-30, 1.25 * inch / 4 - .6, 0])
                cube([30, .6, 50]);
            */
        }
        translate([0, 0, 1])
            lens();
        translate([16, 0, 1])
        scale([.75, 1, 1])
            cylinder(r = 26, h=5);
        translate([0, 0, -.02])
            cylinder(r = 1.15 * inch / 2, h = 50.04);
    }
    if(support) {
    translate([-30, -.3, 0])
        cube([30 + 1.05 * inch / 2, .6, 50]);
    translate([sin(22)*.6, -.3, 0])
    rotate([0, 0, 22])
        cube([1.12 * inch / 2, .6, 50]);
    translate([0, -.3, 0])
    rotate([0, 0, -22])
        cube([1.12 * inch / 2, .6, 50]);
    translate([cos(22)*1.08 * inch / 2, -.25-sin(22)*1.05 * inch / 2, 0])
        cube([.6, sin(22)*1.05 * inch+.5, 50]);
    }
}

module lens_extender() {
    difference() {
        union() {
            cylinder(r = 1.25 * inch / 2 - .6, h = 100);
            cylinder(r = 2 + 1.25 * inch / 2, h = 30);
        }
        translate([0, 0, -.1])
            cylinder(r = +1.25 * inch / 2, h = 28);
        cylinder(r = 1.15 * inch / 2, h = 100.1);
    }
}

module lens_tube_printable() {
    rotate([0, -90, 0])
        lens_tube(support = true);
}

module eyepiece_holes() {
    rotate([0, -90, 0]) {
        cylinder(r = +1.25 * inch / 2, h = 5 * inch);
        for(r = [0 : 90 : 90]) {
            translate([0, -4, 0]) {
                rotate([0, 0, r + 45]) {
                    translate([-20, 0, 60]) {
                        cylinder(r = 2.25, h = 18);
                        cylinder(r = 3.5, h = 6);
                    }
                }
            }
        }
        for(r = [180 : 90 : 270]) {
            translate([0, 4, 0]) {
                rotate([0, 0, r + 45]) {
                    translate([-20, 0, 60]) {
                        cylinder(r = 2.25, h = 18);
                        cylinder(r = 3.5, h = 6);
                    }
                }
            }
        }
    }
}

module eyepiece_tube_2() {
    difference() {
        union() {
            rotate([0, 0, 0]) {
                translate([-base_r4 - 7.5, -1.25 * inch / 2 - 8, -3 - 1.25 * inch / 2])
                    cube([4, 1.25 * inch + 16, 1.25 * inch + 6]);
            }
            rotate([0, -90, 0]) {
                translate([0, 0, 72]){
                    cylinder(r = 2 + 1.25 * inch / 2, h = inch * 1.5);
            }}
        }
        eyepiece_holes();
    }
}

module eyepiece_tube() {
    difference() {
        translate([0, 0, -3 - 1.25 * inch / 2]) {
            union() {
                translate([-base_r4 - 3, -60, 0])
                    cube([30, 120, 3]);
                translate([-base_r4 - 3, -60, 1.25 * inch + 3])
                    cube([30, 120, 3]);
                translate([-base_r4 - 3, -1.25 * inch / 2 - 8, 0])
                    cube([30, 1.25 * inch + 16, 1.25 * inch + 6]);
                cylinder(r = 50, h = 10);
            }
        }
        translate([0, 0, -3.02 - 1.25 * inch / 2])
            cylinder(r = base_r3, h = 2 * inch + 0.04);
        translate([0, 0, -3 - 1.25 * inch / 2]) {
            rotate([0, 0, 45]) {
                rods(2 * inch);
            }
        }
        eyepiece_holes();
    }
    
}

module display_model() {
    tube_base();
    translate([0, 0, 200])
        tube_ring();
    translate([0, 0, 400])
        tube_ring_cut();
    translate([0, 0, 419])
        rotate([0, 180, 45])
            mirror_mount();
    translate([0, 0, 381])
        rotate([0, 180, 180+45])
            eyepiece_tube();
    translate([0, 0, 381])
        rotate([0, 0, 45])
    eyepiece_tube_2();
    translate([0, 0, 600])
        rotate([0, 180, 0])
            tube_base();
    translate([0, 0, -3]) {
        %rods(h = 606);
    }
    translate([0, 0, 381])
        rotate([-90, 0, -45]) {
            translate([0, 0, -base_r5-130])
                lens_tube(support = false);
            translate([0, 0, -base_r5-100])
                lens_extender();
        }
}


display_model();

//tube_ring_cut();
//rotate([0, -90, 0])
//    eyepiece_tube();
//rotate([0, 90, 0])
//    eyepiece_tube_2();

//mirror_mount();