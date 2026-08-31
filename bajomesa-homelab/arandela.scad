// =====================================================================
//  REFUERZO DE BOCALLAVE  (mal llamado "arandela": no es redonda)
//
//  QUE PROBLEMA RESUELVE
//  La cabeza del tornillo (11 mm) apoya sobre el labio de la bocallave
//  a ambos lados de una ranura de 7,5 mm. Eso son 19 mm2 de apoyo
//  real, repartidos en dos medias lunas de 1,75 mm. Poco.
//
//  POR QUE NO VALE UNA ARANDELA COMPRADA
//  El alojamiento de la cabeza mide 13 mm de ancho y el tornillo queda
//  a solo 5,5 mm del fondo. Cualquier arandela redonda que quepa tiene
//  que medir 11 mm o menos, o sea lo mismo que la cabeza: no gana
//  NADA. Una DIN 125 (12,5) o una carrocera (18) simplemente no entran.
//  Por eso hay que imprimirla: la unica forma de ganar superficie es
//  crecer a lo LARGO de la ranura, y eso no lo vende nadie.
//
//  QUE HACE ESTA PIEZA
//    1. Placa oblonga de 12,4 mm de ancho que se mete en el alojamiento
//       y apoya bajo el labio en toda la longitud de la ranura:
//       56 mm2 en vez de 19. Y plana, sin el efecto cuna que hace una
//       cabeza abombada al meterse en la ranura.
//    2. Un TOPE cilindrico que rellena el circulo de entrada. Sin el,
//       nada impide que el rail se deslice hacia atras y se descuelgue
//       de los tornillos: es el otro fallo probable, y sale gratis.
//
//  COMO SE MONTA (con el rail YA COLGADO y deslizado)
//    Uno a uno, los otros 7 tornillos aguantan mientras tanto:
//      1. Saca el tornillo.
//      2. Metelo por el agujero de la placa.
//      3. Mete el conjunto en el alojamiento DESDE ABAJO, con el tope
//         hacia el circulo de entrada. Se coloca solo.
//      4. Aprieta dejando 5,5 mm de vastago fuera del tablero
//         (3,5 del labio + 2 de la placa) en vez de los 3,5 de antes.
//
//  Unidades: milimetros. No necesita BOSL2.
// =====================================================================

/* --------- MEDIDAS COPIADAS DEL RAIL (bajomesa_homelab.scad) -------- */
d_cabeza    = 11;    hol_cabeza  = 2.0;
d_vastago   = 6;     hol_vastago = 1.5;
desliz      = 16;    RH          = 15;
saliente_tornillo = 3.5;

/* --------- DERIVADAS DEL ALOJAMIENTO -------------------------------- */
dh   = d_cabeza  + hol_cabeza;        // 13.0  ancho del alojamiento
sw   = d_vastago + hol_vastago;       //  7.5  ancho de la ranura del labio
prof = RH - saliente_tornillo;        // 11.5  profundidad del alojamiento
x_tornillo = desliz - d_cabeza/2;     // 10.5  donde topa la cabeza al deslizar

/* --------- LA PIEZA -------------------------------------------------- */
hol_pieza = 0.3;                      // holgura contra las paredes
ancho     = dh - 2*hol_pieza;         // 12.4
x_atras   = -dh/2 + hol_pieza;        // -6.2
x_alante  = desliz - hol_pieza;       // 15.7
espesor   = 2;                        // placa
d_paso    = d_vastago + 0.6;          //  6.6  agujero del vastago
tope_h    = saliente_tornillo;        //  3.5  el tope llega hasta el tablero
chaflan   = 0.5;

$fn = 72;

module refuerzo() {
    difference() {
        union() {
            hull() {
                translate([x_atras  + ancho/2, 0, 0]) cylinder(h = espesor, d = ancho);
                translate([x_alante - ancho/2, 0, 0]) cylinder(h = espesor, d = ancho);
            }
            // tope antideslizamiento, rellena el circulo de entrada
            translate([0, 0, espesor]) cylinder(h = tope_h, d = ancho);
        }
        translate([x_tornillo, 0, -1]) cylinder(h = espesor + 2, d = d_paso);
        // chaflan bajo el agujero: la cabeza asienta plana aunque tenga radio
        translate([x_tornillo, 0, -0.01])
            cylinder(h = chaflan, d1 = d_paso + 2*chaflan, d2 = d_paso);
    }
}

refuerzo();

/* --------- COMPROBACIONES CONTRA EL ALOJAMIENTO REAL ----------------- */
echo(str("ancho ", ancho, " en alojamiento de ", dh,
         "  -> ", ancho < dh ? "CABE" : "*** NO CABE ***"));
echo(str("largo ", x_alante - x_atras, " en alojamiento de ", desliz + dh/2,
         "  -> ", x_alante - x_atras < desliz + dh/2 ? "CABE" : "*** NO CABE ***"));
echo(str("altura total ", espesor + tope_h, " en profundidad de ", prof,
         "  -> queda ", prof - espesor, " mm para la cabeza"));
echo(str("solape bajo el labio: ", (ancho - sw)/2, " mm por lado (antes ",
         (d_cabeza - sw)/2, ")"));
echo(str("material por delante del agujero: ", x_alante - x_tornillo - d_paso/2, " mm"));
echo(str("SALIENTE DE TORNILLO NUEVO: ", saliente_tornillo + espesor, " mm"));
