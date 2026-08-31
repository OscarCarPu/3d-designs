// =====================================================================
//  ARANDELA PARA LAS BOCALLAVES DEL RAIL
//
//  Agranda la cabeza del tornillo, que es demasiado pequena respecto a
//  la ranura por la que desliza y apenas pisa el labio del rail.
//
//  DOS COTAS LA DEFINEN, Y SON LAS DEL RAIL, NO LAS DEL TORNILLO:
//    - MENOR que el circulo de entrada (Ø13), para que pase al colgar
//      el rail. Va puesta en el tornillo desde el principio; no hay que
//      desmontar nada.
//    - MAYOR que la ranura de deslizamiento (7,5), que es lo que hace
//      que pise el labio.
//  Con Ø12,2 quedan 2,35 mm de apoyo por lado en vez de los 1,75 que
//  da la cabeza sola: 31 mm2 de superficie contra 19.
//
//  EFECTO SECUNDARIO: al ser mas ancha que la cabeza, el rail desliza
//  9,9 mm en vez de 10,5 antes de topar. Sigue bloqueando igual.
//
//  EL AGUJERO INTERIOR, MIDELO. Tiene que pasar la cana de tu tornillo
//  y ser CLARAMENTE MENOR que su cabeza, o la cabeza se colara por la
//  arandela y no habras arreglado nada. Si tu cabeza mide bastante
//  menos de 11 mm (que es lo que sospecho, por eso apenas agarra),
//  ajusta d_vastago hacia abajo para que sobre mas material.
//
//  EN METAL TAMBIEN VALE: una DIN 125 M6 (Ø12,5 x 1,6) entra y da un
//  pelin mas de apoyo. El acero no fluye con el tiempo y el PLA si, asi
//  que si tienes a mano, mejor esa. Esta es para salir del paso hoy.
//
//  Unidades: milimetros. No necesita BOSL2.
// =====================================================================

/* --------- LO QUE HAY QUE MEDIR ------------------------------------- */
d_vastago = 6;      // cana del tornillo   <-- MIDELO
hol_paso  = 0.6;    // holgura sobre la cana

/* --------- COTAS DEL RAIL (de bajomesa_homelab.scad) ---------------- */
d_circulo = 13;     // d_cabeza + hol_cabeza : por donde entra al colgar
d_ranura  = 7.5;    // d_vastago + hol_vastago : por donde desliza

/* --------- LA ARANDELA ---------------------------------------------- */
hol_circulo = 0.8;                        // para que pase sin rozar
od = d_circulo - hol_circulo;             // 12.2
id = d_vastago + hol_paso;                //  6.6
espesor = 2;
chaflan = 0.4;

$fn = 96;

module arandela() {
    difference() {
        cylinder(h = espesor, d = od);
        translate([0, 0, -0.5]) cylinder(h = espesor + 1, d = id);
        // chaflan en las dos caras: sin rebaba, y la cabeza asienta
        // plana aunque tenga algo de radio bajo el sombrero
        cylinder(h = chaflan, d1 = id + 2*chaflan, d2 = id);
        translate([0, 0, espesor - chaflan])
            cylinder(h = chaflan + 0.01, d1 = id, d2 = id + 2*chaflan);
    }
}

arandela();

/* --------- COMPROBACIONES ------------------------------------------- */
echo(str("Ø exterior ", od, " < circulo de entrada ", d_circulo,
         "  -> ", od < d_circulo ? "PASA al colgar" : "*** NO PASA ***"));
echo(str("Ø exterior ", od, " > ranura ", d_ranura,
         "  -> ", od > d_ranura ? "PISA el labio" : "*** NO PISA ***"));
echo(str("Apoyo por lado: ", (od - d_ranura)/2, " mm   (cabeza sola: ",
         (11 - d_ranura)/2, " mm)"));
echo(str("Agujero ", id, " sobre cana de ", d_vastago,
         "  -> holgura ", (id - d_vastago)/2, " mm por lado"));
echo(str("Saliente de tornillo: 3,5 + ", espesor, " = ", 3.5 + espesor, " mm"));
