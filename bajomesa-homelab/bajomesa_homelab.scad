// =====================================================================
//  SOPORTE BAJO-MESA MODULAR "HOMELAB"   (mesa IKEA MITTZON elevable)
//  Marco de 2 railes + 2 travesanos atornillado bajo el tablero.
//  Los modulos (router, conversor, M920q) cuelgan deslizando por el
//  canal en T. El porque de cada decision esta en README.md.
//  Milimetros. Necesita BOSL2.
// =====================================================================

include <BOSL2/std.scad>
$fn = 48;

// --- 1. QUE PIEZA GENERAR --------------------------------------------
pieza = "conjunto";
//  "conjunto"       vista de montaje (NO imprimible)
//  "testigo-rail"   \_ probeta del ajuste del canal: IMPRIME ESTO PRIMERO
//  "testigo-cabeza" /
//  "rail"       x4  (2 por rail)      "travesano"  x2
//  "llave"      x1 (salen 6, hacen falta 4)
//  "m920q" "aux" "router"  x1         "brida"      x2

// --- 2. APARATOS   <<<  MIDE LOS TUYOS  >>> --------------------------
pc_x = 179;  pc_y = 183;  pc_z = 37;    // ThinkCentre M920q Tiny
fuente_externa = false;                 // true = la fuente es un ladrillo aparte
ps_x = 55;   ps_y = 125;  ps_z = 30;    // solo si fuente_externa
c_x = 70;    c_y = 90;    c_z = 25;     // conversor de fibra
r_x = 170;   r_y = 170;   r_z = 60;     // router
la_x = 400;  la_y = 60;   la_z = 42;    // ladron

// --- 3. TORNILLOS  (aglomerado comun 4 x 20, cabeza avellanada) ------
// Se atornilla directo, sin bocallave: no hay que dejar el tornillo a
// ninguna altura exacta y el agujero es del tamano del tornillo.
d_vastago = 4;                     // cana lisa
d_cabeza  = 8;                     // <-- VERIFICA CON CALIBRE
hol_paso  = 0.5;
d_paso  = d_vastago + hol_paso;    // 4.5  agujero de paso
d_avell = d_cabeza  + hol_paso;    // 8.5  boca del avellanado
d_hueco = 11;                      // acceso del destornillador
h_avell = (d_avell - d_paso)/2;    // cono a 90 grados
t_paso  = 5;                       // plastico que atraviesa: deja 15 mm en la madera

// --- 4. HOLGURAS Y GROSORES ------------------------------------------
pared   = 3;
suelo   = 3;
hol     = 0.35;   // holgura de deslizamiento en el canal
hol_dev = 5;      // holgura alrededor del router

// --- 5. PERFIL DEL RAIL  (T invertida) -------------------------------
R_plate = 4;      // placa contra el tablero
R_ch_h  = 8;      // alto interior del canal
R_ch_w  = 30;     // ancho interior del canal
R_open  = 18;     // apertura entre labios
R_lip   = 3;
R_wall  = 3;

RW = R_ch_w + 2*R_wall;          // 36
RH = R_lip + R_ch_h + R_plate;   // 15

R_ear   = 17;     // vuelo de la pestana de atornillado
R_ear_l = 20;
R_MAX   = 245;    // maxima longitud imprimible de un segmento

// Alojamiento de la llave, excavado en el espesor de las paredes por
// encima del labio: fuera del paso de la cabeza T y con el techo puesto
// por la placa, asi que no hay nada que imprimir en el aire.
R_key_l = 14;              // fondo en cada extremo
R_key_y = 2;               // de los 3 mm de pared (deja 1 de piel)
R_key_z = R_ch_h - 0.4;    // del labio a la placa

// --- 6. GEOMETRIA COMUN DE LOS MODULOS -------------------------------
RAIL_SEP = 200;   // entre ejes de los dos railes
M_wall   = 6;     // paredes que llevan la cabeza T

