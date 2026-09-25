$fn = 96;

diametro_exterior = 14;
altura_total      = 18;
agujero_grande    = 11;
agujero_pequeno   = 6;
altura_fondo      = 2;

module guia_zapatero() {
    difference() {
        cylinder(h = altura_total, d = diametro_exterior);
        translate([0, 0, -1])
            cylinder(h = altura_total, d = agujero_pequeno);
        translate([0, 0, altura_fondo])
            cylinder(h = altura_total - altura_fondo, d = agujero_grande);
    }
}

guia_zapatero();
