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
bandeja = 0;
bote    = 0;
tapa    = 1;

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
lid_h       = 12;   // altura de la tapa
lid_lip_h   = 6;    // profundidad del labio de encaje
hole_d      = 3.5;  // diametro de los agujeros de la tapa
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
//  BOTE: vaso con fondo cerrado y boca abierta para la tapa.
// ============================================================================
module bote_cuerpo() {
    h = holder_h - lid_h + lid_lip_h;
    difference() {
        cyl(d = holder_d, h = h, rounding1 = 2, anchor = BOTTOM);
        up(holder_wall) cyl(d = holder_d - 2*holder_wall, h = h, anchor = BOTTOM);
    }
}

// ============================================================================
//  TAPA: labio a presion + cupula perforada.
// ============================================================================
module bote_tapa() {
    lip_d     = holder_d - 2*holder_wall - 0.3;   // ajuste por friccion
    dome_rise = 9;                                 // altura de la cupula
    dome_sz   = dome_rise / (holder_d/2);
    flange_h  = 2;                                 // reborde que apoya en la boca

    difference() {
        union() {
            // labio que encaja a presion dentro del bote
            down(lid_lip_h)
                tube(h = lid_lip_h + flange_h, od = lip_d, wall = holder_wall, anchor = BOTTOM);
            // aro-reborde con centro abierto (por ahi pasa la sal/azucar)
            tube(h = flange_h, od = holder_d, id = lip_d - 2*holder_wall, anchor = BOTTOM);
            // cupula perforada de una sola capa
            up(flange_h) difference() {
                scale([1, 1, dome_sz]) sphere(d = holder_d);
                scale([1, 1, dome_sz]) sphere(d = holder_d - 2*holder_wall);
                down(holder_h) cube(holder_h*2, center = true);
            }
        }
        for (i = [0 : hole_n - 1])
            zrot(i*360/hole_n) right(holder_d/5)
                cyl(d = hole_d, h = lid_h*3, center = true);
        cyl(d = hole_d, h = lid_h*3, center = true);
    }
}

// ============================================================================
//  RENDER: cada pieza activa en su carril para no solaparse.
// ============================================================================
if (bandeja) plato();
if (bote)    right(cajon_x + cajon_side/2 + holder_d/2 + 40) bote_cuerpo();
if (tapa)    right(cajon_x + cajon_side/2 + holder_d/2 + 40) fwd(holder_d + 20) bote_tapa();