hd_w   = R_ch_w - 2*hol;   // 29.30  cabeza
stem_w = R_open - 2*hol;   // 17.30  cuello

h_head  = 1.3;
h_cham  = (hd_w - stem_w)/2;      // 6.00  chaflan a 45, imprimible
h_stem  = 4;
h_flare = (stem_w - M_wall)/2;
h_trans = h_head + h_cham + h_stem + h_flare;

H_TOP  = suelo + r_z + 3 + h_trans;   // lo fija el aparato mas alto
Z_MURO = H_TOP - h_trans;

z_head_bot = H_TOP - h_head;
z_cham_bot = z_head_bot - h_cham;
z_stem_bot = z_cham_bot - h_stem;

RAIL_Z0 = H_TOP + hol - (R_lip + R_ch_h);
TABLERO = RAIL_Z0 + RH;

W_m920q  = pc_x + 2*4       + 2*pared;
W_aux    = fuente_externa ? ps_x + c_x + 2*2 + 3 + 2*pared
                          : c_x + 2*2 + 2*pared;
W_router = r_x  + 2*hol_dev + 2*pared;
W_TOTAL  = W_m920q + W_aux + W_router;

L_RAIL = W_TOTAL + 12;
N_SEG  = ceil(L_RAIL / R_MAX);
R_seg  = L_RAIL / N_SEG;

// Canal libre en cada boca: de aqui sale lo que se mete el tenon
HUECO_BOCA = (L_RAIL - W_TOTAL)/2 + 10;

Y0 = -M_wall/2;
Y1 = RAIL_SEP + M_wall/2;

// --- 7. PRIMITIVAS ---------------------------------------------------

// Cabeza en T de los modulos. Centrada en y=0, sube de Z_MURO a H_TOP.
module cabeza_T(len) {
    hull() {
        translate([-len/2, -M_wall/2, Z_MURO])     cube([len, M_wall, 0.01]);
        translate([-len/2, -stem_w/2, z_stem_bot]) cube([len, stem_w, 0.01]);
    }
    translate([-len/2, -stem_w/2, z_stem_bot])
        cube([len, stem_w, z_cham_bot - z_stem_bot]);
    hull() {
        translate([-len/2, -stem_w/2, z_cham_bot]) cube([len, stem_w, 0.01]);
        translate([-len/2, -hd_w/2,   z_head_bot]) cube([len, hd_w,   0.01]);
    }
    translate([-len/2, -hd_w/2, z_head_bot]) cube([len, hd_w, h_head]);
}

module ranura_brida() { cube([12, 20, 3.5], center = true); }

// Taladro de una pestana de altura h (z=0 en su cara inferior): agujero
// de paso arriba, avellanado en medio y hueco del destornillador debajo.
module taladro(h) {
    z0 = h - t_paso;
    translate([0, 0, z0 - 0.01]) cylinder(h = t_paso + 0.11, d = d_paso);
    translate([0, 0, z0 - 0.01]) cylinder(h = h_avell + 0.01,
                                          d1 = d_avell, d2 = d_paso);
    if (z0 > 0.02)
        translate([0, 0, -0.1]) cylinder(h = z0 + 0.11, d = d_hueco);
}

// --- 8. RAIL ---------------------------------------------------------

// Pestanas a 16 mm de cada punta y alternadas de lado: la union entre
// segmentos queda pinzada entre dos tornillos separados 32 mm.
function pestanas()    = [[16, +1], [R_seg - 16, -1]];
function y_pestana(p)  = p[1] * (RW/2 + R_ear/2);

module perfil_rail(L) {
    translate([0,  R_open/2, 0]) cube([L, (RW - R_open)/2, R_lip]);
    translate([0, -RW/2,     0]) cube([L, (RW - R_open)/2, R_lip]);
    translate([0,  R_ch_w/2, R_lip]) cube([L, R_wall, R_ch_h]);
    translate([0, -RW/2,     R_lip]) cube([L, R_wall, R_ch_h]);
    translate([0, -RW/2, R_lip + R_ch_h]) cube([L, RW, R_plate]);
}

