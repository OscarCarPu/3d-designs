// =====================================================================
//  SOPORTE BAJO-MESA MODULAR  "HOMELAB"
//  Mesa: IKEA MITTZON 140x80 ELEVABLE  (tablero aglomerado ~20 mm)
//
//  Aloja:  Lenovo ThinkCentre M920q  +  su fuente  +  conversor fibra
//          +  router  +  ladron/regleta de 400 mm
//
//  ---------------------------------------------------------------
//  ARQUITECTURA
//
//  (A) LA FILA: 2 RAILES paralelos atornillados al bajo del tablero
//      con BOCALLAVES (los mismos tornillos que ya usaste en
//      cajon-router). Perfil en T invertida: los MODULOS se deslizan
//      por el canal desde un extremo y quedan colgados. Los bloquea
//      una CUNA de friccion, sin tornilleria extra.
//
//      POR QUE DOS RAILES: reparten los ~4 kg y, sobre todo, matan el
//      momento de palanca. Ningun modulo cuelga en voladizo de una
//      sola linea de tornillos, que es el modo de fallo real del
//      aglomerado de 20 mm.
//
//      Orden de la fila:  M920q | conversor | router
//      El M920q va en el extremo a proposito: es lo que mas vas a
//      tocar y desde ahi sale sin desmontar nada mas.
//
//  (B) EL LADRON: dos BRIDAS independientes atornilladas directamente
//      al tablero, por detras del rail trasero. No tocan el sistema de
//      railes: si compartiesen canal chocarian con las cabezas de los
//      modulos. Van desacopladas a proposito.
//
//  ---------------------------------------------------------------
//  TORNILLOS: 12 para los railes + 4 para el ladron = 16.
//  Son 16 taladros ciegos en una cara que no se ve. Si quieres
//  empezar con menos, pon N_SEG=2 (railes mas largos, no caben en tu
//  cama sin trocear) o deja una oreja de cada dos sin tornillo y
//  anadela si notas cedimiento. La densidad de tornillos es lo que
//  compra margen en aglomerado.
//
//  ---------------------------------------------------------------
//  TODO IMPRIME SIN SOPORTES.  Cama necesaria: 250 x 220.
//    - RAILES:  tal cual. La placa superior es un puente de 30 mm.
//    - MODULOS: tal cual. OJO: el eje Y del modelo (229 mm) va a lo
//               largo del eje de 250 mm de tu cama; el eje X (<=193)
//               a lo largo del de 220.
//    - BRIDAS, CUNA y GALGA: tal cual.
//
//  MATERIAL: PETG o ASA.  PLA NO: bajo carga permanente y con el
//  calor del M920q terminaria descolgandose por fluencia (creep).
//
//  Unidades: milimetros. Necesita la libreria BOSL2.
// =====================================================================

include <BOSL2/std.scad>
$fn = 48;

/* =====================================================================
   1. QUE PIEZA GENERAR
   ===================================================================== */
pieza = "conjunto";
//  "conjunto"  vista de montaje completa (NO imprimible)
//  "testigo"   probeta de ajuste del canal -> IMPRIME ESTO PRIMERO
//  "rail"      1 segmento de rail        -> imprimir x6  (3 por rail)
//  "cuna"      cuna de bloqueo           -> imprimir x4
//  "galga"     galga de separacion       -> imprimir x2  (util de montaje)
//  "m920q"     modulo del M920q          -> imprimir x1
//  "aux"       modulo del conversor      -> imprimir x1
//  "router"    modulo del router         -> imprimir x1
//  "brida"     brida del ladron          -> imprimir x2

/* =====================================================================
   2. APARATOS   <<<<<  MIDE LOS TUYOS Y AJUSTA  >>>>>
   ===================================================================== */
// Lenovo ThinkCentre M920q Tiny  (oficial: 179 x 183 x 37 con pies)
pc_x = 179;  pc_y = 183;  pc_z = 37;

// La fuente va integrada en el equipo, no como ladrillo externo.
// Si en algun momento pasa a ser externa, pon esto a true y el modulo
// auxiliar recupera su cubiculo (la fila crece 58 mm y puede pasar a
// necesitar 3 segmentos de rail por lado en vez de 2).
fuente_externa = false;
ps_x = 55;   ps_y = 125;  ps_z = 30;   // solo se usa si fuente_externa

// Conversor fibra/ethernet  (el mismo del diseno anterior)
c_x = 70;   c_y = 90;   c_z = 25;

// Router  (el mismo del diseno anterior)
r_x = 170;  r_y = 170;  r_z = 60;

