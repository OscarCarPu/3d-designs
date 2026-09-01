// Arandela para las bocallaves del rail (bajomesa_homelab.scad).
// Agranda la cabeza del tornillo para que pise el labio del rail.
//
//   od : MENOR que el circulo de entrada del rail (13 mm), o no pasa
//        al colgarlo. Y MAYOR que la ranura de deslizamiento (7,5 mm),
//        o no pisa nada.
//   id : justo para que pase la cana del tornillo. Si sobra, la cabeza
//        se cuela por la arandela y no has arreglado nada.
//
// Espesor 2 mm, asi que deja 5,5 mm de vastago fuera del tablero en
// vez de 3,5.

od = 12.2;
id = 4.5;

$fn = 96;

difference() {
    cylinder(h = 2, d = od);
    translate([0, 0, -0.5]) cylinder(h = 3, d = id);
}