module rail_seg(L = R_seg) {
    difference() {
        union() {
            perfil_rail(L);
            for (p = pestanas())
                translate([p[0] - R_ear_l/2,
                           p[1] > 0 ? RW/2 - 1 : -RW/2 - R_ear, 0])
                    cube([R_ear_l, R_ear + 1, RH]);
        }
        for (p = pestanas())
            translate([p[0], y_pestana(p), 0]) taladro(RH);
        for (x = [-0.1, L - R_key_l])
            for (s = [-1, 1])
                translate([x, s > 0 ? R_ch_w/2 : -R_ch_w/2 - R_key_y,
                           R_lip + 0.4])
                    cube([R_key_l + 0.1, R_key_y, R_key_z + 0.1]);
    }
}

// LLAVE: alinea los dos segmentos de un rail. Va suelta a proposito. El
// saliente machihembrado que llevaba antes el propio rail era lo primero
// que se partia; esto se imprime plano, es la orientacion mas fuerte, y
// si se rompe una se reimprime en tres minutos. Vale igual un fleje de
// acero o aluminio de 2 mm cortado a 27.
LL_l = 2*R_key_l - 1;
LL_y = R_key_y   - 0.2;
LL_z = R_key_z   - 0.2;

module llave() { cube([LL_l, LL_y, LL_z]); }

// Tenon con el perfil de la cabeza T: entra por la boca del canal y ya
// no puede salirse de lado. z=0 en la cara inferior del labio.
module tenon(L) {
    translate([0, -stem_w/2, 0]) cube([L, stem_w, R_lip]);
    hull() {
        translate([0, -stem_w/2, R_lip])          cube([L, stem_w, 0.01]);
        translate([0, -hd_w/2,   R_lip + h_cham]) cube([L, hd_w,   0.01]);
    }
    translate([0, -hd_w/2, R_lip + h_cham])
        cube([L, hd_w, R_ch_h - h_cham - hol]);
}

// TRAVESANO: barra por fuera de la boca de la fila, con un tenon en cada
// punta. Fija los 200 mm entre railes (el marco se marca por sus propios
// agujeros), tapa el canal haciendo de tope de los modulos y cierra el
// conjunto a torsion. Se saca aflojando un tornillo.
// La seccion es una L: alma alta contra el testero del rail y ala plana
// hacia fuera. Con la misma materia que una barra plana da 18 mm de
// apoyo en la cama y no se dobla de canto.
TRV_x  = 6;                 // alma
TRV_f  = 12;                // ala
TRV_fz = 4;                 // espesor del ala
TRV_t  = HUECO_BOCA - 2;    // lo que se mete el tenon
TRV_b  = TRV_x + TRV_f;     // macizo del tornillo

module travesano() {
    difference() {
        union() {
            translate([-TRV_x, -RW/2, 0]) cube([TRV_x, RAIL_SEP + RW, RH]);
            translate([-TRV_b, -RW/2, 0])
                cube([TRV_f, RAIL_SEP + RW, TRV_fz]);
            translate([-TRV_b, RAIL_SEP/2 - TRV_b/2, 0])
                cube([TRV_b, TRV_b, RH]);
            for (y = [0, RAIL_SEP]) translate([0, y, 0]) tenon(TRV_t);
        }
        translate([-TRV_b/2, RAIL_SEP/2, 0]) taladro(RH);
    }
}

// Probetas del ajuste del canal. Deben deslizar firme y sin traqueteo:
// si va duro sube "hol", si baila bajalo. 0.05 mm cambia el tacto.
module testigo_rail(L = 60) { perfil_rail(L); }

module testigo_cabeza(L = 60) {
    translate([0, 0, -Z_MURO + 6]) {
        translate([-L/2, -M_wall/2, Z_MURO - 6]) cube([L, M_wall, 6]);
        cabeza_T(L);
    }
}