// Ladron / regleta
la_x = 400;  la_y = 60;   la_z = 42;

/* =====================================================================
   3. TORNILLOS  (los que ya usaste en el cajon-router)
   ===================================================================== */
//  d_cabeza es el diametro MAXIMO del sombrero del tornillo, medido
//  atravesado por la parte mas ancha, la que apoya contra la madera:
//
//        |<-- d_cabeza -->|        <- mide AQUI, con el calibre
//         \______________/            atravesado sobre el sombrero
//              |    |
//              |    |  <- d_vastago (la cana lisa, bajo la cabeza)
//              |####|
//              |####|  <- la rosca (no importa para el diseno)
//
//  Si tu cabeza pasa de 13 mm no cabe por la bocallave: sube
//  d_cabeza y el circulo crece solo.
d_vastago   = 6;
d_cabeza    = 11;     // <-- VERIFICA CON CALIBRE
hol_vastago = 1.5;
hol_cabeza  = 2.0;
desliz      = 16;     // recorrido de la bocallave

// Cuanto hay que dejar SIN ROSCAR el tornillo en el tablero: la pieza
// se cuelga en ese hueco. Es LA cota critica del montaje.
//
// Tablero de 20 mm: usa tornillos de 20 mm de largo TOTAL o menos.
// Con 3.5 fuera quedan 16.5 dentro, que agarra de sobra y no asoma
// por la cara de arriba.
saliente_tornillo = 3.5;

/* =====================================================================
   4. HOLGURAS Y GROSORES
   ===================================================================== */
pared   = 3;      // paredes laterales de los modulos
suelo   = 3;      // suelo de los modulos
hol     = 0.35;   // holgura de deslizamiento en el canal
hol_dev = 5;      // holgura alrededor del router

/* =====================================================================
   5. PERFIL DEL RAIL  (T invertida)
   ===================================================================== */
R_plate = 4;      // placa superior (contra el tablero)
R_ch_h  = 8;      // alto interior del canal
R_ch_w  = 30;     // ancho interior del canal
R_open  = 18;     // apertura entre labios
R_lip   = 3;      // espesor del labio
R_wall  = 3;      // pared lateral del rail

RW = R_ch_w + 2*R_wall;          // 36  ancho total del rail
RH = R_lip + R_ch_h + R_plate;   // 15  alto total del rail

R_ear   = 22;     // cuanto sobresale la oreja de la bocallave
R_ear_l = 46;     // longitud de la oreja
R_key   = 6;      // machihembrado de alineacion entre segmentos
R_MAX   = 245;    // maxima longitud imprimible de un segmento

/* =====================================================================
   6. GEOMETRIA COMUN DE LOS MODULOS
   ===================================================================== */
RAIL_SEP = 200;   // separacion entre ejes de los dos railes
M_wall   = 6;     // grosor de las paredes que llevan la cabeza T

hd_w   = R_ch_w - 2*hol;   // 29.30  ancho de la cabeza
stem_w = R_open - 2*hol;   // 17.30  ancho del cuello

h_head  = 1.3;                    // parte recta de la cabeza
h_cham  = (hd_w - stem_w)/2;      // 6.00  chaflan a 45 (imprimible)
h_stem  = 4;                      // cuello recto
h_flare = (stem_w - M_wall)/2;    // 5.65  transicion pared->cuello a 45
h_trans = h_head + h_cham + h_stem + h_flare;   // 16.95

// El plano de enganche lo fija el aparato mas alto (el router)
H_TOP  = suelo + r_z + 3 + h_trans;
Z_MURO = H_TOP - h_trans;         // hasta donde suben las paredes

z_head_bot = H_TOP - h_head;
z_cham_bot = z_head_bot - h_cham;
z_stem_bot = z_cham_bot - h_stem;

RAIL_Z0 = H_TOP + hol - (R_lip + R_ch_h);   // z del labio inferior
TABLERO = RAIL_Z0 + RH;                     // cara inferior del tablero

// Anchos de cada modulo (eje X)
W_m920q  = pc_x + 2*4       + 2*pared;              // 193
W_aux    = fuente_externa ? ps_x + c_x + 2*2 + 3 + 2*pared   // 138
                          : c_x + 2*2 + 2*pared;             //  80
W_router = r_x  + 2*hol_dev + 2*pared;              // 186
W_TOTAL  = W_m920q + W_aux + W_router;

// Railes: se trocean en el minimo numero de segmentos imprimibles
L_RAIL = W_TOTAL + 12;
N_SEG  = ceil(L_RAIL / R_MAX);
R_seg  = L_RAIL / N_SEG;

