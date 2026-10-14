pieza = "figura";

$fn = 36;

sep_tornillos = 365;
n_figuras = 4;

d_vastago = 3;
d_cabeza = 6.5;
llave_labio = 3;
llave_fondo = 3.5;
llave_largo = 7;

x_figuras = [for (i = [0 : n_figuras - 1]) -sep_tornillos / 2 + i * sep_tornillos / (n_figuras - 1)];

module cadena(puntos, diametros) {
    for (i = [0 : len(puntos) - 2])
        hull() {
            translate(puntos[i]) sphere(d = diametros[i]);
            translate(puntos[i + 1]) sphere(d = diametros[i + 1]);
        }
}

module alargado(d, h, largo) {
    hull() {
        cylinder(d = d, h = h);
        translate([0, largo, 0]) cylinder(d = d, h = h);
    }
}

module cerradura() {
    d_entrada = d_cabeza + 0.5;
    d_cuello = d_vastago + 0.4;
    translate([0, 0, -1]) cylinder(d = d_entrada, h = llave_labio + 1);
    translate([0, 0, -1]) alargado(d_cuello, llave_labio + 1, llave_largo);
    translate([0, 0, llave_labio - 0.01]) alargado(d_entrada, llave_fondo + 0.01, llave_largo);
}

module pared_plana() {
    translate([-300, -300, 0]) cube([600, 600, 300]);
}

module figura() {
    difference() {
        intersection() {
            cuerpo();
            pared_plana();
        }
        cerradura();
    }
}

if (pieza == "figura") figura();
else if (pieza == "vista") {
    color("gainsboro") translate([-250, -120, -2]) cube([500, 260, 2]);
    for (x = x_figuras) translate([x, -llave_largo, 0]) color(color_figura) figura();
}

color_figura = "steelblue";

module cuerpo() {
    hull() {
        translate([0, -8, 10]) sphere(d = 30);
        translate([0, 12, 10]) sphere(d = 28);
    }
    hull() {
        translate([2, 22, 12]) sphere(d = 16);
        translate([4, 34, 14]) sphere(d = 24);
    }
    cadena([[12, 18, 10], [22, 30, 12], [24, 46, 16], [18, 58, 26], [10, 62, 38]], [10, 9, 9, 9, 9]);
    translate([10, 62, 38]) sphere(d = 13);
    cadena([[-12, 18, 10], [-24, 28, 12], [-34, 42, 14]], [10, 9, 9]);
    translate([-34, 42, 14]) sphere(d = 11);
    cadena([[-8, -18, 10], [-14, -34, 14], [-26, -44, 20], [-30, -56, 28]], [13, 12, 12, 11]);
    cadena([[8, -18, 10], [18, -30, 14], [14, -46, 12], [22, -58, 16]], [13, 12, 12, 11]);
}