// --- 9. MODULOS ------------------------------------------------------

// suelo + 2 paredes laterales + 2 paredes colgantes rematadas en cabeza T
module chasis(W, h_lat, vent = true) {
    hl = min(h_lat, Z_MURO);
    difference() {
        union() {
            translate([0, Y0, 0])         cube([W, Y1 - Y0, suelo]);
            translate([0, Y0, 0])         cube([pared, Y1 - Y0, hl]);
            translate([W - pared, Y0, 0]) cube([pared, Y1 - Y0, hl]);
            translate([0, -M_wall/2,           0]) cube([W, M_wall, Z_MURO]);
            translate([0, RAIL_SEP - M_wall/2, 0]) cube([W, M_wall, Z_MURO]);
            translate([W/2, 0, 0])        cabeza_T(W - 20);
            translate([W/2, RAIL_SEP, 0]) cabeza_T(W - 20);
        }
        if (vent)
            for (i = [0 : floor((W - 40) / 22)])
                translate([20 + i*22, Y0 + 25, -1])
                    cube([9, (Y1 - Y0) - 50, suelo + 2]);
    }
}

// Aire y paso de cables, dejando 22 mm de columna en los extremos
module ventana(W, y, z0, z1) {
    if (z1 > z0 + 1)
        translate([22, y - M_wall/2 - 1, z0])
            cube([W - 44, M_wall + 2, z1 - z0]);
}

// Separador en Y, aligerado dejando 3 mm de piel contra el aparato
module tope(W, y0, d, alto, piel_al_fondo) {
    difference() {
        translate([pared, y0, suelo]) cube([W - 2*pared, d, alto]);
        if (d >= 6)
            for (i = [0 : floor((W - 2*pared - 12) / 26)])
                translate([pared + 6 + i*26,
                           piel_al_fondo ? y0 - 1 : y0 + 3,
                           suelo - 1])
                    cube([16, d - 2, alto + 2]);
    }
}

module topes(W, dev_y, alto) {
    g = (RAIL_SEP - dev_y) / 2;
    d = g - M_wall/2;
    if (d > 0.5) {
        tope(W, M_wall/2,     d, alto, true);
        tope(W, RAIL_SEP - g, d, alto, false);
    }
}

module rejilla_lateral(W, y0, alto_z, n = 6) {
    if (alto_z > 2)
        for (s = [0, W - pared])
            for (i = [0 : n - 1])
                translate([s - 1, y0 + 12 + i*28, suelo + 5])
                    cube([pared + 2, 16, alto_z]);
}

// El M920q va boca arriba, abierto hacia el tablero: ~47 mm de aire
puertos_al_frente = true;

module mod_m920q() {
    py0 = (RAIL_SEP - pc_y) / 2;
    y_puertos = puertos_al_frente ? RAIL_SEP : 0;
    difference() {
        union() {
            chasis(W_m920q, suelo + pc_z + 6);
            topes(W_m920q, pc_y + 8, pc_z);
        }
        ventana(W_m920q, 0,        suelo + 6, Z_MURO - 4);
        ventana(W_m920q, RAIL_SEP, suelo + 6, Z_MURO - 4);
        rejilla_lateral(W_m920q, py0, pc_z - 8);
        translate([18, y_puertos - M_wall/2 - 1, suelo + 2])
            cube([W_m920q - 36, M_wall + 2, pc_z + 2]);
        for (y = [RAIL_SEP*0.3, RAIL_SEP*0.7])
            translate([W_m920q/2, y, suelo + pc_z - 4])
                rotate([0, 90, 0]) ranura_brida();
    }
}

x_ps = pared;
x_cv = fuente_externa ? x_ps + ps_x + 5 : pared;

// El conversor va pegado a la pared trasera: los 99 mm que quedan
// detras son camara abierta a proposito para el bucle de la fibra.
y_cv_fin = M_wall/2 + c_y + 2;

