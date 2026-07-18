// =====================================================================
//  Mini-cajon bajo-mesa para ROUTER + CONVERSOR fibra/ethernet
//  Bandeja del router en DOS PIEZAS (imprimir SIN SOPORTES):
//    - CUERPO: fondo + paredes (boca arriba) + ganchos + cola + agujeros
//              + 4 COLUMNAS de esquina (a toda altura) con pretaladro.
//    - TAPA:   placa con bocallaves + labio de centrado + 4 OREJAS que
//              se atornillan a las columnas del cuerpo. ESA union (4x M3)
//              es la que aguanta el peso; el labio solo centra/sella.
//  El SOPORTE DEL CONVERSOR no cambia (ya impreso).
//  Unidades: milimetros. Necesita la libreria BOSL2.
// =====================================================================

include <BOSL2/std.scad>

/* --------- QUE PIEZA IMPRIMIR (1 = si, 0 = no) -------------- */
imprimir_cuerpo    = 0;
imprimir_tapa      = 1;
imprimir_conversor = 0;   // ya impreso

/* ----------------------- APARATOS (mm) ---------------------- */
r_x = 170; r_y = 170; r_z = 60;
c_x = 90;  c_y = 70;  c_z = 25;

/* ----------------------- HOLGURAS / GROSORES ---------------- */
holgura        = 8;  // conversor (NO TOCAR: ya impreso)
holgura_router = 5;  // router
pared       = 3;
suelo       = 3;
techo       = 4;
margen_alto = 8;
c_extra     = 30;

/* ----------------- DIVISION CUERPO / TAPA ------------------ */
lab_alto = 8;     // labio (solo centrado/sellado)
lab_gros = 2;
lab_holg = 0.35;

/* -------- UNION RESISTENTE TAPA-CUERPO (orejas + tornillo) -- */
union_tornillos = true;
tu_w     = 14;    // ancho de la oreja/columna
tu_out   = 8;     // cuanto sobresale la oreja (< saliente de ganchos)
tu_pilot = 2.6;   // pretaladro en el cuerpo (M3 autorroscante)
tu_clear = 3.4;   // paso del tornillo en la tapa (M3)
tu_depth = 16;    // profundidad del pretaladro

/* ----------------------- LADO ABIERTO ---------------------- */
lado_abierto = "der";

/* ----------------------- TORNILLOS / BOCALLAVE ------------- */
sep_tornillos = 125;
d_vastago   = 6;
d_cabeza    = 11;     // <-- ¡MIDE EL TUYO Y AJUSTA!
hol_vastago = 1.5;
hol_cabeza  = 2.0;
desliz      = 16;
refuerzo_d  = 22;
refuerzo_h  = 4;

/* ----------------------- GANCHOS PARA BRIDAS (BOSL2) ------ */
ganchos     = true;
g_ancho     = 28;
g_saliente  = 12;
g_base      = 10;
g_labio     = 12;
g_ranura_x  = 14;
g_ranura_y  = 3.5;

/* ----------------- COLA DE MILANO + CONEXION --------------- */
cm_cuello = 9;
cm_base   = 15;
cm_prof   = 6;
cm_pad    = 3;
cm_holg   = 0.4;
cm_yoff   = 33;
cab_con_w = 26;
cab_con_h = 22;

/* ----------------------- EXTRAS ----------------------------- */
ventilacion   = true;
cable_frontal = true;
cable_trasero = true;
ancho_cable   = 50;
alto_cable    = 42;
$fn = 48;

// =====================================================================
//  CALCULOS
// =====================================================================
rx_in = r_x + 2*holgura_router;
ry_in = r_y + 2*holgura_router;
cx_in = c_x + 2*holgura;
cy_in = c_y + 2*holgura;

inner_w = rx_in;  inner_d = ry_in;  inner_h = r_z + margen_alto;
outer_w = inner_w + 2*pared;
outer_d = inner_d + 2*pared;
rim_z   = suelo + inner_h;
outer_h = rim_z + techo;

kx1 = outer_w/2 - sep_tornillos/2;
kx2 = outer_w/2 + sep_tornillos/2;
ky  = outer_d/2 - desliz/2;

cm_z0 = suelo + 6;

h_iw = cx_in + c_extra;  h_id = cy_in;  h_ih = c_z + 6;
HW = h_iw + 2*pared;     HD = h_id + 2*pared;

