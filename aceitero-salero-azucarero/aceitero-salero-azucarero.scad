// ============================================================================
//  Aceitero con soportes para salero y azucarero
// ----------------------------------------------------------------------------
//  Piezas a imprimir:
//    bandeja -> base de una pieza: foso redondo recoge-aceite con encaje
//               central para el bote de aceite (9 cm) y, al lado, DOS CAJONES
//               cuadrados donde entran los botes.
//    bote    -> vaso del salero/azucarero (mismo diseno, imprime 2).
//    tapa    -> tapa perforada a presion, rellenable (imprime 2).
//
//  Activa con 1 lo que quieras dibujar/exportar (0 = no). Unidades en mm.
// ============================================================================

include <BOSL2/std.scad>

// --- Que dibujar (1 = si, 0 = no) ---
bandeja = 1;
bote    = 0;
tapa    = 0;

$fn = 120;

// --- Zona del aceite (bote de 9 cm, no se imprime) ---
oil_d      = 90;    // diametro del bote de aceite que se apoya en el centro
oil_clr    = 1.0;   // holgura radial del encaje
oil_margin = 16;    // anillo de foso alrededor del bote
socket_h   = 14;    // altura del aro de encaje
socket_wall= 3;
moat_depth = 7;     // profundidad del foso recoge-aceite
moat_wall  = 3;     // pared exterior del foso

// --- Base ---
base_h      = 4;
base_round  = 12;   // redondeo de las esquinas de la base
base_top_r  = 2.5;  // redondeo del canto superior (curva final del plato)
base_lip    = 4;    // labio de base que sobresale del foso y los cajones
cajon_gap   = 2;    // separacion entre el foso y los cajones

// --- Botes y cajones ---
holder_d    = 46;   // diametro del bote
holder_h    = 60;
holder_wall = 2.2;
bote_clr    = 1.0;  // holgura del bote dentro del cajon
cajon_wall  = 4;
cajon_h     = 26;   // altura de las paredes del cajon
disc_h      = 2.5;  // grosor de la cara plana perforada de la tapa
lid_lip_h   = 7;    // profundidad del labio de encaje
hole_d      = 3.0;  // diametro de los agujeros de la tapa
hole_n      = 6;

// --- Cierre a presion de la tapa (aro de retencion) ---
// La tapa ya no solo hace friccion: el bote lleva un aro interior que
// estrecha el hueco un poco antes del fondo del labio. La tapa tiene que
// forzar un poco para pasarlo y queda "mordida" en vez de solo apoyada,
// asi no se sale sola al agitar el bote para servir sal/azucar.
lip_clr       = 0.3; // holgura diametral del labio en el tramo recto
snap_bite     = 0.3; // mordida radial del aro de bloqueo sobre el labio
snap_band     = 1.4; // altura total del aro (rampa de entrada + salida)
snap_from_rim = 4;   // profundidad del aro bajo el borde del bote
// El aro de bloqueo vive en el BOTE (ya impreso, no se toca). Para que la
// tapa entre/salga con poca fuerza sin perder el tope, se le talla un
// rebaje al labio justo donde coincide el aro: la mordida efectiva pasa
// a ser (snap_bite - lip_relief). Si sigue dura, sube lip_relief (sin
// llegar a snap_bite, o el cierre deja de retener); si se cae sola, bajalo.
// Solo hace falta reimprimir la tapa para ajustar esto.
lip_relief    = 0.26;

// --- Pestaña para sacar la tapa con los dedos ---
tab_out     = 8;   // cuanto sobresale del borde del disco
tab_overlap = 3;   // cuanto se mete dentro del disco (para que quede bien pegada)
tab_w       = 12;  // ancho de la pestaña
tab_h       = disc_h; // mismo grosor que el disco: plana, no invade la zona de cierre
tab_round   = 3;   // redondeo de las esquinas

// --- Geometria derivada ---
socket_id  = oil_d + 2*oil_clr;
socket_od  = socket_id + 2*socket_wall;
oil_zone_d = oil_d + 2*oil_margin;            // diametro exterior del foso
pocket_d   = holder_d + 2*bote_clr;           // hueco redondo del cajon
cajon_side = pocket_d + 2*cajon_wall;         // lado exterior del cajon
cajon_x    = oil_zone_d/2 + cajon_side/2 + cajon_gap; // cajones fuera del foso
bore_id    = holder_d - 2*holder_wall;        // hueco recto del bote
lip_d      = bore_id - lip_clr;               // diametro recto del labio de la tapa
neck_id    = lip_d - 2*snap_bite;             // diametro del aro de bloqueo

// ============================================================================
//  BANDEJA: base solida + foso del aceite + dos cajones (todo una pieza).
// ============================================================================
module plato() {
    // Contorno = envolvente convexa del circulo del aceite + el bloque de cajones,
    // extruido con el canto superior redondeado (curva suave del plato).
    outline = base_outline();
    offset_sweep(outline, height = base_h, top = os_circle(r = base_top_r));

