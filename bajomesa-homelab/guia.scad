// =====================================================================
//  ESCENAS PARA LA GUIA DE MONTAJE  (un render por paso, no imprimible)
//    openscad -o img/pasoN.png --camera=... -D paso=N guia.scad
//  Naranja = lo que se anade en ese paso. Gris = lo ya montado.
// =====================================================================

include <bajomesa_homelab.scad>
pieza = "none";
paso  = 9;

C_HECHO   = "#9aa0a8";
C_NUEVO   = "#e8590c";
C_MESA    = "#c9b998";
C_TORNI   = "#6e7681";
C_APARATO = "#4a7ba7";

/* ---------- utilidades ---------- */

// Tornillo avellanado, con z=0 en la cara inferior del tablero
module tornillo() {
    color(C_TORNI) {
        translate([0, 0, -t_paso]) cylinder(h = t_paso, d = d_vastago);
        translate([0, 0, -t_paso]) cylinder(h = h_avell,
                                            d1 = d_cabeza, d2 = d_vastago);
        cylinder(h = 15, d = d_vastago);
    }
}

function x_trv() = [-6 + TRV_b/2 - TRV_x, L_RAIL - 6 + TRV_x - TRV_b/2];

module en_tornillos() {
    for (y = [0, RAIL_SEP])
        for (s = [0 : N_SEG - 1])
            for (p = pestanas())
                translate([-6 + s*R_seg + p[0], y + y_pestana(p), TABLERO])
                    children();
    for (x = x_trv())
        translate([x, RAIL_SEP/2, TABLERO]) children();
}

module railes(dx = 0, col = C_HECHO) {
    color(col)
        for (y = [0, RAIL_SEP])
            for (s = [0 : N_SEG - 1])
                translate([-6 + s*R_seg + dx, y, RAIL_Z0]) rail_seg();
}

module travesanos(col = C_HECHO, cuales = [0, 1]) {
    color(col) {
        if (search(0, cuales)) translate([-6, 0, RAIL_Z0]) travesano();
        if (search(1, cuales))
            translate([L_RAIL - 6, 0, RAIL_Z0]) mirror([1, 0, 0]) travesano();
    }
}

module mesa() {
    color(C_MESA, 0.35)
        translate([-110, -190, TABLERO]) cube([W_TOTAL + 220, 580, 20]);
}

module aparatos() {
    color(C_APARATO, 0.9) {
        translate([pared + 4, (RAIL_SEP - pc_y)/2, suelo])   cube([pc_x, pc_y, pc_z]);
        translate([W_m920q + x_cv + 1, M_wall/2, suelo])     cube([c_x, c_y, c_z]);
        translate([W_m920q + W_aux + pared + hol_dev,
                   (RAIL_SEP - r_y)/2, suelo])               cube([r_x, r_y, r_z]);
    }
    color("#c9992e", 0.9)
        translate([W_TOTAL/2 - la_x/2, la_axis - la_y/2, z_lad + lb_lip])
            cube([la_x, la_y, la_z]);
}

module modulos(col = C_HECHO) {
    color(col) {
        mod_m920q();
        translate([W_m920q, 0, 0])          mod_aux();
        translate([W_m920q + W_aux, 0, 0])  mod_router();
    }
}

module bridas(col = C_HECHO) {
    color(col)
        for (x = [W_TOTAL/2 - 130, W_TOTAL/2 + 130]) translate([x, 0, 0]) brida_ladron();
}

/* ---------- escenas ---------- */

// 1. Unir los dos segmentos de cada rail con las dos llaves
if (paso == 1) {
    color(C_HECHO) {
        translate([0, 0, RAIL_Z0]) rail_seg();
        translate([R_seg + 45, 0, RAIL_Z0]) rail_seg();
    }
    color(C_NUEVO)
        for (s = [-1, 1])
            translate([R_seg - R_key_l,
                       s > 0 ? R_ch_w/2 + 0.1 : -R_ch_w/2 - R_key_y + 0.1,
                       RAIL_Z0 + R_lip + 0.5])
                llave();
}

// 2. Cerrar el marco con los dos travesanos: fijan los 200 mm
if (paso == 2) { railes(); travesanos(C_NUEVO); }

// 3. Ofrecer el marco al tablero y marcar por sus propios agujeros
if (paso == 3) {
    railes(); travesanos(); mesa();
    color(C_NUEVO) en_tornillos() translate([0, 0, -2]) cylinder(h = 24, d = 5);
}

// 4. Media pestana en seccion, cortada por el eje del tornillo: se ve
//    el avellanado, los 5 mm que atraviesa y el hueco del destornillador
if (paso == 4) {
    p  = pestanas()[0];
    px = -6 + p[0];
    py = y_pestana(p);
    intersection() {
        union() {
            color(C_HECHO) translate([-6, 0, RAIL_Z0]) rail_seg();
            translate([px, py, TABLERO]) tornillo();
        }
        translate([px, py - 45, RAIL_Z0 - 20]) cube([45, 90, 50]);
    }
}

// 5. El marco atornillado al tablero
if (paso == 5) { railes(); travesanos(); en_tornillos() tornillo(); mesa(); }

// 6. Con un travesano fuera, los modulos entran deslizando por el canal
if (paso == 6) {
    railes(); travesanos(C_HECHO, [1]);
    color(C_HECHO) {
        translate([W_m920q, 0, 0])          mod_aux();
        translate([W_m920q + W_aux, 0, 0])  mod_router();
    }
    color(C_NUEVO) translate([-235, 0, 0]) mod_m920q();
}

// 7. Volver a poner el travesano: cierra la boca y hace de tope
if (paso == 7) {
    intersection() {
        union() {
            railes(); modulos(); travesanos(C_HECHO, [1]);
            color(C_NUEVO) translate([-40, 0, RAIL_Z0]) travesano();
        }
        translate([-60, -30, RAIL_Z0 - 45]) cube([120, 260, 60]);
    }
}

// 8. Detalle de UNA brida del ladron: en vista general no se lee
if (paso == 8) {
    x0 = W_TOTAL/2 - 130;
    color(C_NUEVO) translate([x0, 0, 0]) brida_ladron();
    color(C_HECHO) translate([-6, 0, RAIL_Z0]) rail_seg();
    for (dx = [-lb_sep/2, lb_sep/2])
        translate([x0 + dx, la_axis, TABLERO]) tornillo();
    color("#c9992e", 0.8)
        translate([x0 - 150, la_axis - la_y/2, z_lad + lb_lip])
            cube([300, la_y, la_z]);
}

// 9. Montaje terminado
if (paso == 9) {
    railes(); travesanos(); modulos(); bridas();
    en_tornillos() tornillo();
    for (x = [W_TOTAL/2 - 130, W_TOTAL/2 + 130])
        for (dx = [-lb_sep/2, lb_sep/2])
            translate([x + dx, la_axis, TABLERO]) tornillo();
    aparatos(); mesa();
}

// 10. Planta sin mesa, para el plano de posiciones
if (paso == 10) { railes(); travesanos(); modulos(); bridas(); aparatos(); }
