// all units mm

$fn = 100;

fit_correction_amount = 0;

tight_fit = 0.125 + fit_correction_amount;
normal_fit = 0.250 + fit_correction_amount;
loose_fit = 0.500 + fit_correction_amount;

cell_width = 71.7; // +- 0.8
cell_length = 173.9; // +- 0.8
cell_height = 207.2; // +- 0.8

bracket_thickness = 4;
bracket_skirt_height = 15;
bracket_foot_height = 2;

terminal_radius = 30;
terminal_distance_from_wall = 25;

fit = normal_fit;

cell_blank_width = cell_width + fit;
cell_blank_length = cell_length + fit;
cell_blank_height = cell_height + fit;
cell_blank = [cell_blank_width, cell_blank_length, cell_blank_height];


bottom_bracket = [cell_blank_width + bracket_thickness,cell_blank_length
 + bracket_thickness, bracket_skirt_height + bracket_foot_height];
 
 
module main() {
    bottom_bracket();
    rotate([0, 180, 0]) 
        translate([-cell_blank_width, 0, -cell_blank_height]) 
            top_bracket();
    rotate([0, 270,0]) translate([bracket_skirt_height + bracket_foot_height, 0, 10 + bracket_thickness/2]) inter_cell_wall();
}

module inter_cell_wall() {
    height = cell_blank_height - 2*bracket_skirt_height;
    width = cell_blank_length - 2;
    translate([0,0,2]) honeycomb(width, height, bracket_thickness, 19, 2);
    linear_extrude(height = bracket_thickness) { 
        translate([width/2,height/2,0]) difference() {
            square([width, height], center=true);
            square([width-bracket_thickness, height-bracket_thickness], center=true);
        };
    };
};

module bottom_bracket() {
    difference() {
        translate([
            -bracket_thickness/2, 
            -bracket_thickness/2,
            0.01,
        ]) cube(bottom_bracket);
        cube(cell_blank);
    };  
    translate([
        -bracket_thickness/2, 
        -bracket_thickness/2, 
        1.5
    ]) honeycomb(
        cell_width+bracket_thickness, 
        cell_length+bracket_thickness, 
        bracket_foot_height, 
        19, 
        2
    );  
};

module top_bracket() {
    difference() {
        union() {
            difference() {
                union() {
                    difference() {
                        union() {
                            bottom_bracket();    
                            translate([
                                cell_blank_width/2,
                                terminal_distance_from_wall,
                                0.5,
                            ]) cylinder(bracket_foot_height, d=terminal_radius + bracket_thickness);
                        };
                        translate([
                            cell_blank_width/2,
                            terminal_distance_from_wall,
                            0,
                        ]) cylinder(bracket_foot_height*2, d=terminal_radius);
                    };
                    translate([
                        cell_blank_width/2,
                        cell_blank_length - terminal_distance_from_wall,
                        0.5,
                    ]) cylinder(bracket_foot_height, d=terminal_radius + bracket_thickness);
                };
                translate([
                    cell_blank_width/2,
                    cell_blank_length-terminal_distance_from_wall,
                    0,
                ]) cylinder(bracket_foot_height*2, d=terminal_radius);
            };
            hull() {
                translate([
                    3 * cell_blank_width/8,
                    cell_blank_length/2,
                    0.5,
                ]) cylinder(bracket_foot_height, d=20+bracket_thickness);
                translate([
                    5 * cell_blank_width/8,
                    cell_blank_length/2,
                    0.5,
                ]) cylinder(bracket_foot_height, d=20+bracket_thickness);
            };
        };
        hull() {
            translate([
                3 * cell_blank_width/8,
                cell_blank_length/2,
                0,
            ]) cylinder(bracket_foot_height * 2, d=20);
            translate([
                5 * cell_blank_width/8,
                cell_blank_length/2,
                0,
            ]) cylinder(bracket_foot_height * 2, d=20);
        };
    };
};

module cell_blank() {
    cube(cell_blank);
};
 
module hc_column(length, cell_size, wall_thickness) {
        no_of_cells = floor(length / (cell_size + wall_thickness)) ;

        for (i = [0 : no_of_cells]) {
                translate([0,(i * (cell_size + wall_thickness)),0])
                         circle($fn = 6, r = cell_size * (sqrt(3)/3));
        }
}

module honeycomb (length, width, height, cell_size, wall_thickness) {
        no_of_rows = floor(1.2 * length / (cell_size + wall_thickness)) ;

        tr_mod = cell_size + wall_thickness;
        tr_x = sqrt(3)/2 * tr_mod;
        tr_y = tr_mod / 2;
        off_x = -1 * wall_thickness / 2;
        off_y = wall_thickness / 2;
        linear_extrude(height = height, center = true, convexity = 10, twist = 0, slices = 1)
                difference(){
                        square([length, width]);
                        for (i = [0 : no_of_rows]) {
                                translate([i * tr_x + off_x, (i % 2) * tr_y + off_y,0])
                                        hc_column(width, cell_size, wall_thickness);
                        }
                }
}

main();