// Y exterior de los modulos (comun a todos)
Y0 = -M_wall/2;
Y1 = RAIL_SEP + M_wall/2;

/* =====================================================================
   7. PRIMITIVAS
   ===================================================================== */

// Cabeza en T que engancha en el canal. Centrada en y=0.
// Sube desde Z_MURO hasta H_TOP con todas las transiciones a 45.
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

// Bocallave plana: la cabeza del tornillo entra por el circulo y el
// vastago corre por la ranura. Para chapas de espesor <= saliente.
module bocallave_2d() {
    dh = d_cabeza  + hol_cabeza;    // 13.0
    sw = d_vastago + hol_vastago;   //  7.5
    union() { circle(d = dh); translate([0, -sw/2]) square([desliz, sw]); }
}

/* =====================================================================
   8. RAIL
   ===================================================================== */

// En un bloque grueso hacen falta dos alturas: abajo el canal ancho
// por donde corre la CABEZA, arriba la ranura estrecha del VASTAGO.
module bocallave_cut() {
    dh = d_cabeza + hol_cabeza;
    translate([0, 0, -0.1])
        linear_extrude(RH - saliente_tornillo + 0.1)
            union() { circle(d = dh); translate([0, -dh/2]) square([desliz, dh]); }
    translate([0, 0, RH - saliente_tornillo])
        linear_extrude(saliente_tornillo + 0.1) bocallave_2d();
}

// Orejas alternadas: impiden que el rail gire sobre su propio eje.
function orejas() = [[42, +1], [R_seg - 42, -1]];

module rail_seg(L = R_seg) {
    difference() {
        union() {
            // labios
            translate([0,  R_open/2, 0]) cube([L, (RW - R_open)/2, R_lip]);
            translate([0, -RW/2,     0]) cube([L, (RW - R_open)/2, R_lip]);
            // paredes laterales
            translate([0,  R_ch_w/2, R_lip]) cube([L, R_wall, R_ch_h]);
            translate([0, -RW/2,     R_lip]) cube([L, R_wall, R_ch_h]);
            // placa superior (puente de 30 mm sobre el canal)
            translate([0, -RW/2, R_lip + R_ch_h]) cube([L, RW, R_plate]);
            // orejas de las bocallaves
            for (o = orejas())
                translate([o[0] - R_ear_l/2,
                           o[1] > 0 ? RW/2 - 1 : -RW/2 - R_ear, 0])
                    cube([R_ear_l, R_ear + 1, RH]);
            // machihembrado macho (en los labios, apoyado en la cama)
            for (s = [-1, 1])
                translate([L, s*13.5 - 3, 0]) cube([R_key, 6, R_lip]);
        }
        for (o = orejas())
            translate([o[0] - desliz/2,
                       o[1] > 0 ? RW/2 + R_ear/2 : -RW/2 - R_ear/2, 0])
                bocallave_cut();
        for (s = [-1, 1])
            translate([-0.1, s*13.5 - 3.2, -0.1])
                cube([R_key + 0.4, 6.4, R_lip + 0.2]);
    }
}

// Cuna de bloqueo: entra en el canal por el extremo y se acuna en
// altura contra los labios. El agujero del testero sirve para
// engancharla con un destornillador y sacarla.
module cuna(L = 45) {
    e0 = R_ch_h - 1.0;
    e1 = R_ch_h + 0.5;
    difference() {
        hull() {
            translate([0, -hd_w/2, 0]) cube([0.01, hd_w, e0]);
            translate([L, -hd_w/2, 0]) cube([0.01, hd_w, e1]);
        }
        translate([L + 0.1, 0, e1/2]) rotate([0, -90, 0])
            cylinder(h = 12, d = 4);
    }
}

// TESTIGO: 60 mm de rail + 60 mm de cabeza. IMPRIME ESTO PRIMERO.
// Cuestan 10 minutos y te dicen si el ajuste del canal es el correcto
// ANTES de tirarte 20 horas de impresora en los seis segmentos.
// Debe deslizar con la mano, sin holgura de traqueteo. Si va duro,
// sube "hol"; si baila, bajalo. 0.05 mm cambia mucho.
module testigo() {
    difference() {
        translate([0, -RW/2, 0]) cube([60, RW, RH]);
        translate([0.5, -R_ch_w/2, R_lip]) cube([60, R_ch_w, R_ch_h + R_plate]);
        translate([-0.1, -R_open/2, -0.1]) cube([61, R_open, R_lip + 0.2]);
    }
    translate([32.5, RW + 12, -Z_MURO + 6]) {
        translate([-30, -M_wall/2, Z_MURO - 6]) cube([60, M_wall, 6]);
        cabeza_T(60);
    }
}

