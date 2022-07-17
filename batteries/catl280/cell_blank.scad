// all units mm

tight_fit = 0.125;
normal_fit = 0.250;
loose_fit = 0.500;

cell_width = 71.7; // +- 0.8
cell_length = 173.9; // +- 0.8
cell_height = 207.2; // +- 0.8

bracket_thickness = 4;
bracket_skirt_height = 4;
bracket_foot_height = 3;

fit = normal_fit;

cell_blank_width = cell_width + fit;
cell_blank_length = cell_length + fit;
cell_blank_height = cell_height + fit;
cell_blank = [cell_blank_width, cell_blank_length, cell_blank_height];


bottom_bracket = [cell_blank_width + bracket_thickness,cell_blank_length
 + bracket_thickness, bracket_skirt_height + bracket_foot_height];
 
 
module main() {
    bottom_bracket();
}

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
