// ============================================================================
//  Topper de tarta: texto decorado + palo de 8,5 cm con punta roma.
//  UNA sola pieza, plana, se imprime tumbada y sin soportes.
//
//  Solo hay que tocar 'lineas' y 'alto'. Unidades en mm. Fuentes en ./fonts (OFL).
//
//  Probado (sale de UNA sola pieza, sin trozos sueltos). Medidas con el palo,
//  que son 8,5 cm desde la linea base del texto:
//      ["Parabéns"]         alto 24.5 -> palabra 110 x 40 mm
//      ["Felices 15"]       alto 22.4 -> palabra 105 x 38 mm
//      ["Feliz cumpleaños"] alto 16.6 -> palabra 134 x 33 mm
//      ["Parabéns Carmén"]  alto 15.7 -> palabra 132 x 33 mm
//  Ancho ~ 0.55 * alto * nº caracteres (Allura). No bajes de alto 14: Allura es
//  muy fina y sus contraformas se cierran.
//
//  La letra no se deforma: lo que une la pieza son la barra y la placa de
//  detras. Antes de imprimir, comprueba en el laminador que es UNA sola pieza.
// ============================================================================

use <fonts/Allura-Regular.ttf>
use <fonts/Playball-Regular.ttf>
use <fonts/Courgette-Regular.ttf>
use <fonts/KaushanScript-Regular.ttf>
use <fonts/Lobster-Regular.ttf>
use <fonts/GreatVibes-Regular.ttf>

// Tesela adaptativa: curvas finas donde hacen falta. Con $fn fijo la cursiva
// sale facetada y se ven kinks en los trazos.
$fn = 0; $fs = 0.4; $fa = 8;

lineas = ["Parabéns"];      // una entrada por linea
alto   = 24.5;
fuente = "Allura";          // "Playball", "Courgette", "Kaushan Script",
                            // "Lobster", "Great Vibes"

barra = true;   // subrayado: une palabras y sujeta el cajetin
base  = true;   // placa fina por detras: engancha las tildes

interlineado = 0.62;   // separacion entre lineas (fraccion de 'alto'); bajo a
                       // proposito, asi las lineas se enganchan entre ellas

grosor = 4.0;
base_z = 0.9;

// Engorde minimo: la placa de detras es la que da resistencia, asi que al trazo
// solo se le pide no bajar de ~0.6 mm. Engordar mas aplasta el contraste de la
// cursiva (los finos crecen mucho y los gruesos poco) y ensucia la letra.
engorde   = max(0.15, alto * 0.007);
base_halo = max(0.30, alto * 0.012);
cierre    = 0;   // suelda letras deformandolas; solo para el look sin barra
                 // ni base (prueba 0.9 con Great Vibes y alto 35)

puente    = true;   // engancha las tildes y los puntos de la 'i' a su letra
puente_r  = max(1.1, alto * 0.058);
puente_y0 = 0.22;   // franja de altura donde se permite, fraccion de 'alto'.
puente_y1 = 0.80;   // Tiene que cubrir la tilde Y bajar hasta la letra; si no,
                    // la tilde se queda suelta.

barra_alto   = 1.8;   // fina y por debajo de la linea base: si sube mas, se
barra_solape = 0.5;   // come el arranque de las letras

// --- Palo ---
palo_ancho  = 6;
palo_largo  = 85;     // 8,5 cm medidos desde la linea base del texto
palo_solape = 1.5;    // cuanto se mete el palo en la barra
refuerzo_w  = 16;     // ensanche del arranque, contra la barra
refuerzo_h  = 12;
punta_largo = 16;
punta_r     = 1.5;    // punta roma, no corta

// ============================================================================
n_lineas = len(lineas);

// La ultima linea apoya en y = 0; las de arriba se apilan sobre ella.
function y_linea(i) = (n_lineas - 1 - i) * interlineado * alto;

y_barra = barra ? barra_solape - barra_alto : 0;   // borde inferior de la barra

module trazo_2d(i) {
    offset(r = engorde)
        text(lineas[i], size = alto, font = fuente,
             halign = "center", valign = "baseline");
}

module letras_linea_2d(i) {
    if (cierre > 0) offset(r = -cierre) offset(r = cierre) trazo_2d(i);
    else            trazo_2d(i);
}

module letras_2d() {
    for (i = [0 : n_lineas - 1])
        translate([0, y_linea(i)]) letras_linea_2d(i);
}

// Cierre morfologico de radio grande, recortado a la franja de la tilde: la
// tilde baja hasta su letra y el resto del texto no se toca.
module puente_2d() {
    for (i = [0 : n_lineas - 1])
        translate([0, y_linea(i)])
            intersection() {
                offset(r = -puente_r) offset(r = puente_r) trazo_2d(i);
                translate([-1000, puente_y0 * alto])
                    square([2000, (puente_y1 - puente_y0) * alto]);
            }
}

// Se recorta del casco convexo de la ultima linea, asi sale exactamente de su
// ancho sea cual sea la fuente, el tamano o el texto.
module barra_2d() {
    intersection() {
        hull() letras_linea_2d(n_lineas - 1);
        translate([-1000, barra_solape - barra_alto]) square([2000, barra_alto]);
    }
}

module base_2d() {
    offset(r = base_halo) letras_2d();
}

// Palo: arranca dentro de la barra y baja hasta -palo_largo.
module palo_2d() {
    y_top = y_barra + palo_solape;
    y_fin = -palo_largo;
    y_ini = y_fin + punta_largo;
    union() {
        // refuerzo del arranque contra la barra
        polygon([[-refuerzo_w/2, y_top], [refuerzo_w/2, y_top],
                 [ palo_ancho/2, y_top - refuerzo_h],
                 [-palo_ancho/2, y_top - refuerzo_h]]);
        translate([-palo_ancho/2, y_ini]) square([palo_ancho, y_top - y_ini]);
        hull() {
            translate([-palo_ancho/2, y_ini]) square([palo_ancho, 0.01]);
            translate([0, y_fin + punta_r]) circle(r = punta_r);
        }
    }
}

module topper() {
    if (base)
        linear_extrude(base_z)
            union() {
                base_2d();
                if (puente) puente_2d();
                if (barra)  barra_2d();
                palo_2d();
            }
    linear_extrude(grosor)
        union() {
            letras_2d();
            if (puente && !base) puente_2d();
            if (barra)  barra_2d();
            palo_2d();
        }
}

topper();