// Galga: mantiene los dos railes a la separacion exacta mientras
// marcas y taladras. No queda en el montaje final.
//  Trabaja a traccion/compresion pura (solo separa), no a flexion, asi
//  que se puede vaciar sin miedo: es un util de un solo uso.
module galga(A = 26) {
    difference() {
        translate([0, Y0, Z_MURO - 8]) cube([A, Y1 - Y0, 8]);
        translate([(A - 14)/2, Y0 + 22, Z_MURO - 9])
            cube([14, (Y1 - Y0) - 44, 10]);
    }
    translate([A/2, 0, 0])        cabeza_T(A);
    translate([A/2, RAIL_SEP, 0]) cabeza_T(A);
}

/* =====================================================================
   9. MODULOS
   ===================================================================== */

// Esqueleto comun: suelo + 2 paredes laterales + 2 paredes colgantes
// (trasera y delantera) rematadas en cabeza T.
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

// Ventana en una pared colgante: aire y paso de cables, dejando
// columnas de 22 mm en los extremos, que es por donde baja la carga.
module ventana(W, y, z0, z1) {
    if (z1 > z0 + 1)
        translate([22, y - M_wall/2 - 1, z0])
            cube([W - 44, M_wall + 2, z1 - z0]);
}

// Topes que centran el aparato en Y contra las paredes colgantes.
// Van aligerados con ventanas dejando 3 mm de piel en la cara que toca
// el aparato: son separadores, no estructura. Macizos se comian 200 g.
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

// Rejilla en los dos laterales, a la altura del aparato.
module rejilla_lateral(W, y0, alto_z, n = 6) {
    if (alto_z > 2)
        for (s = [0, W - pared])
            for (i = [0 : n - 1])
                translate([s - 1, y0 + 12 + i*28, suelo + 5])
                    cube([pared + 2, 16, alto_z]);
}

// --- MODULO M920q -----------------------------------------------------
//  El M920q ventila por ARRIBA y expulsa por detras. Va boca arriba con
//  la caja abierta hacia el tablero: le quedan ~47 mm de aire libre por
//  encima, mas rejilla en los cuatro costados.
puertos_al_frente = true;   // true = puertos hacia el frente de la mesa

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
        // hueco amplio delante de los puertos
        translate([18, y_puertos - M_wall/2 - 1, suelo + 2])
            cube([W_m920q - 36, M_wall + 2, pc_z + 2]);
        for (y = [RAIL_SEP*0.3, RAIL_SEP*0.7])
            translate([W_m920q/2, y, suelo + pc_z - 4])
                rotate([0, 90, 0]) ranura_brida();
    }
}

// --- MODULO AUXILIAR: CONVERSOR (+ fuente si fuese externa) -----------
//  Con la fuente integrada en el equipo este modulo solo lleva el
//  conversor y baja de 138 a 80 mm, lo que deja la fila en 459 mm y
//  permite hacer cada rail con DOS segmentos en vez de tres: cuatro
//  tornillos menos.
//  Si algun dia la fuente pasa a ser externa, los dos cubiculos van
//  LADO A LADO en X (en Y no caben: 125 + 90 > 194).
x_ps  = pared;                            // cubiculo de la fuente
x_cv  = fuente_externa ? x_ps + ps_x + 5 : pared;   // cubiculo del conversor