cm_y_tray = outer_d/2 + cm_yoff;
cm_y_hold = HD/2 + cm_yoff;
cz_con    = suelo + inner_h/2;

dx_mate = -(cm_prof + cm_pad) - HW;
dy_mate = outer_d/2 - HD/2;
dz_mate = cm_z0 + 4;

// orejas/columnas: centros en las 4 esquinas
tux  = [tu_w/2, outer_w - tu_w/2];
tuyf = -tu_out/2;             // pretaladro frontal
tuyb = outer_d + tu_out/2;    // pretaladro trasero

// =====================================================================
//  MODULOS COMUNES
// =====================================================================
module bocallave2d() {
    dh = d_cabeza + hol_cabeza;  sw = d_vastago + hol_vastago;
    union() {
        circle(d = dh);
        translate([-sw/2, 0]) square([sw, desliz]);
        translate([0, desliz]) circle(d = sw);
    }
}
module cola2d(h) {
    polygon([[0, -(cm_cuello/2 + h)], [cm_prof, -(cm_base/2 + h)],
             [cm_prof,  (cm_base/2 + h)], [0,  (cm_cuello/2 + h)]]);
}
module bocallaves() {
    for (kx = [kx1, kx2])
        translate([kx, ky, rim_z - refuerzo_h - 1])
            linear_extrude(height = techo + refuerzo_h + 2) bocallave2d();
}
module vent_tapa() {
    for (i = [0:4]) {
        translate([20 + i*((outer_w-40)/4) - 5, pared + 8, rim_z - 1]) cube([10, 40, techo + 2]);
        translate([20 + i*((outer_w-40)/4) - 5, outer_d - pared - 48, rim_z - 1]) cube([10, 40, techo + 2]);
    }
}

// =====================================================================
//  CUERPO
// =====================================================================
module fondo() { cube([outer_w, outer_d, suelo]); }
module paredes() {
    translate([0, 0, suelo])                cube([outer_w, pared, inner_h]);
    translate([0, outer_d - pared, suelo])   cube([outer_w, pared, inner_h]);
    if (lado_abierto != "izq") translate([0, 0, suelo])            cube([pared, outer_d, inner_h]);
    if (lado_abierto != "der") translate([outer_w - pared, 0, suelo]) cube([pared, outer_d, inner_h]);
}
module gancho(cx) {
    translate([cx, 0, 0]) difference() {
        union() {
            translate([0, -g_saliente/2, g_base/2]) cuboid([g_ancho, g_saliente, g_base], rounding = 2.5, edges = "Z");
            translate([0, -g_saliente + 2, g_base + g_labio/2]) cuboid([g_ancho, 4, g_labio], rounding = 1.5, edges = "Z");
        }
        for (yy = [-g_saliente*0.30, -g_saliente*0.66])
            translate([0, yy, g_base/2]) cube([g_ranura_x, g_ranura_y, g_base + 2], center = true);
    }
}
module cola_hembra() {
    difference() {
        translate([-(cm_prof+cm_pad), cm_y_tray-(cm_base/2+cm_pad+2), cm_z0])
            cube([cm_prof+cm_pad, cm_base+2*cm_pad+4, rim_z - cm_z0]);
        translate([-(cm_prof+cm_pad), cm_y_tray, cm_z0+4])
            linear_extrude(rim_z - (cm_z0+4) + 2) cola2d(cm_holg);
    }
}
module ranura_cable_frontal() {
    translate([outer_w/2 - ancho_cable/2, -1, suelo + inner_h/2 - alto_cable/2]) cube([ancho_cable, pared + 2, alto_cable]);
}
module ranura_cable_trasera() {
    translate([outer_w/2 - ancho_cable/2, outer_d - pared - 1, suelo + inner_h/2 - alto_cable/2]) cube([ancho_cable, pared + 2, alto_cable]);
}
module conexion_bandeja() {
    translate([-1, outer_d/2 - cab_con_w/2, cz_con - cab_con_h/2]) cube([pared + 2, cab_con_w, cab_con_h]);
}
module vent_fondo() {
    for (i = [0:5]) translate([outer_w/2 - 72 + i*24, outer_d/2 - 60, -1]) cube([10, 120, suelo + 2]);
}
// columnas de esquina a toda altura (con la oreja saliente), macizas
module columnas_cuerpo() {
    for (x = tux) {
        translate([x - tu_w/2, -tu_out, 0])           cube([tu_w, tu_out + pared, rim_z]);   // frontal
        translate([x - tu_w/2, outer_d - pared, 0])    cube([tu_w, tu_out + pared, rim_z]);    // trasera
    }
}
module pretaladros() {
    for (x = tux) {
        translate([x, tuyf, rim_z - tu_depth]) cylinder(h = tu_depth + 0.1, d = tu_pilot);
        translate([x, tuyb, rim_z - tu_depth]) cylinder(h = tu_depth + 0.1, d = tu_pilot);
    }
}

