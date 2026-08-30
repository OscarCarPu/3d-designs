// =====================================================================
//  ESCENAS PARA LA GUIA DE MONTAJE
//  Genera un render por paso. No es una pieza imprimible.
//    openscad -o img/pasoN.png --camera=... -D paso=N guia.scad
//  La pieza que se anade en cada paso va en NARANJA; lo ya montado,
//  en gris. Es la convencion de cualquier manual de montaje y ahorra
//  media pagina de texto por imagen.
// =====================================================================

include <bajomesa_homelab.scad>
pieza = "none";          // silencia la salida del fichero incluido
paso  = 9;

C_HECHO   = "#9aa0a8";
C_NUEVO   = "#e8590c";
C_MESA    = "#c9b998";
C_TORNI   = "#6e7681";
C_APARATO = "#4a7ba7";

/* ---------- utilidades ---------- */

// Posicion X (local al segmento) del tornillo ya bloqueado
function x_torni(o) = o[0] + desliz/2;
function y_torni(o) = (o[1] > 0 ? 1 : -1) * (RW/2 + R_ear/2);

module tornillo() {
    color(C_TORNI) {
        translate([0, 0, -saliente_tornillo])      cylinder(h = saliente_tornillo, d = d_vastago);
        translate([0, 0, -saliente_tornillo - 3])  cylinder(h = 3, d = d_cabeza);
        cylinder(h = 16, d = 4.5);                 // rosca dentro del tablero
    }
}

module tornillos_railes() {
    for (y = [0, RAIL_SEP])
        for (s = [0 : N_SEG - 1])
            for (o = orejas())
                translate([-6 + s*R_seg + x_torni(o), y + y_torni(o), TABLERO])
                    tornillo();
}

module tornillos_bridas() {
    for (x = [W_TOTAL/2 - 130, W_TOTAL/2 + 130])
        for (dx = [-lb_sep/2, lb_sep/2])
            translate([x + dx, la_axis, TABLERO]) tornillo();
}

module railes(dx = 0, col = C_HECHO) {
    color(col)
        for (y = [0, RAIL_SEP])
            for (s = [0 : N_SEG - 1])
                translate([-6 + s*R_seg + dx, y, RAIL_Z0]) rail_seg();
}

module galgas(col = C_HECHO, dx = 0) {
    color(col)
        for (x = [40 + dx, W_TOTAL - 120 + dx]) translate([x, 0, 0]) galga();
}

module mesa() {
    color(C_MESA, 0.35)
        translate([-110, -190, TABLERO]) cube([W_TOTAL + 220, 580, 20]);
}

module aparatos() {
    color(C_APARATO, 0.9) {
        translate([pared + 4, (RAIL_SEP - pc_y)/2, suelo])            cube([pc_x, pc_y, pc_z]);
        translate([W_m920q + x_cv + 1, M_wall/2, suelo])              cube([c_x, c_y, c_z]);
        translate([W_m920q + W_aux + pared + hol_dev,
                   (RAIL_SEP - r_y)/2, suelo])                        cube([r_x, r_y, r_z]);
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

// 1. Unir los dos segmentos de cada rail por el machihembrado
if (paso == 1) {
    color(C_HECHO) translate([0, 0, RAIL_Z0]) rail_seg();
    color(C_NUEVO) translate([R_seg + 45, 0, RAIL_Z0]) rail_seg();
}

// 2. Meter las galgas: fijan los 200 mm entre railes
if (paso == 2) { railes(); galgas(C_NUEVO); }

// 3. Ofrecer al tablero y marcar las 8 bocallaves
if (paso == 3) {
    railes(desliz); galgas(C_HECHO, desliz); mesa();
    color(C_NUEVO)
        for (y = [0, RAIL_SEP])
            for (s = [0 : N_SEG - 1])
                for (o = orejas())
                    translate([-6 + s*R_seg + x_torni(o), y + y_torni(o), TABLERO - 2])
                        cylinder(h = 24, d = 7);
}

// 4. Detalle de una bocallave, visto DESDE ABAJO. Sin tablero: taparia
//    justo lo que hay que ver.
if (paso == 4) {
    o = orejas()[0];
    intersection() {
        color(C_HECHO) translate([0, 0, RAIL_Z0]) rail_seg();
        translate([x_torni(o) - 48, y_torni(o) - 42, RAIL_Z0 - 5]) cube([96, 84, 30]);
    }
    translate([x_torni(o), y_torni(o), TABLERO]) tornillo();
    // fantasma del tornillo en la posicion de entrada, antes de deslizar
    color(C_NUEVO, 0.35)
        translate([x_torni(o) - desliz, y_torni(o), TABLERO]) tornillo();
}

// 5. Colgado y deslizado 16 mm: el vastago corre a la punta de la ranura
if (paso == 5) { railes(); tornillos_railes(); mesa(); }

// 6. Los modulos entran deslizando por el canal desde un extremo
if (paso == 6) {
    railes(); tornillos_railes();
    color(C_HECHO) {
        translate([W_m920q, 0, 0])          mod_aux();
        translate([W_m920q + W_aux, 0, 0])  mod_router();
    }
    color(C_NUEVO) translate([-235, 0, 0]) mod_m920q();
}

// 7. Una cuna en cada extremo de cada rail
if (paso == 7) {
    intersection() {
        union() {
            railes(); modulos();
            // entra por la boca del rail, extremo fino por delante
            color(C_NUEVO)
                for (y = [0, RAIL_SEP])
                    translate([8, y, RAIL_Z0 + R_lip]) rotate([0, 0, 180]) cuna();
        }
        translate([-30, -35, RAIL_Z0 - 45]) cube([90, 70, 60]);
    }
}

// 8. Las bridas del ladron, con sus 4 tornillos propios
// 8. Detalle de UNA brida del ladron. En vista general no se leen:
//    quedan detras del rail y tapadas por los modulos.
//    OJO: nada de mesa() dentro de un intersection(), pierde la
//    transparencia y tapa la escena entera.
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
    railes(); modulos(); bridas();
    tornillos_railes(); tornillos_bridas();
    aparatos(); mesa();
}

// 10. Planta sin mesa, para el plano de posiciones
if (paso == 10) { railes(); modulos(); bridas(); aparatos(); }
