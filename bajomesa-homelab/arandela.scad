// =====================================================================
//  ARANDELA DE REFUERZO PARA LAS BOCALLAVES DEL RAIL
//
//  Motivo: la cabeza del tornillo (Ø11) apoya sobre un labio de solo
//  1,75 mm de plastico a cada lado de la ranura. Si el tornillo tiene
//  cabeza abombada/avellanada, ese cono hace de cuna contra la ranura
//  y acaba abriendola con el uso. Esta arandela reparte la carga sobre
//  una superficie plana en vez de una linea, sin tocar el modelo.
//
//  MEJOR EN METAL: compra arandelas carroceras DIN 9021 M6 (Ø18x1,6),
//  12 unidades, ~3 EUR en cualquier ferreteria. Esta pieza es sobre
//  todo para verificar el encaje antes de comprar, o como parche de
//  emergencia si no puedes ir a la ferreteria ahora mismo: repartir
//  carga sobre PLA sigue siendo mejor que sobre la punta de un cono,
//  pero el metal no fluye con el tiempo y el plastico si.
//
//  ENCAJE COMPROBADO contra bajomesa_homelab.scad:
//    - Ø18 SI pasa la oreja (23 mm de ancho), con margen de 2-3 mm.
//    - Ø18 NO pasa el circulo de entrada de la bocallave (Ø13): monta
//      la arandela con el rail YA COLGADO, no antes.
//    - Con esta arandela, deja fuera del tablero 3,5 + espesor de
//      arandela (por defecto 5,1 mm en vez de 3,5). Ajusta la
//      profundidad de atornillado en consecuencia.
//
//  Unidades: milimetros.
// =====================================================================

/* --------- MEDIDAS (DIN 9021 M6 por defecto) ----------------------- */
od      = 18;    // diametro exterior
id      = 6.6;    // diametro interior (holgura sobre tornillo M6/Ø6)
espesor = 1.6;    // grosor
chaflan = 0.4;    // chaflan en el agujero, para que entre sin rebaba

$fn = 64;

/* --------- COMPROBACION DE ENCAJE (contra el modelo del rail) ------ */
// Copiadas de bajomesa_homelab.scad para no depender de el (evita
// arrastrar BOSL2 solo para imprimir una arandela).
d_vastago = 6;  R_ear = 22;
eje_ranura = 36/2 + R_ear/2;                    // 29, eje Y de la bocallave
oreja_y0 = 36/2 - 1;  oreja_y1 = oreja_y0 + R_ear + 1;   // 17 .. 40

echo(str("Sobre la cana del tornillo (", d_vastago, " mm): holgura ",
         (id - d_vastago)/2, " mm por lado  ->  ",
         id > d_vastago ? "OK" : "*** NO PASA, sube id ***"));
margen = min(eje_ranura - od/2 - oreja_y0, oreja_y1 - eje_ranura - od/2);
echo(str("Margen dentro de la oreja: ", margen, " mm  ->  ",
         margen > 0 ? "CABE" : "*** NO CABE, baja od ***"));

/* --------- PIEZA ----------------------------------------------------- */
module arandela() {
    difference() {
        cylinder(h = espesor, d = od);
        translate([0, 0, -0.1]) cylinder(h = espesor + 0.2, d = id);
        // chaflan arriba y abajo del agujero, imprime sin rebaba y
        // ayuda a centrar el tornillo al montarla
        for (z = [0, espesor])
            translate([0, 0, z]) rotate_extrude()
                translate([id/2, 0]) polygon([[0,0],[chaflan,0],[0, z==0 ? chaflan : -chaflan]]);
    }
}

arandela();

echo(str("Arandela: OD", od, " x ID", id, " x ", espesor, " mm"));