//  El conversor solo ocupa 90 de los 194 mm del vano. En vez de
//  rellenar el resto con topes, va PEGADO A LA PARED TRASERA y los
//  104 mm que sobran quedan como camara abierta para el bucle de
//  servicio de la fibra, que en una mesa elevable hay que alojar en
//  algun sitio. Sale mas ligero y ademas resuelve un problema real.
y_cv_fin = M_wall/2 + c_y + 2;         // pared de retencion del conversor

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
            // pared de retencion del conversor + escuadras a 45
            translate([pared, y_cv_fin, suelo])
                cube([W_aux - 2*pared, 3, h_dev]);
            for (x = [pared + 6, W_aux/2 - 4, W_aux - pared - 14])
                hull() {
                    translate([x, y_cv_fin + 3, suelo]) cube([8, 0.01, h_dev]);
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

// --- MODULO ROUTER ----------------------------------------------------
//  El router llena casi toda la altura util, asi que aqui las ventanas
//  van a la altura del propio aparato, no por encima.
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

/* =====================================================================
   10. BRIDA DEL LADRON
   ---------------------------------------------------------------------
   Va atornillada DIRECTAMENTE al tablero, por detras del rail trasero,
   con dos bocallaves propias. Deliberadamente desacoplada del sistema
   de railes: si compartiese canal chocaria con las cabezas T de los
   modulos, que ocupan practicamente toda su longitud.
   Se imprime con la placa contra la cama; el cuenco crece hacia arriba
   y los labios salen a 45, asi que no lleva soportes.
   ===================================================================== */
lb_x    = 120;                   // ancho de la brida
lb_t    = saliente_tornillo;     // espesor de la placa (cota critica)
lb_sep  = 70;                    // separacion entre sus dos tornillos
lb_wall = 3;
lb_lip  = 3;

// Eje del ladron. Tiene que quedar por detras de las orejas del rail
// trasero (que llegan hasta y = -40), no solo por detras del rail.
la_axis = -82;
lb_y0   = la_axis - la_y/2 - lb_wall - 4;
lb_y1   = la_axis + la_y/2 + lb_wall + 4;

z_cuenco = TABLERO - lb_t;               // techo del cuenco
z_lad    = z_cuenco - la_z - 3;          // cara inferior de los labios

module brida_ladron() {
    yi = la_y/2 + 1;                     // cara interior de la pared
    difference() {
        union() {
            // placa contra el tablero
            translate([-lb_x/2, lb_y0, z_cuenco]) cube([lb_x, lb_y1 - lb_y0, lb_t]);
            // nervio perimetral para que la placa de 3.5 no flecte
            translate([-lb_x/2, lb_y0, z_cuenco - 7]) cube([lb_x, 5, 7]);
            translate([-lb_x/2, lb_y1 - 5, z_cuenco - 7]) cube([lb_x, 5, 7]);
            // paredes del cuenco + labios a 45
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
        // bocallaves
        for (dx = [-lb_sep/2, lb_sep/2])
            translate([dx - desliz/2, la_axis, z_cuenco - 0.1])
                linear_extrude(lb_t + 0.2) bocallave_2d();
        // ranuras de brida por si tu ladron es mas fino de lo previsto
        for (dx = [-lb_x/4, lb_x/4])
            translate([dx, la_axis, z_lad + 1.5]) rotate([0, 0, 90]) ranura_brida();
    }
}

/* =====================================================================
   11. VISTA DE CONJUNTO
   ===================================================================== */
X_M920Q  = 0;
X_AUX    = W_m920q;
X_ROUTER = W_m920q + W_aux;

module fantasma(x, y, z, dx, dy, dz, col) {
    color(col, 0.45) translate([x, y, z]) cube([dx, dy, dz]);
}

module conjunto() {
    for (y = [0, RAIL_SEP])
        for (s = [0 : N_SEG - 1])
            translate([-6 + s*R_seg, y, RAIL_Z0]) rail_seg();

    translate([X_M920Q,  0, 0]) mod_m920q();
    translate([X_AUX,    0, 0]) mod_aux();
    translate([X_ROUTER, 0, 0]) mod_router();

    for (x = [W_TOTAL/2 - 130, W_TOTAL/2 + 130])
        translate([x, 0, 0]) brida_ladron();

    // aparatos (fantasma)
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

    // tablero de la mesa (fantasma)
    color("Tan", 0.22)
        translate([-90, -170, TABLERO]) cube([W_TOTAL + 180, 560, 20]);
}

/* =====================================================================
   12. SALIDA
   ===================================================================== */
if      (pieza == "conjunto") conjunto();
else if (pieza == "rail")     rail_seg();
else if (pieza == "cuna")     cuna();
else if (pieza == "testigo")  testigo();
else if (pieza == "galga")    translate([0, 0, -Z_MURO + 12]) galga();
else if (pieza == "m920q")    mod_m920q();
else if (pieza == "aux")      mod_aux();
else if (pieza == "router")   mod_router();
// La brida sale girada: se imprime con la placa contra la cama, que es
// la cara ancha, y el cuenco creciendo hacia arriba.
else if (pieza == "brida")    translate([0, 0, TABLERO]) rotate([180, 0, 0]) brida_ladron();

echo(str("Caida total bajo el tablero .... ", TABLERO, " mm"));
echo(str("Ancho total de la fila ......... ", W_TOTAL, " mm"));
echo(str("Fondo ocupado bajo la mesa ..... ", RAIL_SEP + hd_w + (-lb_y0), " mm"));
echo(str("Rail: ", N_SEG, " segmentos de ", R_seg, " mm por cada rail"));
echo(str("Tornillos ...................... ", N_SEG*2*2, " railes + 4 ladron"));
echo(str("Aire libre sobre el M920q ...... ", TABLERO - suelo - pc_z, " mm"));
