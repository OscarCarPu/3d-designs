// =====================================================================
//  CLIP-LADRON — anclaje suelto para colgar el ladron de una regleta
//  bajo un tablero. No depende de ningun ojal ni gancho del ladron:
//  se atornilla al tablero y una brida de plastico pasa por el agujero,
//  rodea el ladron (que queda pegado al mismo tablero, junto al clip) y
//  lo ciñe contra la madera. Van 2 (a lo largo del ladron), 2 tornillos
//  cada uno = 4 en total.
//  Un bloque bajo y macizo: nada en voladizo, toda la carga (minima) va
//  en compresion/cortante sobre un bloque solido, no sobre un brazo fino.
//  Independiente de torre-homelab y de bajomesa-homelab: sirve para
//  cualquiera de los dos.
//  Milimetros.
// =====================================================================

$fn = 48;

// --- 1. TORNILLOS (aglomerado 4x20, cabeza avellanada) ----------------
d_vastago = 4;
d_cabeza  = 8;
hol_paso  = 0.5;
d_paso  = d_vastago + hol_paso;   // 4.5  paso
d_avell = d_cabeza  + hol_paso;   // 8.5  boca del avellanado
d_hueco = 11;                     // acceso del destornillador
h_avell = (d_avell - d_paso)/2;
t_paso  = 5;                      // atraviesa el plastico, deja 15 mm en la madera

module taladro(h) {
    z0 = h - t_paso;
    translate([0, 0, z0 - 0.01]) cylinder(h = t_paso + 0.11, d = d_paso);
    translate([0, 0, z0 - 0.01]) cylinder(h = h_avell + 0.01, d1 = d_avell, d2 = d_paso);
    if (z0 > 0.02)
        translate([0, 0, -0.1]) cylinder(h = z0 + 0.11, d = d_hueco);
}

// --- 2. EL BLOQUE --------------------------------------------------------
BLOQUE_x = 36;  BLOQUE_y = 18;  BLOQUE_t = 12;

// Agujero para la brida: pasa de lado a lado, separado en X de los dos
// tornillos para no comerse el hueco del destornillador de ninguno.
SLOT_w = 12;  SLOT_h = 5;  SLOT_z0 = 3;

module clip_ladron() {
    difference() {
        cube([BLOQUE_x, BLOQUE_y, BLOQUE_t]);
        translate([9, BLOQUE_y/2, 0])            taladro(BLOQUE_t);
        translate([BLOQUE_x - 9, BLOQUE_y/2, 0]) taladro(BLOQUE_t);
        translate([BLOQUE_x/2 - SLOT_w/2, -1, SLOT_z0])
            cube([SLOT_w, BLOQUE_y + 2, SLOT_h]);
    }
}

clip_ladron();
