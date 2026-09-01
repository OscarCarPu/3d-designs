od = 12.2;
id = 4.5;

$fn = 96;

difference() {
    cylinder(h = 2, d = od);
    translate([0, 0, -0.5]) cylinder(h = 3, d = id);
}
