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
lid_lip_h   = 6;    // profundidad del labio de encaje
hole_d      = 3.0;  // diametro de los agujeros de la tapa
hole_n      = 6;

// --- Geometria derivada ---
socket_id  = oil_d + 2*oil_clr;
socket_od  = socket_id + 2*socket_wall;
oil_zone_d = oil_d + 2*oil_margin;            // diametro exterior del foso
pocket_d   = holder_d + 2*bote_clr;           // hueco redondo del cajon
cajon_side = pocket_d + 2*cajon_wall;         // lado exterior del cajon
cajon_x    = oil_zone_d/2 + cajon_side/2 + cajon_gap; // cajones fuera del foso

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
        up(holder_wall) cyl(d = holder_d - 2*holder_wall, h = h, anchor = BOTTOM);
        // chaflan de entrada en la boca para guiar el labio de la tapa
        up(h) cyl(d1 = holder_d - 2*holder_wall, d2 = holder_d - 2*holder_wall + 3,
                  h = 1.5, anchor = TOP);
    }
}

// ============================================================================
//  TAPA: cara plana perforada + labio a presion.
//  MODELADA EN POSICION DE IMPRESION (cara plana sobre la cama, labio hacia
//  arriba): agujeros = taladros verticales limpios, paredes rectas, sin
//  soportes ni voladizos. En uso se coloca del reves sobre el bote.
// ============================================================================
module bote_tapa() {
    lip_d = holder_d - 2*holder_wall - 0.4;   // ajuste por friccion

    difference() {
        union() {
            // cara plana perforada (queda sobre la cama al imprimir)
            cyl(d = holder_d, h = disc_h, chamfer1 = 0.8, anchor = BOTTOM);
            // labio que encaja dentro del bote (hacia arriba al imprimir)
            up(disc_h)
                tube(h = lid_lip_h, od = lip_d, wall = holder_wall,
                     chamfer2 = 1, anchor = BOTTOM);
        }
        // agujeros verticales rectos a traves de la cara
        for (i = [0 : hole_n - 1])
            zrot(i*360/hole_n) right(holder_d/5)
                cyl(d = hole_d, h = disc_h*3, center = true);
        cyl(d = hole_d, h = disc_h*3, center = true);
    }
}

// ============================================================================
//  RENDER: cada pieza activa en su carril para no solaparse.
// ============================================================================
if (bandeja) plato();
if (bote)    right(cajon_x + cajon_side/2 + holder_d/2 + 40) bote_cuerpo();
if (tapa)    right(cajon_x + cajon_side/2 + holder_d/2 + 40) fwd(holder_d + 20) bote_tapa();