module mod_aux() {
    h_dev = fuente_externa ? max(ps_z, c_z) : c_z;
    y_ps  = (RAIL_SEP - ps_y) / 2;
    difference() {
        union() {
            chasis(W_aux, suelo + h_dev + 6);
            if (fuente_externa) {
                translate([x_ps + ps_x + 2, M_wall/2, suelo])
                    cube([3, RAIL_SEP - M_wall, h_dev]);
                tope(ps_x + 2*pared, M_wall/2,        y_ps - M_wall/2, h_dev, true);
                tope(ps_x + 2*pared, RAIL_SEP - y_ps, y_ps - M_wall/2, h_dev, false);
            }
            translate([pared, y_cv_fin, suelo])
                cube([W_aux - 2*pared, 3, h_dev]);
            for (x = [pared + 6, W_aux/2 - 4, W_aux - pared - 14])
                hull() {
                    translate([x, y_cv_fin + 3,  suelo]) cube([8, 0.01, h_dev]);
                    translate([x, y_cv_fin + 15, suelo]) cube([8, 0.01, 3]);
                }
        }
        ventana(W_aux, 0,        suelo + 6, Z_MURO - 4);
        ventana(W_aux, RAIL_SEP, suelo + 6, Z_MURO - 4);
        rejilla_lateral(W_aux, 0, h_dev - 6);
        translate([x_cv + c_x/2, M_wall/2 + c_y/2, suelo + 5])
            rotate([0, 90, 0]) ranura_brida();
        if (fuente_externa)
            translate([x_ps + ps_x/2, RAIL_SEP/2, suelo + 5])
                rotate([0, 90, 0]) ranura_brida();
    }
}

module mod_router() {
    ry0 = (RAIL_SEP - r_y) / 2;
    difference() {
        union() {
            chasis(W_router, suelo + r_z + 5);
            topes(W_router, r_y + 2*hol_dev, 18);
        }
        ventana(W_router, 0,        suelo + 8, suelo + r_z - 6);
        ventana(W_router, RAIL_SEP, suelo + 8, suelo + r_z - 6);
        rejilla_lateral(W_router, ry0, r_z - 14);
        for (y = [RAIL_SEP*0.25, RAIL_SEP*0.75])
            translate([W_router/2, y, suelo + r_z - 8])
                rotate([0, 90, 0]) ranura_brida();
    }
}

// --- 10. BRIDA DEL LADRON  (va al tablero, desacoplada del marco) -----
lb_x    = 120;
lb_t    = t_paso;
lb_sep  = 70;
lb_wall = 3;
lb_lip  = 3;

la_axis = -82;    // por detras de las pestanas del rail trasero (y = -35)
lb_y0   = la_axis - la_y/2 - lb_wall - 4;
lb_y1   = la_axis + la_y/2 + lb_wall + 4;

z_cuenco = TABLERO - lb_t;
z_lad    = z_cuenco - la_z - 3;

module brida_ladron() {
    yi = la_y/2 + 1;
    difference() {
        union() {
            translate([-lb_x/2, lb_y0, z_cuenco]) cube([lb_x, lb_y1 - lb_y0, lb_t]);
            // nervios para que la placa no flecte
            translate([-lb_x/2, lb_y0,     z_cuenco - 7]) cube([lb_x, 5, 7]);
            translate([-lb_x/2, lb_y1 - 5, z_cuenco - 7]) cube([lb_x, 5, 7]);
            for (s = [-1, 1])
                translate([-lb_x/2, la_axis + s*(yi + lb_wall/2), 0]) {
                    translate([0, -lb_wall/2, z_lad])
                        cube([lb_x, lb_wall, z_cuenco - z_lad]);
                    hull() {
                        translate([0, -lb_wall/2, z_lad])
                            cube([lb_x, lb_wall, 0.01]);
                        translate([0, s > 0 ? -lb_wall/2 - lb_lip : lb_wall/2,
                                   z_lad + lb_lip])
                            cube([lb_x, lb_lip, 0.01]);
                    }
                }
        }
        for (dx = [-lb_sep/2, lb_sep/2])
            translate([dx, la_axis, z_cuenco]) taladro(lb_t);
        for (dx = [-lb_x/4, lb_x/4])
            translate([dx, la_axis, z_lad + 1.5]) rotate([0, 0, 90]) ranura_brida();
    }
}