    // Foso del aceite: pared perimetral + aro de encaje + suelo que escurre
    up(base_h) {
        tube(h = moat_depth, od = oil_zone_d, wall = moat_wall,
             rounding2 = 1.5, anchor = BOTTOM);
        tube(h = socket_h, id = socket_id, wall = socket_wall,
             chamfer2 = 1.5, anchor = BOTTOM);
        cyl(d = socket_od, h = 1.5, anchor = BOTTOM);
    }

    // Dos cajones uno al lado del otro
    up(base_h) right(cajon_x)
        for (y = [-cajon_side/2, cajon_side/2]) back(y) cajon();
}

// Contorno 2D de la base (D redondeada): circulo del foso + rect de los cajones,
// ensanchado con un labio para que la base sobresalga de lo que lleva encima.
function base_outline() =
    let(pts = concat(
            circle(d = oil_zone_d),
            move([cajon_x, 0], p = rect([cajon_side, 2*cajon_side], rounding = base_round))),
        hp  = [for (i = hull(pts)) pts[i]])
    offset(hp, r = base_lip, closed = true);

// Cajon cuadrado con hueco redondo para el bote (deja el suelo de la base).
module cajon() {
    difference() {
        cuboid([cajon_side, cajon_side, cajon_h],
               rounding = 5, edges = "Z", anchor = BOTTOM);
        down(1) cyl(d = pocket_d, h = cajon_h + 1, anchor = BOTTOM);
    }
}

// ============================================================================
//  BOTE: vaso con fondo plano (chaflan anti-pata-de-elefante) y boca abierta.
//  Se imprime tal cual: boca arriba, sin soportes.
// ============================================================================
module bote_cuerpo() {
    h = holder_h - disc_h;
    difference() {
        cyl(d = holder_d, h = h, chamfer1 = 0.8, anchor = BOTTOM);
        up(holder_wall) cyl(d = bore_id, h = h, anchor = BOTTOM);
        // chaflan de entrada en la boca para guiar el labio de la tapa
        up(h) cyl(d1 = bore_id, d2 = bore_id + 3, h = 1.5, anchor = TOP);
    }
    // aro de bloqueo: nervio interior que estrecha el hueco justo antes de
    // que el labio llegue al fondo de su recorrido (ver bote_tapa).
    up(h - snap_from_rim - snap_band/2)
        snap_ring(bore_id, neck_id, snap_band);
}

// Aro con perfil triangular (rampa-pico-rampa) revolucionado: se imprime
// como un simple estrechamiento progresivo de la pared, sin voladizos.
module snap_ring(d_out, d_in, band) {
    rotate_extrude()
        polygon([[d_out/2, 0], [d_in/2, band/2], [d_out/2, band]]);
}

// ============================================================================
//  TAPA: cara plana perforada + labio con cierre a presion (encaja en el aro
//  de bloqueo de bote_cuerpo, no es solo friccion: hace "clic" y se queda).
//  MODELADA EN POSICION DE IMPRESION (cara plana sobre la cama, labio hacia
//  arriba): agujeros = taladros verticales limpios, paredes rectas, sin
//  soportes ni voladizos. En uso se coloca del reves sobre el bote.
// ============================================================================
module bote_tapa() {
    difference() {
        union() {
            // cara plana perforada (queda sobre la cama al imprimir)
            cyl(d = holder_d, h = disc_h, chamfer1 = 0.8, anchor = BOTTOM);
            // labio que encaja dentro del bote (hacia arriba al imprimir)
            up(disc_h)
                tube(h = lid_lip_h, od = lip_d, wall = holder_wall,
                     chamfer2 = 1, anchor = BOTTOM);
            // pestaña que sobresale del borde para hacer palanca con los
            // dedos y sacar la tapa sin tener que arañar el canto
            right(holder_d/2 + (tab_out - tab_overlap)/2)
                cuboid([tab_out + tab_overlap, tab_w, tab_h],
                       rounding = tab_round, edges = "Z", anchor = BOTTOM);
        }
        // agujeros verticales rectos a traves de la cara
        for (i = [0 : hole_n - 1])
            zrot(i*360/hole_n) right(holder_d/5)
                cyl(d = hole_d, h = disc_h*3, center = true);
        cyl(d = hole_d, h = disc_h*3, center = true);
        // rebaje que alivia la mordida del aro de bloqueo del bote (ver
        // lip_relief mas arriba): mismo alto y posicion que ese aro.
        up(disc_h + snap_from_rim - snap_band/2)
            snap_ring(lip_d, lip_d - 2*lip_relief, snap_band);
    }
}

// ============================================================================
//  RENDER: cada pieza activa en su carril para no solaparse.
// ============================================================================
if (bandeja) plato();
if (bote)    right(cajon_x + cajon_side/2 + holder_d/2 + 40) bote_cuerpo();
if (tapa)    right(cajon_x + cajon_side/2 + holder_d/2 + 40) fwd(holder_d + 20) bote_tapa();
