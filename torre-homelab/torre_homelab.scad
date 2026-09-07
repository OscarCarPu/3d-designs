// =====================================================================
//  TORRE HOMELAB — columna vertical de una sola pieza, colgada del
//  tablero. Sustituye a la fila de railes cuando no hay 459 mm de ancho
//  libre bajo la mesa pero si un hueco vertical (lejos de las piernas).
//  Los aparatos NO se atornillan ni deslizan: caen en su hueco por
//  gravedad. Todo el peso lo llevan los 4 tornillos de la brida
//  superior — la torre es un solo bloque rigido, no hay piezas sueltas.
//  Milimetros.
// =====================================================================

$fn = 48;

pieza = "conjunto";
//  "conjunto"  vista de montaje, en pie (NO imprimible)
//  "torre"     la columna, ya tumbada en la orientacion de impresion
// El ladron va aparte, ver clip-ladron/clip_ladron.scad — no cuelga de
// esta torre.

// --- 1. APARATOS  <<< MIDE LOS TUYOS >>> ------------------------------
pc_x = 179; pc_y = 183; pc_z = 37;   // ThinkCentre M920q Tiny
c_x  = 70;  c_y  = 90;  c_z  = 25;   // conversor de fibra
r_x  = 170; r_y  = 170; r_z  = 60;   // router


// --- 2. TORNILLOS (aglomerado 4x20, cabeza avellanada) ----------------
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

module ranura_brida() { cube([12, 20, 3.5], center = true); }

// --- 3. HOLGURAS -------------------------------------------------------
pared    = 3;
suelo    = 3;
ins_hol  = 3;    // holgura para que el aparato entre sin apretar
GAP      = 15;   // aire entre niveles: ventilacion + paso de cables
GAP_TOP  = 45;   // aire sobre el M920q, junto al tablero (mismo margen
                 // validado en bajomesa-homelab: ahi ya daba 47 mm y
                 // bastaba con la rejilla de los 4 costados)
FLANGE_T = 10;

// --- 4. ENVOLVENTE: la marca el aparato mas grande (M920q) ------------
W = pc_x + 2*ins_hol + 2*pared;   // 191  ancho exterior
D = pc_y + 2*ins_hol + pared;     // 192  fondo exterior (pared solo atras,
                                  // el frente queda abierto)

// --- 5. NIVELES, de abajo a arriba: conversor, router, M920q ----------
// El que mas calienta (M920q) va arriba, con el aire libre justo bajo
// el tablero — es la misma logica que en bajomesa-homelab.
Z_D1 = suelo;
Z_T1 = Z_D1 + c_z + GAP;
Z_D2 = Z_T1 + suelo;
Z_T2 = Z_D2 + r_z + GAP;
Z_D3 = Z_T2 + suelo;
Z_T3 = Z_D3 + pc_z + GAP_TOP;
Z_FLANGE = Z_T3;
Z_TOTAL  = Z_FLANGE + FLANGE_T;

echo(str("Alto total colgado ............. ", Z_TOTAL, " mm"));
echo(str("Ancho ........................... ", W, " mm"));
echo(str("Fondo ........................... ", D, " mm"));
echo(str("Aire libre sobre el M920q ....... ", GAP_TOP, " mm"));

// --- 6. CASCO: pared trasera + 2 laterales, frente abierto ------------
// Imprimible tumbada sobre la pared trasera: cada piso y cada pared
// lateral queda entonces de canto sobre la cama, sin voladizos que
// puenteen (nada de bridging a 185 mm). Ver rotacion en el bloque SALIDA.
module casco(z0, z1) {
    h = z1 - z0;
    translate([0, 0, z0]) cube([W, pared, h]);          // trasera
    translate([0, 0, z0]) cube([pared, D, h]);          // lateral izq
    translate([W - pared, 0, z0]) cube([pared, D, h]);  // lateral der
}

// Rejilla de ventilacion en un lateral, en forma de rejilla real (filas x
// columnas) y no de rendijas largas: al imprimir tumbada, la profundidad
// (Y natural) pasa a ser la vertical de la pieza, asi que una rendija
// larga en Y sale como una costilla alta y finisima — se rompe sola.
// Con agujeros cortos en las dos direcciones queda una malla que se
// aguanta igual tumbada que en pie. h cubre el aparato y buena parte del
// aire libre de encima.
module rejilla(z0, h, lado) {
    x = lado < 0 ? -1 : W - pared - 1;
    filas = max(2, round(h / 18));
    cols  = 4;
    y0 = pared + 12; y1 = D - pared - 12;
    paso_z = h / (filas + 1);
    paso_y = (y1 - y0) / cols;
    for (fz = [1 : filas])
        for (fy = [0 : cols - 1])
            translate([x, y0 + fy*paso_y + 2, z0 + fz*paso_z - 5])
                cube([pared + 2, paso_y - 4, 10]);
}

