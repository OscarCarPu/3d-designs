$fn = 96;

soporte    = 1;
tapa       = 1;
pisacables = 1;

holgura = 0.5;

diametro_tapa = 100;
altura_tapa   = 40;
pared         = 2;
suelo         = 3;
chaflan       = 1.5;

ancho_pletina  = 20;
grosor_pletina = 4;
grosor_oreja   = 5;
altura_oreja   = 12;
agujero_centro = 12;

separacion_tacos        = 50;
diametro_tornillo_techo = 4.5;
diametro_cabeza_techo   = 9;

altura_tornillo_lateral = 7;
diametro_piloto         = 2.6;
diametro_paso           = 3.4;

diametro_cable    = 7;
apriete           = 0;
distancia_pinza   = 20;
diametro_poste    = 8;
grosor_pisacables = 4;

radio_interior   = diametro_tapa / 2 - pared;
largo_pletina    = 2 * (radio_interior - holgura);
separacion_poste = diametro_cable + diametro_poste + 2;
altura_poste     = diametro_cable - apriete;

module soporte() {
    difference() {
        intersection() {
            union() {
                translate([-largo_pletina / 2, -ancho_pletina / 2, 0])
                    cube([largo_pletina, ancho_pletina, grosor_pletina]);
                for (lado = [-1, 1])
                    translate([lado * (largo_pletina - grosor_oreja) / 2, 0, altura_oreja / 2])
                        cube([grosor_oreja, ancho_pletina, altura_oreja], center = true);
            }
            cylinder(h = altura_oreja, r = largo_pletina / 2);
        }
        translate([0, 0, -1])
            cylinder(h = grosor_pletina + 2, d = agujero_centro);
        for (lado = [-1, 1])
            translate([lado * separacion_tacos / 2, 0, 0]) {
                translate([0, 0, -1])
                    cylinder(h = grosor_pletina + 2, d = diametro_tornillo_techo);
                translate([0, 0, grosor_pletina - (diametro_cabeza_techo - diametro_tornillo_techo) / 2])
                    cylinder(h = (diametro_cabeza_techo - diametro_tornillo_techo) / 2 + 0.01,
                             d1 = diametro_tornillo_techo, d2 = diametro_cabeza_techo);
            }
        translate([0, 0, altura_tornillo_lateral])
            rotate([0, 90, 0])
                cylinder(h = largo_pletina + 2, d = diametro_piloto, center = true);
    }
}

module tapa() {
    difference() {
        union() {
            difference() {
                hull() {
                    cylinder(h = altura_tapa - chaflan, d = diametro_tapa);
                    translate([0, 0, chaflan])
                        cylinder(h = altura_tapa - chaflan, d = diametro_tapa);
                    cylinder(h = 0.01, d = diametro_tapa - 2 * chaflan);
                }
                translate([0, 0, suelo])
                    cylinder(h = altura_tapa, r = radio_interior);
            }
            for (lado = [-1, 1])
                translate([lado * separacion_poste / 2, distancia_pinza, 0])
                    cylinder(h = suelo + altura_poste, d = diametro_poste);
        }
        translate([0, 0, -1])
            cylinder(h = suelo + 2, d = diametro_cable + 1);
        for (lado = [-1, 1])
            translate([lado * separacion_poste / 2, distancia_pinza, suelo])
                cylinder(h = altura_poste + 1, d = diametro_piloto);
        translate([0, 0, altura_tapa - altura_tornillo_lateral])
            rotate([0, 90, 0])
                cylinder(h = diametro_tapa + 2, d = diametro_paso, center = true);
    }
}

module pisacables() {
    difference() {
        hull()
            for (lado = [-1, 1])
                translate([lado * separacion_poste / 2, 0, 0])
                    cylinder(h = grosor_pisacables, d = diametro_poste);
        for (lado = [-1, 1])
            translate([lado * separacion_poste / 2, 0, -1])
                cylinder(h = grosor_pisacables + 2, d = diametro_paso);
    }
}

if (tapa == 1) tapa();
if (soporte == 1) translate([0, -diametro_tapa / 2 - ancho_pletina, 0]) soporte();
if (pisacables == 1) translate([0, diametro_tapa / 2 + diametro_poste, 0]) pisacables();