module cuerpo() {
    difference() {
        union() {
            fondo();
            paredes();
            cola_hembra();
            if (ganchos) { gancho(outer_w*0.35); gancho(outer_w*0.65); }
            if (union_tornillos) columnas_cuerpo();
        }
        if (cable_frontal) ranura_cable_frontal();
        if (cable_trasero) ranura_cable_trasera();
        conexion_bandeja();
        if (ventilacion) vent_fondo();
        if (union_tornillos) pretaladros();
    }
}

// =====================================================================
//  TAPA
// =====================================================================
module labio_tapa() {
    z0 = rim_z - lab_alto;
    x0 = pared + lab_holg;
    xr = outer_w - lab_holg;
    union() {
        translate([x0, pared, z0])                                  cube([lab_gros, inner_d, lab_alto]);
        translate([x0, pared + lab_holg, z0])                       cube([xr - x0, lab_gros, lab_alto]);
        translate([x0, outer_d - pared - lab_holg - lab_gros, z0])  cube([xr - x0, lab_gros, lab_alto]);
    }
}
module orejas_tapa() {
    for (x = tux) {
        translate([x - tu_w/2, -tu_out, rim_z])   cube([tu_w, tu_out, techo]);     // frontal
        translate([x - tu_w/2, outer_d, rim_z])    cube([tu_w, tu_out, techo]);      // trasera
    }
}
module pasos_tornillo() {
    for (x = tux) {
        translate([x, tuyf, rim_z - 0.5]) cylinder(h = techo + 1, d = tu_clear);
        translate([x, tuyb, rim_z - 0.5]) cylinder(h = techo + 1, d = tu_clear);
    }
}

module tapa_pieza() {
    difference() {
        union() {
            translate([0, 0, rim_z]) cube([outer_w, outer_d, techo]);
            for (kx = [kx1, kx2]) translate([kx, ky, rim_z - refuerzo_h]) cylinder(h = refuerzo_h, d = refuerzo_d);
            labio_tapa();
            if (union_tornillos) orejas_tapa();
        }
        bocallaves();
        if (ventilacion) vent_tapa();
        if (union_tornillos) pasos_tornillo();
    }
}

// =====================================================================
//  SOPORTE DEL CONVERSOR  (NO CAMBIAR: ya impreso)
// =====================================================================
module soporte_conversor() {
    difference() {
        union() {
            cube([HW, HD, suelo]);
            translate([0,0,suelo])          cube([pared, HD, h_ih]);
            translate([h_iw+pared,0,suelo])  cube([pared, HD, h_ih]);
            translate([0,0,suelo])          cube([HW, pared, h_ih]);
            translate([0,h_id+pared,suelo])  cube([HW, pared, h_ih]);
            translate([HW, cm_y_hold, 0]) linear_extrude(h_ih) cola2d(0);
        }
        for (i = [0:4]) translate([HW/2 - 32 + i*16, HD/2 - 25, -1]) cube([6, 50, suelo + 2]);
        translate([h_iw + pared - 1, HD/2 - cab_con_w/2, (cz_con - dz_mate) - cab_con_h/2]) cube([pared + 2, cab_con_w, cab_con_h]);
    }
}

// =====================================================================
//  SALIDA
// =====================================================================
montar = (imprimir_cuerpo + imprimir_tapa + imprimir_conversor) > 1;
if (imprimir_cuerpo) cuerpo();
if (imprimir_tapa) {
    if (montar) tapa_pieza();
    else translate([0, outer_d + tu_out, rim_z + techo]) rotate([180,0,0]) tapa_pieza();
}
if (imprimir_conversor) {
    if (montar) translate([dx_mate, dy_mate, dz_mate]) soporte_conversor();
    else soporte_conversor();
}