// Rejilla trasera: mismas alturas que la lateral, para tiro cruzado
// frente-fondo ademas del lateral. Deja 10 mm de margen a cada canto
// para no debilitar la union con las paredes laterales.
module rejilla_trasera(z0, h) {
    n = 5;
    x0 = pared + 10;
    x1 = W - pared - 10;
    paso = (x1 - x0) / (n - 1);
    for (i = [0 : n - 1])
        translate([x0 + i*paso - 4, -1, z0 + 5])
            cube([8, pared + 2, h - 10]);
}

// Piso macizo: el aparato se apoya en el, la ventilacion va toda en los
// laterales/trasera. Con agujeros aqui el piso pierde apoyo justo donde
// mas falta hace (bajo el peso del aparato).
module piso(z0) {
    translate([0, 0, z0]) cube([W, D, suelo]);
}

// Guias laterales: solo dos topes cortos (junto al fondo y junto al
// frente), no un bloque continuo — asi el hueco de en medio del lateral
// queda libre y la rejilla de esa altura sigue ventilando aire real, no
// tapada contra un relleno solido.
module guias(z0, z1, w_dev) {
    hueco = (W - 2*pared - w_dev) / 2;
    tope_y = 12;
    if (hueco > 1)
        for (s = [0, 1])
            for (y = [pared, D - pared - tope_y])
                translate([s == 0 ? pared : W - pared - hueco, y, z0])
                    cube([hueco, tope_y, z1 - z0]);
}

module torre() {
    difference() {
        union() {
            casco(0, Z_TOTAL);
            piso(0);
            piso(Z_T1);
            piso(Z_T2);
            translate([0, 0, Z_FLANGE]) cube([W, D, FLANGE_T]);
            guias(Z_D1, Z_D1 + c_z + 2, c_x);
            guias(Z_D2, Z_D2 + r_z + 2, r_x);
        }
        // Cada rejilla cubre el aparato y buena parte del aire libre de
        // encima (10 mm para los dos niveles bajos, mas para el M920q,
        // que es el que mas calienta y tiene 45 mm de aire sobre si).
        rejilla(Z_D1, c_z + 10, -1);  rejilla(Z_D1, c_z + 10, 1);
        rejilla(Z_D2, r_z + 10, -1); rejilla(Z_D2, r_z + 10, 1);
        rejilla(Z_D3, pc_z + 35, -1); rejilla(Z_D3, pc_z + 35, 1);
        rejilla_trasera(Z_D1, c_z + 10);
        rejilla_trasera(Z_D2, r_z + 10);
        rejilla_trasera(Z_D3, pc_z + 35);
        MARGEN = 20;
        for (dx = [MARGEN, W - MARGEN])
            for (dy = [MARGEN, D - MARGEN])
                translate([dx, dy, Z_FLANGE]) taladro(FLANGE_T);
        translate([W/2, pared/2, Z_D1 + c_z/2]) rotate([90,0,0]) ranura_brida();
        translate([W/2, pared/2, Z_D2 + r_z/2]) rotate([90,0,0]) ranura_brida();
        translate([W/2, pared/2, Z_D3 + pc_z/2]) rotate([90,0,0]) ranura_brida();
    }
}

// --- 7. VISTA DE CONJUNTO ----------------------------------------------
module fantasma(x, y, z, dx, dy, dz, col) {
    color(col, 0.45) translate([x, y, z]) cube([dx, dy, dz]);
}

module conjunto() {
    torre();
    fantasma(pared + ins_hol, pared, Z_D1, c_x, c_y, c_z, "DarkGreen");
    fantasma((W - r_x)/2, pared, Z_D2, r_x, r_y, r_z, "SteelBlue");
    fantasma(pared + ins_hol, pared, Z_D3, pc_x, pc_y, pc_z, "DarkRed");
    color("Tan", 0.22) translate([-60, -60, Z_TOTAL]) cube([W + 120, D + 200, 20]);
}

// --- 8. SALIDA ----------------------------------------------------------
// La torre se gira 90 grados para imprimirse tumbada sobre la pared
// trasera (ver comentario en modulo casco). El resto de piezas salen
// ya en su orientacion de impresion.
if      (pieza == "conjunto")    conjunto();
else if (pieza == "torre")       translate([0, Z_TOTAL, 0]) rotate([90, 0, 0]) torre();