// --- 11. VISTA DE CONJUNTO -------------------------------------------
X_M920Q  = 0;
X_AUX    = W_m920q;
X_ROUTER = W_m920q + W_aux;

module fantasma(x, y, z, dx, dy, dz, col) {
    color(col, 0.45) translate([x, y, z]) cube([dx, dy, dz]);
}

module marco() {
    for (y = [0, RAIL_SEP])
        for (s = [0 : N_SEG - 1])
            translate([-6 + s*R_seg, y, RAIL_Z0]) rail_seg();
    translate([-6, 0, RAIL_Z0]) travesano();
    translate([L_RAIL - 6, 0, RAIL_Z0]) mirror([1, 0, 0]) travesano();
}

module conjunto() {
    marco();
    translate([X_M920Q,  0, 0]) mod_m920q();
    translate([X_AUX,    0, 0]) mod_aux();
    translate([X_ROUTER, 0, 0]) mod_router();
    for (x = [W_TOTAL/2 - 130, W_TOTAL/2 + 130])
        translate([x, 0, 0]) brida_ladron();

    fantasma(X_M920Q + pared + 4, (RAIL_SEP - pc_y)/2, suelo,
             pc_x, pc_y, pc_z, "DarkRed");
    if (fuente_externa)
        fantasma(X_AUX + x_ps + 1, (RAIL_SEP - ps_y)/2, suelo,
                 ps_x, ps_y, ps_z, "DimGray");
    fantasma(X_AUX + x_cv + 1, (RAIL_SEP - c_y)/2, suelo,
             c_x, c_y, c_z, "DarkGreen");
    fantasma(X_ROUTER + pared + hol_dev, (RAIL_SEP - r_y)/2, suelo,
             r_x, r_y, r_z, "SteelBlue");
    fantasma(W_TOTAL/2 - la_x/2, la_axis - la_y/2, z_lad + lb_lip,
             la_x, la_y, la_z, "Goldenrod");

    color("Tan", 0.22)
        translate([-90, -170, TABLERO]) cube([W_TOTAL + 180, 560, 20]);
}

// --- 12. SALIDA ------------------------------------------------------
if      (pieza == "conjunto")       conjunto();
else if (pieza == "rail")           rail_seg();
else if (pieza == "travesano")      rotate([0, 0, -90]) travesano();
else if (pieza == "llave")          for (i = [0 : 5])
                                        translate([0, i*(LL_z + 3), 0])
                                            rotate([-90, 0, 0]) llave();
else if (pieza == "testigo-rail")   testigo_rail();
else if (pieza == "testigo-cabeza") testigo_cabeza();
else if (pieza == "m920q")          mod_m920q();
else if (pieza == "aux")            mod_aux();
else if (pieza == "router")         mod_router();
else if (pieza == "brida")          translate([0, 0, TABLERO])
                                        rotate([180, 0, 0]) brida_ladron();

echo(str("Caida total bajo el tablero .... ", TABLERO, " mm"));
echo(str("Ancho total de la fila ......... ", W_TOTAL, " mm"));
echo(str("Fondo ocupado bajo la mesa ..... ", RAIL_SEP + hd_w + (-lb_y0), " mm"));
echo(str("Rail: ", N_SEG, " segmentos de ", R_seg, " mm por cada rail"));
echo(str("Tornillos ...................... ", N_SEG*2*2, " railes + 2 travesanos + 4 ladron"));
echo(str("Aire libre sobre el M920q ...... ", TABLERO - suelo - pc_z, " mm"));
